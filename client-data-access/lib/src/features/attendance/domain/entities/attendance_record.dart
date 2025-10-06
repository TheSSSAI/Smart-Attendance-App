import 'package:equatable/equatable.dart';

/// Enum representing the possible statuses of an [AttendanceRecord].
enum AttendanceStatus {
  pending,
  approved,
  rejected,
  correctionPending,
}

/// Enum representing possible flags that can be attached to an [AttendanceRecord].
enum AttendanceFlag {
  isOfflineEntry,
  autoCheckedOut,
  manuallyCorrected,
  clockDiscrepancy,
  escalationFailedNoSupervisor,
}

/// A value object representing GPS coordinates.
class GpsCoordinates extends Equatable {
  /// Latitude coordinate.
  final double latitude;
  
  /// Longitude coordinate.
  final double longitude;
  
  /// Horizontal accuracy of the GPS reading.
  final double? accuracy;

  const GpsCoordinates({
    required this.latitude,
    required this.longitude,
    this.accuracy,
  });

  @override
  List<Object?> get props => [latitude, longitude, accuracy];
}

/// Represents a single attendance record for a user on a specific day.
/// This is a pure domain entity.
class AttendanceRecord extends Equatable {
  /// The unique identifier for the attendance record.
  final String id;

  /// The ID of the user this record belongs to.
  final String userId;

  /// The ID of the supervisor responsible for approving this record.
  final String supervisorId;

  /// The timestamp of the check-in action.
  final DateTime checkInTime;

  /// The GPS coordinates at the time of check-in.
  final GpsCoordinates checkInGps;

  /// The server-generated timestamp when the check-in was recorded.
  final DateTime? serverCheckInTime;

  /// The timestamp of the check-out action. Can be null if not yet checked out.
  final DateTime? checkOutTime;

  /// The GPS coordinates at the time of check-out. Can be null.
  final GpsCoordinates? checkOutGps;
  
  /// The server-generated timestamp when the check-out was recorded.
  final DateTime? serverCheckOutTime;

  /// The current status of the attendance record.
  final AttendanceStatus status;

  /// The ID of an event associated with this attendance record, if any.
  final String? eventId;

  /// A list of flags indicating special conditions for this record.
  final List<AttendanceFlag> flags;

  /// The reason provided by a supervisor for rejecting the record.
  final String? rejectionReason;
  
  /// The justification provided by a user for a correction request.
  final String? correctionJustification;
  
  /// The proposed new check-in time during a correction request.
  final DateTime? requestedCheckInTime;

  /// The proposed new check-out time during a correction request.
  final DateTime? requestedCheckOutTime;
  
  /// The status of the record before a correction was requested.
  final AttendanceStatus? statusBeforeCorrection;

  const AttendanceRecord({
    required this.id,
    required this.userId,
    required this.supervisorId,
    required this.checkInTime,
    required this.checkInGps,
    this.serverCheckInTime,
    this.checkOutTime,
    this.checkOutGps,
    this.serverCheckOutTime,
    required this.status,
    this.eventId,
    this.flags = const [],
    this.rejectionReason,
    this.correctionJustification,
    this.requestedCheckInTime,
    this.requestedCheckOutTime,
    this.statusBeforeCorrection,
  });

  /// Calculates the duration of work based on check-in and check-out times.
  /// Returns [Duration.zero] if the user has not checked out yet.
  Duration get workDuration {
    if (checkOutTime != null) {
      return checkOutTime!.difference(checkInTime);
    }
    return Duration.zero;
  }

  /// Helper to check if a specific flag is present.
  bool hasFlag(AttendanceFlag flag) => flags.contains(flag);

  @override
  List<Object?> get props => [
        id,
        userId,
        supervisorId,
        checkInTime,
        checkInGps,
        serverCheckInTime,
        checkOutTime,
        checkOutGps,
        serverCheckOutTime,
        status,
        eventId,
        flags,
        rejectionReason,
        correctionJustification,
        requestedCheckInTime,
        requestedCheckOutTime,
        statusBeforeCorrection
      ];
}