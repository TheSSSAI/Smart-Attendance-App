import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:repo_lib_client_008/repo_lib_client_008.dart';

part 'event_calendar_notifier.freezed.dart';

@freezed
class EventCalendarState with _$EventCalendarState {
  const factory EventCalendarState.initial() = _Initial;
  const factory EventCalendarState.loading() = _Loading;
  const factory EventCalendarState.data({
    required List<User> assignableUsers,
    required List<Team> assignableTeams,
  }) = _Data;
  const factory EventCalendarState.error(String message) = _Error;
}

class EventCalendarNotifier extends StateNotifier<EventCalendarState> {
  final IEventRepository _eventRepository;
  final IUserRepository _userRepository;
  final ITeamRepository _teamRepository;
  final String _supervisorId;

  EventCalendarNotifier({
    required IEventRepository eventRepository,
    required IUserRepository userRepository,
    required ITeamRepository teamRepository,
    required String supervisorId,
  })  : _eventRepository = eventRepository,
        _userRepository = userRepository,
        _teamRepository = teamRepository,
        _supervisorId = supervisorId,
        super(const EventCalendarState.initial());

  Future<void> loadAssignableData() async {
    state = const EventCalendarState.loading();
    try {
      final usersFuture = _userRepository.getDirectSubordinates(_supervisorId);
      final teamsFuture = _teamRepository.getManagedTeams(_supervisorId);

      final results = await Future.wait([usersFuture, teamsFuture]);
      
      final users = results[0] as List<User>;
      final teams = results[1] as List<Team>;

      state = EventCalendarState.data(assignableUsers: users, assignableTeams: teams);
    } catch (e) {
      state = const EventCalendarState.error('Failed to load data for event creation.');
    }
  }

  Future<void> createEvent(Event event) async {
    state = const EventCalendarState.loading();
    try {
      // Basic validation
      if (event.title.isEmpty) {
        throw const EventException('Event title cannot be empty.');
      }
      if (event.endTime.isBefore(event.startTime)) {
        throw const EventException('End time must be after start time.');
      }
      
      await _eventRepository.createEvent(event);
      // After creation, reload the assignable data to return to a stable state
      await loadAssignableData();
    } on EventException catch (e) {
      state = EventCalendarState.error(e.message);
    } catch (e) {
      state = const EventCalendarState.error('An unexpected error occurred while creating the event.');
    }
  }

  Future<void> updateEvent(Event event) async {
    state = const EventCalendarState.loading();
    try {
       if (event.title.isEmpty) {
        throw const EventException('Event title cannot be empty.');
      }
      if (event.endTime.isBefore(event.startTime)) {
        throw const EventException('End time must be after start time.');
      }
      
      await _eventRepository.updateEvent(event);
      await loadAssignableData();
    } on EventException catch (e) {
      state = EventCalendarState.error(e.message);
    } catch (e) {
      state = const EventCalendarState.error('An unexpected error occurred while updating the event.');
    }
  }
}