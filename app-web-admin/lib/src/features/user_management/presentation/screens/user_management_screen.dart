import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_dependencies/shared_dependencies.dart';

import '../../application/providers/user_providers.dart';
import '../models/user_view_model.dart';
import '../widgets/team_edit_dialog.dart';
import '../widgets/user_edit_dialog.dart';

class UserManagementScreen extends ConsumerStatefulWidget {
  const UserManagementScreen({super.key});

  @override
  ConsumerState<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends ConsumerState<UserManagementScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => ref.read(userListNotifierProvider.notifier).fetchUsers());
  }

  @override
  Widget build(BuildContext context) {
    final userListState = ref.watch(userListNotifierProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.person), text: 'Users'),
              Tab(icon: Icon(Icons.group), text: 'Teams'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildUsersView(userListState),
            _buildTeamsView(),
          ],
        ),
      ),
    );
  }

  Widget _buildUsersView(AsyncValue<List<UserViewModel>> userListState) {
    return userListState.when(
      data: (users) => _buildUserList(users),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) =>
          Center(child: Text('Error fetching users: $error')),
    );
  }

  Widget _buildUserList(List<UserViewModel> users) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implement Invite User Dialog
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Invite User functionality not implemented yet.')));
                },
                icon: const Icon(Icons.person_add),
                label: const Text('Invite User'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              PaginatedDataTable(
                header: const Text('Users'),
                columns: const [
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Email')),
                  DataColumn(label: Text('Role')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Supervisor')),
                  DataColumn(label: Text('Actions')),
                ],
                source: _UserDataSouce(users, context),
                rowsPerPage: 10,
                showCheckboxColumn: false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTeamsView() {
    // This is a placeholder for team management functionality.
    // In a real implementation, it would fetch and display teams similarly to users.
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Team Management'),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const TeamEditDialog(),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Create Team'),
          ),
        ],
      ),
    );
  }
}

class _UserDataSouce extends DataTableSource {
  final List<UserViewModel> _users;
  final BuildContext _context;

  _UserDataSouce(this._users, this._context);

  @override
  DataRow? getRow(int index) {
    if (index >= _users.length) {
      return null;
    }
    final user = _users[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(user.displayName)),
        DataCell(Text(user.email)),
        DataCell(Text(user.role)),
        DataCell(Chip(
          label: Text(user.status, style: const TextStyle(color: Colors.white)),
          backgroundColor:
              user.status == 'active' ? Colors.green : Colors.orange,
        )),
        DataCell(Text(user.supervisorName ?? 'N/A')),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                tooltip: 'Edit User',
                onPressed: () {
                  showDialog(
                    context: _context,
                    builder: (context) => UserEditDialog(user: user),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.block, color: Colors.red),
                tooltip: 'Deactivate User',
                onPressed: () {
                  // Placeholder for deactivation logic
                  // This would call ref.read(userListNotifierProvider.notifier).deactivateUser(user.id);
                  ScaffoldMessenger.of(_context).showSnackBar(SnackBar(
                      content: Text('Deactivate user: ${user.displayName}')));
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _users.length;

  @override
  int get selectedRowCount => 0;
}