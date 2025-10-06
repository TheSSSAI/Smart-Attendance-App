import * as functions from "firebase-functions";
import { IAttendanceRepository } from "../../../domain/attendance/repositories/IAttendanceRepository";
import { IAuditLogRepository } from "../../../domain/attendance/repositories/IAuditLogRepository";
import { IUseCase } from "../../shared/IUseCase";
import { RejectAttendanceDTO, RejectAttendanceActor } from "../dtos/RejectAttendanceDTO";
import { AuditLog } from "../../../domain/attendance/entities/AuditLog";
import { HttpsError } from "firebase-functions/v2/https";
import { AttendanceRecord, AttendanceStatus } from "../../../domain/attendance/entities/AttendanceRecord";

/**
 * @implements {IUseCase<RejectAttendanceDTO, void>}
 * @description Use case for a Supervisor or Admin to reject a pending attendance record.
 * This is a security-critical, transactional operation that requires a reason.
 * Fulfills requirement REQ-1-049.
 */
export class RejectAttendanceUseCase implements IUseCase<RejectAttendanceDTO, void> {

    constructor(
        private readonly attendanceRepository: IAttendanceRepository,
        private readonly auditLogRepository: IAuditLogRepository,
        private readonly logger: functions.Logger,
    ) { }

    /**
     * Executes the attendance rejection logic.
     * @param {RejectAttendanceDTO} dto - The data transfer object containing recordId, reason, and actor info.
     * @throws {HttpsError} Throws an error if validation or execution fails.
     * @returns {Promise<void>}
     */
    async execute(dto: RejectAttendanceDTO): Promise<void> {
        const { recordId, reason, actor } = dto;
        this.logger.info(`[RejectAttendanceUseCase] User ${actor.uid} attempting to reject record ${recordId}.`);

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
            
            const oldStatus = record.status;
            const updatedRecord: Partial<AttendanceRecord> = {
                id: record.id,
                tenantId: record.tenantId,
                status: AttendanceStatus.Rejected,
                rejectionReason: reason,
            };

            const auditLog = new AuditLog({
                tenantId: actor.tenantId,
                actorUserId: actor.uid,
                actionType: 'ATTENDANCE_REJECTION',
                targetEntity: 'attendance',
                targetEntityId: record.id,
                details: {
                    oldStatus: oldStatus,
                    newStatus: AttendanceStatus.Rejected,
                    userId: record.userId,
                    reason: reason,
                }
            });
            
            this.attendanceRepository.update(updatedRecord as AttendanceRecord, transaction);
            this.auditLogRepository.create(auditLog, transaction);

            this.logger.info(`[RejectAttendanceUseCase] Transaction prepared for record ${recordId} rejection.`);
        });

        this.logger.info(`[RejectAttendanceUseCase] Successfully rejected attendance record ${recordId}.`);
    }

    /**
     * Authorizes the actor to perform the action on the record.
     * @param {RejectAttendanceActor} actor - The user performing the action.
     * @param {AttendanceRecord} record - The target attendance record.
     * @throws {HttpsError} Throws 'permission-denied' if not authorized.
     * @private
     */
    private authorize(actor: RejectAttendanceActor, record: AttendanceRecord): void {
        const isSupervisor = actor.role === 'Supervisor' && record.supervisorId === actor.uid;
        const isAdmin = actor.role === 'Admin';

        if (!isSupervisor && !isAdmin) {
            this.logger.warn(`[RejectAttendanceUseCase] Permission denied for user ${actor.uid} on record ${record.id}. User is not the assigned supervisor or an admin.`);
            throw new HttpsError('permission-denied', 'You are not authorized to reject this attendance record.');
        }
    }
    
    /**
     * Validates that the record is in a state that allows rejection.
     * @param {AttendanceRecord} record - The target attendance record.
     * @throws {HttpsError} Throws 'failed-precondition' if the state is invalid.
     * @private
     */
    private validateRecordState(record: AttendanceRecord): void {
        if (record.status !== AttendanceStatus.Pending) {
            this.logger.warn(`[RejectAttendanceUseCase] Attempted to reject record ${record.id} which is not in 'pending' state. Current state: ${record.status}.`);
            throw new HttpsError('failed-precondition', `This attendance record is not in a pending state and cannot be rejected.`);
        }
    }
}