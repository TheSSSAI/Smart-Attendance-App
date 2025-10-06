import 'package:fpdart/fpdart.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Stream<AuthUser?> get authStateChanges =>
      remoteDataSource.authStateChanges;

  @override
  Future<Either<Failure, AuthUser>> signInWithEmailAndPassword(
      String email, String password) async {
    if (await networkInfo.isConnected) {
      try {
        final user =
            await remoteDataSource.signInWithEmailAndPassword(email, password);
        return Right(user);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
  
  @override
  Future<Either<Failure, void>> sendPasswordResetEmail(String email) async {
     if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.sendPasswordResetEmail(email);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, AuthUser>> registerOrganization({
    required String orgName,
    required String adminName,
    required String email,
    required String password,
    required String region,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.registerOrganization(
          orgName: orgName,
          adminName: adminName,
          email: email,
          password: password,
          region: region,
        );
        return Right(user);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> completeRegistration({
    required String token,
    required String password,
  }) async {
     if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.completeRegistration(
          token: token,
          password: password,
        );
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> requestOtp(String phoneNumber) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.requestOtp(phoneNumber);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, AuthUser>> signInWithOtp(String smsCode) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.signInWithOtp(smsCode);
        return Right(user);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}