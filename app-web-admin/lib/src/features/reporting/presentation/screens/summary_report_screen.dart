import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/csv_export_button.dart';
import '../widgets/report_filter_widget.dart';

class SummaryReportScreen extends ConsumerWidget {
  const SummaryReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Placeholder for actual reporting data providers and state
    // In a real app, you would watch a provider that returns report data.
    // e.g., final reportData = ref.watch(summaryReportProvider(currentFilters));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Summary Report'),
        actions: [
          CsvExportButton(onExport: () {
            // Placeholder for CSV export logic
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
              // This would trigger a refetch of the report data
              // e.g., ref.read(reportFilterProvider.notifier).state = filters;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Applying filters: ${filters.toString()}')),
              );
            },
          ),
          const Divider(height: 1),
          Expanded(
            // This would be replaced by a widget that reacts to the reportData provider
            child: _buildPlaceholderContent(context),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Summary for: Last 7 Days',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 16.0,
            runSpacing: 16.0,
            children: [
              _buildSummaryCard(context, 'Total Present', '85', Icons.check_circle, Colors.green),
              _buildSummaryCard(context, 'Total Absent', '15', Icons.cancel, Colors.red),
              _buildSummaryCard(context, 'Attendance %', '85%', Icons.pie_chart, Colors.blue),
              _buildSummaryCard(context, 'Late Arrivals', '12', Icons.warning, Colors.orange),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            'Daily Attendance Trend',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          // Placeholder for a chart widget
          Container(
            height: 300,
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: const Center(
              child: Text(
                'Chart Component Placeholder',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: SizedBox(
        width: 250,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(0.1),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.bodyLarge),
                  Text(
                    value,
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}