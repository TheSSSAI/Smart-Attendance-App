// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND

/// A class that holds the route names and paths for the application.
///
/// This class is not meant to be instantiated or extended; it is used only as a
/// repository for static constants that represent the routes in the app.
/// This helps prevent typos and ensures a single source of truth for navigation.
final class AppRoutes {
  const AppRoutes._();

  // Core Routes
  static const String splashName = 'splash';
  static const String splashPath = '/';

  // Authentication Routes
  static const String loginName = 'login';
  static const String loginPath = '/login';

  static const String registrationCompletionName = 'registrationCompletion';
  static const String registrationCompletionPath = '/register';

  static const String forgotPasswordName = 'forgotPassword';
  static const String forgotPasswordPath = '/forgot-password';

  // Subordinate Routes
  static const String subordinateDashboardName = 'subordinateDashboard';
  static const String subordinateDashboardPath = '/subordinate';

  static const String attendanceHistoryName = 'attendanceHistory';
  static const String attendanceHistoryPath = 'history';

  static const String attendanceDetailName = 'attendanceDetail';
  static const String attendanceDetailPath = 'attendance/:attendanceId';

  // Supervisor Routes
  static const String supervisorDashboardName = 'supervisorDashboard';
  static const String supervisorDashboardPath = '/supervisor';

  static const String teamManagementName = 'teamManagement';
  static const String teamManagementPath = 'teams';

  // Event Routes
  static const String eventCalendarName = 'eventCalendar';
  static const String eventCalendarPath = 'calendar';

  static const String eventCreationName = 'eventCreation';
  static const String eventCreationPath = 'create-event';

  // Correction Routes
  static const String correctionRequestName = 'correctionRequest';
  static const String correctionRequestPath = 'request-correction/:attendanceId';

  static const String correctionReviewName = 'correctionReview';
  static const String correctionReviewPath = 'review-correction/:attendanceId';

  // Shared/Common Routes
  static const String settingsName = 'settings';
  static const String settingsPath = '/settings';
  
  // Informational/Error Routes
  static const String linkExpiredName = 'linkExpired';
  static const String linkExpiredPath = '/link-expired';

  static const String invalidLinkName = 'invalidLink';
  static const String invalidLinkPath = '/invalid-link';
}