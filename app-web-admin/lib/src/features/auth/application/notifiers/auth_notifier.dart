import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:attendance_client_data/attendance_client_data.dart';

part 'auth_notifier.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated({required AppUser user}) = _Authenticated;
  const factory AuthState.unauthenticated({String? message}) = _Unauthenticated;
  const factory AuthState.requiresMfa() = _RequiresMfa;
  const factory AuthState.registrationSuccess() = _RegistrationSuccess;
}

class AuthNotifier extends StateNotifier<AuthState> {
  final IAuthRepository _authRepository;
  final IUserRepository _userRepository;
  StreamSubscription<AppUser?>? _authStateSubscription;

  AuthNotifier(this._authRepository, this._userRepository)
      : super(const AuthState.initial()) {
    _authStateSubscription = _authRepository.authStateChanges.listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(AppUser? user) async {
    if (user != null) {
      // User is authenticated with Firebase, now check role and status from Firestore
      try {
        final userProfile = await _userRepository.getUserById(user.uid);
        if (userProfile != null) {
          if (userProfile.status == 'active') {
             if (userProfile.role == 'Admin') {
                state = AuthState.authenticated(user: userProfile);
             } else {
                await signOut();
                state = const AuthState.unauthenticated(message: "Web dashboard is for Admins only.");
             }
          } else {
             await signOut();
             state = AuthState.unauthenticated(
                message: "Your account is not active. Please contact your administrator.");
          }
        } else {
          // This case can happen during registration flow or if Firestore data is missing
          await signOut();
          state = const AuthState.unauthenticated(
              message: "User profile not found. Please contact support.");
        }
      } catch (e) {
        await signOut();
        state = AuthState.unauthenticated(message: "An error occurred while fetching your profile: ${e.toString()}");
      }
    } else {
      state = const AuthState.unauthenticated();
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    state = const AuthState.loading();
    try {
      await _authRepository.signInWithEmailAndPassword(email, password);
      // Auth state change will be handled by the stream listener
    } on AppException catch (e) {
      state = AuthState.unauthenticated(message: e.message);
    } catch (e) {
      state = AuthState.unauthenticated(message: "An unexpected error occurred: ${e.toString()}");
    }
  }

  Future<void> registerOrganization({
    required String orgName,
    required String adminName,
    required String email,
    required String password,
    required String dataResidencyRegion,
  }) async {
    state = const AuthState.loading();
    try {
      // This operation is expected to be a single transactional call to a backend function
      // exposed via a repository method.
      await _authRepository.registerOrganization(
        orgName: orgName,
        adminName: adminName,
        email: email,
        password: password,
        dataResidencyRegion: dataResidencyRegion,
      );
      // On success, the user is created and auth state will change, handled by listener.
      // We can also set a specific state for the UI to show a "Check your email" or similar message if needed.
      state = const AuthState.registrationSuccess();

    } on AppException catch (e) {
      state = AuthState.unauthenticated(message: e.message);
    } catch (e) {
      state = AuthState.unauthenticated(message: "An unexpected registration error occurred: ${e.toString()}");
    }
  }

  Future<void> signOut() async {
    try {
      await _authRepository.signOut();
      state = const AuthState.unauthenticated();
    } on AppException catch (e) {
      // Even if sign-out fails, force the state to unauthenticated
      state = AuthState.unauthenticated(message: "Error signing out: ${e.message}");
    } catch (e) {
      state = AuthState.unauthenticated(message: "An unexpected error occurred during sign-out: ${e.toString()}");
    }
  }

  @override
  void dispose() {
    _authStateSubscription?.cancel();
    super.dispose();
  }
}