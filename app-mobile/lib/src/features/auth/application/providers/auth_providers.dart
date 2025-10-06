import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

// Assuming data access layer from REPO-LIB-CLIENT-008 provides these implementations
import 'package:repo_lib_client_008/repo_lib_client_008.dart';

import '../../../../../core/services/notification_handler_service.dart';
import '../../domain/entities/user_profile.dart';
import '../notifiers/login_notifier.dart';

// ignore: unused_import
import 'package:app_mobile/src/core/services/location_service.dart'; // Though unused here, demonstrates provider setup for core services

//------------------ Core Auth Service Providers ------------------//

/// Provides the singleton instance of FirebaseAuth.
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

/// Provides an authentication state change stream from FirebaseAuth.
/// This is the primary source of truth for the user's authentication status.
final authStateChangesProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

//------------------ Repository Providers ------------------//

/// Provides the concrete implementation of the [IAuthRepository].
/// This is the central point for abstracting authentication-related data operations.
/// The implementation `FirebaseAuthRepository` is assumed to come from the data access library.
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return FirebaseAuthRepository(
    ref.watch(firebaseAuthProvider),
    ref.watch(userRepositoryProvider), // Depends on IUserRepository to fetch profile after login
  );
});

/// Provides the concrete implementation of the [IUserRepository].
/// This is used for managing user profile data in Firestore.
/// The implementation `FirestoreUserRepository` is assumed to come from the data access library.
final userRepositoryProvider = Provider<IUserRepository>((ref) {
  // Assuming Firestore instance is provided elsewhere, or injected directly in implementation.
  // For this context, we assume the repository handles its own Firestore instance.
  return FirestoreUserRepository();
});

//------------------ Application Logic / State Notifier Providers ------------------//

/// Provides the [LoginNotifier] and its state for the login screen.
/// It handles the business logic for both email/password and phone OTP login.
final loginNotifierProvider = StateNotifierProvider.autoDispose<LoginNotifier, LoginState>((ref) {
  return LoginNotifier(
    authRepository: ref.watch(authRepositoryProvider),
  );
});

//------------------ User Profile & Role Providers ------------------//

/// Provides the [UserProfile] of the currently authenticated user.
/// It returns null if the user is not logged in.
/// This provider is crucial for role-based routing and displaying user-specific data.
final userProfileProvider = FutureProvider<UserProfile?>((ref) async {
  final authRepository = ref.watch(authRepositoryProvider);
  final authState = ref.watch(authStateChangesProvider);

  final user = authState.asData?.value;
  if (user != null) {
    final profileResult = await authRepository.getUserProfile(user.uid);
    return profileResult.fold(
      (failure) {
        // Log the failure, but return null for the UI to handle gracefully
        // e.g., show an error screen or force logout.
        print('Failed to get user profile: $failure');
        return null;
      },
      (profile) => profile,
    );
  }
  return null;
});

/// A provider that handles post-authentication tasks, such as updating the FCM token.
/// This is a FutureProvider that can be watched on a loading screen after login.
final postLoginInitializationProvider = FutureProvider<void>((ref) async {
  final user = ref.watch(authStateChangesProvider).asData?.value;
  if (user == null) return;

  final notificationService = ref.watch(notificationHandlerServiceProvider);
  final userRepository = ref.watch(userRepositoryProvider);

  // Initialize notifications and get token
  await notificationService.initialize();
  final fcmToken = await notificationService.getToken();

  if (fcmToken != null) {
    // Update the user's profile with the latest FCM token
    await userRepository.updateFcmToken(userId: user.uid, token: fcmToken);
  }
});