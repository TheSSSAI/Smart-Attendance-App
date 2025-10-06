import 'package:client_data_access/src/core/network/network_info.dart';
import 'package:client_data_access/src/features/attendance/data/datasources/attendance_remote_data_source.dart';
import 'package:client_data_access/src/features/attendance/data/repositories/attendance_repository_impl.dart';
import 'package:client_data_access/src/features/attendance/domain/repositories/attendance_repository.dart';
import 'package:client_data_access/src/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:client_data_access/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:client_data_access/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:client_data_access/src/features/event/data/datasources/event_remote_data_source.dart';
import 'package:client_data_access/src/features/event/data/repositories/event_repository_impl.dart';
import 'package:client_data_access/src/features/event/domain/repositories/event_repository.dart';
import 'package:client_data_access/src/features/team/data/datasources/team_remote_data_source.dart';
import 'package:client_data_access/src/features/team/data/repositories/team_repository_impl.dart';
import 'package:client_data_access/src/features/team/domain/repositories/team_repository.dart';
import 'package:client_data_access/src/features/user/data/datasources/user_remote_data_source.dart';
import 'package:client_data_access/src/features/user/data/repositories/user_repository_impl.dart';
import 'package:client_data_access/src/features/user/domain/repositories/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_functions/firebase_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore_for_file: unused_local_variable

// #############################################################################
// # EXTERNAL PACKAGES PROVIDERS
// #############################################################################

/// Provides the singleton instance of [FirebaseFirestore].
final firebaseFirestoreProvider =
    Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

/// Provides the singleton instance of [FirebaseAuth].
final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

/// Provides the singleton instance of [FirebaseFunctions].
final firebaseFunctionsProvider =
    Provider<FirebaseFunctions>((ref) => FirebaseFunctions.instance);

/// Provides a singleton instance of the [Connectivity] package.
final connectivityProvider = Provider<Connectivity>((ref) => Connectivity());

// #############################################################################
// # CORE PROVIDERS
// #############################################################################

/// Provides the concrete implementation of [NetworkInfo].
final networkInfoProvider = Provider<NetworkInfo>((ref) {
  final connectivity = ref.watch(connectivityProvider);
  return NetworkInfoImpl(connectivity);
});

// #############################################################################
// # FEATURE: AUTH
// #############################################################################

/// Provides the remote data source for authentication feature.
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  final firestore = ref.watch(firebaseFirestoreProvider);
  final functions = ref.watch(firebaseFunctionsProvider);
  return AuthRemoteDataSourceImpl(
    firebaseAuth: firebaseAuth,
    firestore: firestore,
    firebaseFunctions: functions,
  );
});

/// Provides the repository implementation for the authentication feature.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  final networkInfo = ref.watch(networkInfoProvider);
  return AuthRepositoryImpl(
    remoteDataSource: remoteDataSource,
    networkInfo: networkInfo,
  );
});

// #############################################################################
// # FEATURE: USER
// #############################################################################

/// Provides the remote data source for user-related data.
final userRemoteDataSourceProvider = Provider<UserRemoteDataSource>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  final functions = ref.watch(firebaseFunctionsProvider);
  return UserRemoteDataSourceImpl(
    firestore: firestore,
    functions: functions,
  );
});

/// Provides the repository implementation for the user feature.
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final remoteDataSource = ref.watch(userRemoteDataSourceProvider);
  final networkInfo = ref.watch(networkInfoProvider);
  return UserRepositoryImpl(
    remoteDataSource: remoteDataSource,
    networkInfo: networkInfo,
  );
});

// #############################################################################
// # FEATURE: TEAM
// #############################################################################

/// Provides the remote data source for team-related data.
final teamRemoteDataSourceProvider = Provider<TeamRemoteDataSource>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  final functions = ref.watch(firebaseFunctionsProvider);
  return TeamRemoteDataSourceImpl(
    firestore: firestore,
    functions: functions,
  );
});

/// Provides the repository implementation for the team feature.
final teamRepositoryProvider = Provider<TeamRepository>((ref) {
  final remoteDataSource = ref.watch(teamRemoteDataSourceProvider);
  final networkInfo = ref.watch(networkInfoProvider);
  return TeamRepositoryImpl(
    remoteDataSource: remoteDataSource,
    networkInfo: networkInfo,
  );
});

// #############################################################################
// # FEATURE: EVENT
// #############################################################################

/// Provides the remote data source for event-related data.
final eventRemoteDataSourceProvider = Provider<EventRemoteDataSource>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  final functions = ref.watch(firebaseFunctionsProvider);
  return EventRemoteDataSourceImpl(
    firestore: firestore,
    functions: functions,
  );
});

/// Provides the repository implementation for the event feature.
final eventRepositoryProvider = Provider<EventRepository>((ref) {
  final remoteDataSource = ref.watch(eventRemoteDataSourceProvider);
  final networkInfo = ref.watch(networkInfoProvider);
  return EventRepositoryImpl(
    remoteDataSource: remoteDataSource,
    networkInfo: networkInfo,
  );
});

// #############################################################################
// # FEATURE: ATTENDANCE
// #############################################################################

/// Provides the remote data source for attendance-related data.
final attendanceRemoteDataSourceProvider =
    Provider<AttendanceRemoteDataSource>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  final functions = ref.watch(firebaseFunctionsProvider);
  return AttendanceRemoteDataSourceImpl(
    firestore: firestore,
    functions: functions,
  );
});

/// Provides the repository implementation for the attendance feature.
final attendanceRepositoryProvider = Provider<AttendanceRepository>((ref) {
  final remoteDataSource = ref.watch(attendanceRemoteDataSourceProvider);
  final networkInfo = ref.watch(networkInfoProvider);
  return AttendanceRepositoryImpl(
    remoteDataSource: remoteDataSource,
    networkInfo: networkInfo,
  );
});