import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:attendance_client_data/models/team_model.dart';
import 'package:attendance_client_data/models/user_model.dart';
import 'package:app_web_admin/src/features/user_management/application/providers/user_providers.dart';
// Assuming a team notifier exists, similar to the user notifier
// e.g., final teamManagementNotifierProvider = StateNotifierProvider...

class TeamEditDialog extends ConsumerStatefulWidget {
  final Team team;

  const TeamEditDialog({super.key, required this.team});

  @override
  ConsumerState<TeamEditDialog> createState() => _TeamEditDialogState();
}

class _TeamEditDialogState extends ConsumerState<TeamEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  String? _selectedSupervisorId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.team.name);
    _selectedSupervisorId = widget.team.supervisorId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      final updatedTeam = widget.team.copyWith(
        name: _nameController.text,
        supervisorId: _selectedSupervisorId,
      );

      try {
        // In a real app, you would call a notifier method.
        // await ref.read(teamManagementNotifierProvider.notifier).updateTeam(updatedTeam);
        await Future.delayed(const Duration(seconds: 1)); // Simulate network call
        print('Updating team: ${updatedTeam.toJson()}');
        
        if (mounted) {
          Navigator.of(context).pop(true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Team updated successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to update team: ${e.toString()}'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Team: ${widget.team.name}'),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Team Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Team name cannot be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildSupervisorDropdown(),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submitForm,
          child: _isLoading ? const CircularProgressIndicator() : const Text('Save Changes'),
        ),
      ],
    );
  }

  Widget _buildSupervisorDropdown() {
    final allUsersAsync = ref.watch(userListProvider);

    return allUsersAsync.when(
      data: (users) {
        final supervisors = users
            .where((u) => u.role == 'Supervisor' || u.role == 'Admin')
            .toList();

        return DropdownButtonFormField<String>(
          value: _selectedSupervisorId,
          decoration: const InputDecoration(
            labelText: 'Supervisor',
            border: OutlineInputBorder(),
          ),
          hint: const Text('Select a supervisor'),
          items: supervisors.map((supervisor) {
            return DropdownMenuItem<String>(
              value: supervisor.id,
              child: Text(supervisor.fullName ?? supervisor.email),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedSupervisorId = value;
            });
          },
          validator: (value) {
            if (value == null) {
              return 'A supervisor must be assigned';
            }
            return null;
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => TextFormField(
        readOnly: true,
        decoration: InputDecoration(
          labelText: 'Supervisor',
          border: const OutlineInputBorder(),
          filled: true,
          errorText: 'Could not load supervisors',
        ),
      ),
    );
  }
}