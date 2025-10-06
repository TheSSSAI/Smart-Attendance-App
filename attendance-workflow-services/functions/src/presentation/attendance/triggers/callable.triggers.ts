import { onCall, HttpsError } from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";

// Infrastructure Layer - Data Persistence
import { FirestoreAttendanceRepository } from "@/infrastructure/persistence/firestore/FirestoreAttendanceRepository";
import { FirestoreAuditLogRepository } from "@/infrastructure/persistence/firestore/FirestoreAuditLogRepository";

// Application Layer - Use Cases
import { ApproveAttendanceUseCase } from "@/application/attendance/use-cases/ApproveAttendanceUseCase";
import { RejectAttendanceUseCase } from "@/application/attendance/use-cases/RejectAttendanceUseCase";
import { ApproveCorrectionUseCase } from "@/application/attendance/use-cases/ApproveCorrectionUseCase";
import { RejectCorrectionUseCase } from "@/application/attendance/use-cases/RejectCorrectionUseCase";

// Application Layer - DTOs for validation and data contract
import {
  ApproveAttendanceDTO,
  ApproveAttendanceSchema,
} from "@/application/attendance/dtos/ApproveAttendanceDTO";
import {
  RejectAttendanceDTO,
  RejectAttendanceSchema,
} from "@/application/attendance/dtos/RejectAttendanceDTO";
import {
  ApproveCorrectionDTO,
  ApproveCorrectionSchema,
} from "@/application/attendance/dtos/ApproveCorrectionDTO";
import {
  RejectCorrectionDTO,
  RejectCorrectionSchema,
} from "@/application/attendance/dtos/RejectCorrectionDTO";

// Domain Layer - Repositories
import { IAttendanceRepository } from "@/domain/attendance/repositories/IAttendanceRepository";
import { IAuditLogRepository } from "@/domain/attendance/repositories/IAuditLogRepository";
import { Actor } from "@/domain/auth/Actor";

// ======================================================================================
// DEPENDENCY INJECTION (COMPOSITION ROOT)
// ======================================================================================

const attendanceRepository: IAttendanceRepository = new FirestoreAttendanceRepository();
const auditLogRepository: IAuditLogRepository = new FirestoreAuditLogRepository();

const approveAttendanceUseCase = new ApproveAttendanceUseCase(
  attendanceRepository,
  auditLogRepository
);
const rejectAttendanceUseCase = new RejectAttendanceUseCase(
  attendanceRepository,
  auditLogRepository
);
const approveCorrectionUseCase = new ApproveCorrectionUseCase(
  attendanceRepository,
  auditLogRepository
);
const rejectCorrectionUseCase = new RejectCorrectionUseCase(
  attendanceRepository,
  auditLogRepository
);

// ======================================================================================
// HELPER FUNCTIONS
// ======================================================================================

const getAuthenticatedActor = (context: any): Actor => {
  if (!context.auth) {
    throw new HttpsError(
      "unauthenticated",
      "The function must be called while authenticated."
    );
  }
  return {
    uid: context.auth.uid,
    role: context.auth.token.role,
    tenantId: context.auth.token.tenantId,
  };
};

// ======================================================================================
// CALLABLE TRIGGERS
// ======================================================================================

/**
 * Callable function for a Supervisor to approve a single attendance record.
 * Corresponds to REQ-1-005.
 */
export const approveAttendance = onCall(async (request) => {
  const functionName = "approveAttendance";
  try {
    const actor = getAuthenticatedActor(request);
    const validatedData = ApproveAttendanceSchema.parse(request.data);
    const dto: ApproveAttendanceDTO = { ...validatedData, actor };

    await approveAttendanceUseCase.execute(dto);

    return { success: true };
  } catch (error) {
    if (error instanceof HttpsError) {
      logger.warn(`${functionName}: HttpsError caught:`, { error, data: request.data });
      throw error;
    }
    logger.error(`${functionName}: An unexpected error occurred.`, { error, data: request.data });
    throw new HttpsError("internal", "An unexpected error occurred.");
  }
});

/**
 * Callable function for a Supervisor to reject a single attendance record.
 * Corresponds to REQ-1-049.
 */
export const rejectAttendance = onCall(async (request) => {
  const functionName = "rejectAttendance";
  try {
    const actor = getAuthenticatedActor(request);
    const validatedData = RejectAttendanceSchema.parse(request.data);
    const dto: RejectAttendanceDTO = { ...validatedData, actor };

    await rejectAttendanceUseCase.execute(dto);

    return { success: true };
  } catch (error) {
    if (error instanceof HttpsError) {
      logger.warn(`${functionName}: HttpsError caught:`, { error, data: request.data });
      throw error;
    }
    logger.error(`${functionName}: An unexpected error occurred.`, { error, data: request.data });
    throw new HttpsError("internal", "An unexpected error occurred.");
  }
});

/**
 * Callable function for a Supervisor to approve an attendance correction request.
 * Corresponds to REQ-1-053.
 */
export const approveCorrection = onCall(async (request) => {
  const functionName = "approveCorrection";
  try {
    const actor = getAuthenticatedActor(request);
    const validatedData = ApproveCorrectionSchema.parse(request.data);
    const dto: ApproveCorrectionDTO = { ...validatedData, actor };

    await approveCorrectionUseCase.execute(dto);

    return { success: true };
  } catch (error) {
    if (error instanceof HttpsError) {
      logger.warn(`${functionName}: HttpsError caught:`, { error, data: request.data });
      throw error;
    }
    logger.error(`${functionName}: An unexpected error occurred.`, { error, data: request.data });
    throw new HttpsError("internal", "An unexpected error occurred.");
  }
});

/**
 * Callable function for a Supervisor to reject an attendance correction request.
 * Logical counterpart to approveCorrection.
 */
export const rejectCorrection = onCall(async (request) => {
  const functionName = "rejectCorrection";
  try {
    const actor = getAuthenticatedActor(request);
    const validatedData = RejectCorrectionSchema.parse(request.data);
    const dto: RejectCorrectionDTO = { ...validatedData, actor };

    await rejectCorrectionUseCase.execute(dto);

    return { success: true };
  } catch (error) {
    if (error instanceof HttpsError) {
      logger.warn(`${functionName}: HttpsError caught:`, { error, data: request.data });
      throw error;
    }
    logger.error(`${functionName}: An unexpected error occurred.`, { error, data: request.data });
    throw new HttpsError("internal", "An unexpected error occurred.");
  }
});