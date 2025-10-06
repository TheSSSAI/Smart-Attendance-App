import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/application/providers/auth_providers.dart';
import '../../features/auth/domain/enums/auth_status.dart';
import '../../features/auth/domain/enums/user_role.dart';
import 'app_router.dart';

/// A routing guard that protects application routes based on authentication status and user role.
///
/// This guard is the primary security checkpoint for the web admin application, ensuring
/// that only authenticated users with the 'Admin' role can access protected routes.
/// It systematically handles various authentication states:
/// - **Loading**: Allows the app to show a splash/loading screen while auth state is being determined.
/// - **Unauthenticated**: Redirects any attempt to access protected routes to the login screen.
/// - **Authenticated (Non-Admin)**: Redirects users to an 'unauthorized' screen, as this web portal is for Admins only.
/// - **Authenticated (Admin)**: Allows access to protected routes and prevents access to public routes like login.
class AuthGuard {
  /// A private constructor to prevent instantiation of this utility class.
  AuthGuard._();

  /// The core redirect logic to be used with GoRouter.
  ///
  /// This method is called by GoRouter on every navigation event. It watches the
  /// authentication state via Riverpod and returns a new route path to redirect
  /// the user if necessary, or `null` to allow the navigation to proceed.
  ///
  /// [context] The build context.
  /// [ref] A Riverpod ref to watch providers.
  /// [state] The current router state.
  ///
  /// Returns a `Future<String?>` which resolves to a route path for redirection, or null.
  static FutureOr<String?> redirect(
      BuildContext context, WidgetRef ref, GoRouterState state) {
    final authState = ref.watch(authNotifierProvider);
    final isLoggedIn = authState.status == AuthStatus.authenticated;
    final isAuthenticating = authState.status == AuthStatus.loading ||
        authState.status == AuthStatus.initial;

    final location = state.uri.toString();

    // While authenticating, don't redirect. The router's builder will show a loading screen.
    if (isAuthenticating) {
      return null;
    }

    // Define public routes that do not require authentication.
    final isPublicRoute =
        location == AppRoutes.login || location == AppRoutes.unauthorized;

    if (isLoggedIn) {
      final user = authState.user;
      final isAdmin = user?.role == UserRole.admin;

      if (isAdmin) {
        // If an Admin is logged in and tries to access a public route like login,
        // redirect them to the main dashboard.
        if (isPublicRoute) {
          return AppRoutes.dashboard;
        }
        // Admin is logged in and accessing a protected route, allow access.
        return null;
      } else {
        // A non-Admin user is logged in. They are not authorized for this portal.
        // Redirect them to the unauthorized screen.
        if (location != AppRoutes.unauthorized) {
          return AppRoutes.unauthorized;
        }
        // They are already on the unauthorized screen, allow it.
        return null;
      }
    } else {
      // User is not logged in.
      // If they are trying to access a protected route, redirect to login.
      if (!isPublicRoute) {
        return AppRoutes.login;
      }
      // User is not logged in and is on a public route, allow access.
      return null;
    }
  }
}