import * as functions from "firebase-functions";
import { IAttendanceRepository } from "../../../domain/attendance/repositories/IAttendanceRepository";
import { ITenantConfigRepository } from "../../../domain/attendance/repositories/ITenantConfigRepository";
import { IAuditLogRepository } from "../../../domain/attendance/repositories/IAuditLogRepository";
import { IUserRepository } from "../../../domain/user/repositories/IUserRepository";
import { IUseCase } from "../../shared/IUseCase";
import { TenantConfiguration } from "../../../domain/attendance/entities/TenantConfiguration";
import { AttendanceRecord, AttendanceStatus } from "../../../domain/attendance/entities/AttendanceRecord";
import { AuditLog } from "../../../domain/attendance/entities/AuditLog";
import { User } from "../../../domain/user/entities/User";

const MAX_ESCALATION_DEPTH = 10; // Safety break to prevent infinite loops

/**
 * @implements {IUseCase<void, void>}
 * @description Use case for executing the daily approval escalation process.
 * This logic is triggered by a scheduled function. It finds overdue pending records
 * and reassigns them to the next supervisor in the hierarchy.
 * Fulfills requirement REQ-1-051.
 */
export class ExecuteApprovalEscalationUseCase implements IUseCase<void, void> {
    constructor(
        private readonly tenantConfigRepository: ITenantConfigRepository,
        private readonly attendanceRepository: IAttendanceRepository,
        private readonly userRepository: IUserRepository,
        private readonly auditLogRepository: IAuditLogRepository,
        private readonly logger: functions.Logger,
    ) { }

    /**
     * Executes the escalation logic for all eligible tenants.
     * @returns {Promise<void>}
     */
    async execute(): Promise<void> {
        this.logger.info("[ExecuteApprovalEscalationUseCase] Starting daily approval escalation job.");

        const tenantsWithEscalation = await this.tenantConfigRepository.findAllWithEscalationEnabled();

        if (tenantsWithEscalation.length === 0) {
            this.logger.info("[ExecuteApprovalEscalationUseCase] No tenants have escalation enabled. Job finished.");
            return;
        }

        this.logger.info(`[ExecuteApprovalEscalationUseCase] Found ${tenantsWithEscalation.length} tenants with escalation enabled.`);
        
        const jobPromises = tenantsWithEscalation.map(tenantConfig => this.processTenant(tenantConfig));
        await Promise.allSettled(jobPromises);

        this.logger.info("[ExecuteApprovalEscalationUseCase] Daily approval escalation job finished for all tenants.");
    }

    /**
     * Processes a single tenant, finding and escalating overdue records.
     * @param {TenantConfiguration} tenantConfig - The configuration for the tenant.
     * @private
     */
    private async processTenant(tenantConfig: TenantConfiguration): Promise<void> {
        const { tenantId, approvalEscalationDays } = tenantConfig;

        if (!approvalEscalationDays || approvalEscalationDays <= 0) {
            this.logger.warn(`[ExecuteApprovalEscalationUseCase] Tenant ${tenantId} has invalid escalation config. Skipping.`);
            return;
        }

        try {
            this.logger.info(`[ExecuteApprovalEscalationUseCase] Processing escalations for tenant ${tenantId}.`);

            const olderThanDate = new Date();
            olderThanDate.setDate(olderThanDate.getDate() - approvalEscalationDays);

            const overdueRecords = await this.attendanceRepository.findOverduePendingRecordsForTenant(tenantId, olderThanDate);

            if (overdueRecords.length === 0) {
                this.logger.info(`[ExecuteApprovalEscalationUseCase] No overdue records found for tenant ${tenantId}.`);
                return;
            }

            this.logger.info(`[ExecuteApprovalEscalationUseCase] Found ${overdueRecords.length} overdue records for tenant ${tenantId}.`);
            
            for (const record of overdueRecords) {
                await this.escalateRecord(record);
            }
        } catch (error) {
            this.logger.error(`[ExecuteApprovalEscalationUseCase] Failed to process escalations for tenant ${tenantId}.`, { error });
        }
    }

    /**
     * Finds the next supervisor and updates the record if found.
     * @param {AttendanceRecord} record - The overdue attendance record.
     * @private
     */
    private async escalateRecord(record: AttendanceRecord): Promise<void> {
        try {
            const nextSupervisor = await this.findNextActiveSupervisor(record.tenantId, record.supervisorId);

            if (!nextSupervisor) {
                this.logger.warn(`[ExecuteApprovalEscalationUseCase] Could not find an active supervisor to escalate record ${record.id} to. Flagging.`);
                const updatedRecord: Partial<AttendanceRecord> = {
                    id: record.id,
                    tenantId: record.tenantId,
                    flags: [...(record.flags || []), 'escalation_failed_no_supervisor'],
                };
                await this.attendanceRepository.update(updatedRecord as AttendanceRecord);
                return;
            }
            
            if (nextSupervisor.id === record.supervisorId) {
                this.logger.warn(`[ExecuteApprovalEscalationUseCase] Escalation for record ${record.id} resulted in the same supervisor. This should not happen. Skipping.`);
                return;
            }

            this.logger.info(`[ExecuteApprovalEscalationUseCase] Escalating record ${record.id} from ${record.supervisorId} to ${nextSupervisor.id}.`);
            
            await this.attendanceRepository.runInTransaction(async (transaction) => {
                const freshRecord = await this.attendanceRepository.findById(record.tenantId, record.id, transaction);
                // Race condition check: only escalate if still pending.
                if (freshRecord?.status !== AttendanceStatus.Pending && freshRecord?.status !== AttendanceStatus.CorrectionPending) {
                    this.logger.info(`[ExecuteApprovalEscalationUseCase] Record ${record.id} was actioned before escalation. Skipping.`);
                    return;
                }

                const updatedRecord: Partial<AttendanceRecord> = {
                    id: record.id,
                    tenantId: record.tenantId,
                    supervisorId: nextSupervisor.id,
                };

                const auditLog = new AuditLog({
                    tenantId: record.tenantId,
                    actorUserId: 'SYSTEM', // System-initiated action
                    actionType: 'APPROVAL_ESCALATION',
                    targetEntity: 'attendance',
                    targetEntityId: record.id,
                    details: {
                        originalSupervisorId: record.supervisorId,
                        newSupervisorId: nextSupervisor.id,
                        userId: record.userId,
                    }
                });

                this.attendanceRepository.update(updatedRecord as AttendanceRecord, transaction);
                this.auditLogRepository.create(auditLog, transaction);
            });
            this.logger.info(`[ExecuteApprovalEscalationUseCase] Successfully escalated record ${record.id}.`);
        } catch (error) {
            this.logger.error(`[ExecuteApprovalEscalationUseCase] Failed to escalate record ${record.id}.`, { error });
        }
    }

    /**
     * Traverses the user hierarchy to find the next active supervisor.
     * @param {string} tenantId
     * @param {string | null} currentSupervisorId
     * @returns {Promise<User | null>} The next active supervisor or null if none is found.
     * @private
     */
    private async findNextActiveSupervisor(tenantId: string, currentSupervisorId: string | null): Promise<User | null> {
        if (!currentSupervisorId) {
            return null;
        }

        let currentUser = await this.userRepository.findById(tenantId, currentSupervisorId);
        let depth = 0;

        while (currentUser && depth < MAX_ESCALATION_DEPTH) {
            const nextSupervisorId = currentUser.supervisorId;
            if (!nextSupervisorId) {
                this.logger.info(`[ExecuteApprovalEscalationUseCase] Reached top of hierarchy for user ${currentUser.id}. No further supervisor to escalate to.`);
                return null; // Top of the hierarchy
            }
            
            const nextSupervisor = await this.userRepository.findById(tenantId, nextSupervisorId);
            if (nextSupervisor && nextSupervisor.status === 'active' && (nextSupervisor.role === 'Supervisor' || nextSupervisor.role === 'Admin')) {
                return nextSupervisor; // Found an active supervisor
            }
            
            // If next supervisor is not active or doesn't exist, continue up the chain
            currentUser = nextSupervisor;
            depth++;
        }

        if (depth >= MAX_ESCALATION_DEPTH) {
            this.logger.error(`[ExecuteApprovalEscalationUseCase] Exceeded max escalation depth of ${MAX_ESCALATION_DEPTH} starting from user ${currentSupervisorId}. Possible circular dependency.`);
        }

        return null;
    }
}