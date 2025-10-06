import * as functions from "firebase-functions/v2/https";
import { logger } from "firebase-functions";
import { z } from "zod";

import { TenantService } from "@/application/services/TenantService";
import { UserService } from "@/application/services/UserService";
import { MaintenanceService } from "@/application/services/MaintenanceService";

import { FirestoreTenantRepository } from "@/infrastructure/persistence/FirestoreTenantRepository";
import { FirestoreUserRepository } from "@/infrastructure/persistence/FirestoreUserRepository";
import { FirebaseAuthService } from "@/infrastructure/security/FirebaseAuthService";
import { SendGridEmailService } from "@/infrastructure/email/SendGridEmailService";
import { FirestoreAuditLogService } from "@/infrastructure/audit/FirestoreAuditLogService";
import { getAuthenticatedContext, handleCallableError } from "@/presentation/utils/callable-utils";
import { 
  TenantRegistrationDtoSchema, 
  UserInvitationDtoSchema,
  CompleteRegistrationDtoSchema
} from "@/application/dtos";

// =====================================================================================
// Manual Dependency Injection (Composition Root)
// Instantiated once per server instance to be reused across function invocations.
// =====================================================================================
const tenantRepository = new FirestoreTenantRepository();
const userRepository = new FirestoreUserRepository();
const authService = new FirebaseAuthService();
const emailService = new SendGridEmailService();
const auditLogService = new FirestoreAuditLogService();

const tenantService = new TenantService(tenantRepository, userRepository, authService, auditLogService);
const userService = new UserService(userRepository, emailService, authService, auditLogService);
const maintenanceService = new MaintenanceService(tenantRepository, userRepository, authService, auditLogService);


// =====================================================================================
// Callable Function Definitions
// =====================================================================================

/**
 * Public callable function for registering a new organization and its first admin.
 * Implements REQ-1-032, REQ-1-033, US-001, US-002.
 */
export const registerOrganization = functions.onCall(
  { secrets: [SendGridEmailService.SENDGRID_API_KEY_SECRET] },
  async (request: functions.CallableRequest) => {
    logger.info("registerOrganization callable function triggered.", { data: request.data });
    try {
      const registrationData = TenantRegistrationDtoSchema.parse(request.data);
      const result = await tenantService.registerNewTenant(registrationData);
      return { success: true, userId: result.userId };
    } catch (error) {
      throw handleCallableError(error, "registerOrganization");
    }
  }
);

/**
 * Admin-only callable function to invite a new user to the tenant.
 * Implements REQ-1-036, US-004.
 */
export const inviteUser = functions.onCall(
  { secrets: [SendGridEmailService.SENDGRID_API_KEY_SECRET] },
  async (request: functions.CallableRequest) => {
    logger.info("inviteUser callable function triggered.", { data: request.data });
    try {
      const { tenantId } = getAuthenticatedContext(request, ["Admin"]);
      const invitationData = UserInvitationDtoSchema.parse(request.data);

      await userService.inviteNewUser(invitationData, tenantId);
      return { success: true };
    } catch (error) {
      throw handleCallableError(error, "inviteUser");
    }
  }
);

/**
 * Public callable function for an invited user to complete their registration.
 * Implements REQ-1-037, US-006.
 */
export const completeRegistration = functions.onCall(
  async (request: functions.CallableRequest) => {
    logger.info("completeRegistration callable function triggered.");
    try {
      const registrationData = CompleteRegistrationDtoSchema.parse(request.data);
      const result = await userService.completeUserRegistration(registrationData);
      return { success: true, userId: result.userId };
    } catch (error) {
      throw handleCallableError(error, "completeRegistration");
    }
  }
);

/**
 * Admin-only callable function to deactivate a user account.
 * Implements REQ-1-029, REQ-1-037, US-008, US-009.
 */
export const deactivateUser = functions.onCall(
  async (request: functions.CallableRequest) => {
    logger.info("deactivateUser callable function triggered.", { data: request.data });
    try {
      const { tenantId } = getAuthenticatedContext(request, ["Admin"]);
      const { userId } = z.object({ userId: z.string().min(1) }).parse(request.data);

      await userService.deactivateUser(userId, tenantId);
      return { success: true };
    } catch (error) {
      throw handleCallableError(error, "deactivateUser");
    }
  }
);

/**
 * Admin-only callable function to update a user's supervisor.
 * Implements REQ-1-026, US-016.
 */
export const updateUserSupervisor = functions.onCall(
  async (request: functions.CallableRequest) => {
    logger.info("updateUserSupervisor callable function triggered.", { data: request.data });
    try {
      const { tenantId } = getAuthenticatedContext(request, ["Admin"]);
      const { userId, newSupervisorId } = z.object({
        userId: z.string().min(1),
        newSupervisorId: z.string().min(1).nullable(),
      }).parse(request.data);

      await userService.updateUserSupervisor(userId, newSupervisorId, tenantId);
      return { success: true };
    } catch (error) {
      throw handleCallableError(error, "updateUserSupervisor");
    }
  }
);

/**
 * Admin-only callable function to initiate the 30-day tenant deletion grace period.
 * Implements REQ-1-034, US-022, US-023.
 */
export const requestTenantDeletion = functions.onCall(
  async (request: functions.CallableRequest) => {
    logger.info("requestTenantDeletion callable function triggered.");
    try {
      const { tenantId, userId } = getAuthenticatedContext(request, ["Admin"]);
      // Re-authentication should be handled on the client-side before calling this.
      // This function serves as the final, secure confirmation.
      await tenantService.initiateTenantDeletion(tenantId, userId);
      return { success: true };
    } catch (error) {
      throw handleCallableError(error, "requestTenantDeletion");
    }
  }
);

/**
 * Admin-only callable function to cancel a pending tenant deletion.
 * Implements US-025.
 */
export const cancelTenantDeletion = functions.onCall(
  async (request: functions.CallableRequest) => {
    logger.info("cancelTenantDeletion callable function triggered.");
    try {
      const { tenantId, userId } = getAuthenticatedContext(request, ["Admin"]);
      await tenantService.cancelTenantDeletion(tenantId, userId);
      return { success: true };
    } catch (error) {
      throw handleCallableError(error, "cancelTenantDeletion");
    }
  }
);