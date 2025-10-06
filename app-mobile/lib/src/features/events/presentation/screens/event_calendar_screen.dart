import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:core_domain/models.dart';
import 'package:app_mobile/src/core/routing/routes.dart';
import 'package:app_mobile/src/features/auth/application/providers/auth_providers.dart';
import 'package:app_mobile/src/features/events/application/providers/event_providers.dart';

class EventCalendarScreen extends ConsumerStatefulWidget {
  const EventCalendarScreen({super.key});

  @override
  ConsumerState<EventCalendarScreen> createState() => _EventCalendarScreenState();
}

class _EventCalendarScreenState extends ConsumerState<EventCalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final userRole = ref.watch(currentUserRoleProvider);
    final eventsAsync = ref.watch(eventsForMonthProvider(_focusedDay));
    final selectedDayEvents = ref.watch(eventsForDayProvider(_selectedDay ?? _focusedDay));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Calendar'),
      ),
      body: Column(
        children: [
          eventsAsync.when(
            data: (eventsMap) => TableCalendar<Event>(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onPageChanged: (focusedDay) {
                setState(() {
                   _focusedDay = focusedDay;
                });
              },
              eventLoader: (day) {
                return eventsMap[DateTime(day.year, day.month, day.day)] ?? [];
              },
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  if (events.isNotEmpty) {
                    return Positioned(
                      right: 1,
                      bottom: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).primaryColor,
                        ),
                        width: 7,
                        height: 7,
                      ),
                    );
                  }
                  return null;
                },
              ),
            ),
            loading: () => const Center(child: LinearProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error loading events: $err')),
          ),
          const Divider(),
          Expanded(
            child: selectedDayEvents.when(
              data: (events) {
                if (events.isEmpty) {
                  return const Center(child: Text('No events for selected day.'));
                }
                return ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return ListTile(
                      title: Text(event.title),
                      subtitle: Text(event.description ?? ''),
                      trailing: Text('${event.startTime.toLocal()} - ${event.endTime.toLocal()}'), // Format
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error loading events: $err')),
            ),
          )
        ],
      ),
      floatingActionButton: userRole == UserRole.supervisor || userRole == UserRole.admin
          ? FloatingActionButton(
              onPressed: () => context.go(AppRoutes.eventCreation.path),
              child: const Icon(Icons.add),
              tooltip: 'Create Event',
            )
          : null,
    );
  }
}