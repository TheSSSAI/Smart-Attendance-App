import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:core_domain/models.dart';
import 'package:app_mobile/src/features/events/application/providers/event_providers.dart';
import 'package:shared_ui/widgets/widgets.dart';

class EventCreationScreen extends ConsumerStatefulWidget {
  final String? eventId; // if null, creating new. if not null, editing.
  const EventCreationScreen({super.key, this.eventId});

  @override
  ConsumerState<EventCreationScreen> createState() => _EventCreationScreenState();
}

class _EventCreationScreenState extends ConsumerState<EventCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _startTime;
  DateTime? _endTime;
  final Set<String> _assignedUserIds = {};
  final Set<String> _assignedTeamIds = {};
  // TODO: Add state for recurrence rules

  @override
  void initState() {
    super.initState();
    if (widget.eventId != null) {
      // TODO: Fetch existing event data and populate fields
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime(bool isStart) async {
    final date = await showDatePicker(
      context: context,
      initialDate: (isStart ? _startTime : _endTime) ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime((isStart ? _startTime : _endTime) ?? DateTime.now()),
    );
    if (time == null) return;

    setState(() {
      final newDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
      if (isStart) {
        _startTime = newDateTime;
      } else {
        _endTime = newDateTime;
      }
    });
  }
  
  void _submit() {
    if (_formKey.currentState!.validate()) {
      final notifier = ref.read(eventCreationNotifierProvider.notifier);
      final event = Event(
        id: widget.eventId ?? '', // Let repository handle ID generation on create
        title: _titleController.text,
        description: _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
        startTime: _startTime!,
        endTime: _endTime!,
        assignedUserIds: _assignedUserIds.toList(),
        assignedTeamIds: _assignedTeamIds.toList(),
        createdBy: '', // Should be filled by repository/notifier
        tenantId: '', // Should be filled by repository/notifier
      );

      if (widget.eventId == null) {
        notifier.createEvent(event);
      } else {
        notifier.updateEvent(event);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(eventCreationNotifierProvider, (previous, next) {
      if (next.hasError && !next.isLoading) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(next.error.toString()),
          backgroundColor: Theme.of(context).colorScheme.error,
        ));
      } else if (!next.hasError && !next.isLoading && previous?.isLoading == true) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Event saved successfully!'),
        ));
        context.pop();
      }
    });

    final state = ref.watch(eventCreationNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.eventId == null ? 'Create Event' : 'Edit Event'),
        actions: [
          IconButton(
            onPressed: state.isLoading ? null : _submit,
            icon: const Icon(Icons.save),
            tooltip: 'Save Event',
          ),
        ],
      ),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                    validator: (value) => (value?.isEmpty ?? true) ? 'Title is required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Description (Optional)'),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  _buildDateTimePicker(label: 'Start Time', time: _startTime, isStart: true),
                  const SizedBox(height: 16),
                  _buildDateTimePicker(label: 'End Time', time: _endTime, isStart: false),
                  const SizedBox(height: 24),
                  const Divider(),
                  // TODO: Implement User/Team assignment UI (US-054, US-055)
                  // For now, placeholders
                  const Text('Assignments', style: TextStyle(fontWeight: FontWeight.bold)),
                   const ListTile(title: Text('Assign Users/Teams (UI not implemented)')),
                  const SizedBox(height: 24),
                  const Divider(),
                  // TODO: Implement Recurrence UI (US-053)
                   const ListTile(title: Text('Recurrence (UI not implemented)')),
                ],
              ),
            ),
          ),
          if (state.isLoading) const LoadingOverlay(),
        ],
      ),
    );
  }

   Widget _buildDateTimePicker({required String label, required DateTime? time, required bool isStart}) {
    return InkWell(
      onTap: () => _pickDateTime(isStart),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        child: Text(
          time?.toLocal().toString() ?? 'Select a time', // Format properly
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}