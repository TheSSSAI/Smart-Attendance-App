import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_view_model.freezed.dart';

/// A UI-specific model representing a user for display in the admin dashboard.
///
/// This ViewModel is an immutable data class designed to be consumed by the
/// presentation layer (widgets). It decouples the UI from the underlying domain
/// model (`User` entity from the data layer), allowing for UI-specific data
/// formatting and properties without polluting the core domain logic.
///
/// For example, it includes `displayName` and `supervisorName` which might be
/// derived or formatted from the domain model before being passed to the UI.
/// This aligns with Clean Architecture principles by keeping the presentation
/// layer independent of the core data structure.
@freezed
class UserViewModel with _$UserViewModel {
  /// Creates an instance of UserViewModel.
  ///
  /// All properties are required to ensure the UI has the necessary data
  /// to display a user row correctly, with the exception of `supervisorName`
  /// which can be null if a user has no assigned supervisor.
  const factory UserViewModel({
    /// The unique identifier of the user (from Firebase Auth).
    required String id,

    /// The user's full name, formatted for display.
    required String displayName,

    /// The user's email address.
    required String email,

    /// The user's role (e.g., 'Admin', 'Supervisor', 'Subordinate').
    required String role,

    /// The user's account status (e.g., 'active', 'deactivated', 'invited').
    required String status,

    /// The name of the user's supervisor, if assigned.
    String? supervisorName,
  }) = _UserViewModel;
}