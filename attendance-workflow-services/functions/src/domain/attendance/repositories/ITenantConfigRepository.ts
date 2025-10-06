/**
 * Represents the configuration settings for a single tenant.
 * This entity stores tenant-specific business rules and parameters.
 */
export interface TenantConfiguration {
  tenantId: string;
  timezone: string;
  autoCheckoutTime?: string; // e.g., "17:30"
  autoCheckoutEnabled?: boolean;
  approvalEscalationDays?: number;
  dataRetentionPeriods?: {
    attendance: number; // in days
    auditLog: number; // in days
  };
  passwordPolicy?: {
    minLength: number;
    requireUppercase: boolean;
    requireLowercase: boolean;
    requireNumber: boolean;
    requireSpecialChar: boolean;
  };
}

/**
 * Defines the contract for a repository that retrieves tenant-specific configuration settings.
 * This decouples the business logic from how and where tenant configurations are stored.
 */
export interface ITenantConfigRepository {
  /**
   * Retrieves the configuration for a single tenant by its ID.
   * @param tenantId The ID of the tenant.
   * @returns A promise that resolves to the TenantConfiguration or null if not found.
   */
  findByTenantId(tenantId: string): Promise<TenantConfiguration | null>;

  /**
   * Retrieves all tenant configurations that have the auto-checkout feature enabled.
   * Used by the auto-checkout scheduled job to determine which tenants to process.
   * @returns A promise that resolves to an array of TenantConfiguration objects.
   */
  findAllWithAutoCheckoutEnabled(): Promise<TenantConfiguration[]>;

  /**
   * Retrieves all tenant configurations that have the approval escalation feature configured.
   * Used by the approval escalation scheduled job.
   * @returns A promise that resolves to an array of TenantConfiguration objects.
   */
  findAllWithEscalationEnabled(): Promise<TenantConfiguration[]>;
}