import 'dart:async';

import 'package:client_data_access/client_data_access.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_web_admin/src/providers/repository_providers.dart';

/// Provides and manages the current state of the report filters.
///
/// This [StateProvider] holds the `ReportFilters` object that the user configures
/// in the `ReportFilterWidget`. Report screens watch this provider to get the
/// current filters and pass them to the data-fetching providers.
final reportFilterStateProvider =
    StateProvider.autoDispose<ReportFilters>((ref) {
  // Default to showing data for the current month.
  final now = DateTime.now();
  final firstDayOfMonth = DateTime(now.year, now.month, 1);
  final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

  return ReportFilters(
    startDate: firstDayOfMonth,
    endDate: lastDayOfMonth,
  );
}, name: 'reportFilterStateProvider');

/// Fetches a paginated list of attendance records based on the provided filters.
///
/// This is a `.family` provider, which means it takes an argument—in this case,
/// a `PaginatedReportQuery` object containing both filters and pagination options.
/// The UI will watch this provider with the current filter and page state to
/// fetch and display the relevant report data.
///
/// Riverpod automatically caches the results, so if the same query is requested
/// again, the data is returned from the cache instead of making a new network request.
final filteredAttendanceReportProvider = FutureProvider.autoDispose
    .family<PaginatedResult<AttendanceRecord>, PaginatedReportQuery>(
        (ref, query) async {
  final reportRepository = ref.watch(reportRepositoryProvider);
  final cancellableOperation =
      reportRepository.getFilteredAttendanceRecords(query: query);

  // When the provider is destroyed, cancel the network request if it's still ongoing.
  ref.onDispose(() => cancellableOperation.cancel());

  return cancellableOperation.value;
}, name: 'filteredAttendanceReportProvider');

/// Fetches a paginated list of audit log entries based on provided filters.
///
/// Similar to [filteredAttendanceReportProvider], this is a `.family` provider
/// that takes a `PaginatedReportQuery` to fetch filtered and paginated audit logs.
/// This is used by the Audit Log screen to display compliance and security data.
final filteredAuditLogProvider = FutureProvider.autoDispose
    .family<PaginatedResult<AuditLog>, PaginatedReportQuery>((ref, query) async {
  final reportRepository = ref.watch(reportRepositoryProvider);
  final cancellableOperation =
      reportRepository.getFilteredAuditLogs(query: query);

  // When the provider is destroyed, cancel the network request if it's still ongoing.
  ref.onDispose(() => cancellableOperation.cancel());

  return cancellableOperation.value;
}, name: 'filteredAuditLogProvider');

/// A provider to generate and download a CSV representation of a report.
///
/// This provider takes a [ReportFilters] object and fetches ALL matching records
/// (bypassing UI pagination) to generate a CSV file as a `List<int>` of bytes.
/// The UI can call this provider to trigger a download.
final csvExportProvider =
    FutureProvider.autoDispose.family<List<int>, ReportFilters>(
        (ref, filters) async {
  final reportRepository = ref.watch(reportRepositoryProvider);
  // Here we would typically fetch all pages of data.
  // This is a simplified example; a real implementation would loop through pages.
  final data = await reportRepository
      .getFilteredAttendanceRecords(
        query: PaginatedReportQuery(filters: filters, page: 1, limit: 500),
      )
      .value;

  // In a real app, we would use a CSV generation library.
  // For this example, we generate a simple string.
  final csvStringBuffer = StringBuffer();
  // Header
  csvStringBuffer.writeln(
      'RecordID,UserName,UserEmail,CheckInTime,CheckInLat,CheckInLon,CheckOutTime,CheckOutLat,CheckOutLon,Status,Notes');

  // Rows
  for (final record in data.items) {
    final values = [
      record.id,
      record.userName,
      record.userEmail,
      record.checkInTime?.toIso8601String() ?? '',
      record.checkInGps?.latitude ?? '',
      record.checkInGps?.longitude ?? '',
      record.checkOutTime?.toIso8601String() ?? '',
      record.checkOutGps?.latitude ?? '',
      record.checkOutGps?.longitude ?? '',
      record.status.name,
      // Assuming notes are part of a details object, handle accordingly
      (record.flags ?? []).join('; '),
    ].map((v) => '"${v.toString().replaceAll('"', '""')}"').join(',');
    csvStringBuffer.writeln(values);
  }

  return csvStringBuffer.toString().codeUnits;
}, name: 'csvExportProvider');