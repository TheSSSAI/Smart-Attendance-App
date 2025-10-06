import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/unauthorized_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/reporting/presentation/screens/audit_log_screen.dart';
import '../../features/reporting/presentation/screens/exception_report_screen.dart';
import '../../features/reporting/presentation/screens/summary_report_screen.dart';
import '../../features/settings/presentation/screens/tenant_settings_screen.dart';
import '../../features/user_management/presentation/screens/user_management_screen.dart';
import 'auth_guard.dart';

// Private navigator keys
final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

/// Provides the configured GoRouter instance for the application.
///
/// This provider centralizes the application's routing logic, including public routes,
/// protected routes with a shell layout, and authentication guards.
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: LoginScreen.routePath,
    debugLogDiagnostics: true, // Set to false in production

    // Routes configuration
    routes: [
      // Public routes that don't require the main dashboard shell
      GoRoute(
        path: LoginScreen.routePath,
        name: LoginScreen.routeName,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: UnauthorizedScreen.routePath,
        name: UnauthorizedScreen.routeName,
        builder: (context, state) => const UnauthorizedScreen(),
      ),

      // Protected routes wrapped in a ShellRoute for the main dashboard layout
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return DashboardScreen(child: child);
        },
        routes: [
          // The root of the dashboard, redirects to the summary report.
          GoRoute(
              path: '/',
              name: 'home',
              redirect: (context, state) => SummaryReportScreen.routePath,
              routes: [
                GoRoute(
                  path: UserManagementScreen.routePath.substring(1), // remove leading '/'
                  name: UserManagementScreen.routeName,
                  pageBuilder: (context, state) => const NoTransitionPage(
                    child: UserManagementScreen(),
                  ),
                ),
                GoRoute(
                  path: TenantSettingsScreen.routePath.substring(1), // remove leading '/'
                  name: TenantSettingsScreen.routeName,
                  pageBuilder: (context, state) => const NoTransitionPage(
                    child: TenantSettingsScreen(),
                  ),
                ),
                // Reporting sub-routes
                GoRoute(
                  path: SummaryReportScreen.routePath.substring(1), // remove leading '/'
                  name: SummaryReportScreen.routeName,
                  pageBuilder: (context, state) => const NoTransitionPage(
                    child: SummaryReportScreen(),
                  ),
                ),
                GoRoute(
                  path: ExceptionReportScreen.routePath.substring(1), // remove leading '/'
                  name: ExceptionReportScreen.routeName,
                  pageBuilder: (context, state) => const NoTransitionPage(
                    child: ExceptionReportScreen(),
                  ),
                ),
                GoRoute(
                  path: AuditLogScreen.routePath.substring(1), // remove leading '/'
                  name: AuditLogScreen.routeName,
                  pageBuilder: (context, state) => const NoTransitionPage(
                    child: AuditLogScreen(),
                  ),
                ),
              ]),
        ],
      ),
    ],

    // Redirect logic to enforce authentication and authorization
    redirect: (BuildContext context, GoRouterState state) {
      // We use a ProviderContainer to read providers within a non-widget context.
      // This is a clean way to access auth state without passing 'ref' around.
      final container = ProviderScope.containerOf(context);
      return AuthGuard.redirect(context, state, container);
    },

    // Error handling for routes that are not found
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '404 - Page Not Found',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'The requested page at "${state.uri.path}" could not be found.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => GoRouter.of(context).go('/'),
              child: const Text('Go to Dashboard'),
            ),
          ],
        ),
      ),
    ),
  );
});