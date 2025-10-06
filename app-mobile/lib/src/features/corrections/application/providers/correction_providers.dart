import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repo_lib_client_008/repo_lib_client_008.dart';

import '../../../auth/application/providers/auth_providers.dart';
import '../../../attendance/application/providers/attendance_providers.dart';
import '../notifiers/correction_request_notifier.dart';

// Note: ICorrectionRepository might be part of IAttendanceRepository.
// For this implementation, we assume a method exists on IAttendanceRepository
// for correction-related tasks to avoid creating a new repository provider.

//------------------ State Notifier Providers ------------------//

/// Provides the [CorrectionRequestNotifier] and its state for the correction request form.
/// Manages the business logic for submitting a new correction request (US-045).
final correctionRequestNotifierProvider =
    StateNotifierProvider.autoDispose<CorrectionRequestNotifier, CorrectionRequestState>((ref) {
  return CorrectionRequestNotifier(
    attendanceRepository: ref.watch(attendanceRepositoryProvider),
    userProfile: ref.watch(userProfileProvider).asData?.value,
  );
});

//------------------ Data Fetching Providers ------------------//

/// A stream provider that watches all pending attendance correction requests
/// for a supervisor's direct subordinates.
/// This is the primary data source for the supervisor's correction review queue (US-046).
final pendingCorrectionsProvider = StreamProvider.autoDispose<List<AttendanceRecord>>((ref) {
  final userProfile = ref.watch(userProfileProvider).asData?.value;

  // Only supervisors can have pending corrections to review.
  if (userProfile == null || userProfile.role != UserRole.supervisor) {
    return Stream.value([]);
  }

  final attendanceRepo = ref.watch(attendanceRepositoryProvider);
  return attendanceRepo.watchPendingCorrectionRequests(supervisorId: userProfile.uid);
});

/// A provider to fetch a single, specific attendance record.
/// Used to load the details of a record for which a correction is being requested,
/// or when viewing the details of a rejected correction (US-043).
/// It uses `.family` to be parameterized by the attendance record ID.
final attendanceRecordProvider =
    FutureProvider.family.autoDispose<AttendanceRecord?, String>((ref, recordId) {
  final userProfile = ref.watch(userProfileProvider).asData?.value;
  if (userProfile == null) {
    return Future.value(null);
  }

  final attendanceRepo = ref.watch(attendanceRepositoryProvider);
  // The repository method should internally handle security to ensure
  // the user is authorized to view this specific record.
  return attendanceRepo.getAttendanceRecord(recordId: recordId);
});