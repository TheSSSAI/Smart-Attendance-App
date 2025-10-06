import 'package:app_web_admin/src/features/auth/application/notifiers/auth_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client_data_access/client_data_access.dart';
import 'package:app_web_admin/src/providers/repository_providers.dart';

/// Provides the authentication state changes as a stream.
///
/// This is used primarily by the AuthGuard to react to login/logout events
/// and redirect the user accordingly. It directly exposes the stream from the
/// authentication repository.
final authStateChangesProvider = StreamProvider.autoDispose<User?>(
  (ref) {
    final authRepository = ref.watch(authRepositoryProvider);
    return authRepository.authStateChanges();
  },
  name: 'authStateChangesProvider',
);

/// Provides the [AuthNotifier] to the widget tree.
///
/// The [AuthNotifier] contains the business logic for authentication actions
/// such as logging in, logging out, and checking the current user's role.
///
/// This is a global provider and should not be auto-disposed as the authentication
/// state is relevant throughout the entire application lifecycle.
final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthNotifier(authRepository);
}, name: 'authNotifierProvider');

/// Provides the currently authenticated user's data, including custom claims.
///
/// This provider depends on the authentication state. If the user is logged in,
/// it returns the [User] object; otherwise, it returns null. This is useful for
/// UI components that need to display user information or make decisions based on
/// the user's role without listening to the full auth state.
final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.when(
    initial: () => null,
    loading: () => null,
    authenticated: (user) => user,
    unauthenticated: () => null,
    error: (_, __) => null,
  );
}, name: 'currentUserProvider');