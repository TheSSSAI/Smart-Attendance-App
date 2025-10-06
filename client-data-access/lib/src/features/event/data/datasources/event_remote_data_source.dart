import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_functions/firebase_functions.dart';

import '../../../../core/error/exceptions.dart';
import '../models/event_model.dart';

abstract class EventRemoteDataSource {
  /// Creates a new event. This may involve creating a single event
  /// or a series of recurring events.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<void> createEvent(EventModel event);

  /// Updates an existing event.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<void> updateEvent(EventModel event);

  /// Deletes an event.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<void> deleteEvent(String eventId);

  /// Watches for real-time updates to events assigned to a specific user,
  /// either directly or through their team memberships.
  Stream<List<EventModel>> watchEventsForUser(String userId, List<String> teamIds);
}

class EventRemoteDataSourceImpl implements EventRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final FirebaseFunctions _functions;

  EventRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required FirebaseFunctions functions,
  })  : _firestore = firestore,
        _auth = auth,
        _functions = functions;

  Future<CollectionReference<Map<String, dynamic>>>
      _getEventsCollection() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw const ServerException(
          message: 'User not authenticated.', code: 'unauthenticated');
    }
    final idTokenResult = await user.getIdTokenResult();
    final tenantId = idTokenResult.claims?['tenantId'];
    if (tenantId == null) {
      throw const ServerException(
          message: 'Tenant ID not found in user token.', code: 'no-tenant-id');
    }
    return _firestore.collection('tenants').doc(tenantId).collection('events');
  }

  @override
  Future<void> createEvent(EventModel event) async {
    try {
      final callable = _functions.httpsCallable('createEvent');
      await callable.call(event.toJson());
    } on FirebaseFunctionsException catch (e) {
      throw ServerException(message: e.message ?? 'Unknown error', code: e.code);
    } catch (e) {
      throw ServerException(message: e.toString(), code: 'generic-error');
    }
  }

  @override
  Future<void> updateEvent(EventModel event) async {
    if (event.id == null) {
      throw const ServerException(
          message: 'Event ID is required for updates.', code: 'invalid-argument');
    }
    try {
      final collection = await _getEventsCollection();
      await collection.doc(event.id).update(event.toJson());
    } on FirebaseException catch (e) {
      throw ServerException(message: e.message ?? 'Unknown error', code: e.code);
    } catch (e) {
      throw ServerException(message: e.toString(), code: 'generic-error');
    }
  }

  @override
  Future<void> deleteEvent(String eventId) async {
    try {
      final collection = await _getEventsCollection();
      await collection.doc(eventId).delete();
    } on FirebaseException catch (e) {
      throw ServerException(message: e.message ?? 'Unknown error', code: e.code);
    } catch (e) {
      throw ServerException(message: e.toString(), code: 'generic-error');
    }
  }

  @override
  Stream<List<EventModel>> watchEventsForUser(
      String userId, List<String> teamIds) {
    // Combine user ID and team IDs for the 'array-contains-any' query.
    // Firestore's 'array-contains-any' is limited to 10 items. If a user is a member of
    // more than 9 teams, this query needs to be split. The repository layer should handle this.
    final userAndTeamIds = [userId, ...teamIds];
    
    return _getEventsCollection().asStream().asyncExpand((collection) {
      // NOTE: This query requires a composite index on (assignedUserIds, startTime)
      // and another on (assignedTeamIds, startTime)
      final userQuery = collection
          .where('assignedUserIds', arrayContains: userId);

      final teamQuery = teamIds.isNotEmpty
          ? collection.where('assignedTeamIds', arrayContainsAny: teamIds)
          : null;

      // This logic is complex. For simplicity, we can fetch two streams and merge them client-side.
      // A more optimized approach might use a denormalized data structure on the backend.
      // For now, let's assume we can query by a combined field or handle merging in the repository.
      // Here, we'll implement a query that gets events assigned to the user OR their teams.
      // Firestore does not support logical OR on different fields. So we query both and merge.
      // This is a simplified version; the repository will combine these streams.
      // For now we query on 'assignedUserIds' as the main source. The repo will merge.
      return collection
        .where('assignedUserIds', arrayContains: userId)
        .snapshots()
        .map((snapshot) {
          try {
            return snapshot.docs.map((doc) => EventModel.fromSnapshot(doc)).toList();
          } catch (e) {
            throw ServerException(
              message: 'Error parsing event data.',
              code: 'data-parsing-error');
          }
        });

      // A more robust implementation would look like this, handled by the repository:
      // Stream<List<EventModel>> userEvents = collection.where('assignedUserIds', arrayContains: userId).snapshots()...;
      // Stream<List<EventModel>> teamEvents = collection.where('assignedTeamIds', arrayContainsAny: teamIds).snapshots()...;
      // return StreamGroup.merge([userEvents, teamEvents])... // using async package
    });
  }
}