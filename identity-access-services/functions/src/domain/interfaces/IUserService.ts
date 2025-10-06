/**
 * @fileoverview Defines the contract for the User Service in the application layer.
 * This service orchestrates the business logic for user lifecycle management.
 */

// These DTOs would be defined in the application/dtos directory at level 1.
// Placeholder definitions are included here for type safety.
type UserInvitationDto = { email: string; role: 'Supervisor' | 'Subordinate' };
type CompleteRegistrationDto = { token: string; password: string; name: string };
type AdminContext = { adminId: string; tenantId: string; adminEmail: string; adminRole: string };
// End of DTO definitions

export interface IUserService {
  /**
   * Orchestrates the invitation of a new user to a tenant.
   * @param data The user invitation data.
   * @param context The context of the authenticated Admin performing the action.
   * @returns A Promise that resolves on successful invitation.
   * @see REQ-1-036
   */
  inviteNewUser(data: UserInvitationDto, context: AdminContext): Promise<void>;

  /**
   * Orchestrates the completion of a user's registration via an invitation token.
   * @param data The registration completion data, including the token and new password.
   * @returns A Promise that resolves with the new user's ID.
   * @see REQ-1-037
   */
  completeUserRegistration(data: CompleteRegistrationDto): Promise<{ userId: string }>;

  /**
   * Orchestrates the deactivation of a user account.
   * Enforces business rules, such as preventing deactivation of a supervisor with active subordinates.
   * @param userIdToDeactivate The ID of the user to deactivate.
   * @param context The context of the authenticated Admin performing the action.
   * @returns A Promise that resolves on successful deactivation.
   * @see REQ-1-029, US-008
   */
  deactivateUser(userIdToDeactivate: string, context: AdminContext): Promise<void>;

  /**
   * Orchestrates the update of a user's supervisor.
   * Enforces the business rule preventing circular reporting hierarchies.
   * @param userId The ID of the user being updated.
   * @param newSupervisorId The ID of the new supervisor, or null.
   * @param context The context of the authenticated Admin performing the action.
   * @returns A Promise that resolves on a successful update.
   * @see REQ-1-026
   */
  updateUserSupervisor(
    userId: string,
    newSupervisorId: string | null,
    context: AdminContext
  ): Promise<void>;
}