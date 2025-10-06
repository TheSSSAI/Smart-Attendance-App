import { z } from 'zod';
import { firestoreTimestampSchema, idSchema, tenantIdSchema } from '../shared';

/**
 * @description Schema for the Event entity, used for scheduling.
 * Corresponds to the '/tenants/{tenantId}/events/{eventId}' collection in Firestore.
 * @see REQ-1-007 - Functionality for creating and assigning events.
 * @see REQ-1-073 - Specifies the Firestore data model structure.
 */
export const eventSchema = z.object({
  eventId: idSchema,
  tenantId: tenantIdSchema,
  title: z
    .string()
    .min(1, { message: 'Event title is required.' })
    .max(200, { message: 'Event title cannot exceed 200 characters.' }),
  description: z.string().optional().nullable(),
  startTime: firestoreTimestampSchema,
  endTime: firestoreTimestampSchema,
  createdByUserId: idSchema.describe('The userId of the user who created the event.'),
  assignedUserIds: z
    .array(idSchema)
    .default([])
    .describe('List of userIds directly assigned to this event.'),
  assignedTeamIds: z
    .array(idSchema)
    .default([])
    .describe('List of teamIds assigned to this event.'),
  // For recurring events (US-053)
  recurrenceRule: z
    .string()
    .optional()
    .nullable()
    .describe('An iCalendar RRULE string for recurring events.'),
  recurrenceId: idSchema
    .optional()
    .nullable()
    .describe('If this is an instance of a recurring event, this links to the master event.'),
});

export type Event = z.infer<typeof eventSchema>;