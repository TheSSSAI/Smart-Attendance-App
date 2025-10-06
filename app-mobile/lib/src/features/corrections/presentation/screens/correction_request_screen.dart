import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:core_domain/models.dart';
import 'package:app_mobile/src/features/corrections/application/providers/correction_providers.dart';
import 'package:shared_ui/widgets/widgets.dart';

class CorrectionRequestScreen extends ConsumerStatefulWidget {
  final String attendanceRecordId;
  const CorrectionRequestScreen({super.key, required this.attendanceRecordId});

  @override
  ConsumerState<CorrectionRequestScreen> createState() =>
      _CorrectionRequestScreenState();
}

class _CorrectionRequestScreenState
    extends ConsumerState<CorrectionRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _justificationController = TextEditingController();
  DateTime? _newCheckInTime;
  DateTime? _newCheckOutTime;

  @override
  void dispose() {
    _justificationController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ref.read(correctionRequestNotifierProvider.notifier).submitCorrection(
            recordId: widget.attendanceRecordId,
            newCheckIn: _newCheckInTime,
            newCheckOut: _newCheckOutTime,
            justification: _justificationController.text,
          );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final originalRecordAsync = ref.watch(originalRecordForCorrectionProvider(widget.attendanceRecordId));
    final notifierState = ref.watch(correctionRequestNotifierProvider);

    ref.listen(correctionRequestNotifierProvider, (previous, next) {
      next.whenOrNull(
        error: (err, stack) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(err.toString()), backgroundColor: Colors.red)),
        data: (success) {
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Correction request submitted.')));
            context.pop();
          }
        },
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Correction'),
      ),
      body: Stack(
        children: [
          originalRecordAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: ${err.toString()}')),
            data: (originalRecord) {
              if (originalRecord == null) {
                return const Center(child: Text('Original record not found.'));
              }
              _newCheckInTime ??= originalRecord.checkInTime;
              _newCheckOutTime ??= originalRecord.checkOutTime;

              return Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Original Times', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text('Check-in: ${originalRecord.checkInTime.toLocal()}'),
                      Text('Check-out: ${originalRecord.checkOutTime?.toLocal() ?? "N/A"}'),
                      const Divider(height: 32),
                      Text('Corrected Times', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 16),
                      _buildDateTimePicker(
                        label: 'Corrected Check-in',
                        initialTime: _newCheckInTime!,
                        onTimeChanged: (time) => setState(() => _newCheckInTime = time),
                      ),
                      const SizedBox(height: 16),
                      _buildDateTimePicker(
                        label: 'Corrected Check-out',
                        initialTime: _newCheckOutTime,
                        onTimeChanged: (time) => setState(() => _newCheckOutTime = time),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _justificationController,
                        decoration: const InputDecoration(
                          labelText: 'Justification for change',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 4,
                        validator: (value) {
                          if (value == null || value.trim().length < 20) {
                            return 'Justification must be at least 20 characters long.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      PrimaryButton(
                        onPressed: notifierState.isLoading ? null : _submit,
                        text: 'Submit Request',
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          if (notifierState.isLoading) const LoadingOverlay(),
        ],
      ),
    );
  }

  Widget _buildDateTimePicker({
    required String label,
    required DateTime? initialTime,
    required ValueChanged<DateTime> onTimeChanged,
  }) {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: initialTime ?? DateTime.now(),
          firstDate: DateTime.now().subtract(const Duration(days: 90)),
          lastDate: DateTime.now(),
        );
        if (date == null) return;

        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(initialTime ?? DateTime.now()),
        );
        if (time == null) return;
        
        onTimeChanged(DateTime(date.year, date.month, date.day, time.hour, time.minute));
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        child: Text(
          initialTime?.toLocal().toString() ?? 'Select a time',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}