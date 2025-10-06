import * as functions from "firebase-functions";
import { createContainer } from "../../config/di";
import { env } from "../../config/env";

/**
 * A scheduled Cloud Function that runs daily to export approved attendance
 * records to Google Sheets for all tenants with an active integration.
 *
 * This function is the primary entry point for the batch job defined in
 * REQ-1-008 and REQ-1-059. It is designed to be idempotent and resilient,
 * handling failures for individual tenants without halting the entire job.
 */
export const exportAttendanceToSheets = functions
  .region(env.firebase.region)
  .runWith({
    memory: "512MB",
    timeoutSeconds: 540, // 9 minutes, max for Cloud Functions v1 compatibility
    secrets: [env.secrets.googleClientSecretName],
  })
  .pubsub.schedule("every day 02:00") // Runs at 2 AM daily.
  .timeZone("America/New_York") // Timezone for the scheduler itself. Logic inside handles per-tenant timezones.
  .onRun(async (context) => {
    functions.logger.info(
      `Scheduled job 'exportAttendanceToSheets' started at ${context.timestamp}`,
    );

    try {
      // 1. Dependency Resolution and Use Case Execution
      const container = createContainer();
      const exportUseCase = container.getExportAttendanceToSheetsUseCase();

      await exportUseCase.execute();

      functions.logger.info(
        "Scheduled job 'exportAttendanceToSheets' completed successfully.",
      );
    } catch (error) {
      // 2. Top-Level Error Handling
      // This catch block is for catastrophic failures of the entire job,
      // not for individual tenant processing errors, which are handled
      // within the use case.
      functions.logger.error(
        "Catastrophic failure in 'exportAttendanceToSheets' scheduled job:",
        error,
      );
      // Depending on monitoring setup, this log could trigger a high-priority alert (REQ-1-076).
      // No re-throw is necessary as the function invocation is complete.
    }
  });

// Example of another scheduled function for data aggregation, if needed.
// This supports the potential responsibility mentioned in REQ-1-057.
export const aggregateDailyAttendance = functions
  .region(env.firebase.region)
  .pubsub.schedule("every day 01:00")
  .timeZone("America/New_York")
  .onRun(async (context) => {
    functions.logger.info(
      `Scheduled job 'aggregateDailyAttendance' started at ${context.timestamp}`,
    );
    // In a real implementation, this would call a use case similar to the export function.
    // const container = createContainer();
    // const aggregationUseCase = container.getAggregationUseCase();
    // await aggregationUseCase.execute();
    functions.logger.info(
      "Scheduled job 'aggregateDailyAttendance' completed.",
    );
  });