import * as functions from "firebase-functions";
import { IUseCase } from "../ports/IUseCase";
import { IIntegrationRepository } from "../../domain/repositories/IIntegrationRepository";
import { IAttendanceRepository } from "../../domain/repositories/IAttendanceRepository";
import { IGoogleAuthClient } from "../../infrastructure/services/GoogleAuthClient";
import { ISecretManagerClient } from "../../infrastructure/services/SecretManagerClient";
import { IntegrationConfig } from "../../domain/entities/IntegrationConfig";
import { AttendanceRecord, User } from "../../domain/entities/AttendanceRecord";
import { IGoogleSheetsClient } from "../../infrastructure/services/GoogleSheetsClient";

/**
 * @implements {IUseCase<void, void>}
 * @description Orchestrates the scheduled job to export attendance data to Google Sheets
 * for all tenants with an active integration. Implements idempotency, error handling,
 * and state management as required.
 * Supports requirements: REQ-1-008, REQ-1-059, REQ-1-060
 */
export class ExportAttendanceToSheetsUseCase implements IUseCase<void, void> {
    private readonly logger = functions.logger;

    constructor(
        private readonly integrationRepository: IIntegrationRepository,
        private readonly attendanceRepository: IAttendanceRepository,
        private readonly googleAuthClient: IGoogleAuthClient,
        private readonly secretManagerClient: ISecretManagerClient,
        private readonly googleSheetsClient: IGoogleSheetsClient,
    ) { }

    /**
     * Executes the main export logic. Fetches all active integrations and processes them.
     * @returns {Promise<void>} A promise that resolves when the job is complete.
     */
    async execute(): Promise<void> {
        this.logger.info("[ExportAttendanceToSheetsUseCase] Starting scheduled export job.");

        const activeIntegrations = await this.integrationRepository.getActiveIntegrations();

        if (activeIntegrations.length === 0) {
            this.logger.info("[ExportAttendanceToSheetsUseCase] No active integrations found. Job finished.");
            return;
        }

        this.logger.info(`[ExportAttendanceToSheetsUseCase] Found ${activeIntegrations.length} active integrations to process.`);

        const processingPromises = activeIntegrations.map((config) => this.processTenant(config));
        const results = await Promise.allSettled(processingPromises);

        results.forEach((result, index) => {
            if (result.status === "rejected") {
                this.logger.error(
                    `[ExportAttendanceToSheetsUseCase] Unhandled error processing tenant: ${activeIntegrations[index].tenantId}`,
                    { error: result.reason },
                );
            }
        });

        this.logger.info("[ExportAttendanceToSheetsUseCase] Scheduled export job finished.");
    }

    /**
     * Processes a single tenant's data export.
     * This method is designed to be fault-tolerant; an error here will not stop other tenants from processing.
     * @param {IntegrationConfig} config The integration configuration for the tenant.
     * @returns {Promise<void>}
     */
    private async processTenant(config: IntegrationConfig): Promise<void> {
        this.logger.info(`[ExportAttendanceToSheetsUseCase] Processing tenant: ${config.tenantId}`);
        let accessToken = "";
        try {
            // 1. Get credentials
            const refreshToken = await this.secretManagerClient.getSecret(config.secretName);
            const tokenResponse = await this.googleAuthClient.refreshAccessToken(refreshToken);
            accessToken = tokenResponse.access_token;

            // 2. Fetch new data
            const recordsToExport = await this.attendanceRepository.findApprovedRecordsSince(
                config.tenantId,
                config.lastSyncTimestamp,
            );

            if (recordsToExport.length === 0) {
                this.logger.info(`[ExportAttendanceToSheetsUseCase] No new records to export for tenant: ${config.tenantId}`);
                // Optionally update last sync time to now to prevent re-scanning
                await this.integrationRepository.updateLastSyncTimestamp(config.id, new Date());
                return;
            }

            this.logger.info(`[ExportAttendanceToSheetsUseCase] Found ${recordsToExport.length} new records for tenant: ${config.tenantId}`);

            // 3. Transform data
            const dataForSheet = this.transformRecordsForSheet(recordsToExport);

            // 4. Append to Google Sheet
            await this.googleSheetsClient.appendData(config.sheetId, accessToken, dataForSheet);

            // 5. Update state on success
            const latestRecordTimestamp = recordsToExport[recordsToExport.length - 1].checkInTime;
            await this.integrationRepository.updateLastSyncTimestamp(config.id, latestRecordTimestamp);

            this.logger.info(`[ExportAttendanceToSheetsUseCase] Successfully exported ${recordsToExport.length} records for tenant: ${config.tenantId}`);

        } catch (error: any) {
            this.logger.error(`[ExportAttendanceToSheetsUseCase] Failed to process tenant ${config.tenantId}`, { error: error.message, stack: error.stack });

            // 6. Handle errors and update status
            const errorDetails = this.googleSheetsClient.classifyError(error);
            if (errorDetails.isPermanent) {
                await this.integrationRepository.updateStatus(config.id, "error", errorDetails);
                this.logger.warn(`[ExportAttendanceToSheetsUseCase] Set integration status to 'error' for tenant: ${config.tenantId}`, errorDetails);
            }
            // For transient errors, we do nothing, allowing the job to retry on the next run with the old `lastSyncTimestamp`.
        }
    }

    /**
     * Transforms Firestore documents into the 2D array format required by Google Sheets API.
     * @param records An array of AttendanceRecord with enriched User data.
     * @returns A 2D array of strings.
     */
    private transformRecordsForSheet(records: (AttendanceRecord & { user: User })[]): string[][] {
        return records.map(record => [
            record.id ?? "",
            record.user.name ?? "",
            record.user.email ?? "",
            record.checkInTime?.toISOString() ?? "",
            record.checkInGps?.latitude.toString() ?? "",
            record.checkInGps?.longitude.toString() ?? "",
            record.checkOutTime?.toISOString() ?? "",
            record.checkOutGps?.latitude.toString() ?? "",
            record.checkOutGps?.longitude.toString() ?? "",
            record.status ?? "",
            // Assuming a 'notes' field might exist. If not, use an empty string.
            (record as any).notes ?? "",
        ]);
    }
}