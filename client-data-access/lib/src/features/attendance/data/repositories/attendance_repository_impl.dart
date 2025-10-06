import 'package:fpdart/fpdart.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/attendance_record.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../datasources/attendance_remote_data_source.dart';
import '../models/attendance_model.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AttendanceRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, void>> createAttendanceRecord(
      AttendanceRecord record) async {
    try {
      final isConnected = await networkInfo.isConnected;
      final attendanceModel = AttendanceModel.fromEntity(record)
          .copyWith(isOfflineEntry: !isConnected);
      await remoteDataSource.createAttendanceRecord(attendanceModel);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateAttendanceRecord(
      AttendanceRecord record) async {
    try {
      final isConnected = await networkInfo.isConnected;
      // Note: check-outs for offline check-ins should also be flagged.
      final model = AttendanceModel.fromEntity(record);
      final finalModel =
          !isConnected ? model.copyWith(isOfflineEntry: true) : model;
      await remoteDataSource.updateAttendanceRecord(finalModel);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Stream<Either<Failure, List<AttendanceRecord>>>
      watchPendingSubordinateRecords(String supervisorId) {
    try {
      return remoteDataSource
          .watchPendingSubordinateRecords(supervisorId)
          .map((records) => Right(records));
    } catch (e) {
      return Stream.value(Left(
          ServerFailure(message: 'Failed to stream pending records.')));
    }
  }

  @override
  Stream<Either<Failure, List<AttendanceRecord>>> watchUserAttendanceRecords(
      String userId, DateTime startDate, DateTime endDate) {
    try {
      return remoteDataSource
          .watchUserAttendanceRecords(userId, startDate, endDate)
          .map((records) => Right(records));
    } catch (e) {
      return Stream.value(Left(
          ServerFailure(message: 'Failed to stream attendance records.')));
    }
  }

  @override
  Future<Either<Failure, void>> submitCorrectionRequest({
    required String attendanceRecordId,
    required String justification,
    DateTime? newCheckInTime,
    DateTime? newCheckOutTime,
  }) async {
    try {
      await remoteDataSource.submitCorrectionRequest(
        attendanceRecordId: attendanceRecordId,
        justification: justification,
        newCheckInTime: newCheckInTime,
        newCheckOutTime: newCheckOutTime,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
  
  @override
  Future<Either<Failure, void>> approveAttendanceRecords(List<String> recordIds) async {
    try {
      await remoteDataSource.approveAttendanceRecords(recordIds);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> rejectAttendanceRecords(List<String> recordIds, String reason) async {
     try {
      await remoteDataSource.rejectAttendanceRecords(recordIds, reason);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
  
  @override
  Stream<Either<Failure, List<AttendanceRecord>>> getAttendanceReports({
    required DateTime startDate,
    required DateTime endDate,
    List<String>? userIds,
    List<String>? teamIds,
    List<String>? statuses,
  }) {
     try {
      return remoteDataSource
          .getAttendanceReports(
            startDate: startDate,
            endDate: endDate,
            userIds: userIds,
            teamIds: teamIds,
            statuses: statuses,
          )
          .map((records) => Right(records));
    } catch (e) {
      return Stream.value(Left(
          ServerFailure(message: 'Failed to get attendance reports.')));
    }
  }

  @override
  Future<Either<Failure, void>> approveCorrectionRequest(String recordId) async {
    try {
      await remoteDataSource.approveCorrectionRequest(recordId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> rejectCorrectionRequest(String recordId, String reason) async {
    try {
      await remoteDataSource.rejectCorrectionRequest(recordId, reason);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}