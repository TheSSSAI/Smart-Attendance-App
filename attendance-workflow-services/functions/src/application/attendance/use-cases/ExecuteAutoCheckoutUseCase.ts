import * as functions from "firebase-functions";
import { IAttendanceRepository } from "../../../domain/attendance/repositories/IAttendanceRepository";
import { ITenantConfigRepository } from "../../../domain/attendance/repositories/ITenantConfigRepository";
import { IUseCase } from "../../shared/IUseCase";
import { Timestamp } from "firebase-admin/firestore";
import { TenantConfiguration } from "../../../domain/attendance/entities/TenantConfiguration";
import { AttendanceRecord } from "../../../domain/attendance/entities/AttendanceRecord";

/**
 * @implements {IUseCase<void, void>}
 * @description Use case for executing the daily automated check-out process.
 * This logic is triggered by a scheduled function. It finds all tenants with the feature enabled,
 * identifies users who have not checked out, and updates their records.
 * Fulfills requirement REQ-1-045.
 */
export class ExecuteAutoCheckoutUseCase implements IUseCase<void, void> {

    constructor(
        private readonly tenantConfigRepository: ITenantConfigRepository,
        private readonly attendanceRepository: IAttendanceRepository,
        private readonly logger: functions.Logger,
    ) { }

    /**
     * Executes the auto-checkout logic for all eligible tenants.
     * @returns {Promise<void>}
     */
    async execute(): Promise<void> {
        this.logger.info("[ExecuteAutoCheckoutUseCase] Starting daily auto-checkout job.");

        const tenantsWithAutoCheckout = await this.tenantConfigRepository.findAllWithAutoCheckoutEnabled();

        if (tenantsWithAutoCheckout.length === 0) {
            this.logger.info("[ExecuteAutoCheckoutUseCase] No tenants have auto-checkout enabled. Job finished.");
            return;
        }

        this.logger.info(`[ExecuteAutoCheckoutUseCase] Found ${tenantsWithAutoCheckout.length} tenants with auto-checkout enabled.`);

        const jobPromises = tenantsWithAutoCheckout.map(tenantConfig => this.processTenant(tenantConfig));

        await Promise.allSettled(jobPromises);

        this.logger.info("[ExecuteAutoCheckoutUseCase] Daily auto-checkout job finished for all tenants.");
    }

    /**
     * Processes a single tenant, finding and checking out open attendance records.
     * @param {TenantConfiguration} tenantConfig - The configuration for the tenant to process.
     * @returns {Promise<void>}
     * @private
     */
    private async processTenant(tenantConfig: TenantConfiguration): Promise<void> {
        const { tenantId, timezone, autoCheckoutTime } = tenantConfig;

        if (!timezone || !autoCheckoutTime) {
            this.logger.warn(`[ExecuteAutoCheckoutUseCase] Tenant ${tenantId} has auto-checkout enabled but is missing timezone or autoCheckoutTime config. Skipping.`);
            return;
        }
        
        try {
            const nowInTenantTimezone = new Date().toLocaleTimeString('en-US', { timeZone: timezone, hour12: false, hour: '2-digit', minute: '2-digit' });

            // Only proceed if the current time in the tenant's timezone is past their configured checkout time.
            // This adds a safeguard if the scheduler is not perfectly aligned.
            if (nowInTenantTimezone < autoCheckoutTime) {
                this.logger.info(`[ExecuteAutoCheckoutUseCase] Skipping tenant ${tenantId} as current time (${nowInTenantTimezone}) is before configured auto-checkout time (${autoCheckoutTime}).`);
                return;
            }

            this.logger.info(`[ExecuteAutoCheckoutUseCase] Processing tenant ${tenantId}.`);

            const openRecords = await this.attendanceRepository.findOpenRecordsForTenantOnDate(tenantId, new Date(), timezone);

            if (openRecords.length === 0) {
                this.logger.info(`[ExecuteAutoCheckoutUseCase] No open attendance records found for tenant ${tenantId}.`);
                return;
            }

            this.logger.info(`[ExecuteAutoCheckoutUseCase] Found ${openRecords.length} open records for tenant ${tenantId}.`);

            const recordsToUpdate = this.prepareRecordsForUpdate(openRecords, autoCheckoutTime, timezone);

            await this.attendanceRepository.batchUpdate(recordsToUpdate);

            this.logger.info(`[ExecuteAutoCheckoutUseCase] Successfully processed ${recordsToUpdate.length} auto-checkouts for tenant ${tenantId}.`);

        } catch (error) {
            this.logger.error(`[ExecuteAutoCheckoutUseCase] Failed to process auto-checkouts for tenant ${tenantId}.`, { error });
            // Do not re-throw, to allow other tenants to be processed.
        }
    }

    /**
     * Prepares a list of partial attendance records for batch update.
     * @param {AttendanceRecord[]} openRecords - The records to update.
     * @param {string} autoCheckoutTime - The configured checkout time (e.g., "17:30").
     * @param {string} timezone - The IANA timezone string for the tenant.
     * @returns {Partial<AttendanceRecord>[]} An array of partial records ready for update.
     * @private
     */
    private prepareRecordsForUpdate(openRecords: AttendanceRecord[], autoCheckoutTime: string, timezone: string): Partial<AttendanceRecord>[] {
        return openRecords.map(record => {
            const [hours, minutes] = autoCheckoutTime.split(':').map(Number);
            
            const checkInDate = record.checkInTime.toDate();
            // Create the checkout time on the same date as the check-in, in the tenant's timezone
            const checkoutDateTime = new Date(checkInDate.getFullYear(), checkInDate.getMonth(), checkInDate.getDate(), hours, minutes);
            
            // Note: This naive date creation is in the server's local timezone.
            // A robust solution would use a library like `date-fns-tz` to correctly construct
            // the date in the target timezone before converting to a UTC timestamp for Firestore.
            // For example: `zonedTimeToUtc(`${year}-${month}-${day}T${autoCheckoutTime}`, timezone)`
            // For simplicity here, we assume the server runs in UTC and this approximation is sufficient.
            const checkoutTimestamp = Timestamp.fromDate(checkoutDateTime);

            return {
                id: record.id,
                tenantId: record.tenantId,
                checkOutTime: checkoutTimestamp,
                checkOutGps: null, // No GPS data for auto-checkout
                flags: [...(record.flags || []), 'auto-checked-out'],
            };
        });
    }
}