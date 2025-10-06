import * as functions from "firebase-functions";
import { IAttendanceRepository } from "../../../domain/attendance/repositories/IAttendanceRepository";
import { AttendanceRecord } from "../../../domain/attendance/entities/AttendanceRecord";
import { IUseCase } from "../../shared/IUseCase";
import { serverTimestamp } from "firebase/firestore";

const CLOCK_DISCREPANCY_THRESHOLD_MINUTES = 5;

export interface ValidateClockDiscrepancyInput {
    before: AttendanceRecord | null;
    after: AttendanceRecord;
}

/**
 * @implements {IUseCase<ValidateClockDiscrepancyInput, void>}
 * @description Use case for validating clock discrepancy on an attendance record.
 * This is triggered on write events to the attendance collection. It compares the client-provided
 * timestamp with the server-generated timestamp to detect potential time manipulation.
 * Fulfills requirement REQ-1-044.
 */
export class ValidateClockDiscrepancyUseCase implements IUseCase<ValidateClockDiscrepancyInput, void> {
    constructor(
        private readonly attendanceRepository: IAttendanceRepository,
        private readonly logger: functions.Logger,
    ) { }

    /**
     * Executes the clock discrepancy validation logic.
     * @param {ValidateClockDiscrepancyInput} input - The before and after snapshots of the attendance record.
     * @returns {Promise<void>}
     */
    async execute(input: ValidateClockDiscrepancyInput): Promise<void> {
        const { before, after } = input;
        
        // This function is triggered on write, but the server timestamp is populated by Firestore itself.
        // The record passed to `after` might not have the serverTimestamp yet.
        // A common pattern is to let this trigger write a server timestamp, and have a second trigger
        // or a check on the next update.
        // However, a simpler, more direct approach is to check if we can add the server timestamp here.
        // We will assume the trigger context provides a server timestamp, or we add it ourselves.
        // For this implementation, we will compare the most recent client timestamp against the server-written time.
        
        const isCreate = !before;
        const clientTimestamp = after.checkOutTime ?? after.checkInTime;

        // If there's no client timestamp, we can't compare. This happens on check-in creation before client time is set.
        if (!clientTimestamp) {
            this.logger.info(`[ValidateClockDiscrepancy] No client timestamp available for record ${after.id}. Skipping.`);
            return;
        }

        // The after.serverTimestamp might be populated by the Firestore trigger itself.
        // We ensure we have a valid server timestamp to compare against.
        // In a real onWrite trigger, the serverTimestamp is part of the commit time, available in context.
        // Let's assume we have `after.updatedAt` which is populated by `FieldValue.serverTimestamp()` on every write.
        if (!after.updatedAt) {
            this.logger.warn(`[ValidateClockDiscrepancy] Server timestamp (updatedAt) not found for record ${after.id}. Cannot perform validation.`);
            return;
        }

        const clientTimeMs = clientTimestamp.toMillis();
        const serverTimeMs = after.updatedAt.toMillis();
        const differenceMinutes = Math.abs(serverTimeMs - clientTimeMs) / (1000 * 60);

        const hasDiscrepancy = differenceMinutes > CLOCK_DISCREPANCY_THRESHOLD_MINUTES;
        const alreadyFlagged = after.flags?.includes('clock_discrepancy') ?? false;

        if (hasDiscrepancy && !alreadyFlagged) {
            this.logger.warn(`[ValidateClockDiscrepancy] Clock discrepancy detected for record ${after.id}. Difference: ${differenceMinutes.toFixed(2)} minutes.`);
            
            const updatedFlags = [...(after.flags || []), 'clock_discrepancy'];
            const recordToUpdate: Partial<AttendanceRecord> = {
                id: after.id,
                tenantId: after.tenantId,
                flags: updatedFlags
            };

            try {
                await this.attendanceRepository.update(recordToUpdate as AttendanceRecord);
                this.logger.info(`[ValidateClockDiscrepancy] Successfully flagged record ${after.id} for clock discrepancy.`);
            } catch (error) {
                this.logger.error(`[ValidateClockDiscrepancy] Failed to flag record ${after.id} for clock discrepancy.`, { error });
                // We don't re-throw here to prevent the function from retrying indefinitely on a persistent error.
            }
        } else if (!hasDiscrepancy && isCreate) {
             this.logger.info(`[ValidateClockDiscrepancy] No clock discrepancy for record ${after.id}. Difference: ${differenceMinutes.toFixed(2)} minutes.`);
        }
    }
}