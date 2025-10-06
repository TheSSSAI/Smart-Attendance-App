import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_functions/firebase_functions.dart';

import '../../../../core/error/exceptions.dart';
import '../models/team_model.dart';

abstract class TeamRemoteDataSource {
  /// Calls a cloud function to create a new team.
  /// Throws [ServerException] on failure.
  Future<String> createTeam({required String name, required String supervisorId});

  /// Calls a cloud function to update a team's details.
  /// Throws [ServerException] on failure.
  Future<void> updateTeam(TeamModel team);

  /// Calls a cloud function to delete a team.
  /// Throws [ServerException] on failure.
  Future<void> deleteTeam(String teamId);

  /// Calls a cloud function to add a member to a team.
  /// Throws [ServerException] on failure.
  Future<void> addMemberToTeam({required String teamId, required String userId});

  /// Calls a cloud function to remove a member from a team.
  /// Throws [ServerException] on failure.
  Future<void> removeMemberFromTeam({required String teamId, required String userId});

  /// Watches for real-time updates to all teams in the tenant.
  Stream<List<TeamModel>> watchAllTeams();

  /// Watches for real-time updates to teams managed by a specific supervisor.
  Stream<List<TeamModel>> watchSupervisorTeams(String supervisorId);
}

class TeamRemoteDataSourceImpl implements TeamRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final FirebaseFunctions _functions;

  TeamRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required FirebaseFunctions functions,
  })  : _firestore = firestore,
        _auth = auth,
        _functions = functions;

  Future<CollectionReference<Map<String, dynamic>>> _getTeamsCollection() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw const ServerException(message: 'User not authenticated.', code: 'unauthenticated');
    }
    final idTokenResult = await user.getIdTokenResult();
    final tenantId = idTokenResult.claims?['tenantId'];
    if (tenantId == null) {
      throw const ServerException(message: 'Tenant ID not found in user token.', code: 'no-tenant-id');
    }
    return _firestore.collection('tenants').doc(tenantId).collection('teams');
  }

  @override
  Future<String> createTeam({required String name, required String supervisorId}) async {
    try {
      final callable = _functions.httpsCallable('createTeam');
      final result = await callable.call({'name': name, 'supervisorId': supervisorId});
      return result.data['teamId'];
    } on FirebaseFunctionsException catch (e) {
      throw ServerException(message: e.message ?? 'Unknown error', code: e.code);
    } catch (e) {
      throw ServerException(message: e.toString(), code: 'generic-error');
    }
  }

  @override
  Future<void> updateTeam(TeamModel team) async {
     try {
      final callable = _functions.httpsCallable('updateTeam');
      await callable.call(team.toJson()..['id'] = team.id);
    } on FirebaseFunctionsException catch (e) {
      throw ServerException(message: e.message ?? 'Unknown error', code: e.code);
    } catch (e) {
      throw ServerException(message: e.toString(), code: 'generic-error');
    }
  }

  @override
  Future<void> deleteTeam(String teamId) async {
     try {
      final callable = _functions.httpsCallable('deleteTeam');
      await callable.call({'teamId': teamId});
    } on FirebaseFunctionsException catch (e) {
      throw ServerException(message: e.message ?? 'Unknown error', code: e.code);
    } catch (e) {
      throw ServerException(message: e.toString(), code: 'generic-error');
    }
  }

  @override
  Future<void> addMemberToTeam({required String teamId, required String userId}) async {
    try {
      final callable = _functions.httpsCallable('addMemberToTeam');
      await callable.call({'teamId': teamId, 'userId': userId});
    } on FirebaseFunctionsException catch (e) {
      throw ServerException(message: e.message ?? 'Unknown error', code: e.code);
    } catch (e) {
      throw ServerException(message: e.toString(), code: 'generic-error');
    }
  }
  
  @override
  Future<void> removeMemberFromTeam({required String teamId, required String userId}) async {
    try {
      final callable = _functions.httpsCallable('removeMemberFromTeam');
      await callable.call({'teamId': teamId, 'userId': userId});
    } on FirebaseFunctionsException catch (e) {
      throw ServerException(message: e.message ?? 'Unknown error', code: e.code);
    } catch (e) {
      throw ServerException(message: e.toString(), code: 'generic-error');
    }
  }

  @override
  Stream<List<TeamModel>> watchAllTeams() {
    return _getTeamsCollection().asStream().asyncExpand((collection) {
      return collection.snapshots().map((snapshot) {
        try {
          return snapshot.docs.map((doc) => TeamModel.fromSnapshot(doc)).toList();
        } catch (e) {
          throw ServerException(
              message: 'Error parsing team data.', code: 'data-parsing-error');
        }
      });
    });
  }

  @override
  Stream<List<TeamModel>> watchSupervisorTeams(String supervisorId) {
    return _getTeamsCollection().asStream().asyncExpand((collection) {
      // NOTE: This query requires an index on 'supervisorId'
      return collection
          .where('supervisorId', isEqualTo: supervisorId)
          .snapshots()
          .map((snapshot) {
        try {
          return snapshot.docs.map((doc) => TeamModel.fromSnapshot(doc)).toList();
        } catch (e) {
          throw ServerException(
              message: 'Error parsing supervisor team data.',
              code: 'data-parsing-error');
        }
      });
    });
  }
}