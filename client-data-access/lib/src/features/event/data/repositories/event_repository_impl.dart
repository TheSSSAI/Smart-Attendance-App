import 'package:fpdart/fpdart.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/event.dart';
import '../../domain/repositories/event_repository.dart';
import '../datasources/event_remote_data_source.dart';
import '../models/event_model.dart';


class EventRepositoryImpl implements EventRepository {
  final EventRemoteDataSource remoteDataSource;

  EventRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, String>> createEvent(Event event) async {
    try {
      final eventModel = EventModel.fromEntity(event);
      final eventId = await remoteDataSource.createEvent(eventModel);
      return Right(eventId);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteEvent(String eventId) async {
    try {
      await remoteDataSource.deleteEvent(eventId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateEvent(Event event) async {
    try {
      final eventModel = EventModel.fromEntity(event);
      await remoteDataSource.updateEvent(eventModel);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Stream<Either<Failure, List<Event>>> watchEventsForUser({
    required String userId,
    required List<String> teamIds,
    required DateTime date,
  }) {
    try {
      return remoteDataSource
          .watchEventsForUser(userId: userId, teamIds: teamIds, date: date)
          .map((events) => Right(events));
    } catch (e) {
      return Stream.value(
          Left(ServerFailure(message: 'Failed to stream events.')));
    }
  }

  @override
  Stream<Either<Failure, List<Event>>> watchEventsForSupervisor({
    required String supervisorId,
    required DateTime startDate,
    required DateTime endDate,
  }) {
     try {
      return remoteDataSource
          .watchEventsForSupervisor(supervisorId: supervisorId, startDate: startDate, endDate: endDate)
          .map((events) => Right(events));
    } catch (e) {
      return Stream.value(
          Left(ServerFailure(message: 'Failed to stream supervisor events.')));
    }
  }
}