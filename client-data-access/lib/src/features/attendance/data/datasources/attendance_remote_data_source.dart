import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_functions/firebase_functions.dart';

import '../../../../core/error/exceptions.dart';
import '../models/attendance_model.dart';

abstract class AttendanceRemoteDataSource {
  /// Creates a new attendance record.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<String> createAttendanceRecord(AttendanceModel recordModel);

  /// Updates an existing attendance record.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<void> updateAttendanceRecord(AttendanceModel recordModel);

  /// Watches for real-time updates to a user's attendance records for a given date range.
  Stream<List<AttendanceModel>> watchUserAttendanceForDateRange(
      String userId, DateTime startDate, DateTime endDate);

  /// Watches for real-time updates to pending attendance records for a supervisor.
  Stream<List<AttendanceModel>> watchPendingSubordinateRecords(String supervisorId);

  /// Fetches a paginated list of attendance records based on filters for reporting.
  Future<List<AttendanceModel>> getAttendanceRecords({
    required List<String> userIds,
    required DateTime startDate,
    required DateTime endDate,
    List<String>? statuses,
    DocumentSnapshot? startAfter,
    int limit = 50,
  });

  /// Submits a correction request for an attendance record.
  Future<void> submitCorrectionRequest({
    required String recordId,
    required DateTime? newCheckInTime,
    required DateTime? newCheckOutTime,
    required String justification,
  });
}

class AttendanceRemoteDataSourceImpl implements AttendanceRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final FirebaseFunctions _functions;

  AttendanceRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required FirebaseFunctions functions,
  })  : _firestore = firestore,
        _auth = auth,
        _functions = functions;

  Future<CollectionReference<Map<String, dynamic>>>
      _getAttendanceCollection() async {
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
    return _firestore.collection('tenants').doc(tenantId).collection('attendance');
  }

  @override
  Future<String> createAttendanceRecord(AttendanceModel recordModel) async {
    try {
      final collection = await _getAttendanceCollection();
      final docRef = await collection.add(recordModel.toJson());
      return docRef.id;
    } on FirebaseException catch (e) {
      throw ServerException(message: e.message ?? 'Unknown error', code: e.code);
    } catch (e) {
      throw ServerException(message: e.toString(), code: 'generic-error');
    }
  }

  @override
  Future<void> updateAttendanceRecord(AttendanceModel recordModel) async {
    if (recordModel.id == null) {
      throw const ServerException(
          message: 'Record ID is required for updates.', code: 'invalid-argument');
    }
    try {
      final collection = await _getAttendanceCollection();
      await collection.doc(recordModel.id).update(recordModel.toJson());
    } on FirebaseException catch (e) {
      throw ServerException(message: e.message ?? 'Unknown error', code: e.code);
    } catch (e) {
      throw ServerException(message: e.toString(), code: 'generic-error');
    }
  }

  @override
  Stream<List<AttendanceModel>> watchUserAttendanceForDateRange(
      String userId, DateTime startDate, DateTime endDate) {
    return _getAttendanceCollection().asStream().asyncExpand((collection) {
      return collection
          .where('userId', isEqualTo: userId)
          .where('checkInTime', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('checkInTime', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .orderBy('checkInTime', descending: true)
          .snapshots()
          .map((snapshot) {
        try {
          return snapshot.docs
              .map((doc) => AttendanceModel.fromSnapshot(doc))
              .toList();
        } catch (e) {
          // Propagate error through the stream
          throw ServerException(
              message: 'Error parsing attendance data.', code: 'data-parsing-error');
        }
      });
    });
  }

  @override
  Stream<List<AttendanceModel>> watchPendingSubordinateRecords(String supervisorId) {
    return _getAttendanceCollection().asStream().asyncExpand((collection) {
      // NOTE: This query requires a composite index on (supervisorId, status)
      return collection
          .where('supervisorId', isEqualTo: supervisorId)
          .where('status', whereIn: ['pending', 'correction_pending'])
          .snapshots()
          .map((snapshot) {
        try {
          return snapshot.docs
              .map((doc) => AttendanceModel.fromSnapshot(doc))
              .toList();
        } catch (e) {
          throw ServerException(
              message: 'Error parsing pending records.', code: 'data-parsing-error');
        }
      });
    });
  }

  @override
  Future<List<AttendanceModel>> getAttendanceRecords({
    required List<String> userIds,
    required DateTime startDate,
    required DateTime endDate,
    List<String>? statuses,
    DocumentSnapshot? startAfter,
    int limit = 50,
  }) async {
    try {
      final collection = await _getAttendanceCollection();
      Query query = collection
          .where('checkInTime', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('checkInTime', isLessThanOrEqualTo: Timestamp.fromDate(endDate));

      // Firestore 'in' queries are limited to 10 items. If more users are needed,
      // multiple queries must be run in parallel, or the data structure needs to change.
      if (userIds.isNotEmpty) {
        query = query.where('userId', whereIn: userIds);
      }

      if (statuses != null && statuses.isNotEmpty) {
        query = query.where('status', whereIn: statuses);
      }
      
      query = query.orderBy('checkInTime', descending: true).limit(limit);

      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }

      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => AttendanceModel.fromSnapshot(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw ServerException(message: e.message ?? 'Unknown error', code: e.code);
    } catch (e) {
      throw ServerException(message: e.toString(), code: 'generic-error');
    }
  }

  @override
  Future<void> submitCorrectionRequest({
    required String recordId,
    required DateTime? newCheckInTime,
    required DateTime? newCheckOutTime,
    required String justification,
  }) async {
    try {
      final callable = _functions.httpsCallable('submitCorrectionRequest');
      await callable.call({
        'recordId': recordId,
        'newCheckInTime': newCheckInTime?.toIso8601String(),
        'newCheckOutTime': newCheckOutTime?.toIso8601String(),
        'justification': justification,
      });
    } on FirebaseFunctionsException catch (e) {
      throw ServerException(message: e.message ?? 'Unknown error', code: e.code);
    } catch (e) {
      throw ServerException(message: e.toString(), code: 'generic-error');
    }
  }
}