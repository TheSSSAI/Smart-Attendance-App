import 'package:flutter_riverpod/flutter_riverpod.dart';

// Assuming data access layer from REPO-LIB-CLIENT-008 provides these implementations
import 'package:repo_lib_client_008/repo_lib_client_008.dart';

import '../../../auth/application/providers/auth_providers.dart';
import '../notifiers/event_calendar_notifier.dart';

//------------------ Repository Providers ------------------//

/// Provides the concrete implementation of the [IEventRepository].
/// This abstracts all event-related data operations.
/// Implementation is assumed to come from the data access library.
final eventRepositoryProvider = Provider<IEventRepository>((ref) {
  return FirestoreEventRepository();
});

/// Provides the concrete implementation of the [ITeamRepository].
/// This is needed for Supervisors to fetch teams they manage for event assignment.
/// Implementation is assumed to come from the data access library.
final teamRepositoryProvider = Provider<ITeamRepository>((ref) {
  return FirestoreTeamRepository();
});

//------------------ State Notifier Providers ------------------//

/// Provides the [EventCalendarNotifier] and its state.
/// Manages the business logic for creating, editing, and assigning events.
final eventCalendarNotifierProvider = StateNotifierProvider.autoDispose<EventCalendarNotifier, EventCalendarState>((ref) {
  final userProfile = ref.watch(userProfileProvider).asData?.value;
  return EventCalendarNotifier(
    eventRepository: ref.watch(eventRepositoryProvider),
    teamRepository: ref.watch(teamRepositoryProvider),
    userRepository: ref.watch(userRepositoryProvider),
    currentUser: userProfile,
  );
});

//------------------ Data Fetching Providers ------------------//

/// A stream provider that fetches all events relevant to the current user for a given month.
/// This is the primary data source for the calendar view (US-057).
/// It uses `.family` to be parameterized by the month being viewed.
final monthlyEventsProvider = StreamProvider.family.autoDispose<List<Event>, DateTime>((ref, date) {
  final userProfile = ref.watch(userProfileProvider).asData?.value;
  if (userProfile == null) {
    return Stream.value([]);
  }

  final eventRepo = ref.watch(eventRepositoryProvider);
  return eventRepo.watchUserEventsForMonth(
    userId: userProfile.uid,
    teamIds: userProfile.teamIds,
    date: date,
  );
});

/// A future provider that fetches events assigned to the current user for the current day.
/// This is used during the check-in process to allow linking an event (US-056).
final eventsForTodayProvider = FutureProvider.autoDispose<List<Event>>((ref) {
  final userProfile = ref.watch(userProfileProvider).asData?.value;
  if (userProfile == null) {
    return Future.value([]);
  }

  final eventRepo = ref.watch(eventRepositoryProvider);
  return eventRepo.getEventsForDay(
    userId: userProfile.uid,
    teamIds: userProfile.teamIds,
    date: DateTime.now(),
  );
});

/// A future provider for supervisors to fetch a list of their direct subordinates.
/// This is used in the event creation form to populate the user assignment list (US-054).
final supervisorSubordinatesProvider = FutureProvider.autoDispose<List<UserProfile>>((ref) {
  final userProfile = ref.watch(userProfileProvider).asData?.value;
  if (userProfile == null || userProfile.role != UserRole.supervisor) {
    return Future.value([]);
  }
  final userRepo = ref.watch(userRepositoryProvider);
  return userRepo.getDirectSubordinates(supervisorId: userProfile.uid);
});

/// A future provider for supervisors to fetch a list of teams they manage.
/// This is used in the event creation form to populate the team assignment list (US-055).
final managedTeamsProvider = FutureProvider.autoDispose<List<Team>>((ref) {
  final userProfile = ref.watch(userProfileProvider).asData?.value;
  if (userProfile == null || userProfile.role != UserRole.supervisor) {
    return Future.value([]);
  }
  final teamRepo = ref.watch(teamRepositoryProvider);
  return teamRepo.getManagedTeams(supervisorId: userProfile.uid);
});