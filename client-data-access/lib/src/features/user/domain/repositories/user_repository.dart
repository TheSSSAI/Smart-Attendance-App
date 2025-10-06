import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user.dart';

/// The repository contract for handling user-related data operations.
///
/// This abstract class defines the interface for managing user profiles,
/// including fetching, updating, and managing their lifecycle (invitation, deactivation).
abstract class UserRepository {
  /// Watches for real-time updates to a specific user's profile.
  ///
  /// - [userId]: The ID of the user to watch.
  ///
  /// Returns a [Stream] of `Either<Failure, User>`.
  /// - Emits [Right<User>] with the user's profile data on initial fetch and
  ///   any subsequent changes.
  /// - Emits [Left<Failure>] if an error occurs.
  Stream<Either<Failure, User>> watchUser(String userId);

  /// Fetches a single user by their ID.
  ///
  /// - [userId]: The ID of the user to fetch.
  ///
  /// Returns a [Future] of `Either<Failure, User>`.
  /// - [Right<User>] on success.
  /// - [Left<Failure>] if the user is not found or an error occurs.
  Future<Either<Failure, User>> getUser(String userId);

  /// Fetches a paginated list of all users within the current user's tenant.
  ///
  /// This is typically used by Admins.
  ///
  /// Returns a [Future] of `Either<Failure, List<User>>`.
  /// - [Right<List<User>>] with a list of users.
  /// - [Left<Failure>] on error.
  Future<Either<Failure, List<User>>> getAllUsersInTenant();

  /// Fetches a list of all subordinates for a given supervisor.
  ///
  /// - [supervisorId]: The ID of the supervisor.
  ///
  /// Returns a [Future] of `Either<Failure, List<User>>`.
  /// - [Right<List<User>>] with a list of subordinates.
  /// - [Left<Failure>] on error.
  Future<Either<Failure, List<User>>> getSubordinates(String supervisorId);

  /// Invites a new user to the organization.
  ///
  /// This process creates a user profile with an 'invited' status and triggers
  /// an email with a registration link.
  ///
  /// - [email]: The email of the user to invite.
  /// - [role]: The role to assign to the new user.
  ///
  /// Returns a [Future] of `Either<Failure, void>`.
  /// - [Right<void>] on successful invitation.
  /// - [Left<Failure>] on error (e.g., user already exists).
  Future<Either<Failure, void>> inviteUser({
    required String email,
    required UserRole role,
  });

  /// Updates an existing user's profile information.
  ///
  /// - [user]: The [User] entity with updated data. The ID must be valid.
  ///
  /// Returns a [Future] of `Either<Failure, void>`.
  /// - [Right<void>] on successful update.
  /// - [Left<Failure>] on error.
  Future<Either<Failure, void>> updateUser(User user);

  /// Deactivates a user's account, preventing them from logging in.
  ///
  /// - [userId]: The ID of the user to deactivate.
  ///
  /// Returns a [Future] of `Either<Failure, void>`.
  /// - [Right<void>] on successful deactivation.
  /// - [Left<Failure>] on error (e.g., trying to deactivate a supervisor with subordinates).
  Future<Either<Failure, void>> deactivateUser(String userId);

  /// Reactivates a user's account.
  ///
  /// - [userId]: The ID of the user to reactivate.
  ///
  /// Returns a [Future] of `Either<Failure, void>`.
  /// - [Right<void>] on successful reactivation.
  /// - [Left<Failure>] on error.
  Future<Either<Failure, void>> reactivateUser(String userId);
}