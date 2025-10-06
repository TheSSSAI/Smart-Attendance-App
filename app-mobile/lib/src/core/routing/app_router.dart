import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/application/providers/auth_providers.dart';
import '../../features/auth/domain/user_role.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/registration_completion_screen.dart';
import '../../features/attendance/presentation/screens/attendance_detail_screen.dart';
import '../../features/attendance/presentation/screens/attendance_history_screen.dart';
import '../../features/attendance/presentation/screens/subordinate_dashboard_screen.dart';
import '../../features/attendance/presentation/screens/supervisor_dashboard_screen.dart';
import '../../features/corrections/presentation/screens/correction_request_screen.dart';
import '../../features/corrections/presentation/screens/correction_review_screen.dart';
import '../../features/events/presentation/screens/event_calendar_screen.dart';
import '../../features/events/presentation/screens/event_creation_screen.dart';
import 'routes.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

class _NotFoundScreen extends StatelessWidget {
  const _NotFoundScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('404 - The page you were looking for was not found.'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.root),
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    );
  }
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateChangesProvider);
  final userProfileStream = ref.watch(userProfileStreamProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.login,
    debugLogDiagnostics: true,
    routerNeglect: true,
    redirect: (BuildContext context, GoRouterState state) {
      final isLoggingIn = state.matchedLocation == AppRoutes.login;
      final isRegistering =
          state.matchedLocation.startsWith(AppRoutes.registerBase);

      // Handle loading state
      if (authState.isLoading ||
          (authState.hasValue &&
              authState.value != null &&
              userProfileStream.isLoading)) {
        // While auth state is resolving or user profile is loading after login,
        // don't redirect. A loading screen should be shown by a parent widget.
        return null;
      }

      final isAuthenticated = authState.hasValue && authState.value != null;
      final userProfile =
          userProfileStream.hasValue ? userProfileStream.value : null;

      // Case 1: User is not authenticated
      if (!isAuthenticated) {
        // If not authenticated, allow access only to public routes
        return (isLoggingIn || isRegistering) ? null : AppRoutes.login;
      }

      // Case 2: User is authenticated
      if (userProfile == null) {
        // This can happen briefly after login before the profile stream emits.
        // It's also a sign of an improperly configured account.
        // For robustness, redirect to login to force a state refresh.
        // Consider logging this as an error.
        ref.read(authRepositoryProvider).signOut();
        return AppRoutes.login;
      }

      // Handle user status conditions
      switch (userProfile.status) {
        case 'invited':
        case 'pending_terms':
          // Force user to complete registration, unless they are already there.
          return isRegistering ? null : AppRoutes.login;
        case 'deactivated':
          // If deactivated, sign out and send to login screen.
          ref.read(authRepositoryProvider).signOut();
          return AppRoutes.login;
        case 'active':
        // User is active, proceed to role-based routing
        default:
          break;
      }

      // Case 3: Authenticated and active, but on a public route
      if (isLoggingIn || isRegistering) {
        // If user is already logged in and tries to access login/register,
        // redirect them to their home dashboard.
        switch (userProfile.role) {
          case UserRole.subordinate:
            return AppRoutes.subordinateDashboard;
          case UserRole.supervisor:
            return AppRoutes.supervisorDashboard;
          case UserRole.admin:
          default:
            // Mobile app does not support admin role, log out.
            ref.read(authRepositoryProvider).signOut();
            return AppRoutes.login;
        }
      }

      // Case 4: Authenticated and on root path, redirect to role-specific home
      if (state.matchedLocation == AppRoutes.root) {
        switch (userProfile.role) {
          case UserRole.subordinate:
            return AppRoutes.subordinateDashboard;
          case UserRole.supervisor:
            return AppRoutes.supervisorDashboard;
          default:
            ref.read(authRepositoryProvider).signOut();
            return AppRoutes.login;
        }
      }

      // No redirection needed, allow access.
      return null;
    },
    errorBuilder: (context, state) => const _NotFoundScreen(),
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '${AppRoutes.registerBase}/:token',
        builder: (context, state) {
          final token = state.pathParameters['token'];
          return RegistrationCompletionScreen(token: token);
        },
      ),
      GoRoute(
        path: AppRoutes.subordinateDashboard,
        builder: (context, state) => const SubordinateDashboardScreen(),
        routes: [
          GoRoute(
            path: AppRoutes.subordinateHistory,
            builder: (context, state) => const AttendanceHistoryScreen(),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.supervisorDashboard,
        builder: (context, state) => const SupervisorDashboardScreen(),
        routes: [
          GoRoute(
            path: AppRoutes.supervisorEventCreate,
            builder: (context, state) => const EventCreationScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '${AppRoutes.attendanceDetailBase}/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'];
          if (id == null) return const _NotFoundScreen();
          return AttendanceDetailScreen(attendanceId: id);
        },
      ),
      GoRoute(
        path: '${AppRoutes.correctionRequestBase}/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'];
          if (id == null) return const _NotFoundScreen();
          return CorrectionRequestScreen(attendanceId: id);
        },
      ),
      GoRoute(
        path: '${AppRoutes.correctionReviewBase}/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'];
          if (id == null) return const _NotFoundScreen();
          return CorrectionReviewScreen(attendanceId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.eventCalendar,
        builder: (context, state) => const EventCalendarScreen(),
      ),
      // Root redirect handled by the redirect logic
      GoRoute(
        path: AppRoutes.root,
        builder: (context, state) {
          // This should ideally not be reached due to the redirect logic.
          // A loading screen is a safe fallback.
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    ],
  );
});