import { z } from 'zod';
import { firestoreTimestampSchema, idSchema, tenantIdSchema } from '../shared';

/**
 * @description Defines the RBAC roles within the system.
 * @see REQ-1-003 - Specifies the three distinct user roles.
 */
export const userRoleSchema = z.enum(['Admin', 'Supervisor', 'Subordinate']);
export type UserRole = z.infer<typeof userRoleSchema>;

/**
 * @description Defines the lifecycle statuses for a user account.
 * - 'invited': User has been invited but has not completed registration (REQ-1-036).
 * - 'active': User has completed registration and can log in.
 * - 'deactivated': User's access has been revoked by an Admin (REQ-1-037).
 */
export const userStatusSchema = z.enum(['invited', 'active', 'deactivated']);
export type UserStatus = z.infer<typeof userStatusSchema>;

/**
 * @description Schema for the User entity.
 * Corresponds to the '/tenants/{tenantId}/users/{userId}' collection in Firestore.
 * @see REQ-1-002 - Defines hierarchical organizational structures (supervisorId).
 * @see REQ-1-003 - Implements RBAC roles.
 * @see REQ-1-073 - Specifies the Firestore data model structure.
 */
export const userSchema = z.object({
  userId: idSchema.describe('Firebase Authentication UID.'),
  tenantId: tenantIdSchema,
  email: z.string().email({ message: 'Invalid email address.' }),
  firstName: z.string().min(1, { message: 'First name is required.' }),
  lastName: z.string().min(1, { message: 'Last name is required.' }),
  role: userRoleSchema,
  status: userStatusSchema.default('invited'),
  supervisorId: idSchema
    .optional()
    .nullable()
    .describe('The userId of this user_s direct supervisor.'),
  teamIds: z.array(idSchema).default([]).describe('List of teamIds this user is a member of.'),
  createdAt: firestoreTimestampSchema,
  deactivatedAt: firestoreTimestampSchema
    .optional()
    .nullable()
    .describe('Timestamp when the user was deactivated.'),
  fcmTokens: z
    .array(z.string())
    .optional()
    .describe('Firebase Cloud Messaging device tokens for push notifications.'),
  invitationToken: z
    .string()
    .optional()
    .nullable()
    .describe('One-time token for initial user registration.'),
  invitationExpiresAt: firestoreTimestampSchema
    .optional()
    .nullable()
    .describe('Expiry timestamp for the invitation token.'),
});

export type User = z.infer<typeof userSchema>;