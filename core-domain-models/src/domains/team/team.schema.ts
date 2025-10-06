import { z } from 'zod';
import { idSchema, tenantIdSchema } from '../shared';

/**
 * @description Schema for the Team entity.
 * Corresponds to the '/tenants/{tenantId}/teams/{teamId}' collection in Firestore.
 * @see REQ-1-073 - Specifies the Firestore data model structure.
 * @see US-011 - Admin creates a new team and assigns a Supervisor.
 */
export const teamSchema = z.object({
  teamId: idSchema,
  tenantId: tenantIdSchema,
  name: z
    .string()
    .min(1, { message: 'Team name is required.' })
    .max(100, { message: 'Team name cannot exceed 100 characters.' }),
  supervisorId: idSchema.describe('The userId of the user who supervises this team.'),
  memberIds: z
    .array(idSchema)
    .default([])
    .describe('List of userIds for members of this team.'),
});

export type Team = z.infer<typeof teamSchema>;