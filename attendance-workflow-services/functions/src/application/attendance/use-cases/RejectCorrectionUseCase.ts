import * as functions from "firebase-functions";
import { IAttendanceRepository } from "../../../domain/attendance/repositories/IAttendanceRepository";
import { IAuditLogRepository } from "../../../domain/attendance/repositories/IAuditLogRepository";
import { IUseCase } from "../../shared/IUseCase";
import { RejectCorrectionDTO, RejectCorrectionActor } from "../dtos/RejectCorrectionDTO";
import { AuditLog } from "../../../domain/attendance/entities/AuditLog";
import { HttpsError } from "firebase-functions/v2/https";
import { AttendanceRecord, AttendanceStatus } from "../../../domain/attendance/entities/AttendanceRecord";

/**
 * @implements {IUseCase<RejectCorrectionDTO, void>}
 * @description Use case for a Supervisor or Admin to reject a subordinate's attendance correction request.
 * This is a security-critical, transactional operation that reverts the record's state and logs the rejection.
 * Fulfills implied requirement from US-048.
 */
export class RejectCorrectionUseCase implements IUseCase<RejectCorrectionDTO, void> {

    constructor(
        private readonly attendanceRepository: IAttendanceRepository,
        private readonly auditLogRepository: IAuditLogRepository,
        private readonly logger: functions.Logger,
    ) { }

    /**
     * Executes the attendance correction rejection logic.
     * @param {RejectCorrectionDTO} dto - The data transfer object containing recordId, reason, and actor info.
     * @throws {HttpsError} Throws an error if validation or execution fails.
     * @returns {Promise<void>}
     */
    async execute(dto: RejectCorrectionDTO): Promise<void> {
        const { recordId, reason, actor } = dto;
        this.logger.info(`[RejectCorrectionUseCase] User ${actor.uid} attempting to reject correction for record ${recordId}.`);

        if (!reason || reason.trim().length < 10) {
            throw new HttpsError('invalid-argument', 'A meaningful reason of at least 10 characters is required for rejection.');
        }

        await this.attendanceRepository.runInTransaction(async (transaction) => {
            const record = await this.attendanceRepository.findById(actor.tenantId, recordId, transaction);

            if (!record) {
                throw new HttpsError('not-found', `Attendance record with ID ${recordId} not found.`);
            }

            this.authorize(actor, record);
            this.validateRecordState(record);
            
            const revertedStatus = record.statusBeforeCorrection || AttendanceStatus.Rejected;

            const updatedRecord: Partial<AttendanceRecord> = {
                id: record.id,
                tenantId: record.tenantId,
                status: revertedStatus,
                rejectionReason: reason, // Store the reason for this specific rejection
                // Clear the temporary correction fields
                requestedCheckInTime: null,
                requestedCheckOutTime: null,
                correctionReason: null,
                statusBeforeCorrection: null,
            };

            const auditLog = new AuditLog({
                tenantId: actor.tenantId,
                actorUserId: actor.uid,
                actionType: 'CORRECTION_REJECTION',
                targetEntity: 'attendance',
                targetEntityId: record.id,
                details: {
                    requesterUserId: record.userId,
                    rejecterUserId: actor.uid,
                    justification: record.correctionReason || 'N/A',
                    rejectionReason: reason,
                }
            });

            this.attendanceRepository.update(updatedRecord as AttendanceRecord, transaction);
            this.auditLogRepository.create(auditLog, transaction);

            this.logger.info(`[RejectCorrectionUseCase] Transaction prepared for correction rejection of record ${recordId}.`);
        });

        this.logger.info(`[RejectCorrectionUseCase] Successfully rejected correction for attendance record ${recordId}.`);
    }

    /**
     * Authorizes the actor to perform the action on the record.
     * @param {RejectCorrectionActor} actor - The user performing the action.
     * @param {AttendanceRecord} record - The target attendance record.
     * @throws {HttpsError} Throws 'permission-denied' if not authorized.
     * @private
     */
    private authorize(actor: RejectCorrectionActor, record: AttendanceRecord): void {
        const isSupervisor = actor.role === 'Supervisor' && record.supervisorId === actor.uid;
        const isAdmin = actor.role === 'Admin';

        if (!isSupervisor && !isAdmin) {
            this.logger.warn(`[RejectCorrectionUseCase] Permission denied for user ${actor.uid} on record ${record.id}.`);
            throw new HttpsError('permission-denied', 'You are not authorized to reject this correction request.');
        }
    }
    
    /**
     * Validates that the record is in a state that allows correction rejection.
     * @param {AttendanceRecord} record - The target attendance record.
     * @throws {HttpsError} Throws 'failed-precondition' if the state is invalid.
     * @private
     */
    private validateRecordState(record: AttendanceRecord): void {
        if (record.status !== AttendanceStatus.CorrectionPending) {
            this.logger.warn(`[RejectCorrectionUseCase] Attempted to reject correction for record ${record.id} which is not in 'correction_pending' state. Current state: ${record.status}.`);
            throw new HttpsError('failed-precondition', `This correction request is not in a pending state.`);
        }
    }
}