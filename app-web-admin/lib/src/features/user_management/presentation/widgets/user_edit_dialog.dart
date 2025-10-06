import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:attendance_client_data/models/user_model.dart';
import 'package:app_web_admin/src/features/user_management/application/providers/user_providers.dart';

class UserEditDialog extends ConsumerStatefulWidget {
  final User user;

  const UserEditDialog({super.key, required this.user});

  @override
  ConsumerState<UserEditDialog> createState() => _UserEditDialogState();
}

class _UserEditDialogState extends ConsumerState<UserEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _selectedRole;
  String? _selectedSupervisorId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.user.role;
    _selectedSupervisorId = widget.user.supervisorId;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      final userNotifier = ref.read(userListNotifierProvider.notifier);
      final updatedUser = widget.user.copyWith(
        role: _selectedRole,
        supervisorId: _selectedSupervisorId,
      );

      try {
        await userNotifier.updateUser(updatedUser);
        if (mounted) {
          Navigator.of(context).pop(true); // Pop with success signal
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User updated successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to update user: ${e.toString()}'),
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
      title: Text('Edit User: ${widget.user.fullName ?? widget.user.email}'),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: widget.user.email,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  filled: true,
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedRole,
                decoration: const InputDecoration(
                  labelText: 'Role',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'Admin', child: Text('Admin')),
                  DropdownMenuItem(value: 'Supervisor', child: Text('Supervisor')),
                  DropdownMenuItem(value: 'Subordinate', child: Text('Subordinate')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedRole = value;
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a role';
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
            .where((u) => (u.role == 'Supervisor' || u.role == 'Admin') && u.id != widget.user.id)
            .toList();

        return DropdownButtonFormField<String>(
          value: _selectedSupervisorId,
          decoration: const InputDecoration(
            labelText: 'Supervisor',
            border: OutlineInputBorder(),
          ),
          hint: const Text('None'),
          // Allow clearing the selection
          items: [
            const DropdownMenuItem<String>(
              value: null,
              child: Text('None'),
            ),
            ...supervisors.map((supervisor) {
              return DropdownMenuItem<String>(
                value: supervisor.id,
                child: Text(supervisor.fullName ?? supervisor.email),
              );
            }),
          ],
          onChanged: (value) {
            setState(() {
              _selectedSupervisorId = value;
            });
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