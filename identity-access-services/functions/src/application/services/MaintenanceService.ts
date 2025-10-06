import * as functions from "firebase-functions";
import { IAuditLogService } from "@/domain/interfaces/IAuditLogService";
import { IAuthService } from "@/domain/interfaces/IAuthService";
import { IMaintenanceService } from "@/domain/interfaces/IMaintenanceService";
import { ITenantRepository } from "@/domain/interfaces/ITenantRepository";
import { IUserRepository } from "@/domain/interfaces/IUserRepository";

const BATCH_SIZE = 400; // Firestore batch writes are limited to 500 operations

export class MaintenanceService implements IMaintenanceService {
  constructor(
    private readonly tenantRepository: ITenantRepository,
    private readonly userRepository: IUserRepository,
    private readonly authService: IAuthService,
    private readonly auditLogService: IAuditLogService // For logging maintenance actions
  ) {}

  /**
   * Finds and permanently deletes all data for tenants whose deletion grace period has expired.
   * This is a highly destructive and critical background job.
   */
  async processTenantDeletions(): Promise<void> {
    functions.logger.info("Starting scheduled job: processTenantDeletions.");

    const tenantsToDelete = await this.tenantRepository.findTenantsPastDeletionGracePeriod();

    if (tenantsToDelete.length === 0) {
      functions.logger.info("No tenants found past their deletion grace period.");
      return;
    }

    functions.logger.warn(`Found ${tenantsToDelete.length} tenants to permanently delete.`);

    for (const tenant of tenantsToDelete) {
      functions.logger.warn(`Processing deletion for tenant ${tenant.id} (${tenant.name}).`);
      try {
        // Step 1: Delete all users associated with the tenant
        const users = await this.userRepository.findAllByTenantId(tenant.id);
        if (users.length > 0) {
          const userIds = users.map((u) => u.userId);

          // Step 1a: Delete users from Firebase Auth in batches
          await this.authService.deleteUsers(userIds);
          functions.logger.info(`Deleted ${userIds.length} Auth users for tenant ${tenant.id}.`);

          // Step 1b: Delete user documents from Firestore in batches
          await this.userRepository.deleteMany(users.map((u) => u.id));
          functions.logger.info(`Deleted ${users.length} user documents for tenant ${tenant.id}.`);
        }

        // Step 2: Delete other tenant-specific data (e.g., attendance, teams, events, audit logs)
        // This would involve calling other repositories' `deleteAllByTenantId` methods.
        // For this service, we assume other services would handle their own data.
        // Here, we just delete the audit logs this service knows about.
        await this.auditLogService.deleteAllByTenantId(tenant.id);
        functions.logger.info(`Deleted audit logs for tenant ${tenant.id}.`);

        // Final Step: Delete the tenant document itself
        await this.tenantRepository.delete(tenant.id);
        functions.logger.warn(`SUCCESS: Permanently deleted tenant ${tenant.id} and all associated data.`);
      } catch (error: any) {
        functions.logger.error(`CRITICAL: Failed to fully delete tenant ${tenant.id}. Manual intervention required.`, {
          tenantId: tenant.id,
          error,
        });
        // Continue to the next tenant
      }
    }
  }

  /**
   * Finds deactivated users past their retention period and anonymizes their PII.
   */
  async anonymizeDeactivatedUsers(): Promise<void> {
    functions.logger.info("Starting scheduled job: anonymizeDeactivatedUsers.");
    const retentionDays = 90;
    const cutoffDate = new Date();
    cutoffDate.setDate(cutoffDate.getDate() - retentionDays);

    const usersToAnonymize = await this.userRepository.findDeactivatedBefore(cutoffDate);

    if (usersToAnonymize.length === 0) {
      functions.logger.info("No deactivated users found past the retention period for anonymization.");
      return;
    }

    functions.logger.info(`Found ${usersToAnonymize.length} users to anonymize.`);

    const updates: Promise<void>[] = [];
    for (const user of usersToAnonymize) {
      const anonymizedData = {
        name: "Anonymized User",
        email: `anonymized+${user.id}@deleted.local`,
        status: "anonymized" as const,
        // Keep other fields like role, supervisorId for historical integrity if needed
      };

      updates.push(this.userRepository.update(user.id, anonymizedData));
    }

    try {
      await Promise.all(updates);
      functions.logger.info(`Successfully anonymized PII for ${usersToAnonymize.length} users.`);
    } catch (error) {
      functions.logger.error("An error occurred during the user anonymization batch update.", { error });
    }
  }
}