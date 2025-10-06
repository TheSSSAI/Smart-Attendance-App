import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/csv_export_button.dart';
import '../widgets/report_filter_widget.dart';

class ExceptionReportScreen extends ConsumerWidget {
  const ExceptionReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Placeholder data
    final exceptions = [
      _ExceptionRecord('John Doe', '2024-05-23', '09:10', '17:35', ['Clock Discrepancy']),
      _ExceptionRecord('Jane Smith', '2024-05-23', '08:55', '--:--', ['Auto-checked-out']),
      _ExceptionRecord('Peter Jones', '2024-05-22', '09:01', '17:02', ['Offline Entry']),
      _ExceptionRecord('Maria Garcia', '2024-05-22', '10:15', '16:50', ['Manually Corrected', 'Clock Discrepancy']),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exception Report'),
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
            // You can add extra filters specific to this report here
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              children: [
                PaginatedDataTable(
                  header: const Text('Flagged Records'),
                  columns: const [
                    DataColumn(label: Text('User')),
                    DataColumn(label: Text('Date')),
                    DataColumn(label: Text('Check-In')),
                    DataColumn(label: Text('Check-Out')),
                    DataColumn(label: Text('Exceptions')),
                  ],
                  source: _ExceptionDataSource(exceptions),
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

class _ExceptionDataSource extends DataTableSource {
  final List<_ExceptionRecord> _exceptions;
  _ExceptionDataSource(this._exceptions);

  @override
  DataRow? getRow(int index) {
    if (index >= _exceptions.length) return null;
    final record = _exceptions[index];
    return DataRow.byIndex(index: index, cells: [
      DataCell(Text(record.user)),
      DataCell(Text(record.date)),
      DataCell(Text(record.checkIn)),
      DataCell(Text(record.checkOut)),
      DataCell(
        Wrap(
          spacing: 4.0,
          runSpacing: 4.0,
          children: record.flags.map((flag) => Chip(
            label: Text(flag),
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0),
            labelStyle: const TextStyle(fontSize: 12),
            backgroundColor: _getFlagColor(flag).withOpacity(0.1),
            side: BorderSide(color: _getFlagColor(flag)),
          )).toList(),
        ),
      ),
    ]);
  }

  Color _getFlagColor(String flag) {
    switch(flag) {
      case 'Clock Discrepancy':
        return Colors.orange;
      case 'Auto-checked-out':
        return Colors.blue;
      case 'Offline Entry':
        return Colors.purple;
      case 'Manually Corrected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _exceptions.length;

  @override
  int get selectedRowCount => 0;
}

class _ExceptionRecord {
  final String user;
  final String date;
  final String checkIn;
  final String checkOut;
  final List<String> flags;

  _ExceptionRecord(this.user, this.date, this.checkIn, this.checkOut, this.flags);
}