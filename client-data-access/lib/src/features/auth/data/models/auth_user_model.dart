import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:equatable/equatable.dart';

import '../../domain/entities/auth_user.dart';

class AuthUserModel extends AuthUser {
  const AuthUserModel({
    required String uid,
    String? email,
    String? displayName,
    bool isEmailVerified = false,
  }) : super(
          uid: uid,
          email: email,
          displayName: displayName,
          isEmailVerified: isEmailVerified,
        );

  factory AuthUserModel.fromFirebaseUser(firebase.User user) {
    return AuthUserModel(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      isEmailVerified: user.emailVerified,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'isEmailVerified': isEmailVerified,
    };
  }

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      uid: json['uid'] as String,
      email: json['email'] as String?,
      displayName: json['displayName'] as String?,
      isEmailVerified: json['isEmailVerified'] as bool? ?? false,
    );
  }

  AuthUserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    bool? isEmailVerified,
  }) {
    return AuthUserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
    );
  }
}