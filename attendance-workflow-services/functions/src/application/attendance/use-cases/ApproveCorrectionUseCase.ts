import * as functions from "firebase-functions";
import { IAttendanceRepository } from "../../../domain/attendance/repositories/IAttendanceRepository";
import { IAuditLogRepository } from "../../../domain/attendance/repositories/IAuditLogRepository";
import { IUseCase } from "../../shared/IUseCase";
import { ApproveCorrectionDTO, ApproveCorrectionActor } from "../dtos/ApproveCorrectionDTO";
import { AuditLog } from "../../../domain/attendance/entities/AuditLog";
import { HttpsError } from "firebase-functions/v2/https";
import { AttendanceRecord, AttendanceStatus } from "../../../domain/attendance/entities/AttendanceRecord";

/**
 * @implements {IUseCase<ApproveCorrectionDTO, void>}
 * @description Use case for a Supervisor or Admin to approve a subordinate's attendance correction request.
 * This is a security-critical, transactional operation that updates the attendance record and logs the change.
 * Fulfills requirement REQ-1-053.
 */
export class ApproveCorrectionUseCase implements IUseCase<ApproveCorrectionDTO, void> {

    constructor(
        private readonly attendanceRepository: IAttendanceRepository,
        private readonly auditLogRepository: IAuditLogRepository,
        private readonly logger: functions.Logger,
    ) { }

    /**
     * Executes the attendance correction approval logic.
     * @param {ApproveCorrectionDTO} dto - The data transfer object containing recordId and actor info.
     * @throws {HttpsError} Throws an error if validation or execution fails.
     * @returns {Promise<void>}
     */
    async execute(dto: ApproveCorrectionDTO): Promise<void> {
        const { recordId, actor } = dto;
        this.logger.info(`[ApproveCorrectionUseCase] User ${actor.uid} attempting to approve correction for record ${recordId}.`);

        await this.attendanceRepository.runInTransaction(async (transaction) => {
            const record = await this.attendanceRepository.findById(actor.tenantId, recordId, transaction);

            if (!record) {
                throw new HttpsError('not-found', `Attendance record with ID ${recordId} not found.`);
            }

            this.authorize(actor, record);
            this.validateRecordState(record);
            
            const originalValues = {
                checkInTime: record.checkInTime.toDate().toISOString(),
                checkOutTime: record.checkOutTime?.toDate().toISOString() || null,
            };
            
            const newValues = {
                checkInTime: record.requestedCheckInTime?.toDate().toISOString() || originalValues.checkInTime,
                checkOutTime: record.requestedCheckOutTime?.toDate().toISOString() || originalValues.checkOutTime,
            };

            const updatedRecord: Partial<AttendanceRecord> = {
                id: record.id,
                tenantId: record.tenantId,
                status: AttendanceStatus.Approved,
                checkInTime: record.requestedCheckInTime || record.checkInTime,
                checkOutTime: record.requestedCheckOutTime || record.checkOutTime,
                flags: [...(record.flags || []).filter(f => f !== 'manually-corrected'), 'manually-corrected'],
                // Clear the temporary correction fields
                requestedCheckInTime: null,
                requestedCheckOutTime: null,
                correctionReason: null,
                statusBeforeCorrection: null,
            };

            const auditLog = new AuditLog({
                tenantId: actor.tenantId,
                actorUserId: actor.uid,
                actionType: 'CORRECTION_APPROVAL',
                targetEntity: 'attendance',
                targetEntityId: record.id,
                details: {
                    requesterUserId: record.userId,
                    approverUserId: actor.uid,
                    justification: record.correctionReason || 'No justification provided.',
                    oldValue: originalValues,
                    newValue: newValues,
                }
            });

            this.attendanceRepository.update(updatedRecord as AttendanceRecord, transaction);
            this.auditLogRepository.create(auditLog, transaction);

            this.logger.info(`[ApproveCorrectionUseCase] Transaction prepared for correction approval of record ${recordId}.`);
        });

        this.logger.info(`[ApproveCorrectionUseCase] Successfully approved correction for attendance record ${recordId}.`);
    }

    /**
     * Authorizes the actor to perform the action on the record.
     * @param {ApproveCorrectionActor} actor - The user performing the action.
     * @param {AttendanceRecord} record - The target attendance record.
     * @throws {HttpsError} Throws 'permission-denied' if not authorized.
     * @private
     */
    private authorize(actor: ApproveCorrectionActor, record: AttendanceRecord): void {
        const isSupervisor = actor.role === 'Supervisor' && record.supervisorId === actor.uid;
        const isAdmin = actor.role === 'Admin';

        if (!isSupervisor && !isAdmin) {
            this.logger.warn(`[ApproveCorrectionUseCase] Permission denied for user ${actor.uid} on record ${record.id}.`);
            throw new HttpsError('permission-denied', 'You are not authorized to approve this correction request.');
        }
    }
    
    /**
     * Validates that the record is in a state that allows correction approval.
     * @param {AttendanceRecord} record - The target attendance record.
     * @throws {HttpsError} Throws 'failed-precondition' if the state is invalid.
     * @private
     */
    private validateRecordState(record: AttendanceRecord): void {
        if (record.status !== AttendanceStatus.CorrectionPending) {
            this.logger.warn(`[ApproveCorrectionUseCase] Attempted to approve correction for record ${record.id} which is not in 'correction_pending' state. Current state: ${record.status}.`);
            throw new HttpsError('failed-precondition', `This correction request is not in a pending state.`);
        }
        if (!record.requestedCheckInTime && !record.requestedCheckOutTime) {
            this.logger.error(`[ApproveCorrectionUseCase] Record ${record.id} is in 'correction_pending' state but has no requested times.`);
            throw new HttpsError('internal', 'Record is in an inconsistent state. Cannot approve correction.');
        }
    }
}