import { z } from 'zod';
import { firestoreTimestampSchema, tenantIdSchema } from '../shared';

/**
 * @description Defines the possible statuses for the Google Sheets integration.
 * - 'active': The integration is configured and running.
 * - 'error': The integration has encountered a persistent error (e.g., permission revoked).
 * - 'syncing': A data sync is currently in progress.
 * @see US-067 - Admin is alerted to a Google Sheets sync failure.
 * @see US-068 - Admin re-authorizes Google Sheets sync after a failure.
 */
export const integrationStatusSchema = z.enum(['active', 'error', 'syncing']);
export type IntegrationStatus = z.infer<typeof integrationStatusSchema>;

/**
 * @description Schema for metadata related to the Google Sheets integration for a tenant.
 * Corresponds to the '/tenants/{tenantId}/linkedSheets/{docId}' document.
 * @see REQ-1-008 - Configure automated export of attendance data to Google Sheet.
 * @see REQ-1-073 - Specifies this as the '/linkedSheets' sub-collection.
 */
export const googleSheetIntegrationSchema = z.object({
  tenantId: tenantIdSchema,
  googleSheetId: z.string().describe('The ID of the target Google Sheet.'),
  status: integrationStatusSchema.describe(
    'The current status of the integration.'
  ),
  lastSyncTimestamp: firestoreTimestampSchema
    .optional()
    .nullable()
    .describe('Timestamp of the last successful data export.'),
  errorMessage: z
    .string()
    .optional()
    .nullable()
    .describe('A user-friendly error message if the status is "error".'),
  errorDetails: z
    .record(z.unknown())
    .optional()
    .nullable()
    .describe('Technical details of the last error for debugging.'),
  lastExportedRecordTimestamp: firestoreTimestampSchema
    .optional()
    .nullable()
    .describe(
      'The timestamp of the most recent attendance record that was exported to prevent duplicates.'
    ),
});

export type GoogleSheetIntegration = z.infer<typeof googleSheetIntegrationSchema>;