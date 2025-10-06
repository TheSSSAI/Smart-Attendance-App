import 'package:fpdart/fpdart.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/team.dart';
import '../../domain/repositories/team_repository.dart';
import '../datasources/team_remote_data_source.dart';
import '../models/team_model.dart';

class TeamRepositoryImpl implements TeamRepository {
  final TeamRemoteDataSource remoteDataSource;

  TeamRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, String>> createTeam(Team team) async {
    try {
      final teamModel = TeamModel.fromEntity(team);
      final teamId = await remoteDataSource.createTeam(teamModel);
      return Right(teamId);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTeam(String teamId) async {
    try {
      await remoteDataSource.deleteTeam(teamId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateTeam(Team team) async {
    try {
      final teamModel = TeamModel.fromEntity(team);
      await remoteDataSource.updateTeam(teamModel);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> addMemberToTeam(
      {required String teamId, required String userId}) async {
    try {
      await remoteDataSource.addMemberToTeam(teamId: teamId, userId: userId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> removeMemberFromTeam(
      {required String teamId, required String userId}) async {
    try {
      await remoteDataSource.removeMemberFromTeam(
          teamId: teamId, userId: userId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Stream<Either<Failure, List<Team>>> watchAllTeams() {
    try {
      return remoteDataSource.watchAllTeams().map((teams) => Right(teams));
    } catch (e) {
      return Stream.value(
          Left(ServerFailure(message: 'Failed to stream teams.')));
    }
  }

  @override
  Stream<Either<Failure, List<Team>>> watchSupervisorTeams(
      String supervisorId) {
    try {
      return remoteDataSource
          .watchSupervisorTeams(supervisorId)
          .map((teams) => Right(teams));
    } catch (e) {
      return Stream.value(
          Left(ServerFailure(message: 'Failed to stream supervisor teams.')));
    }
  }
}