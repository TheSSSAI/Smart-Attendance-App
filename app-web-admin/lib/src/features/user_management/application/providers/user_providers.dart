import 'package:app_web_admin/src/features/user_management/application/notifiers/user_list_notifier.dart';
import 'package:client_data_access/client_data_access.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_web_admin/src/providers/repository_providers.dart';

/// Provides the [UserListNotifier] to the widget tree.
///
/// The [UserListNotifier] is responsible for managing the state of the user list,
/// including fetching users, handling pagination, filtering, and performing
/// administrative actions like deactivating or reassigning users.
///
/// This provider is `autoDispose` to ensure that the user list state is discarded
/// and re-fetched when the user navigates away from and back to the user
/// management screen, ensuring the data is always fresh.
final userListNotifierProvider =
    StateNotifierProvider.autoDispose<UserListNotifier, UserListState>(
  (ref) {
    final userRepository = ref.watch(userRepositoryProvider);
    final teamRepository = ref.watch(teamRepositoryProvider);
    final functionsRepository = ref.watch(functionsRepositoryProvider);
    return UserListNotifier(
        userRepository, teamRepository, functionsRepository);
  },
  name: 'userListNotifierProvider',
);

/// Provides a list of users eligible to be supervisors.
///
/// This provider fetches all active users with the 'Supervisor' or 'Admin' role.
/// It's used to populate dropdowns in UI components like the `UserEditDialog`
/// or `TeamEditDialog`, allowing an Admin to assign a supervisor to a user or a team.
///
/// The provider is `autoDispose` to ensure the list is refreshed when needed and
/// the cache is cleared when the relevant UI is no longer visible.
final eligibleSupervisorsProvider =
    FutureProvider.autoDispose<List<User>>((ref) async {
  final userRepository = ref.watch(userRepositoryProvider);
  return userRepository.fetchEligibleSupervisors();
}, name: 'eligibleSupervisorsProvider');