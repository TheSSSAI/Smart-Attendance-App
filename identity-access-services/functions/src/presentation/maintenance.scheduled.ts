import * as functions from "firebase-functions/v2/scheduler";
import { logger } from "firebase-functions";

import { TenantService } from "@/application/services/TenantService";
import { UserService } from "@/application/services/UserService";
import { MaintenanceService } from "@/application/services/MaintenanceService";

import { FirestoreTenantRepository } from "@/infrastructure/persistence/FirestoreTenantRepository";
import { FirestoreUserRepository } from "@/infrastructure/persistence/FirestoreUserRepository";
import { FirebaseAuthService } from "@/infrastructure/security/FirebaseAuthService";
import { SendGridEmailService } from "@/infrastructure/email/SendGridEmailService";
import { FirestoreAuditLogService } from "@/infrastructure/audit/FirestoreAuditLogService";

// =====================================================================================
// Manual Dependency Injection (Composition Root)
// =====================================================================================
const tenantRepository = new FirestoreTenantRepository();
const userRepository = new FirestoreUserRepository();
const authService = new FirebaseAuthService();
const emailService = new SendGridEmailService(); // Needed for service constructor, though not used here
const auditLogService = new FirestoreAuditLogService();

// Note: We instantiate all services, but only MaintenanceService is used.
// In a real DI container, this would be cleaner.
const tenantService = new TenantService(tenantRepository, userRepository, authService, auditLogService);
const userService = new UserService(userRepository, emailService, authService, auditLogService);
const maintenanceService = new MaintenanceService(tenantRepository, userRepository, authService, auditLogService);

// =====================================================================================
// Scheduled Function Definitions
// =====================================================================================

/**
 * A daily scheduled function to process permanent tenant deletions after the grace period.
 * Implements REQ-1-035.
 *
 * This function runs every day at 3:00 AM UTC. It queries for tenants marked
 * for deletion whose grace period has expired and performs a cascading delete
 * of all associated data.
 */
export const processTenantDeletions = functions.onSchedule(
  "every day 03:00",
  async (event: functions.ScheduledEvent) => {
    logger.info("Scheduled function 'processTenantDeletions' triggered.", { event });
    try {
      await maintenanceService.processTenantDeletions();
      logger.info("Scheduled function 'processTenantDeletions' completed successfully.");
    } catch (error) {
      logger.error("Scheduled function 'processTenantDeletions' failed.", { error });
      // Errors are logged for monitoring and alerting.
      // We don't re-throw as there is no caller to handle it.
    }
  }
);

/**
 * A daily scheduled function to anonymize PII from deactivated user accounts
 * that have passed their retention period.
 * Implements REQ-1-074, US-086.
 *
 * This function runs every day at 4:00 AM UTC. It queries for users who have
 * been deactivated for more than 90 days and removes their PII to comply with
 * data retention policies.
 */
export const anonymizeDeactivatedUsers = functions.onSchedule(
  "every day 04:00",
  async (event: functions.ScheduledEvent) => {
    logger.info("Scheduled function 'anonymizeDeactivatedUsers' triggered.", { event });
    try {
      await maintenanceService.anonymizeDeactivatedUsers();
      logger.info("Scheduled function 'anonymizeDeactivatedUsers' completed successfully.");
    } catch (error) {
      logger.error("Scheduled function 'anonymizeDeactivatedUsers' failed.", { error });
    }
  }
);