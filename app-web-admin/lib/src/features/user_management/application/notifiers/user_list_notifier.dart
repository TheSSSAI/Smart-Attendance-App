import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:attendance_client_data/attendance_client_data.dart';
import 'package:app_web_admin/src/features/user_management/presentation/models/user_view_model.dart';

part 'user_list_notifier.freezed.dart';

@freezed
class UserListState with _$UserListState {
  const factory UserListState.initial() = _Initial;
  const factory UserListState.loading() = _Loading;
  const factory UserListState.data({
    required List<UserViewModel> users,
    required bool hasMore,
    String? infoMessage,
  }) = _Data;
  const factory UserListState.error(String message) = _Error;
  const factory UserListState.reassignmentRequired({
    required String supervisorIdToDeactivate,
    required List<AppUser> subordinates,
    required String supervisorName,
  }) = _ReassignmentRequired;
}

class UserListNotifier extends StateNotifier<UserListState> {
  final IUserRepository _userRepository;
  final ITeamRepository _teamRepository; // Assuming needed for some operations
  final String _tenantId;
  dynamic _lastDocument;

  UserListNotifier(this._userRepository, this._teamRepository, this._tenantId)
      : super(const UserListState.initial()) {
    fetchUsers();
  }

  Future<void> fetchUsers({bool isRefresh = false}) async {
    if (state is _Loading && !isRefresh) return;
    
    state = const UserListState.loading();
    _lastDocument = null;

    try {
      final supervisorsResult = await _userRepository.getUsersByRole(['Admin', 'Supervisor'], _tenantId);
      final supervisorMap = {for (var s in supervisorsResult) s.uid: s.displayName ?? s.email};

      final paginatedResult = await _userRepository.fetchAllUsers(_tenantId);
      final viewModels = paginatedResult.data
          .map((user) => UserViewModel.fromAppUser(user, supervisorMap[user.supervisorId]))
          .toList();
      
      _lastDocument = paginatedResult.lastDocument;

      state = UserListState.data(
        users: viewModels,
        hasMore: paginatedResult.hasMore,
      );
    } on AppException catch (e) {
      state = UserListState.error(e.message);
    } catch (e) {
      state = UserListState.error("An unexpected error occurred: ${e.toString()}");
    }
  }

  Future<void> fetchNextPage() async {
    if (state is _Data) {
      final currentState = state as _Data;
      if (!currentState.hasMore) return;

      try {
        final supervisorsResult = await _userRepository.getUsersByRole(['Admin', 'Supervisor'], _tenantId);
        final supervisorMap = {for (var s in supervisorsResult) s.uid: s.displayName ?? s.email};
        
        final paginatedResult = await _userRepository.fetchAllUsers(_tenantId, startAfter: _lastDocument);
        
        final newViewModels = paginatedResult.data
            .map((user) => UserViewModel.fromAppUser(user, supervisorMap[user.supervisorId]))
            .toList();

        _lastDocument = paginatedResult.lastDocument;
        
        state = currentState.copyWith(
          users: [...currentState.users, ...newViewModels],
          hasMore: paginatedResult.hasMore,
        );
      } on AppException catch (e) {
        // Optionally update state to show error on current data screen
        state = currentState.copyWith(infoMessage: "Error loading more users: ${e.message}");
      } catch (e) {
        state = currentState.copyWith(infoMessage: "An unexpected error occurred: ${e.toString()}");
      }
    }
  }
  
  Future<void> inviteUser({required String email, required String role}) async {
    final originalState = state;
    try {
      await _userRepository.inviteUser(email: email, role: role, tenantId: _tenantId);
      await fetchUsers(isRefresh: true);
      if (state is _Data) {
        state = (state as _Data).copyWith(infoMessage: 'Invitation sent to $email successfully.');
      }
    } on AppException catch (e) {
      state = originalState; // Revert state on failure
      if (originalState is _Data) {
        state = (originalState as _Data).copyWith(infoMessage: 'Failed to send invitation: ${e.message}');
      } else {
        state = UserListState.error('Failed to send invitation: ${e.message}');
      }
    }
  }

  Future<void> deactivateUser({required String userId, required String userName, required String userRole}) async {
    try {
      await _userRepository.deactivateUser(userId: userId, tenantId: _tenantId);
      await fetchUsers(isRefresh: true);
       if (state is _Data) {
        state = (state as _Data).copyWith(infoMessage: 'User $userName deactivated successfully.');
      }
    } on SupervisorHasSubordinatesException catch (e) {
      state = UserListState.reassignmentRequired(
        supervisorIdToDeactivate: userId, 
        subordinates: e.subordinates,
        supervisorName: userName,
      );
    } on AppException catch(e) {
        if (state is _Data) {
            state = (state as _Data).copyWith(infoMessage: 'Failed to deactivate user: ${e.message}');
        } else {
            state = UserListState.error('Failed to deactivate user: ${e.message}');
        }
    }
  }

  Future<void> reassignAndDeactivate({
    required String supervisorToDeactivateId,
    required Map<String, String> reassignments,
  }) async {
    try {
      await _userRepository.reassignSubordinatesAndDeactivateSupervisor(
        supervisorToDeactivateId: supervisorToDeactivateId,
        reassignments: reassignments,
        tenantId: _tenantId,
      );
      await fetchUsers(isRefresh: true);
       if (state is _Data) {
        state = (state as _Data).copyWith(infoMessage: 'Subordinates reassigned and supervisor deactivated.');
      }
    } on AppException catch (e) {
      await fetchUsers(isRefresh: true); // Refresh list to revert UI
      if (state is _Data) {
        state = (state as _Data).copyWith(infoMessage: 'Operation failed: ${e.message}');
      } else {
        state = UserListState.error('Operation failed: ${e.message}');
      }
    }
  }
}