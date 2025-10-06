import 'package:equatable/equatable.dart';

/// Enum representing the possible roles a user can have within a tenant.
enum UserRole {
  admin,
  supervisor,
  subordinate,
}

/// Enum representing the possible lifecycle statuses of a user account.
enum UserStatus {
  invited,
  active,
  deactivated,
  anonymized,
}

/// Represents a detailed user profile within an organization's tenant.
/// This is a pure domain entity.
class User extends Equatable {
  /// The unique identifier of the user (matches Firebase Auth UID).
  final String id;

  /// The ID of the tenant the user belongs to.
  final String tenantId;

  /// The user's email address.
  final String email;

  /// The user's first name.
  final String? firstName;

  /// The user's last name.
  final String? lastName;

  /// The user's assigned role.
  final UserRole role;

  /// The current status of the user's account.
  final UserStatus status;

  /// The ID of the user's direct supervisor, if any.
  final String? supervisorId;

  /// A list of team IDs the user is a member of.
  final List<String> teamIds;

  /// The user's registered phone number.
  final String? phoneNumber;
  
  /// Timestamp when the user was created.
  final DateTime? createdAt;
  
  /// Timestamp when the user was last deactivated.
  final DateTime? deactivatedAt;

  const User({
    required this.id,
    required this.tenantId,
    required this.email,
    this.firstName,
    this.lastName,
    required this.role,
    required this.status,
    this.supervisorId,
    this.teamIds = const [],
    this.phoneNumber,
    this.createdAt,
    this.deactivatedAt,
  });

  /// A convenience getter to return the user's full name.
  /// Returns the email if no name is available.
  String get fullName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    }
    if (firstName != null) {
      return firstName!;
    }
    if (lastName != null) {
      return lastName!;
    }
    return email;
  }
  
  /// A convenience getter to check if the user is in an active state.
  bool get isActive => status == UserStatus.active;

  @override
  List<Object?> get props => [
        id,
        tenantId,
        email,
        firstName,
        lastName,
        role,
        status,
        supervisorId,
        teamIds,
        phoneNumber,
        createdAt,
        deactivatedAt,
      ];
}