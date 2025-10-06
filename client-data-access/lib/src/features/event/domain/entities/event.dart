import 'package:equatable/equatable.dart';

/// Enum representing the frequency of a recurring event.
enum RecurrenceFrequency {
  daily,
  weekly,
  monthly,
}

/// A value object representing the recurrence rule for an event.
class RecurrenceRule extends Equatable {
  /// The frequency of the recurrence.
  final RecurrenceFrequency frequency;

  /// The interval of recurrence (e.g., every 2 weeks). Defaults to 1.
  final int interval;

  /// The date until which the event recurs (inclusive).
  final DateTime until;

  /// For weekly recurrence, the days of the week (1=Monday, 7=Sunday).
  final List<int>? byDay;

  const RecurrenceRule({
    required this.frequency,
    this.interval = 1,
    required this.until,
    this.byDay,
  });

  @override
  List<Object?> get props => [frequency, interval, until, byDay];
}


/// Represents a scheduled event within a tenant.
/// This is a pure domain entity.
class Event extends Equatable {
  /// The unique identifier for the event.
  final String id;

  /// The ID of the tenant this event belongs to.
  final String tenantId;

  /// The title of the event.
  final String title;

  /// A detailed description of the event.
  final String? description;

  /// The start time of the event.
  final DateTime startTime;

  /// The end time of the event.
  final DateTime endTime;

  /// The ID of the user who created the event.
  final String createdByUserId;

  /// A list of user IDs directly assigned to this event.
  final List<String> assignedUserIds;

  /// A list of team IDs assigned to this event.
  final List<String> assignedTeamIds;
  
  /// The recurrence rule for this event, if it's a recurring event.
  final RecurrenceRule? recurrenceRule;
  
  /// If this is an instance of a recurring event, this ID links it to the master event.
  final String? recurrenceId;

  const Event({
    required this.id,
    required this.tenantId,
    required this.title,
    this.description,
    required this.startTime,
    required this.endTime,
    required this.createdByUserId,
    this.assignedUserIds = const [],
    this.assignedTeamIds = const [],
    this.recurrenceRule,
    this.recurrenceId,
  });
  
  /// Returns true if this is a recurring event master.
  bool get isRecurring => recurrenceRule != null;

  /// Calculates the duration of the event.
  Duration get duration => endTime.difference(startTime);

  @override
  List<Object?> get props => [
        id,
        tenantId,
        title,
        description,
        startTime,
        endTime,
        createdByUserId,
        assignedUserIds,
        assignedTeamIds,
        recurrenceRule,
        recurrenceId,
      ];
}