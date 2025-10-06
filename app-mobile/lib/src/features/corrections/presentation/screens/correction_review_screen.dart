import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:core_domain/models.dart';
import 'package:app_mobile/src/features/corrections/application/providers/correction_providers.dart';
import 'package:shared_ui/widgets/widgets.dart';

class CorrectionReviewScreen extends ConsumerWidget {
  final String attendanceRecordId;
  const CorrectionReviewScreen({super.key, required this.attendanceRecordId});

  void _handleApprove(WidgetRef ref, BuildContext context) {
    ref.read(correctionActionNotifierProvider.notifier).approveCorrection(attendanceRecordId);
  }

  void _handleReject(WidgetRef ref, BuildContext context) async {
    final reason = await showDialog<String>(
      context: context,
      builder: (context) => const _RejectReasonDialog(),
    );

    if (reason != null && reason.isNotEmpty) {
      ref.read(correctionActionNotifierProvider.notifier).rejectCorrection(attendanceRecordId, reason);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final correctionDetailsAsync = ref.watch(correctionDetailsProvider(attendanceRecordId));
    final actionState = ref.watch(correctionActionNotifierProvider);

    ref.listen(correctionActionNotifierProvider, (previous, next) {
      if (!next.isLoading && !next.hasError && previous?.isLoading == true) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Action completed.')));
        context.pop();
      } else if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.error.toString()), backgroundColor: Colors.red));
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Correction'),
      ),
      body: Stack(
        children: [
          correctionDetailsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: ${err.toString()}')),
            data: (record) {
              if (record == null) {
                return const Center(child: Text('Correction request not found or no longer pending.'));
              }
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoCard(context, record),
                    const SizedBox(height: 16),
                    _buildChangesCard(context, record),
                    const SizedBox(height: 16),
                    _buildJustificationCard(context, record),
                  ],
                ),
              );
            },
          ),
          if (actionState.isLoading) const LoadingOverlay(),
        ],
      ),
      bottomNavigationBar: _buildActionButtons(context, ref, actionState.isLoading),
    );
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref, bool isLoading) {
    return BottomAppBar(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: isLoading ? null : () => _handleReject(ref, context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                  side: BorderSide(color: Theme.of(context).colorScheme.error),
                ),
                child: const Text('Reject'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: FilledButton(
                onPressed: isLoading ? null : () => _handleApprove(ref, context),
                child: const Text('Approve'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, AttendanceRecord record) {
     final textTheme = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Request Details', style: textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('User: ${record.user?.name ?? 'Unknown User'}'),
            Text('Date: ${record.checkInTime.toLocal()}'), // Format properly
          ],
        ),
      ),
    );
  }

  Widget _buildChangesCard(BuildContext context, AttendanceRecord record) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Proposed Changes', style: textTheme.titleLarge),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildTimeColumn('Original', record.originalCheckInTime, record.originalCheckOutTime, context)),
                const Icon(Icons.arrow_forward),
                Expanded(child: _buildTimeColumn('Requested', record.requestedCheckInTime, record.requestedCheckOutTime, context)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTimeColumn(String title, DateTime? checkIn, DateTime? checkOut, BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: textTheme.titleMedium),
        const SizedBox(height: 8),
        Text('Check-in: ${checkIn?.toLocal() ?? "No Change"}'),
        Text('Check-out: ${checkOut?.toLocal() ?? "No Change"}'),
      ],
    );
  }
  
  Widget _buildJustificationCard(BuildContext context, AttendanceRecord record) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Justification', style: textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(record.correctionJustification ?? 'No justification provided.', style: textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _RejectReasonDialog extends StatefulWidget {
  const _RejectReasonDialog();

  @override
  State<_RejectReasonDialog> createState() => __RejectReasonDialogState();
}

class __RejectReasonDialogState extends State<_RejectReasonDialog> {
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
            hintText: 'A reason is required to reject.',
          ),
          validator: (value) {
            if (value == null || value.trim().length < 10) {
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
          child: const Text('CONFIRM REJECTION'),
        ),
      ],
    );
  }
}