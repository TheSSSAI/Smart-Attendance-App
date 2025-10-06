import { onDocumentWritten } from "firebase-functions/v2/firestore";
import * as logger from "firebase-functions/logger";

// Infrastructure Layer - Data Persistence
import { FirestoreAttendanceRepository } from "@/infrastructure/persistence/firestore/FirestoreAttendanceRepository";
import { FirestoreAuditLogRepository } from "@/infrastructure/persistence/firestore/FirestoreAuditLogRepository";
import { FirestoreUserRepository } from "@/infrastructure/persistence/firestore/FirestoreUserRepository";
import { FirestoreTenantConfigRepository } from "@/infrastructure/persistence/firestore/FirestoreTenantConfigRepository";

// Application Layer - Use Cases
import { ValidateClockDiscrepancyUseCase } from "@/application/attendance/use-cases/ValidateClockDiscrepancyUseCase";

// Domain Layer - Repositories (for type safety, not direct implementation)
import { IAttendanceRepository } from "@/domain/attendance/repositories/IAttendanceRepository";
import { IAuditLogRepository } from "@/domain/attendance/repositories/IAuditLogRepository";
import { IUserRepository } from "@/domain/user/repositories/IUserRepository";
import { ITenantConfigRepository } from "@/domain/attendance/repositories/ITenantConfigRepository";


// ======================================================================================
// DEPENDENCY INJECTION (COMPOSITION ROOT)
// ======================================================================================

// Note: In a serverless environment, we instantiate dependencies for each function group.
// A more complex setup might use a DI container library, but manual instantiation is
// clear and sufficient for this scale.

const attendanceRepository: IAttendanceRepository = new FirestoreAttendanceRepository();
const auditLogRepository: IAuditLogRepository = new FirestoreAuditLogRepository();
const userRepository: IUserRepository = new FirestoreUserRepository();
const tenantConfigRepository: ITenantConfigRepository = new FirestoreTenantConfigRepository();

const validateClockDiscrepancyUseCase = new ValidateClockDiscrepancyUseCase(
  attendanceRepository
);

// ======================================================================================
// FIRESTORE TRIGGERS
// ======================================================================================

/**
 * Firestore trigger that runs when an attendance record is created or updated.
 * It invokes the use case to validate and flag any clock discrepancies.
 *
 * Corresponds to REQ-1-044.
 */
export const onAttendanceWrite = onDocumentWritten(
  "/tenants/{tenantId}/attendance/{attendanceId}",
  async (event) => {
    const functionName = "onAttendanceWrite";
    const { tenantId, attendanceId } = event.params;

    logger.info(
      `${functionName}: Triggered for tenant [${tenantId}], attendance [${attendanceId}].`
    );

    try {
      // The business logic is encapsulated in the use case.
      // This trigger's responsibility is to call the use case with the event data.
      await validateClockDiscrepancyUseCase.execute({
        change: event.data,
        context: event,
      });

      logger.info(
        `${functionName}: Successfully processed clock discrepancy check for attendance [${attendanceId}].`
      );
    } catch (error) {
      // We log the error but do not re-throw it. Re-throwing in a background
      // function can cause repeated retries for non-transient errors, leading
      // to infinite loops and increased costs. The use case should handle its
      // own logic to prevent partial data states.
      logger.error(
        `${functionName}: Failed to process clock discrepancy for attendance [${attendanceId}].`,
        {
          error,
          tenantId,
          attendanceId,
        }
      );
    }
  }
);

// To add other attendance-related Firestore triggers, define them below
// and add their use case instantiations in the DI section above.