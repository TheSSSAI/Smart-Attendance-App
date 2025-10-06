/**
 * @fileoverview Defines the contract for the Maintenance service, which handles scheduled,
 * automated data lifecycle tasks such as tenant deletion and user anonymization.
 */

export interface MaintenanceResult {
  tenantsProcessed: number;
  tenantsDeleted: number;
  usersProcessed: number;
  usersAnonymized: number;
  errors: { id: string; reason: string }[];
}

export interface IMaintenanceService {
  /**
   * Processes all tenants marked for deletion whose grace period has expired.
   * This is a destructive operation that cascades deletes all tenant data.
   * @returns A Promise that resolves with a summary of the operations performed.
   * @see REQ-1-035
   */
  processTenantDeletions(): Promise<Partial<MaintenanceResult>>;

  /**
   * Finds and anonymizes Personally Identifiable Information (PII) for deactivated users
   * who are past their data retention period.
   * @returns A Promise that resolves with a summary of the operations performed.
   * @see REQ-1-074
   */
  anonymizeDeactivatedUsers(): Promise<Partial<MaintenanceResult>>;
}