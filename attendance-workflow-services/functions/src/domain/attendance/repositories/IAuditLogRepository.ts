import { Timestamp } from "firebase-admin/firestore";
import { ITransaction } from "./IAttendanceRepository";

/**
 * Represents the structure of a detailed audit log entry.
 * These records are immutable and provide a complete history of critical system actions.
 */
export interface AuditLog {
  id?: string; // Optional as it's generated on creation
  tenantId: string;
  actionType: string; // e.g., 'ATTENDANCE_CORRECTION_APPROVED', 'APPROVAL_ESCALATED'
  actorUserId: string; // The ID of the user (or 'system') who performed the action
  targetEntity: string; // e.g., 'AttendanceRecord', 'User'
  targetEntityId: string; // The ID of the entity that was affected
  timestamp: Timestamp;
  details: {
    [key: string]: any; // A flexible map to store action-specific details
  };
  justification?: string;
}

/**
 * Defines the contract for a repository that handles the creation of immutable AuditLog entities.
 * Adheres to the Command Query Responsibility Segregation (CQRS) principle, as this repository is write-only from the service's perspective.
 */
export interface IAuditLogRepository {
  /**
   * Creates a new, immutable audit log entry.
   * This operation should be performed within the same transaction as the business action being audited to ensure atomicity.
   * @param log The AuditLog entity to create.
   * @param transaction The transaction object to ensure the creation is part of a larger atomic operation.
   * @returns A promise that resolves when the creation is complete.
   */
  create(log: AuditLog, transaction: ITransaction): Promise<void>;
}