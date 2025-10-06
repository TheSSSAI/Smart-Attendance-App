import 'package:equatable/equatable.dart';

import '../../../user/domain/entities/user.dart';

/// Represents the core authenticated user identity within the application.
/// This entity contains the essential information derived from the authentication
/// token (JWT) and is used for authorization and identification throughout the app.
class AuthUser extends Equatable {
  /// The unique identifier of the user (from Firebase Auth UID).
  final String id;

  /// The user's email address.
  final String? email;

  /// The user's assigned role within their tenant.
  final UserRole role;

  /// The unique identifier of the tenant the user belongs to.
  final String tenantId;

  /// A flag indicating if the user has provided a display name.
  final bool get hasDisplayName => (displayName?.isNotEmpty ?? false);

  /// The user's display name.
  final String? displayName;

  const AuthUser({
    required this.id,
    this.email,
    required this.role,
    required this.tenantId,
    this.displayName,
  });

  /// Represents an unauthenticated user.
  /// This is useful for initializing state in the application.
  static const empty = AuthUser(
    id: '',
    role: UserRole.subordinate, // Default to most restrictive role
    tenantId: '',
  );

  /// Convenience getter to check if the user is authenticated.
  bool get isAuthenticated => id.isNotEmpty;

  /// Convenience getter to check if the user is an Admin.
  bool get isAdmin => role == UserRole.admin;

  /// Convenience getter to check if the user is a Supervisor.
  bool get isSupervisor => role == UserRole.supervisor;

  @override
  List<Object?> get props => [id, email, role, tenantId, displayName];
}