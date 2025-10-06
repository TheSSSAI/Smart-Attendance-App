import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/csv_export_button.dart';
import '../widgets/report_filter_widget.dart';

class AuditLogScreen extends ConsumerWidget {
  const AuditLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Placeholder data
    final auditLogs = [
      _AuditLog('2024-05-23 14:30:15', 'admin@example.com', 'Direct Data Edit', 'Attendance for John Doe', 'Corrected missed check-out'),
      _AuditLog('2024-05-23 11:05:00', 'supervisor@example.com', 'Correction Approved', 'Attendance for Jane Smith', 'User forgot to check out'),
      _AuditLog('2024-05-22 18:00:00', 'admin@example.com', 'User Deactivated', 'user_id_12345', 'Employee offboarding'),
      _AuditLog('2024-05-21 09:00:12', 'system', 'Tenant Deletion Requested', 'tenant_id_abc', 'Admin request'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Audit Log Report'),
         actions: [
          CsvExportButton(onExport: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('CSV export functionality not implemented yet.')),
            );
          }),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          ReportFilterWidget(
            onApplyFilters: (filters) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Applying filters: ${filters.toString()}')),
              );
            },
            // You can add extra filters specific to this report here (e.g., Action Type)
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              children: [
                PaginatedDataTable(
                  header: const Text('System Actions'),
                  columns: const [
                    DataColumn(label: Text('Timestamp')),
                    DataColumn(label: Text('Actor')),
                    DataColumn(label: Text('Action Type')),
                    DataColumn(label: Text('Target')),
                    DataColumn(label: Text('Details/Justification')),
                  ],
                  source: _AuditLogDataSource(auditLogs),
                  rowsPerPage: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class _AuditLogDataSource extends DataTableSource {
  final List<_AuditLog> _logs;
  _AuditLogDataSource(this._logs);

  @override
  DataRow? getRow(int index) {
    if (index >= _logs.length) return null;
    final log = _logs[index];
    return DataRow.byIndex(index: index, cells: [
      DataCell(Text(log.timestamp)),
      DataCell(Text(log.actor)),
      DataCell(Text(log.actionType)),
      DataCell(Text(log.target)),
      DataCell(Text(log.details, overflow: TextOverflow.ellipsis)),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _logs.length;

  @override
  int get selectedRowCount => 0;
}

class _AuditLog {
  final String timestamp;
  final String actor;
  final String actionType;
  final String target;
  final String details;

  _AuditLog(this.timestamp, this.actor, this.actionType, this.target, this.details);
}