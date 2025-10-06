import 'dart:convert';
import 'package:universal_html/html.dart' as html;
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';

class CsvExportButton extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  final String filename;
  final List<String> headers;

  const CsvExportButton({
    super.key,
    required this.data,
    required this.headers,
    this.filename = 'report.csv',
  });

  @override
  State<CsvExportButton> createState() => _CsvExportButtonState();
}

class _CsvExportButtonState extends State<CsvExportButton> {
  bool _isLoading = false;

  Future<void> _exportData() async {
    if (widget.data.isEmpty) {
      _showSnackBar('No data to export.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Create a list of lists for the CSV converter
      final List<List<dynamic>> rows = [];
      
      // Add header row
      rows.add(widget.headers);

      // Add data rows
      for (final item in widget.data) {
        final row = widget.headers.map((header) {
          // Attempt to map header to a key in the data map.
          // This assumes keys are simple strings. For nested data, more complex logic is needed.
          final key = _headerToKey(header);
          final value = item[key];
          
          // Format Timestamps or other complex types
          if (value is DateTime) {
            return value.toIso8601String();
          }
          return value ?? ''; // Use empty string for null values
        }).toList();
        rows.add(row);
      }

      final String csvString = const ListToCsvConverter().convert(rows);
      
      // Create a Blob and trigger download
      final bytes = utf8.encode(csvString);
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', widget.filename)
        ..click();
      html.Url.revokeObjectUrl(url);

      _showSnackBar('Export successful.');
    } catch (e) {
      _showSnackBar('An error occurred during export: $e', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _headerToKey(String header) {
    // Simple conversion from "Display Name" to "displayName"
    // This should be adapted to the actual data model keys.
    if (!header.contains(' ')) return header.toLowerCase();
    final parts = header.split(' ');
    return parts[0].toLowerCase() +
        parts.sublist(1).map((p) => p[0].toUpperCase() + p.substring(1)).join('');
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Theme.of(context).colorScheme.error : null,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: _isLoading ? null : _exportData,
      icon: _isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.download),
      label: const Text('Export to CSV'),
    );
  }
}