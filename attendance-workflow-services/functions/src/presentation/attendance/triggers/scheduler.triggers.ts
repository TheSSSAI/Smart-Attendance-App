import { onSchedule } from "firebase-functions/v2/scheduler";
import * as logger from "firebase-functions/logger";

// Infrastructure Layer - Data Persistence
import { FirestoreAttendanceRepository } from "@/infrastructure/persistence/firestore/FirestoreAttendanceRepository";
import { FirestoreAuditLogRepository } from "@/infrastructure/persistence/firestore/FirestoreAuditLogRepository";
import { FirestoreTenantConfigRepository } from "@/infrastructure/persistence/firestore/FirestoreTenantConfigRepository";
import { FirestoreUserRepository } from "@/infrastructure/persistence/firestore/FirestoreUserRepository";

// Application Layer - Use Cases
import { ExecuteAutoCheckoutUseCase } from "@/application/attendance/use-cases/ExecuteAutoCheckoutUseCase";
import { ExecuteApprovalEscalationUseCase } from "@/application/attendance/use-cases/ExecuteApprovalEscalationUseCase";

// Domain Layer - Repositories (for type safety)
import { IAttendanceRepository } from "@/domain/attendance/repositories/IAttendanceRepository";
import { IAuditLogRepository } from "@/domain/attendance/repositories/IAuditLogRepository";
import { ITenantConfigRepository } from "@/domain/attendance/repositories/ITenantConfigRepository";
import { IUserRepository } from "@/domain/user/repositories/IUserRepository";

// ======================================================================================
// DEPENDENCY INJECTION (COMPOSITION ROOT)
// ======================================================================================

const attendanceRepository: IAttendanceRepository = new FirestoreAttendanceRepository();
const tenantConfigRepository: ITenantConfigRepository = new FirestoreTenantConfigRepository();
const userRepository: IUserRepository = new FirestoreUserRepository();
const auditLogRepository: IAuditLogRepository = new FirestoreAuditLogRepository();

const executeAutoCheckoutUseCase = new ExecuteAutoCheckoutUseCase(
  tenantConfigRepository,
  attendanceRepository
);

const executeApprovalEscalationUseCase = new ExecuteApprovalEscalationUseCase(
  tenantConfigRepository,
  attendanceRepository,
  userRepository,
  auditLogRepository
);

// ======================================================================================
// SCHEDULER TRIGGERS
// ======================================================================================

/**
 * Daily scheduled function to automatically check out users who have not checked out.
 * This function runs for all tenants that have the feature enabled.
 * The use case handles timezone-specific logic for each tenant.
 *
 * Corresponds to REQ-1-045.
 *
 * Runs every 15 minutes to check which tenants' local time has passed their auto-checkout time.
 */
export const runAutoCheckout = onSchedule("every 15 minutes", async (event) => {
  const functionName = "runAutoCheckout";
  logger.info(
    `${functionName}: Scheduled job started at ${event.timestamp}.`
  );

  try {
    await executeAutoCheckoutUseCase.execute();
    logger.info(
      `${functionName}: Scheduled job completed successfully.`
    );
  } catch (error) {
    // Log errors but don't re-throw to prevent Cloud Scheduler from retrying
    // a potentially non-transient failure. The use case should handle per-tenant errors internally.
    logger.error(`${functionName}: Scheduled job failed.`, {
      error,
      timestamp: event.timestamp,
    });
  }
});

/**
 * Daily scheduled function to escalate overdue pending attendance approvals.
 * This function runs for all tenants that have the feature enabled.
 *
 * Corresponds to REQ-1-051.
 *
 * Runs once daily.
 */
export const runApprovalEscalation = onSchedule(
  "every day 03:00",
  async (event) => {
    const functionName = "runApprovalEscalation";
    logger.info(
      `${functionName}: Scheduled job started at ${event.timestamp}.`
    );

    try {
      await executeApprovalEscalationUseCase.execute();
      logger.info(
        `${functionName}: Scheduled job completed successfully.`
      );
    } catch (error) {
      logger.error(`${functionName}: Scheduled job failed.`, {
        error,
        timestamp: event.timestamp,
      });
    }
  }
);