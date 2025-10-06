import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:repo_lib_client_008/repo_lib_client_008.dart';
import 'package:app_mobile/src/core/services/location_service.dart';

part 'subordinate_dashboard_notifier.freezed.dart';

@freezed
class SubordinateDashboardState with _$SubordinateDashboardState {
  const factory SubordinateDashboardState.initial() = _Initial;
  const factory SubordinateDashboardState.loading(String message) = _Loading;
  const factory SubordinateDashboardState.data({
    required AttendanceRecord? activeRecord,
    required List<Event> todaysEvents,
    String? infoMessage,
  }) = _Data;
  const factory SubordinateDashboardState.error(String message) = _Error;
}

class SubordinateDashboardNotifier extends StateNotifier<SubordinateDashboardState> {
  final IAttendanceRepository _attendanceRepository;
  final IEventRepository _eventRepository;
  final ILocationService _locationService;
  final String _userId;
  StreamSubscription<AttendanceRecord?>? _activeRecordSubscription;

  SubordinateDashboardNotifier({
    required IAttendanceRepository attendanceRepository,
    required IEventRepository eventRepository,
    required ILocationService locationService,
    required String userId,
  })  : _attendanceRepository = attendanceRepository,
        _eventRepository = eventRepository,
        _locationService = locationService,
        _userId = userId,
        super(const SubordinateDashboardState.initial()) {
    _watchActiveRecord();
    fetchTodaysEvents();
  }

  void _watchActiveRecord() {
    _activeRecordSubscription?.cancel();
    _activeRecordSubscription = _attendanceRepository.watchActiveAttendanceRecord(_userId).listen(
      (record) {
        state.maybeWhen(
          data: (previousRecord, todaysEvents, _) {
            state = SubordinateDashboardState.data(
              activeRecord: record,
              todaysEvents: todaysEvents,
            );
          },
          orElse: () {
            state = SubordinateDashboardState.data(
              activeRecord: record,
              todaysEvents: const [],
            );
          },
        );
      },
      onError: (e) {
        state = const SubordinateDashboardState.error("Failed to load attendance status. Please restart the app.");
      },
    );
  }

  Future<void> fetchTodaysEvents() async {
    try {
      final events = await _eventRepository.getEventsForDay(_userId, DateTime.now());
      state.maybeWhen(
        data: (activeRecord, _, infoMessage) {
          state = SubordinateDashboardState.data(
            activeRecord: activeRecord,
            todaysEvents: events,
            infoMessage: infoMessage,
          );
        },
        orElse: () {
          state = SubordinateDashboardState.data(
            activeRecord: null,
            todaysEvents: events,
          );
        },
      );
    } catch (e) {
      // Don't transition to error state, as fetching events is non-critical for check-in
      // Log the error
    }
  }

  Future<void> checkIn({String? eventId}) async {
    state = const SubordinateDashboardState.loading('Getting your location...');
    try {
      final position = await _locationService.getCurrentPosition();
      final geoPoint = GeoPoint(position.latitude, position.longitude);

      state = const SubordinateDashboardState.loading('Recording your check-in...');
      
      await _attendanceRepository.checkIn(
        userId: _userId,
        position: geoPoint,
        clientTimestamp: DateTime.now(),
        eventId: eventId,
      );
      // The stream will automatically update the state to _Data
    } on LocationServiceException catch (e) {
      state = SubordinateDashboardState.error(e.message);
    } on AttendanceException catch (e) {
      state = SubordinateDashboardState.error(e.message);
    } catch (e) {
      state = const SubordinateDashboardState.error('An unexpected error occurred during check-in.');
    }
  }

  Future<void> checkOut() async {
    final currentActiveRecord = state.maybeMap(
      data: (data) => data.activeRecord,
      orElse: () => null,
    );

    if (currentActiveRecord == null) {
      state = const SubordinateDashboardState.error('No active check-in found to check out from.');
      return;
    }

    state = const SubordinateDashboardState.loading('Getting your location...');
    try {
      final position = await _locationService.getCurrentPosition();
      final geoPoint = GeoPoint(position.latitude, position.longitude);

      state = const SubordinateDashboardState.loading('Recording your check-out...');
      
      await _attendanceRepository.checkOut(
        recordId: currentActiveRecord.id,
        position: geoPoint,
        clientTimestamp: DateTime.now(),
      );
      // The stream will automatically update the state to _Data
    } on LocationServiceException catch (e) {
      state = SubordinateDashboardState.error(e.message);
    } on AttendanceException catch (e) {
      state = SubordinateDashboardState.error(e.message);
    } catch (e) {
      state = const SubordinateDashboardState.error('An unexpected error occurred during check-out.');
    }
  }

  @override
  void dispose() {
    _activeRecordSubscription?.cancel();
    super.dispose();
  }
}