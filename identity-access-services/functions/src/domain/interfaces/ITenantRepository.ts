/**
 * @fileoverview Defines the contract for a Tenant repository.
 * This interface abstracts the data persistence logic for the Tenant aggregate root.
 */

// This would typically be imported from a shared core domain models library (e.g., REPO-LIB-CORE-001)
export type TenantStatus = 'active' | 'pending_deletion';

export interface Tenant {
  tenantId: string;
  name: string;
  normalizedName: string; // For case-insensitive uniqueness checks
  status: TenantStatus;
  subscriptionPlanId: string;
  createdAt: Date;
  deletionScheduledAt?: Date;
}
// End of shared model definition

export interface ITenantRepository {
  /**
   * Finds a tenant by its unique ID.
   * @param tenantId The ID of the tenant.
   * @returns A Promise that resolves with the Tenant object or null if not found.
   */
  findById(tenantId: string): Promise<Tenant | null>;

  /**
   * Finds a tenant by its normalized, case-insensitive name.
   * @param normalizedName The normalized name of the tenant.
   * @returns A Promise that resolves with the Tenant object or null if not found.
   */
  findByName(normalizedName: string): Promise<Tenant | null>;

  /**
   * Persists a new tenant to the data store.
   * @param tenant The Tenant object to create.
   * @returns A Promise that resolves when the creation is complete.
   */
  create(tenant: Tenant): Promise<void>;

  /**
   * Updates an existing tenant in the data store.
   * @param tenantId The ID of the tenant to update.
   * @param data The partial data to update.
   * @returns A Promise that resolves when the update is complete.
   */
  update(tenantId: string, data: Partial<Omit<Tenant, 'tenantId'>>): Promise<void>;

  /**
   * Finds all tenants that are scheduled for deletion and whose grace period has expired.
   * @returns A Promise that resolves with an array of tenants to be deleted.
   * @see REQ-1-035
   */
  findForDeletion(): Promise<Tenant[]>;

  /**
   * Deletes a tenant and all its associated data. This is a complex, multi-collection operation.
   * @param tenantId The ID of the tenant to delete.
   * @returns A Promise that resolves when the tenant and all its data have been deleted.
   */
  delete(tenantId: string): Promise<void>;
}