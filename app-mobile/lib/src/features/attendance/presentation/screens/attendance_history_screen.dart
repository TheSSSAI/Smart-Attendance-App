import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:app_mobile/src/core/routing/routes.dart';
import 'package:app_mobile/src/features/attendance/application/providers/attendance_providers.dart';
import 'package:app_mobile/src/features/attendance/presentation/widgets/attendance_list_item.dart';

class AttendanceHistoryScreen extends ConsumerWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // For simplicity, fetching all history. In a real app, this should be paginated.
    final historyAsync = ref.watch(attendanceHistoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance History'),
      ),
      body: historyAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: ${err.toString()}')),
        data: (records) {
          if (records.isEmpty) {
            return const Center(child: Text('No attendance history found.'));
          }
          return RefreshIndicator(
            onRefresh: () => ref.refresh(attendanceHistoryProvider.future),
            child: ListView.builder(
              itemCount: records.length,
              itemBuilder: (context, index) {
                final record = records[index];
                return AttendanceListItem(
                  record: record,
                  isSelectable: false, // History view is not for bulk actions
                  onTap: () => context.goNamed(
                    AppRoutes.attendanceDetail.name,
                    pathParameters: {'id': record.id},
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}