import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_functions/firebase_functions.dart';

import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

abstract class UserRemoteDataSource {
  /// Calls a cloud function to invite a new user to the organization.
  /// Throws [ServerException] on failure.
  Future<void> inviteUser({required String email, required String role});

  /// Calls a cloud function to deactivate a user's account.
  /// Throws [ServerException] on failure.
  Future<void> deactivateUser(String userId);

  /// Calls a cloud function to update a user's details (e.g., role, supervisor).
  /// Throws [ServerException] on failure.
  Future<void> updateUser(UserModel user);
  
  /// Watches for real-time updates to a specific user's profile.
  Stream<UserModel> watchUser(String userId);

  /// Fetches a paginated list of all users in the tenant.
  Future<List<UserModel>> getPaginatedUsers({
    DocumentSnapshot? startAfter,
    int limit = 50,
  });

  /// Fetches a list of users eligible to be supervisors.
  Future<List<UserModel>> getEligibleSupervisors();

  /// Gets a single user by their ID.
  Future<UserModel> getUser(String userId);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final FirebaseFunctions _functions;

  UserRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required FirebaseFunctions functions,
  })  : _firestore = firestore,
        _auth = auth,
        _functions = functions;

  Future<CollectionReference<Map<String, dynamic>>> _getUsersCollection() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw const ServerException(message: 'User not authenticated.', code: 'unauthenticated');
    }
    final idTokenResult = await user.getIdTokenResult();
    final tenantId = idTokenResult.claims?['tenantId'];
    if (tenantId == null) {
      throw const ServerException(message: 'Tenant ID not found in user token.', code: 'no-tenant-id');
    }
    return _firestore.collection('tenants').doc(tenantId).collection('users');
  }

  @override
  Future<void> inviteUser({required String email, required String role}) async {
    try {
      final callable = _functions.httpsCallable('inviteUser');
      await callable.call({'email': email, 'role': role});
    } on FirebaseFunctionsException catch (e) {
      throw ServerException(message: e.message ?? 'Unknown error', code: e.code);
    } catch (e) {
      throw ServerException(message: e.toString(), code: 'generic-error');
    }
  }

  @override
  Future<void> deactivateUser(String userId) async {
    try {
      final callable = _functions.httpsCallable('deactivateUser');
      await callable.call({'userId': userId});
    } on FirebaseFunctionsException catch (e) {
      throw ServerException(message: e.message ?? 'Unknown error', code: e.code);
    } catch (e) {
      throw ServerException(message: e.toString(), code: 'generic-error');
    }
  }

  @override
  Future<void> updateUser(UserModel user) async {
    try {
      final callable = _functions.httpsCallable('updateUser');
      await callable.call(user.toJson()..['id'] = user.id);
    } on FirebaseFunctionsException catch (e) {
      throw ServerException(message: e.message ?? 'Unknown error', code: e.code);
    } catch (e) {
      throw ServerException(message: e.toString(), code: 'generic-error');
    }
  }

  @override
  Stream<UserModel> watchUser(String userId) {
    return _getUsersCollection().asStream().asyncExpand((collection) {
      return collection.doc(userId).snapshots().map((doc) {
        if (!doc.exists) {
          throw const ServerException(message: 'User not found.', code: 'not-found');
        }
        try {
          return UserModel.fromSnapshot(doc);
        } catch (e) {
          throw ServerException(
              message: 'Error parsing user data.', code: 'data-parsing-error');
        }
      });
    });
  }

  @override
  Future<List<UserModel>> getPaginatedUsers({
    DocumentSnapshot? startAfter,
    int limit = 50,
  }) async {
    try {
      final collection = await _getUsersCollection();
      Query query = collection.orderBy('name').limit(limit);

      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }

      final snapshot = await query.get();
      return snapshot.docs.map((doc) => UserModel.fromSnapshot(doc)).toList();
    } on FirebaseException catch (e) {
      throw ServerException(message: e.message ?? 'Unknown error', code: e.code);
    } catch (e) {
      throw ServerException(message: e.toString(), code: 'generic-error');
    }
  }

  @override
  Future<List<UserModel>> getEligibleSupervisors() async {
    try {
      final collection = await _getUsersCollection();
      // NOTE: This query requires a composite index on (role, status)
      final snapshot = await collection
          .where('role', whereIn: ['Admin', 'Supervisor'])
          .where('status', isEqualTo: 'active')
          .get();
      return snapshot.docs.map((doc) => UserModel.fromSnapshot(doc)).toList();
    } on FirebaseException catch (e) {
      throw ServerException(message: e.message ?? 'Unknown error', code: e.code);
    } catch (e) {
      throw ServerException(message: e.toString(), code: 'generic-error');
    }
  }
  
  @override
  Future<UserModel> getUser(String userId) async {
    try {
      final collection = await _getUsersCollection();
      final doc = await collection.doc(userId).get();
       if (!doc.exists) {
          throw const ServerException(message: 'User not found.', code: 'not-found');
        }
      return UserModel.fromSnapshot(doc);
    } on FirebaseException catch (e) {
      throw ServerException(message: e.message ?? 'Unknown error', code: e.code);
    } catch (e) {
      throw ServerException(message: e.toString(), code: 'generic-error');
    }
  }
}