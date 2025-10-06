import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import '../molecular/attendance_list_item.dart';
import '../theme/app_theme.dart';

/// A simple data class to represent an event on the calendar.
/// In a real application, this would be a more complex domain model.
class CalendarEvent {
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final Map<String, dynamic> rawData;

  const CalendarEvent({
    required this.title,
    required this.startTime,
    required this.endTime,
    this.rawData = const {},
  });
}

/// A complex organism widget that displays events in a calendar format.
///
/// This widget wraps a third-party calendar library (`table_calendar`) and styles
/// it to match the application's design system. It supports displaying events,
/// selecting days, and viewing event details for the selected day.
///
/// ### Requirements Covered:
/// - **REQ-1-062 (Material Design 3)**: The calendar is styled to match the app's theme.
/// - **REQ-1-063 (Accessibility)**: Leverages the accessibility features of the
///   underlying calendar library and ensures custom elements are accessible.
/// - **User Stories**:
///   - **US-057**: Provides the main calendar view for a Subordinate.
class CalendarView extends StatefulWidget {
  /// A map where keys are days and values are lists of events for that day.
  final Map<DateTime, List<CalendarEvent>> events;

  /// Callback function when a day is selected.
  final ValueChanged<DateTime>? onDateSelected;
  
  /// Callback for when the visible month/week changes.
  final ValueChanged<DateTime>? onPageChanged;

  const CalendarView({
    super.key,
    required this.events,
    this.onDateSelected,
    this.onPageChanged,
  });

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  late DateTime _focusedDay;
  DateTime? _selectedDay;
  late List<CalendarEvent> _selectedEvents;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
    _selectedEvents = _getEventsForDay(_selectedDay!);
  }
  
  @override
  void didUpdateWidget(covariant CalendarView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(widget.events != oldWidget.events && _selectedDay != null){
      _selectedEvents = _getEventsForDay(_selectedDay!);
    }
  }

  List<CalendarEvent> _getEventsForDay(DateTime day) {
    // This implementation uses `isSameDay` from `table_calendar` for date comparison
    // without considering the time component.
    final dayWithoutTime = DateTime(day.year, day.month, day.day);
    return widget.events[dayWithoutTime] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _selectedEvents = _getEventsForDay(selectedDay);
      });
      widget.onDateSelected?.call(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        TableCalendar<CalendarEvent>(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: _onDaySelected,
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
            widget.onPageChanged?.call(focusedDay);
          },
          eventLoader: _getEventsForDay,
          calendarFormat: CalendarFormat.month,
          availableCalendarFormats: const {CalendarFormat.month: 'Month'},
          headerStyle: HeaderStyle(
            titleTextStyle: textTheme.titleLarge!,
            formatButtonVisible: false,
            titleCentered: true,
            leftChevronIcon: Icon(Icons.chevron_left, color: colorScheme.onSurface),
            rightChevronIcon: Icon(Icons.chevron_right, color: colorScheme.onSurface),
          ),
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: textTheme.bodySmall!.copyWith(color: colorScheme.onSurfaceVariant),
            weekendStyle: textTheme.bodySmall!.copyWith(color: colorScheme.onSurfaceVariant),
          ),
          calendarStyle: CalendarStyle(
            defaultTextStyle: textTheme.bodyMedium!,
            weekendTextStyle: textTheme.bodyMedium!,
            outsideTextStyle: textTheme.bodyMedium!.copyWith(color: colorScheme.onSurface.withOpacity(0.5)),
            selectedDecoration: BoxDecoration(
              color: colorScheme.primary,
              shape: BoxShape.circle,
            ),
            selectedTextStyle: textTheme.bodyMedium!.copyWith(color: colorScheme.onPrimary),
            todayDecoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            todayTextStyle: textTheme.bodyMedium!.copyWith(color: colorScheme.primary),
            markerDecoration: BoxDecoration(
              color: colorScheme.secondary,
              shape: BoxShape.circle,
            ),
            markerSize: 5.0,
            markersMaxCount: 1,
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: _buildEventList(),
        ),
      ],
    );
  }

  Widget _buildEventList() {
    if (_selectedEvents.isEmpty) {
      return Center(
        child: Text(
          'No events for this day.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _selectedEvents.length,
      itemBuilder: (context, index) {
        final event = _selectedEvents[index];
        // Here we can use a dedicated EventListItem or adapt AttendanceListItem
        // For demonstration, we create a simple ListTile.
        return Card(
          margin: const EdgeInsets.only(bottom: 8.0),
          child: ListTile(
            title: Text(event.title, style: Theme.of(context).textTheme.titleMedium),
            subtitle: Text(
              '${DateFormat.jm().format(event.startTime)} - ${DateFormat.jm().format(event.endTime)}',
            ),
            leading: Icon(Icons.event, color: Theme.of(context).colorScheme.primary),
          ),
        );
      },
    );
  }
}