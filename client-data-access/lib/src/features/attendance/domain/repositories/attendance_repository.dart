import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/attendance_record.dart';

/// The repository contract for handling attendance-related data operations.
///
/// This abstract class defines the interface that the application layer (use cases)
/// will use to interact with attendance data, regardless of the underlying data source.
/// Implementations of this repository are responsible for fetching, creating, updating,
/// and managing attendance records.
abstract class AttendanceRepository {
  /// Creates a new attendance record in the data source.
  ///
  /// This method is typically used for a 'check-in' action.
  /// The [record] should be a fully formed [AttendanceRecord] entity, though the ID
  /// may be empty if the data source is expected to generate it.
  ///
  /// Returns a [Future] of `Either<Failure, void>`.
  /// - [Right<void>] on successful creation.
  /// - [Left<Failure>] on any error, such as a [ServerFailure] if the remote
  ///   data source is unavailable.
  Future<Either<Failure, void>> createAttendanceRecord(
      AttendanceRecord record);

  /// Updates an existing attendance record.
  ///
  /// This method is used for 'check-out' actions, status changes (approval/rejection),
  /// or when a correction is approved.
  /// The [record] must have a valid ID.
  ///
  /// Returns a [Future] of `Either<Failure, void>`.
  /// - [Right<void>] on successful update.
  /// - [Left<Failure>] on any error, such as a [ServerFailure].
  Future<Either<Failure, void>> updateAttendanceRecord(
      AttendanceRecord record);

  /// Submits a correction request for an existing attendance record.
  ///
  /// This initiates the approval workflow for an attendance correction.
  /// The implementation will typically update the record's status to 'correction_pending'
  /// and store the proposed changes.
  ///
  /// - [recordId]: The ID of the record to be corrected.
  /// - [newCheckInTime]: The proposed new check-in time, if changed.
  /// - [newCheckOutTime]: The proposed new check-out time, if changed.
  /// - [justification]: The mandatory reason for the correction request.
  ///
  /// Returns a [Future] of `Either<Failure, void>`.
  /// - [Right<void>] on successful submission.
  /// - [Left<Failure>] on any error.
  Future<Either<Failure, void>> submitCorrectionRequest({
    required String recordId,
    DateTime? newCheckInTime,
    DateTime? newCheckOutTime,
    required String justification,
  });

  /// Watches for real-time updates to a user's attendance records for a given date range.
  ///
  /// - [userId]: The ID of the user whose records are to be watched.
  /// - [startDate]: The beginning of the date range.
  /// - [endDate]: The end of the date range.
  ///
  /// Returns a [Stream] of `Either<Failure, List<AttendanceRecord>>`.
  /// - Emits [Right<List<AttendanceRecord>>] with the list of records on initial fetch
  ///   and on any subsequent changes.
  /// - Emits [Left<Failure>] if an error occurs while listening to the data source.
  Stream<Either<Failure, List<AttendanceRecord>>> watchUserAttendanceForDateRange({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Watches for real-time updates to pending attendance records for a supervisor's direct subordinates.
  ///
  /// This is used for the supervisor's approval dashboard.
  ///
  /// - [supervisorId]: The ID of the supervisor.
  ///
  /// Returns a [Stream] of `Either<Failure, List<AttendanceRecord>>`.
  /// - Emits [Right<List<AttendanceRecord>>] with the list of pending records.
  /// - Emits [Left<Failure>] on any data source error.
  Stream<Either<Failure, List<AttendanceRecord>>>
      watchPendingSubordinateRecords(String supervisorId);

  /// Fetches a single attendance record by its ID.
  ///
  /// - [recordId]: The unique identifier of the attendance record.
  ///
  /// Returns a [Future] of `Either<Failure, AttendanceRecord>`.
  /// - [Right<AttendanceRecord>] with the found record.
  /// - [Left<Failure>] if the record is not found or an error occurs.
  Future<Either<Failure, AttendanceRecord>> getAttendanceRecord(String recordId);

  /// Performs a bulk update on the status of multiple attendance records.
  ///
  /// Used by supervisors for bulk approval or rejection.
  ///
  /// - [recordIds]: A list of record IDs to update.
  /// - [status]: The new status to apply to all records.
  /// - [rejectionReason]: An optional reason, required if the status is 'rejected'.
  ///
  /// Returns a [Future] of `Either<Failure, void>`.
  /// - [Right<void>] on successful bulk update.
  /// - [Left<Failure>] if the operation fails.
  Future<Either<Failure, void>> bulkUpdateAttendanceStatus({
    required List<String> recordIds,
    required AttendanceStatus status,
    String? rejectionReason,
  });
}