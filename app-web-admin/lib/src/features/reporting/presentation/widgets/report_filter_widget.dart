import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:attendance_client_data/models/filters/report_filters.dart';
import 'package:attendance_client_data/models/team_model.dart';
import 'package:attendance_client_data/models/user_model.dart';
import 'package:app_web_admin/src/features/user_management/application/providers/user_providers.dart';

// Note: A provider for teams would be defined similarly to user_providers.dart
// For now, we'll mock the data fetching part for teams.
final teamListProvider = FutureProvider<List<Team>>((ref) async {
  // In a real app, this would call a repository method.
  // final teamRepository = ref.watch(teamRepositoryProvider);
  // return teamRepository.getAllTeams();
  await Future.delayed(const Duration(milliseconds: 500)); // Simulate fetch
  return [
    Team(id: 'team1', name: 'Field Operations', supervisorId: 'sup1', memberIds: ['user1', 'user2']),
    Team(id: 'team2', name: 'Sales', supervisorId: 'sup2', memberIds: ['user3', 'user4']),
  ];
});

class ReportFilterWidget extends ConsumerStatefulWidget {
  final Function(ReportFilters) onApplyFilters;
  final ReportFilters initialFilters;

  const ReportFilterWidget({
    super.key,
    required this.onApplyFilters,
    required this.initialFilters,
  });

  @override
  ConsumerState<ReportFilterWidget> createState() => _ReportFilterWidgetState();
}

class _ReportFilterWidgetState extends ConsumerState<ReportFilterWidget> {
  late DateTimeRange _selectedDateRange;
  List<User> _selectedUsers = [];
  List<Team> _selectedTeams = [];
  List<String> _selectedStatuses = [];

  final List<String> _availableStatuses = const [
    'approved',
    'pending',
    'rejected',
    'correction_pending',
    'isOfflineEntry',
    'auto-checked-out',
    'manually-corrected',
    'clock_discrepancy',
  ];

  @override
  void initState() {
    super.initState();
    _selectedDateRange = widget.initialFilters.dateRange ??
        DateTimeRange(
          start: DateTime.now().subtract(const Duration(days: 7)),
          end: DateTime.now(),
        );
    // Initial selections would be populated from widget.initialFilters if needed
  }

  void _applyFilters() {
    final filters = ReportFilters(
      dateRange: _selectedDateRange,
      userIds: _selectedUsers.map((u) => u.id).toList(),
      teamIds: _selectedTeams.map((t) => t.id).toList(),
      statuses: _selectedStatuses,
    );
    widget.onApplyFilters(filters);
  }

  void _clearFilters() {
    setState(() {
      _selectedDateRange = DateTimeRange(
        start: DateTime.now().subtract(const Duration(days: 7)),
        end: DateTime.now(),
      );
      _selectedUsers = [];
      _selectedTeams = [];
      _selectedStatuses = [];
    });
    final filters = ReportFilters(dateRange: _selectedDateRange);
    widget.onApplyFilters(filters);
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: _selectedDateRange,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDateRange) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final usersAsyncValue = ref.watch(userListProvider);
    final teamsAsyncValue = ref.watch(teamListProvider);

    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Filter Options', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildDateRangePicker(context),
                _buildMultiSelectDropdown<User>(
                  label: 'Users',
                  asyncValue: usersAsyncValue,
                  selectedItems: _selectedUsers,
                  onSelectionChanged: (users) {
                    setState(() {
                      _selectedUsers = users;
                    });
                  },
                  itemBuilder: (user) => user.fullName ?? user.email,
                ),
                _buildMultiSelectDropdown<Team>(
                  label: 'Teams',
                  asyncValue: teamsAsyncValue,
                  selectedItems: _selectedTeams,
                  onSelectionChanged: (teams) {
                    setState(() {
                      _selectedTeams = teams;
                    });
                  },
                  itemBuilder: (team) => team.name,
                ),
                _buildMultiSelectDropdown<String>(
                  label: 'Statuses',
                  items: _availableStatuses,
                  selectedItems: _selectedStatuses,
                  onSelectionChanged: (statuses) {
                    setState(() {
                      _selectedStatuses = statuses;
                    });
                  },
                  itemBuilder: (status) => status,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: _clearFilters,
                  child: const Text('Clear Filters'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _applyFilters,
                  child: const Text('Apply Filters'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateRangePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Date Range', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        InputChip(
          label: Text(
            '${DateFormat.yMd().format(_selectedDateRange.start)} - ${DateFormat.yMd().format(_selectedDateRange.end)}',
          ),
          onPressed: () => _selectDateRange(context),
          avatar: const Icon(Icons.calendar_today),
        ),
      ],
    );
  }

  Widget _buildMultiSelectDropdown<T>({
    required String label,
    AsyncValue<List<T>>? asyncValue,
    List<T>? items,
    required List<T> selectedItems,
    required void Function(List<T>) onSelectionChanged,
    required String Function(T) itemBuilder,
  }) {
    Widget content;
    if (asyncValue != null) {
      content = asyncValue.when(
        data: (data) => _buildDropdownContent(data, selectedItems, onSelectionChanged, itemBuilder),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Text('Error: $error'),
      );
    } else if (items != null) {
      content = _buildDropdownContent(items, selectedItems, onSelectionChanged, itemBuilder);
    } else {
      content = const Text('No items provided');
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 200, maxWidth: 300),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          content,
        ],
      ),
    );
  }

  Widget _buildDropdownContent<T>(
    List<T> items,
    List<T> selectedItems,
    void Function(List<T>) onSelectionChanged,
    String Function(T) itemBuilder,
  ) {
    return DropdownButtonFormField<T>(
      isExpanded: true,
      hint: const Text('Select...'),
      items: null, // Disable default dropdown, we use a dialog
      onTap: () async {
        final result = await showDialog<List<T>>(
          context: context,
          builder: (context) => _MultiSelectDialog(
            items: items,
            selectedItems: selectedItems,
            itemBuilder: itemBuilder,
          ),
        );
        if (result != null) {
          onSelectionChanged(result);
        }
      },
      decoration: InputDecoration(
        filled: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
        border: const OutlineInputBorder(),
        suffixIcon: const Icon(Icons.arrow_drop_down),
        // Display selected items as chips
        prefixIcon: selectedItems.isEmpty
            ? null
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    children: selectedItems
                        .map((item) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2.0),
                              child: Chip(label: Text(itemBuilder(item))),
                            ))
                        .toList(),
                  ),
                ),
              ),
      ),
    );
  }
}

class _MultiSelectDialog<T> extends StatefulWidget {
  final List<T> items;
  final List<T> selectedItems;
  final String Function(T) itemBuilder;

  const _MultiSelectDialog({
    required this.items,
    required this.selectedItems,
    required this.itemBuilder,
  });

  @override
  State<_MultiSelectDialog<T>> createState() => _MultiSelectDialogState<T>();
}

class _MultiSelectDialogState<T> extends State<_MultiSelectDialog<T>> {
  late final Set<T> _tempSelectedItems;

  @override
  void initState() {
    super.initState();
    _tempSelectedItems = widget.selectedItems.toSet();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Items'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          itemCount: widget.items.length,
          itemBuilder: (context, index) {
            final item = widget.items[index];
            final isSelected = _tempSelectedItems.contains(item);
            return CheckboxListTile(
              title: Text(widget.itemBuilder(item)),
              value: isSelected,
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    _tempSelectedItems.add(item);
                  } else {
                    _tempSelectedItems.remove(item);
                  }
                });
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(_tempSelectedItems.toList()),
          child: const Text('OK'),
        ),
      ],
    );
  }
}