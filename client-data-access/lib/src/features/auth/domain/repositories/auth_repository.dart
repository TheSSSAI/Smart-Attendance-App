import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/auth_user.dart';

/// The repository contract for handling authentication-related operations.
///
/// This abstract class defines the interface for all authentication methods,
/// including signing in, signing out, registration, and observing the authentication state.
/// It decouples the application from the specific authentication provider (e.g., Firebase Auth).
abstract class AuthRepository {
  /// Authenticates a user with their email and password.
  ///
  /// - [email]: The user's email address.
  /// - [password]: The user's password.
  ///
  /// Returns a [Future] of `Either<Failure, AuthUser>`.
  /// - [Right<AuthUser>] containing the authenticated user's data on success.
  /// - [Left<Failure>] on any authentication error, such as [ServerFailure] for
  ///   invalid credentials or network issues.
  Future<Either<Failure, AuthUser>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Sends a One-Time Password (OTP) to the user's phone number to initiate login.
  ///
  /// - [phoneNumber]: The user's full phone number including country code.
  ///
  /// Returns a [Future] of `Either<Failure, String>`.
  /// - [Right<String>] containing the verification ID required for `signInWithSmsCode`.
  /// - [Left<Failure>] on any error, such as an invalid phone number or rate limiting.
  Future<Either<Failure, String>> verifyPhoneNumber(String phoneNumber);

  /// Signs in the user using the verification ID and the SMS code they received.
  ///
  /// - [verificationId]: The ID received from the `verifyPhoneNumber` call.
  /// - [smsCode]: The 6-digit code received by the user via SMS.
  ///
  /// Returns a [Future] of `Either<Failure, AuthUser>`.
  /// - [Right<AuthUser>] with the authenticated user's data on success.
  /// - [Left<Failure>] on any error, such as an invalid or expired code.
  Future<Either<Failure, AuthUser>> signInWithSmsCode({
    required String verificationId,
    required String smsCode,
  });

  /// Signs out the currently authenticated user.
  ///
  /// Clears the user's session from the device.
  ///
  /// Returns a [Future] of `Either<Failure, void>`.
  /// - [Right<void>] on successful sign-out.
  /// - [Left<Failure>] if an error occurs during the sign-out process.
  Future<Either<Failure, void>> signOut();

  /// Provides a stream of the current authentication state.
  ///
  /// Emits a [AuthUser] object when a user is signed in, and `null` when
  /// they are signed out. This is the primary mechanism for the application to
  /// react to changes in the user's authentication status.
  ///
  /// Returns a [Stream] of `AuthUser?`.
  Stream<AuthUser?> get authStateChanges;

  /// Gets the currently signed-in user, if any.
  ///
  /// Returns a [Future] of `Either<Failure, AuthUser?>`.
  /// - [Right<AuthUser?>] with the current user or null if not authenticated.
  /// - [Left<Failure>] if there's an issue retrieving the user state.
  Future<Either<Failure, AuthUser?>> getCurrentUser();

  /// Registers a new organization and its first Admin user.
  ///
  /// This is the entry point for a new company to join the platform.
  ///
  /// - [organizationName]: The unique name for the new organization.
  /// - [adminName]: The full name of the registering administrator.
  /// - [email]: The administrator's email address.
  /// - [password]: The administrator's chosen password.
  ///
  /// Returns a [Future] of `Either<Failure, AuthUser>`.
  /// - [Right<AuthUser>] with the newly created Admin user's data on success.
  /// - [Left<Failure>] on any error, such as a duplicate organization name.
  Future<Either<Failure, AuthUser>> registerOrganization({
    required String organizationName,
    required String adminName,
    required String email,
    required String password,
  });

  /// Completes the registration for a user who was invited via email.
  ///
  /// - [invitationToken]: The unique token from the registration link.
  /// - [password]: The new password set by the user.
  ///
  /// Returns a [Future] of `Either<Failure, void>`.
  /// - [Right<void>] on successful account activation.
  /// - [Left<Failure>] if the token is invalid, expired, or an error occurs.
  Future<Either<Failure, void>> completeInvitedUserRegistration({
    required String invitationToken,
    required String password,
  });

  /// Sends a password reset link to the specified email address.
  ///
  /// - [email]: The email address of the user who forgot their password.
  ///
  /// Returns a [Future] of `Either<Failure, void>`.
  /// - [Right<void>] on success (note: success is returned even if the email
  ///   does not exist to prevent email enumeration).
  /// - [Left<Failure>] on server or network errors.
  Future<Either<Failure, void>> sendPasswordResetEmail(String email);
}