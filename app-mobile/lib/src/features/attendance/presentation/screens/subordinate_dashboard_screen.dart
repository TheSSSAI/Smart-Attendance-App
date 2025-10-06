import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:core_domain/models.dart';
import 'package:app_mobile/src/core/routing/routes.dart';
import 'package:app_mobile/src/core/services/sync_status_service.dart';
import 'package:app_mobile/src/features/attendance/application/providers/attendance_providers.dart';
import 'package:shared_ui/widgets/widgets.dart';

class SubordinateDashboardScreen extends ConsumerWidget {
  const SubordinateDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(subordinateDashboardNotifierProvider);
    final syncStatusState = ref.watch(syncStatusProvider);
    final textTheme = Theme.of(context).textTheme;

    ref.listen(subordinateDashboardNotifierProvider, (previous, next) {
      if (next.errorMessage != null && next.errorMessage != previous?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    });

    final bool isCheckedIn = state.activeRecord != null && state.activeRecord!.checkOutTime == null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => context.go(AppRoutes.attendanceHistory.path),
            tooltip: 'Attendance History',
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => context.go(AppRoutes.eventCalendar.path),
            tooltip: 'Event Calendar',
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (syncStatusState.staleRecordCount > 0)
                  AlertBanner(
                    message: '${syncStatusState.staleRecordCount} record(s) failed to sync.',
                    type: AlertType.warning,
                    actionText: 'Retry',
                    onAction: () {
                      // US-036: Manually re-trigger a failed data sync
                      ref.read(syncStatusProvider.notifier).retrySync();
                    },
                  ),
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Text(
                          isCheckedIn ? 'You are currently Checked In' : 'You are Checked Out',
                          style: textTheme.titleLarge,
                        ),
                        if (isCheckedIn) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Since: ${state.activeRecord!.checkInTime.toLocal()}', // Format this properly
                            style: textTheme.bodyMedium,
                          ),
                        ],
                        const SizedBox(height: 32),
                        Row(
                          children: [
                            Expanded(
                              child: PrimaryButton(
                                onPressed: isCheckedIn || state.isLoading ? null : () => _onCheckIn(context, ref),
                                text: 'Check In',
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: !isCheckedIn || state.isLoading ? null : () => _onCheckOut(ref),
                                child: const Text('Check Out'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Add other dashboard widgets here
              ],
            ),
          ),
          if (state.isLoading) const LoadingOverlay(),
        ],
      ),
    );
  }

  Future<void> _onCheckIn(BuildContext context, WidgetRef ref) async {
    final eventsToday = await ref.read(eventsForTodayProvider.future);

    if (eventsToday.isNotEmpty) {
      final selectedEventId = await showDialog<String?>(
        context: context,
        builder: (context) => _EventSelectionDialog(events: eventsToday),
      );
      // selectedEventId can be null if user skips
      ref.read(subordinateDashboardNotifierProvider.notifier).checkIn(eventId: selectedEventId);
    } else {
      ref.read(subordinateDashboardNotifierProvider.notifier).checkIn();
    }
  }

  void _onCheckOut(WidgetRef ref) {
    ref.read(subordinateDashboardNotifierProvider.notifier).checkOut();
  }
}


class _EventSelectionDialog extends StatelessWidget {
  final List<Event> events;
  const _EventSelectionDialog({required this.events});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Link to an Event?'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            return ListTile(
              title: Text(event.title),
              subtitle: Text('${event.startTime.toLocal()} - ${event.endTime.toLocal()}'), // Format properly
              onTap: () => Navigator.of(context).pop(event.id),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null), // Skip
          child: const Text('SKIP (GENERAL CHECK-IN)'),
        ),
      ],
    );
  }
}