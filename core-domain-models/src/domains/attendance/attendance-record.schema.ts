import { z } from 'zod';
import {
  firestoreTimestampSchema,
  geoPointSchema,
  idSchema,
  tenantIdSchema,
} from '../shared';

/**
 * @description Defines the possible statuses for an attendance record throughout its lifecycle.
 * @see REQ-1-005 - 'pending', 'approved', 'rejected'.
 * @see REQ-1-052 - 'correction_pending'.
 */
export const attendanceStatusSchema = z.enum([
  'pending',
  'approved',
  'rejected',
  'correction_pending',
]);
export type AttendanceStatus = z.infer<typeof attendanceStatusSchema>;

/**
 * @description Defines flags that can be applied to an attendance record to indicate exceptions.
 * @see REQ-1-009 - 'isOfflineEntry'.
 * @see REQ-1-044 - 'clock_discrepancy'.
 * @see REQ-1-045 - 'auto-checked-out'.
 * @see REQ-1-053 - 'manually-corrected'.
 */
export const attendanceFlagSchema = z.enum([
  'isOfflineEntry',
  'clock_discrepancy',
  'auto-checked-out',
  'manually-corrected',
]);
export type AttendanceFlag = z.infer<typeof attendanceFlagSchema>;

/**
 * @description Schema for the correction request data embedded in an attendance record.
 * @see US-045 - Subordinate requests a correction.
 */
const correctionSchema = z.object({
  requestedCheckInTime: firestoreTimestampSchema.optional().nullable(),
  requestedCheckOutTime: firestoreTimestampSchema.optional().nullable(),
  justification: z.string().min(20, 'Justification must be at least 20 characters.'),
  statusBeforeCorrection: attendanceStatusSchema,
});

/**
 * @description Schema for the AttendanceRecord entity. This is the core data entity for the application.
 * Corresponds to the '/tenants/{tenantId}/attendance/{attendanceRecordId}' collection.
 * @see REQ-1-004 - Captures check-in/out actions with GPS.
 * @see REQ-1-073 - Specifies the Firestore data model structure.
 */
export const attendanceRecordSchema = z.object({
  attendanceRecordId: idSchema,
  tenantId: tenantIdSchema,
  userId: idSchema,
  supervisorId: idSchema.describe('Denormalized ID of the user_s supervisor at the time of creation.'),
  
  checkInTime: firestoreTimestampSchema,
  checkInGps: geoPointSchema,
  
  checkOutTime: firestoreTimestampSchema.optional().nullable(),
  checkOutGps: geoPointSchema.optional().nullable(),
  
  status: attendanceStatusSchema.default('pending'),
  
  eventId: idSchema
    .optional()
    .nullable()
    .describe('ID of an event this attendance is linked to (US-056).'),

  flags: z.array(attendanceFlagSchema).default([]).describe('Array of flags indicating exceptions.'),

  rejectionReason: z
    .string()
    .optional()
    .nullable()
    .describe('Reason provided by a supervisor for rejecting a record (US-040).'),
  
  correction: correctionSchema
    .optional()
    .nullable()
    .describe('Holds data for a pending correction request.'),
  
  serverTimestamp: firestoreTimestampSchema.describe('Server-side timestamp for clock discrepancy checks.'),
});

export type AttendanceRecord = z.infer<typeof attendanceRecordSchema>;