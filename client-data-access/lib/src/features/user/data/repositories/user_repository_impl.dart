import 'package:fpdart/fpdart.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, User>> getUser(String userId) async {
    try {
      final userModel = await remoteDataSource.getUser(userId);
      return Right(userModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Stream<Either<Failure, User>> watchUser(String userId) {
    try {
      return remoteDataSource.watchUser(userId).map((user) => Right(user));
    } catch (e) {
      return Stream.value(
          Left(ServerFailure(message: 'Failed to stream user data.')));
    }
  }
  
  @override
  Future<Either<Failure, void>> inviteUser(String email, String role) async {
    try {
      await remoteDataSource.inviteUser(email, role);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateUser(User user) async {
     try {
      // Assuming UserModel has a fromEntity constructor or similar
      await remoteDataSource.updateUser(user);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deactivateUser(String userId) async {
    try {
      await remoteDataSource.deactivateUser(userId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
  
  @override
  Future<Either<Failure, void>> reassignSubordinates({
    required List<String> subordinateIds,
    required String newSupervisorId,
  }) async {
    try {
      await remoteDataSource.reassignSubordinates(
        subordinateIds: subordinateIds,
        newSupervisorId: newSupervisorId,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
  
  @override
  Stream<Either<Failure, List<User>>> watchAllUsers() {
    try {
      return remoteDataSource.watchAllUsers().map((users) => Right(users));
    } catch (e) {
      return Stream.value(
          Left(ServerFailure(message: 'Failed to stream all users.')));
    }
  }

  @override
  Stream<Either<Failure, List<User>>> watchSubordinates(String supervisorId) {
     try {
      return remoteDataSource
          .watchSubordinates(supervisorId)
          .map((users) => Right(users));
    } catch (e) {
      return Stream.value(
          Left(ServerFailure(message: 'Failed to stream subordinates.')));
    }
  }
  
  @override
  Stream<Either<Failure, List<User>>> watchEligibleSupervisors() {
     try {
      return remoteDataSource
          .watchEligibleSupervisors()
          .map((users) => Right(users));
    } catch (e) {
      return Stream.value(
          Left(ServerFailure(message: 'Failed to stream eligible supervisors.')));
    }
  }
}