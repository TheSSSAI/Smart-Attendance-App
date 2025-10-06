import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repo_lib_client_008/repo_lib_client_008.dart';

import '../../../../core/services/location_service.dart';
import '../../../../core/services/sync_status_service.dart';
import '../../../auth/application/providers/auth_providers.dart';
import '../../../events/application/providers/event_providers.dart';
import '../notifiers/subordinate_dashboard_notifier.dart';
import '../notifiers/supervisor_dashboard_notifier.dart';

//------------------ Repository Provider ------------------//

/// Provides the concrete implementation of the [IAttendanceRepository].
/// This abstracts all attendance-related data operations from the application logic.
/// The implementation `FirestoreAttendanceRepository` is assumed to be from the data access library.
final attendanceRepositoryProvider = Provider<IAttendanceRepository>((ref) {
  // Assuming the repository implementation handles its own Firestore instance.
  return FirestoreAttendanceRepository();
});

//------------------ Core Service Providers ------------------//

/// Provides the singleton instance of our location service abstraction.
final locationServiceProvider = Provider<ILocationService>((ref) {
  return LocationService();
});

/// Provides the singleton instance of our offline sync status service.
final syncStatusServiceProvider = Provider<ISyncStatusService>((ref) {
  return SyncStatusService();
});

//------------------ Subordinate-Specific Providers ------------------//

/// Provides the [SubordinateDashboardNotifier] and its state for the subordinate's main screen.
/// Manages the logic for check-in, check-out, and fetching the user's current status.
final subordinateDashboardNotifierProvider =
    StateNotifierProvider.autoDispose<SubordinateDashboardNotifier, SubordinateDashboardState>((ref) {
  return SubordinateDashboardNotifier(
    attendanceRepository: ref.watch(attendanceRepositoryProvider),
    locationService: ref.watch(locationServiceProvider),
    eventRepository: ref.watch(eventRepositoryProvider),
    userProfile: ref.watch(userProfileProvider).asData?.value,
  );
});

/// A stream provider that watches the subordinate's active (non-checked-out) attendance record for the current day.
/// This is used to drive the UI state of the subordinate dashboard.
final activeAttendanceRecordProvider = StreamProvider.autoDispose<AttendanceRecord?>((ref) {
  final userProfile = ref.watch(userProfileProvider).asData?.value;
  if (userProfile == null) {
    return Stream.value(null);
  }
  final attendanceRepo = ref.watch(attendanceRepositoryProvider);
  return attendanceRepo.watchActiveAttendanceRecord(userId: userProfile.uid);
});

/// A stream provider for fetching the user's entire attendance history.
/// Uses `StreamProvider.family` to support pagination in the future if needed,
/// but for now, it's a simple stream.
final attendanceHistoryProvider = StreamProvider.autoDispose<List<AttendanceRecord>>((ref) {
  final userProfile = ref.watch(userProfileProvider).asData?.value;
  if (userProfile == null) {
    return Stream.value([]);
  }
  final attendanceRepo = ref.watch(attendanceRepositoryProvider);
  // In a real app, this would be paginated.
  return attendanceRepo.getAttendanceHistoryStream(userId: userProfile.uid);
});

//------------------ Supervisor-Specific Providers ------------------//

/// Provides the [SupervisorDashboardNotifier] and its state.
/// This handles the business logic for approving/rejecting attendance records.
final supervisorDashboardNotifierProvider =
    StateNotifierProvider.autoDispose<SupervisorDashboardNotifier, SupervisorDashboardState>((ref) {
  return SupervisorDashboardNotifier(
    attendanceRepository: ref.watch(attendanceRepositoryProvider),
    userProfile: ref.watch(userProfileProvider).asData?.value,
  );
});

/// A stream provider that watches all pending attendance records for a supervisor's direct subordinates.
/// This is the primary data source for the supervisor's approval queue.
final pendingRecordsProvider = StreamProvider.autoDispose<List<AttendanceRecord>>((ref) {
  final userProfile = ref.watch(userProfileProvider).asData?.value;
  // Only supervisors can have pending records to review.
  if (userProfile == null || userProfile.role != UserRole.supervisor) {
    return Stream.value([]);
  }
  final attendanceRepo = ref.watch(attendanceRepositoryProvider);
  return attendanceRepo.watchPendingRecords(supervisorId: userProfile.uid);
});

//------------------ Sync Status Provider ------------------//

/// A provider that exposes the number of stale offline records that have failed to sync.
/// This drives the persistent sync failure banner UI (US-035).
final staleSyncRecordsProvider = StateProvider<int>((ref) {
  // The initial state is 0. The value will be updated by a service at app startup.
  return 0;
});