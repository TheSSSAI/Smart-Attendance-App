/// Represents the different types of reports available in the Admin dashboard.
///
/// This enum provides a type-safe way to identify and manage the various reports
/// required by the system, such as those specified in REQ-1-057. Using an enum
/// prevents magic strings and ensures that all report-related logic is clear
/// and maintainable.
enum ReportType {
  /// The main attendance summary report (e.g., daily, weekly, monthly).
  /// Corresponds to user story US-059.
  attendanceSummary,

  /// A report detailing late arrivals and early departures.
  /// Corresponds to user story US-061.
  lateArrivalEarlyDeparture,

  /// A report focused on attendance records with exceptions or flags.
  /// Corresponds to user story US-062.
  exceptionReport,

  /// A report for viewing the immutable audit log of critical system actions.
  /// Corresponds to user story US-063.
  auditLog,
}

/// An extension on [ReportType] to provide user-friendly display names.
///
/// This decouples the enum's raw value from its presentation in the UI,
/// allowing for easier localization and more descriptive labels in report
/// selection menus or titles.
extension ReportTypeExtension on ReportType {
  /// Returns a human-readable string for the report type.
  String get displayName {
    switch (this) {
      case ReportType.attendanceSummary:
        return 'Attendance Summary';
      case ReportType.lateArrivalEarlyDeparture:
        return 'Late Arrival / Early Departure';
      case ReportType.exceptionReport:
        return 'Exception Report';
      case ReportType.auditLog:
        return 'Audit Log';
      default:
        // This should never be reached if all enum cases are handled.
        // It serves as a compile-time check for developers.
        throw UnimplementedError('Display name not implemented for $this');
    }
  }
}