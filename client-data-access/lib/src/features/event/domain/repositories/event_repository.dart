import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/event.dart';

/// The repository contract for handling event-related data operations.
///
/// This abstract class defines the interface for creating, reading, updating,
/// and deleting events within a tenant. It decouples the application from the
/// specifics of the event data source.
abstract class EventRepository {
  /// Creates a new event.
  ///
  /// - [event]: The [Event] entity to be created.
  ///
  /// Returns a [Future] of `Either<Failure, String>`.
  /// - [Right<String>] with the ID of the newly created event on success.
  /// - [Left<Failure>] on any error.
  Future<Either<Failure, String>> createEvent(Event event);

  /// Updates an existing event.
  ///
  /// - [event]: The [Event] entity with updated information. The ID must be valid.
  ///
  /// Returns a [Future] of `Either<Failure, void>`.
  /// - [Right<void>] on successful update.
  /// - [Left<Failure>] on any error.
  Future<Either<Failure, void>> updateEvent(Event event);

  /// Deletes an event.
  ///
  /// - [eventId]: The ID of the event to be deleted.
  ///
  /// Returns a [Future] of `Either<Failure, void>`.
  /// - [Right<void>] on successful deletion.
  /// - [Left<Failure>] on any error.
  Future<Either<Failure, void>> deleteEvent(String eventId);

  /// Fetches a single event by its ID.
  ///
  /// - [eventId]: The unique identifier of the event.
  ///
  /// Returns a [Future] of `Either<Failure, Event>`.
  /// - [Right<Event>] with the found event.
  /// - [Left<Failure>] if the event is not found or an error occurs.
  Future<Either<Failure, Event>> getEventById(String eventId);

  /// Watches for real-time updates to events assigned to a specific user for a given date range.
  ///
  /// This method must fetch events assigned directly to the user AND events
  /// assigned to any teams the user is a member of.
  ///
  /// - [userId]: The ID of the user.
  /// - [teamIds]: A list of team IDs the user belongs to.
  /// - [startDate]: The beginning of the date range to watch.
  /// - [endDate]: The end of the date range to watch.
  ///
  /// Returns a [Stream] of `Either<Failure, List<Event>>`.
  /// - Emits [Right<List<Event>>] with the list of assigned events.
  /// - Emits [Left<Failure>] if a data source error occurs.
  Stream<Either<Failure, List<Event>>> watchEventsForUser({
    required String userId,
    required List<String> teamIds,
    required DateTime startDate,
    required DateTime endDate,
  });
}