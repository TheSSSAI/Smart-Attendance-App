import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/team.dart';

/// The repository contract for handling team-related data operations.
///
/// This abstract class defines the interface for creating, reading, updating,
/// and deleting teams, as well as managing team membership. It serves as the
/// boundary between the domain and data layers for the Team aggregate.
abstract class TeamRepository {
  /// Creates a new team within the tenant.
  ///
  /// - [name]: The name of the new team. Must be unique within the tenant.
  /// - [supervisorId]: The ID of the user assigned as the team's supervisor.
  ///
  /// Returns a [Future] of `Either<Failure, String>`.
  /// - [Right<String>] with the ID of the newly created team on success.
  /// - [Left<Failure>] on any error, such as a non-unique name.
  Future<Either<Failure, String>> createTeam({
    required String name,
    required String supervisorId,
  });

  /// Updates an existing team's details.
  ///
  /// - [team]: The [Team] entity with updated information. The ID must be valid.
  ///
  /// Returns a [Future] of `Either<Failure, void>`.
  /// - [Right<void>] on successful update.
  /// - [Left<Failure>] on any error.
  Future<Either<Failure, void>> updateTeam(Team team);

  /// Deletes a team.
  ///
  /// Implementations must handle the logic of disassociating members from the team.
  ///
  /// - [teamId]: The ID of the team to delete.
  ///
  /// Returns a [Future] of `Either<Failure, void>`.
  /// - [Right<void>] on successful deletion.
  /// - [Left<Failure>] on any error.
  Future<Either<Failure, void>> deleteTeam(String teamId);

  /// Watches for real-time updates to all teams within the current user's tenant.
  ///
  /// Returns a [Stream] of `Either<Failure, List<Team>>`.
  /// - Emits [Right<List<Team>>] with the list of all teams.
  /// - Emits [Left<Failure>] if a data source error occurs.
  Stream<Either<Failure, List<Team>>> watchAllTeams();

  /// Fetches a single team by its ID.
  ///
  /// - [teamId]: The unique identifier for the team.
  ///
  /// Returns a [Future] of `Either<Failure, Team>`.
  /// - [Right<Team>] with the found team.
  /// - [Left<Failure>] if the team is not found or an error occurs.
  Future<Either<Failure, Team>> getTeamById(String teamId);

  /// Adds a user to a team.
  ///
  /// Implementations must ensure data consistency (e.g., update both the
  /// team's member list and the user's team list).
  ///
  /// - [teamId]: The ID of the team to add the user to.
  /// - [userId]: The ID of the user to be added.
  ///
  /// Returns a [Future] of `Either<Failure, void>`.
  /// - [Right<void>] on success.
  /// - [Left<Failure>] on error.
  Future<Either<Failure, void>> addMemberToTeam({
    required String teamId,
    required String userId,
  });

  /// Removes a user from a team.
  ///
  /// Implementations must ensure data consistency.
  ///
  /// - [teamId]: The ID of the team to remove the user from.
  /// - [userId]: The ID of the user to be removed.
  ///
  /// Returns a [Future] of `Either<Failure, void>`.
  /// - [Right<void>] on success.
  /// - [Left<Failure>] on error.
  Future<Either<Failure, void>> removeMemberFromTeam({
    required String teamId,
    required String userId,
  });

  /// Fetches all teams managed by a specific supervisor.
  ///
  /// - [supervisorId]: The ID of the supervisor.
  ///
  /// Returns a [Stream] of `Either<Failure, List<Team>>`.
  /// - Emits [Right<List<Team>>] with the list of managed teams.
  /// - Emits [Left<Failure>] on error.
  Stream<Either<Failure, List<Team>>> watchTeamsBySupervisor(
      String supervisorId);
}