/**
 * @fileoverview Defines the contract for an Audit Log service.
 * This service is responsible for creating immutable records of critical system actions.
 */

// This would typically be imported from a shared core domain models library (e.g., REPO-LIB-CORE-001)
export type ActionType = 
  | 'tenant.create'
  | 'tenant.deletion.request'
  | 'tenant.deletion.cancel'
  | 'tenant.deletion.process'
  | 'user.invite'
  | 'user.activate'
  | 'user.deactivate'
  | 'user.supervisor.update'
  | 'user.anonymize';

export interface AuditLogData {
  tenantId: string;
  actor: {
    userId: string;
    email: string;
    role: string;
  };
  action: ActionType;
  target: {
    id: string;
    type: string; // e.g., 'user', 'tenant', 'team'
    display: string; // e.g., user email, tenant name
  };
  details?: Record<string, unknown>; // For storing oldValue/newValue, etc.
}

export interface AuditLogEntry extends AuditLogData {
  id: string;
  timestamp: Date;
}
// End of shared model definition


export interface IAuditLogService {
  /**
   * Creates a new, immutable entry in the audit log.
   * This method must be called within any business logic that performs a critical, auditable action.
   * @param data The data for the audit log entry.
   * @returns A Promise that resolves when the log entry has been successfully created.
   * @see REQ-1-028 - Mandates immutability.
   * @see US-051 - Use case for viewing audit logs.
   */
  log(data: AuditLogData): Promise<void>;
}