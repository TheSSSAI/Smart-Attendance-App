import * as functions from "firebase-functions";
import { IAttendanceRepository } from "../../../domain/attendance/repositories/IAttendanceRepository";
import { IAuditLogRepository } from "../../../domain/attendance/repositories/IAuditLogRepository";
import { IUseCase } from "../../shared/IUseCase";
import { ApproveAttendanceDTO, ApproveAttendanceActor } from "../dtos/ApproveAttendanceDTO";
import { AuditLog } from "../../../domain/attendance/entities/AuditLog";
import { HttpsError } from "firebase-functions/v2/https";
import { AttendanceRecord, AttendanceStatus } from "../../../domain/attendance/entities/AttendanceRecord";

/**
 * @implements {IUseCase<ApproveAttendanceDTO, void>}
 * @description Use case for a Supervisor or Admin to approve a pending attendance record.
 * This is a security-critical, transactional operation.
 * Fulfills part of requirement REQ-1-005.
 */
export class ApproveAttendanceUseCase implements IUseCase<ApproveAttendanceDTO, void> {

    constructor(
        private readonly attendanceRepository: IAttendanceRepository,
        private readonly auditLogRepository: IAuditLogRepository,
        private readonly logger: functions.Logger,
    ) { }

    /**
     * Executes the attendance approval logic.
     * @param {ApproveAttendanceDTO} dto - The data transfer object containing recordId and actor info.
     * @throws {HttpsError} Throws an error if validation or execution fails.
     * @returns {Promise<void>}
     */
    async execute(dto: ApproveAttendanceDTO): Promise<void> {
        const { recordId, actor } = dto;
        this.logger.info(`[ApproveAttendanceUseCase] User ${actor.uid} attempting to approve record ${recordId}.`);

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
                status: AttendanceStatus.Approved,
            };

            const auditLog = new AuditLog({
                tenantId: actor.tenantId,
                actorUserId: actor.uid,
                actionType: 'ATTENDANCE_APPROVAL',
                targetEntity: 'attendance',
                targetEntityId: record.id,
                details: {
                    oldStatus: oldStatus,
                    newStatus: AttendanceStatus.Approved,
                    userId: record.userId,
                }
            });

            this.attendanceRepository.update(updatedRecord as AttendanceRecord, transaction);
            this.auditLogRepository.create(auditLog, transaction);

            this.logger.info(`[ApproveAttendanceUseCase] Transaction prepared for record ${recordId} approval.`);
        });

        this.logger.info(`[ApproveAttendanceUseCase] Successfully approved attendance record ${recordId}.`);
    }

    /**
     * Authorizes the actor to perform the action on the record.
     * @param {ApproveAttendanceActor} actor - The user performing the action.
     * @param {AttendanceRecord} record - The target attendance record.
     * @throws {HttpsError} Throws 'permission-denied' if not authorized.
     * @private
     */
    private authorize(actor: ApproveAttendanceActor, record: AttendanceRecord): void {
        const isSupervisor = actor.role === 'Supervisor' && record.supervisorId === actor.uid;
        const isAdmin = actor.role === 'Admin';

        if (!isSupervisor && !isAdmin) {
            this.logger.warn(`[ApproveAttendanceUseCase] Permission denied for user ${actor.uid} on record ${record.id}. User is not the assigned supervisor or an admin.`);
            throw new HttpsError('permission-denied', 'You are not authorized to approve this attendance record.');
        }
    }
    
    /**
     * Validates that the record is in a state that allows approval.
     * @param {AttendanceRecord} record - The target attendance record.
     * @throws {HttpsError} Throws 'failed-precondition' if the state is invalid.
     * @private
     */
    private validateRecordState(record: AttendanceRecord): void {
        if (record.status !== AttendanceStatus.Pending) {
            this.logger.warn(`[ApproveAttendanceUseCase] Attempted to approve record ${record.id} which is not in 'pending' state. Current state: ${record.status}.`);
            throw new HttpsError('failed-precondition', `This attendance record is not in a pending state and cannot be approved.`);
        }
    }
}