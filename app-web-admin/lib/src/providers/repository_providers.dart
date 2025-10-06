import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:attendance_client_data/attendance_client_data.dart';

// This file acts as the composition root for the data layer, providing concrete
// implementations of repository interfaces to the rest of the application.
// This adheres to the Dependency Inversion Principle, allowing the application
// layer (StateNotifiers) to depend on abstractions rather than concrete
// implementations.

/// Provides the singleton instance of FirebaseAuth.
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

/// Provides the singleton instance of FirebaseFirestore.
final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

/// Provides the singleton instance of FirebaseFunctions.
final firebaseFunctionsProvider = Provider<FirebaseFunctions>((ref) {
  // You can specify a region if your functions are deployed to a specific one.
  // e.g., FirebaseFunctions.instanceFor(region: 'europe-west1');
  return FirebaseFunctions.instance;
});

/// Provider for the [IAuthRepository] implementation.
///
/// This repository handles all authentication-related operations, such as
/// logging in, logging out, and checking the current authentication state.
/// It abstracts the underlying Firebase Authentication service.
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return FirebaseAuthRepository(
    ref.watch(firebaseAuthProvider),
    ref.watch(firebaseFirestoreProvider),
  );
});

/// Provider for the [IUserRepository] implementation.
///
/// This repository is responsible for all CRUD operations and queries
/// related to user data stored in Firestore.
final userRepositoryProvider = Provider<IUserRepository>((ref) {
  return FirestoreUserRepository(
    ref.watch(firebaseFirestoreProvider),
  );
});

/// Provider for the [ITeamRepository] implementation.
///
/// This repository manages all data operations for teams, including creation,
/// updates, deletion, and membership management.
final teamRepositoryProvider = Provider<ITeamRepository>((ref) {
  return FirestoreTeamRepository(
    ref.watch(firebaseFirestoreProvider),
  );
});

/// Provider for the [IAttendanceRepository] implementation.
///
/// This repository handles fetching and managing attendance records, which is
/// crucial for the reporting features of the admin dashboard.
final attendanceRepositoryProvider = Provider<IAttendanceRepository>((ref) {
  return FirestoreAttendanceRepository(
    ref.watch(firebaseFirestoreProvider),
  );
});

/// Provider for the [IAuditLogRepository] implementation.
///
/// This repository provides access to the immutable audit log, allowing Admins
/// to view a history of critical actions within their tenant.
final auditLogRepositoryProvider = Provider<IAuditLogRepository>((ref) {
  return FirestoreAuditLogRepository(
    ref.watch(firebaseFirestoreProvider),
  );
});

/// Provider for the [ITenantConfigRepository] implementation.
///
/// This repository is responsible for reading and writing tenant-specific
/// configuration settings, such as timezone, password policies, etc.
final tenantConfigRepositoryProvider = Provider<ITenantConfigRepository>((ref) {
  return FirestoreTenantConfigRepository(
    ref.watch(firebaseFirestoreProvider),
  );
});

/// Provider for the [IIntegrationRepository] implementation.
///
/// This repository manages data related to third-party integrations, such as
/// the Google Sheets export configuration.
final integrationRepositoryProvider = Provider<IIntegrationRepository>((ref) {
  return FirestoreIntegrationRepository(
    ref.watch(firebaseFirestoreProvider),
  );
});

/// Provider for the [ICallableFunctionsRepository] implementation.
///
/// This repository abstracts the calls to secure Firebase Cloud Functions
/// for operations that require elevated privileges or transactional integrity.
final callableFunctionsRepositoryProvider =
    Provider<ICallableFunctionsRepository>((ref) {
  return FirebaseCallableFunctionsRepository(
    ref.watch(firebaseFunctionsProvider),
  );
});