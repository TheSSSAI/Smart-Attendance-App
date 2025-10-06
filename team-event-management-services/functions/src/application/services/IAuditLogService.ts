/**
 * Defines the types of actions that can be recorded in the audit log.
 * This ensures consistency and allows for easy filtering.
 */
export type AuditActionType =
  // Team actions
  | "team.create"
  | "team.update"
  | "team.delete"
  | "team.addMember"
  | "team.removeMember"
  // Event actions
  | "event.create"
  | "event.update"
  | "event.delete"
  // Other administrative actions, can be extended by other services
  | "user.deactivate"
  | "user.reassign"
  | "tenant.deletion.request"
  | "tenant.deletion.cancel";

/**
 * Defines the types of entities that can be the target of an audited action.
 */
export type TargetEntityType = "Team" | "Event" | "User" | "Tenant";

/**
 * Represents a single, structured entry for the audit log.
 */
export interface AuditLogEntry {
  /** The ID of the tenant where the action occurred. */
  tenantId: string;

  /** The user ID of the individual who performed the action. Can be 'system' for automated processes. */
  actorUserId: string;

  /** The specific type of action performed. */
  actionType: AuditActionType;

  /** The type of the entity that was affected. */
  targetEntity: TargetEntityType;

  /** The unique ID of the entity that was affected. */
  targetEntityId: string;

  /** A snapshot of the state of the entity before the change. */
  oldValue?: Record<string, unknown> | null;

  /** A snapshot of the state of the entity after the change. */
  newValue?: Record<string, unknown> | null;

  /** Optional justification provided by the user for the action. */
  justification?: string;
}

/**
 * Defines the contract for the Audit Log service.
 * This service is responsible for creating immutable records of critical actions
 * performed within the system.
 */
export interface IAuditLogService {
  /**
   * Creates a new, immutable entry in the audit log.
   * @param entry - The structured data representing the audited action.
   * @returns A promise that resolves when the log entry has been successfully created.
   * @throws An error if the log entry cannot be created.
   */
  log(entry: AuditLogEntry): Promise<void>;
}