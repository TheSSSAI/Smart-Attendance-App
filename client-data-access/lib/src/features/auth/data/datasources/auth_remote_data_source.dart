import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:firebase_functions/firebase_functions.dart';

import '../../../../core/error/exceptions.dart';
import '../models/auth_user_model.dart';

abstract class AuthRemoteDataSource {
  /// Signs in a user with their email and password.
  /// Throws [ServerException] for all error codes.
  Future<AuthUserModel> signInWithEmailAndPassword(String email, String password);

  /// Signs in a user with a phone credential after OTP verification.
  /// Throws [ServerException] for all error codes.
  Future<AuthUserModel> signInWithPhoneCredential(firebase.PhoneAuthCredential credential);

  /// Initiates phone number verification and sends an OTP.
  /// Callbacks handle the stream of verification states.
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(firebase.PhoneAuthCredential) verificationCompleted,
    required void Function(firebase.FirebaseAuthException) verificationFailed,
    required void Function(String, int?) codeSent,
    required void Function(String) codeAutoRetrievalTimeout,
  });

  /// Signs out the current user.
  /// Throws [ServerException] on failure.
  Future<void> signOut();

  /// Provides a stream of the current authentication state.
  Stream<AuthUserModel?> get authStateChanges;

  /// Gets the current authenticated user model.
  Future<AuthUserModel?> getCurrentUser();

  /// Calls a cloud function to register a new organization and its first admin.
  /// Throws [ServerException] for all error codes.
  Future<AuthUserModel> registerOrganization({
    required String orgName,
    required String adminName,
    required String email,
    required String password,
    required String dataResidencyRegion,
  });

  /// Calls a cloud function to complete the registration for an invited user.
  /// Throws [ServerException] for all error codes.
  Future<void> completeRegistration({
    required String token,
    required String password,
  });

  /// Sends a password reset email to the given email address.
  /// Throws [ServerException] for all error codes.
  Future<void> sendPasswordResetEmail(String email);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final firebase.FirebaseAuth _firebaseAuth;
  final FirebaseFunctions _functions;

  AuthRemoteDataSourceImpl({
    required firebase.FirebaseAuth firebaseAuth,
    required FirebaseFunctions functions,
  })  : _firebaseAuth = firebaseAuth,
        _functions = functions;

  @override
  Future<AuthUserModel> signInWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user == null) {
        throw const ServerException(message: 'Login failed: User not found.', code: 'user-not-found');
      }
      return AuthUserModel.fromFirebaseUser(userCredential.user!);
    } on firebase.FirebaseAuthException catch (e) {
      throw ServerException(message: e.message ?? 'An unknown error occurred.', code: e.code);
    } catch (e) {
      throw ServerException(message: e.toString(), code: 'generic-error');
    }
  }

  @override
  Future<AuthUserModel> signInWithPhoneCredential(firebase.PhoneAuthCredential credential) async {
    try {
      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      if (userCredential.user == null) {
        throw const ServerException(message: 'Login failed: User not found.', code: 'user-not-found');
      }
      return AuthUserModel.fromFirebaseUser(userCredential.user!);
    } on firebase.FirebaseAuthException catch (e) {
      throw ServerException(message: e.message ?? 'An unknown error occurred.', code: e.code);
    } catch (e) {
      throw ServerException(message: e.toString(), code: 'generic-error');
    }
  }

  @override
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(firebase.PhoneAuthCredential) verificationCompleted,
    required void Function(firebase.FirebaseAuthException) verificationFailed,
    required void Function(String, int?) codeSent,
    required void Function(String) codeAutoRetrievalTimeout,
  }) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
    } on firebase.FirebaseAuthException catch (e) {
      throw ServerException(message: e.message ?? 'An unknown error occurred.', code: e.code);
    } catch (e) {
      throw ServerException(message: e.toString(), code: 'generic-error');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on firebase.FirebaseAuthException catch (e) {
      throw ServerException(message: e.message ?? 'An unknown error occurred.', code: e.code);
    } catch (e) {
      throw ServerException(message: e.toString(), code: 'generic-error');
    }
  }

  @override
  Stream<AuthUserModel?> get authStateChanges =>
      _firebaseAuth.authStateChanges().map((firebaseUser) =>
          firebaseUser != null ? AuthUserModel.fromFirebaseUser(firebaseUser) : null);

  @override
  Future<AuthUserModel?> getCurrentUser() async {
    try {
      final firebaseUser = _firebaseAuth.currentUser;
      return firebaseUser != null ? AuthUserModel.fromFirebaseUser(firebaseUser) : null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<AuthUserModel> registerOrganization({
    required String orgName,
    required String adminName,
    required String email,
    required String password,
    required String dataResidencyRegion,
  }) async {
    try {
      final callable = _functions.httpsCallable('registerOrganization');
      final result = await callable.call(<String, dynamic>{
        'orgName': orgName,
        'adminName': adminName,
        'email': email,
        'password': password,
        'dataResidencyRegion': dataResidencyRegion,
      });

      // After successful registration, sign in the new user to get the AuthUserModel
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user == null) {
        throw const ServerException(message: 'Failed to sign in after registration.', code: 'signin-failed');
      }
      return AuthUserModel.fromFirebaseUser(userCredential.user!);

    } on FirebaseFunctionsException catch (e) {
      throw ServerException(message: e.message ?? 'Unknown error', code: e.code);
    } catch (e) {
      throw ServerException(message: e.toString(), code: 'generic-error');
    }
  }
  
  @override
  Future<void> completeRegistration({required String token, required String password}) async {
     try {
      final callable = _functions.httpsCallable('completeRegistration');
      await callable.call(<String, dynamic>{
        'token': token,
        'password': password,
      });
    } on FirebaseFunctionsException catch (e) {
      throw ServerException(message: e.message ?? 'Unknown error', code: e.code);
    } catch (e) {
      throw ServerException(message: e.toString(), code: 'generic-error');
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on firebase.FirebaseAuthException catch (e) {
      throw ServerException(message: e.message ?? 'An unknown error occurred.', code: e.code);
    } catch (e) {
      throw ServerException(message: e.toString(), code: 'generic-error');
    }
  }
}