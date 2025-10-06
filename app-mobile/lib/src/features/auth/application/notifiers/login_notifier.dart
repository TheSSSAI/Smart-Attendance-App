import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:repo_lib_client_008/repo_lib_client_008.dart';

part 'login_notifier.freezed.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState.initial() = _Initial;
  const factory LoginState.loading() = _Loading;
  const factory LoginState.otpSent(String verificationId) = _OtpSent;
  const factory LoginState.success(User user) = _Success;
  const factory LoginState.error(String message) = _Error;
}

class LoginNotifier extends StateNotifier<LoginState> {
  final IAuthRepository _authRepository;

  LoginNotifier(this._authRepository) : super(const LoginState.initial());

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    state = const LoginState.loading();
    try {
      if (email.isEmpty || password.isEmpty) {
        state = const LoginState.error('Email and password cannot be empty.');
        return;
      }
      final user = await _authRepository.signInWithEmailAndPassword(email, password);
      state = LoginState.success(user);
    } on AuthException catch (e) {
      state = LoginState.error(e.message);
    } catch (e) {
      state = const LoginState.error('An unexpected error occurred. Please try again.');
    }
  }

  Future<void> sendOtp(String phoneNumber) async {
    state = const LoginState.loading();
    try {
      final verificationId = await _authRepository.sendOtp(
        phoneNumber: phoneNumber,
        timeout: const Duration(minutes: 2),
      );
      state = LoginState.otpSent(verificationId);
    } on AuthException catch (e) {
      state = LoginState.error(e.message);
    } catch (e) {
      state = const LoginState.error('An unexpected error occurred while sending OTP.');
    }
  }

  Future<void> verifyOtpAndSignIn(String verificationId, String otp) async {
    state = const LoginState.loading();
    try {
      final user = await _authRepository.verifyOtpAndSignIn(
        verificationId: verificationId,
        otp: otp,
      );
      state = LoginState.success(user);
    } on AuthException catch (e) {
      state = LoginState.error(e.message);
    } catch (e) {
      state = const LoginState.error('An unexpected error occurred during OTP verification.');
    }
  }

  void resetState() {
    state = const LoginState.initial();
  }
}