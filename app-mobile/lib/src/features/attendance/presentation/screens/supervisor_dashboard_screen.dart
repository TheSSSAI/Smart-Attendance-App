import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:app_mobile/src/core/routing/routes.dart';
import 'package:app_mobile/src/features/attendance/application/providers/attendance_providers.dart';
import 'package:app_mobile/src/features/attendance/presentation/widgets/attendance_list_item.dart';
import 'package:shared_ui/widgets/widgets.dart';

class SupervisorDashboardScreen extends ConsumerStatefulWidget {
  const SupervisorDashboardScreen({super.key});

  @override
  ConsumerState<SupervisorDashboardScreen> createState() => _SupervisorDashboardScreenState();
}

class _SupervisorDashboardScreenState extends ConsumerState<SupervisorDashboardScreen> {
  final Set<String> _selectedRecordIds = {};

  void _onSelectionChanged(String recordId, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedRecordIds.add(recordId);
      } else {
        _selectedRecordIds.remove(recordId);
      }
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedRecordIds.clear();
    });
  }

  void _handleBulkApprove() {
    if (_selectedRecordIds.isEmpty) return;
    ref
        .read(supervisorDashboardNotifierProvider.notifier)
        .bulkApprove(_selectedRecordIds.toList());
    _clearSelection();
  }

  void _handleBulkReject() async {
    if (_selectedRecordIds.isEmpty) return;
    
    final reason = await showDialog<String>(
      context: context,
      builder: (context) => const _BulkRejectReasonDialog(),
    );

    if (reason != null && reason.isNotEmpty) {
      ref
          .read(supervisorDashboardNotifierProvider.notifier)
          .bulkReject(_selectedRecordIds.toList(), reason);
      _clearSelection();
    }
  }

  @override
  Widget build(BuildContext context) {
    final pendingRecordsAsync = ref.watch(pendingRecordsProvider);
    final notifier = ref.read(supervisorDashboardNotifierProvider.notifier);

    ref.listen(supervisorDashboardNotifierProvider, (previous, next) {
        if(next.hasError && !next.isLoading){
             ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(next.error.toString()), backgroundColor: Colors.red),
            );
        }
    });


    return Scaffold(
      appBar: AppBar(
        title: const Text('Supervisor Dashboard'),
        actions: [
           IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => context.go(AppRoutes.eventCreation.path),
            tooltip: 'Create Event',
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => context.go(AppRoutes.eventCalendar.path),
            tooltip: 'Event Calendar',
          ),
        ],
      ),
      body: pendingRecordsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: ${err.toString()}')),
        data: (records) {
          if (records.isEmpty) {
            return const Center(child: Text('No pending records to review.'));
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: records.length,
                  itemBuilder: (context, index) {
                    final record = records[index];
                    return AttendanceListItem(
                      record: record,
                      isSelected: _selectedRecordIds.contains(record.id),
                      onSelected: (isSelected) => _onSelectionChanged(record.id, isSelected!),
                      onTap: () {
                          // Could navigate to a detail screen if needed
                      },
                      onApprove: () => notifier.approveRecord(record.id),
                      onReject: () async {
                         final reason = await showDialog<String>(
                            context: context,
                            builder: (context) => const _BulkRejectReasonDialog(), // Can reuse
                         );
                         if(reason != null && reason.isNotEmpty) {
                             notifier.rejectRecord(record.id, reason);
                         }
                      },
                    );
                  },
                ),
              ),
              if (_selectedRecordIds.isNotEmpty)
                _buildBulkActionToolbar(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBulkActionToolbar() {
    return Material(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: Theme.of(context).colorScheme.surfaceVariant,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${_selectedRecordIds.length} selected'),
            Row(
              children: [
                TextButton(
                  onPressed: _handleBulkReject,
                  child: const Text('REJECT'),
                  style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: _handleBulkApprove,
                  child: const Text('APPROVE'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BulkRejectReasonDialog extends StatefulWidget {
  const _BulkRejectReasonDialog();

  @override
  State<_BulkRejectReasonDialog> createState() => _BulkRejectReasonDialogState();
}

class _BulkRejectReasonDialogState extends State<_BulkRejectReasonDialog> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Reason for Rejection'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Reason',
            hintText: 'Provide a reason for all selected records.',
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'A reason is required.';
            }
            if(value.length < 10){
              return 'Reason must be at least 10 characters.';
            }
            return null;
          },
          maxLines: 3,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('CANCEL'),
        ),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.of(context).pop(_controller.text.trim());
            }
          },
          child: const Text('REJECT'),
        ),
      ],
    );
  }
}