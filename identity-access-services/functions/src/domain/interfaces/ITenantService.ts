/**
 * @fileoverview Defines the contract for the Tenant Service in the application layer.
 * This service orchestrates the business logic for the tenant lifecycle.
 */

// This DTO would be defined in the application/dtos directory at level 1.
// A placeholder definition is included here for type safety.
type TenantRegistrationDto = {
  orgName: string;
  adminName: string;
  email: string;
  password: string;
  region: string; // Data residency region
};

type AdminContext = { adminId: string; tenantId: string; adminEmail: string; adminRole: string };
// End of DTO definition

export interface ITenantService {
  /**
   * Orchestrates the registration of a new organization tenant and its first Admin user.
   * This is a complex, atomic operation.
   * @param data The registration data for the new tenant and admin.
   * @returns A Promise that resolves with the new Admin's user ID.
   * @see REQ-1-032, REQ-1-033
   */
  registerNewTenant(data: TenantRegistrationDto): Promise<{ userId: string }>;

  /**
   * Orchestrates the initiation of the tenant deletion process.
   * This sets the tenant's status to 'pending_deletion' and starts the 30-day grace period.
   * @param context The context of the authenticated Admin performing the action.
   * @returns A Promise that resolves on successful initiation.
   * @see REQ-1-034
   */
  initiateTenantDeletion(context: AdminContext): Promise<void>;

  /**
   * Orchestrates the cancellation of a pending tenant deletion.
   * This reverts the tenant's status back to 'active'.
   * @param context The context of the authenticated Admin performing the action.
   * @returns A Promise that resolves on successful cancellation.
   * @see US-025
   */
  cancelTenantDeletion(context: AdminContext): Promise<void>;
}