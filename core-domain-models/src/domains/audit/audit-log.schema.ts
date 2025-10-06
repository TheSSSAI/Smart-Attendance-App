import { z } from 'zod';
import { firestoreTimestampSchema, idSchema, tenantIdSchema } from '../shared';

/**
 * @description Schema for the immutable AuditLog entity.
 * Corresponds to the '/tenants/{tenantId}/auditLog/{auditLogId}' collection.
 * This collection is configured to be immutable via Firestore Security Rules.
 * @see REQ-1-028 - Specification for the immutable auditLog collection.
 * @see REQ-1-006 - Requirement to log all stages of correction process.
 * @see REQ-1-016 - Requirement to log all direct admin edits.
 */
export const auditLogSchema = z.object({
  auditLogId: idSchema,
  tenantId: tenantIdSchema,
  actingUserId: idSchema.describe('The user who performed the action.'),
  timestamp: firestoreTimestampSchema.describe('Server-side timestamp of the action.'),
  actionType: z.string().describe('A namespaced action type, e.g., "user.deactivate".'),
  targetEntity: z
    .string()
    .optional()
    .nullable()
    .describe('The type of entity that was affected, e.g., "user", "attendanceRecord".'),
  targetEntityId: idSchema
    .optional()
    .nullable()
    .describe('The ID of the affected entity.'),
  justification: z
    .string()
    .optional()
    .nullable()
    .describe('A mandatory justification for high-privilege actions.'),
  details: z
    .record(z.unknown())
    .optional()
    .nullable()
    .describe('A flexible object to store action-specific context, such as oldValue and newValue.'),
});

export type AuditLog = z.infer<typeof auditLogSchema>;