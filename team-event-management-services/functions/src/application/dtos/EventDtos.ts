import { z } from "zod";

// Zod schema for Date objects, ensuring they are valid dates
const dateSchema = z.preprocess((arg) => {
  if (typeof arg == "string" || arg instanceof Date) return new Date(arg);
}, z.date());

// DTO for representing an Event in API responses
export const eventDtoSchema = z.object({
  id: z.string().uuid(),
  tenantId: z.string(),
  createdByUserId: z.string().uuid(),
  title: z.string(),
  description: z.string().optional(),
  startTime: dateSchema,
  endTime: dateSchema,
  assignedUserIds: z.array(z.string().uuid()),
  assignedTeamIds: z.array(z.string().uuid()),
  recurrenceRule: z.string().optional(),
});
export type EventDto = z.infer<typeof eventDtoSchema>;

// DTO for creating a new Event
export const createEventDtoSchema = z.object({
  title: z.string().min(1, "Title is required.").max(200, "Title must be 200 characters or less."),
  description: z.string().max(1000, "Description must be 1000 characters or less.").optional(),
  startTime: dateSchema,
  endTime: dateSchema,
  assignedUserIds: z.array(z.string().uuid()).optional().default([]),
  assignedTeamIds: z.array(z.string().uuid()).optional().default([]),
  recurrenceRule: z.string().optional(),
}).refine((data) => data.endTime > data.startTime, {
  message: "End time must be after start time.",
  path: ["endTime"],
});
export type CreateEventDto = z.infer<typeof createEventDtoSchema>;


// DTO for updating an existing Event
export const updateEventDtoSchema = z.object({
  eventId: z.string().uuid(),
  title: z.string().min(1).max(200).optional(),
  description: z.string().max(1000).optional(),
  startTime: dateSchema.optional(),
  endTime: dateSchema.optional(),
  assignedUserIds: z.array(z.string().uuid()).optional(),
  assignedTeamIds: z.array(z.string().uuid()).optional(),
  recurrenceRule: z.string().optional().nullable(), // Allow clearing the rule
}).refine((data) => {
  if (data.startTime && data.endTime) {
    return data.endTime > data.startTime;
  }
  return true; // Pass validation if one or both are absent
}, {
  message: "End time must be after start time.",
  path: ["endTime"],
});
export type UpdateEventDto = z.infer<typeof updateEventDtoSchema>;