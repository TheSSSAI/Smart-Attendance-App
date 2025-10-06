import { z } from 'zod';
import { firestoreTimestampSchema, tenantIdSchema } from '../shared';

/**
 * @description Defines the possible lifecycle statuses for a tenant.
 * - 'active': The tenant is operational.
 * - 'pending_deletion': The tenant has requested deletion and is in a grace period (REQ-1-035).
 * - 'deleted': The tenant has been permanently deleted (for archival marking, though data is gone).
 */
export const tenantStatusSchema = z.enum([
  'active',
  'pending_deletion',
  'deleted',
]);
export type TenantStatus = z.infer<typeof tenantStatusSchema>;

/**
 * @description Schema for the Tenant entity. This is the root entity for an organization.
 * Corresponds to the '/tenants/{tenantId}' collection in Firestore.
 * @see REQ-1-002 - Defines the multi-tenant platform architecture.
 * @see REQ-1-073 - Specifies the Firestore data model structure.
 * @see US-001 - Admin registers a new organization tenant.
 * @see US-022 - Admin initiates permanent deletion of their tenant.
 */
export const tenantSchema = z.object({
  tenantId: tenantIdSchema,
  name: z
    .string()
    .min(1, { message: 'Organization name cannot be empty.' })
    .max(100, { message: 'Organization name cannot exceed 100 characters.' }),
  status: tenantStatusSchema.default('active'),
  subscriptionPlanId: z
    .string()
    .optional()
    .describe('ID of the subscription plan the tenant is on.'),
  createdAt: firestoreTimestampSchema.describe(
    'Server timestamp of when the tenant was created.'
  ),
  deletionScheduledAt: firestoreTimestampSchema
    .optional()
    .nullable()
    .describe(
      'Timestamp for when the permanent deletion is scheduled to occur after the grace period.'
    ),
});

export type Tenant = z.infer<typeof tenantSchema>;