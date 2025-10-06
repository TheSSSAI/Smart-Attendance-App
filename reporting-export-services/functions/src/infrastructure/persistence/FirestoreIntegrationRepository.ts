import { IIntegrationRepository } from "../../domain/repositories/IIntegrationRepository";
import { IntegrationConfig } from "../../domain/entities/IntegrationConfig";
import { db } from "../../config/firebase";
import { logger } from "firebase-functions/v2";
import { DocumentData, QueryDocumentSnapshot } from "firebase-admin/firestore";

/**
 * Firestore-based implementation of the IIntegrationRepository.
 * This class handles all data access logic for Google Sheets integration
 * configurations stored in the `/linkedSheets` collection.
 */
export class FirestoreIntegrationRepository implements IIntegrationRepository {
  private readonly collectionPath = "linkedSheets";

  /**
   * Retrieves all active Google Sheets integration configurations.
   *
   * @returns {Promise<IntegrationConfig[]>} A promise that resolves to an array of active integration configs.
   */
  public async getActiveIntegrations(): Promise<IntegrationConfig[]> {
    logger.info(`Fetching all active integrations from '${this.collectionPath}'...`);
    try {
      const snapshot = await db
        .collection(this.collectionPath)
        .where("status", "==", "active")
        .get();

      if (snapshot.empty) {
        logger.info("No active integrations found.");
        return [];
      }

      const configs = snapshot.docs.map(this.toIntegrationConfig);
      logger.info(`Found ${configs.length} active integrations.`);
      return configs;
    } catch (error) {
      logger.error("Error fetching active integrations:", error);
      throw error;
    }
  }

  /**
   * Saves or updates an integration configuration.
   *
   * @param {IntegrationConfig} config - The integration configuration object to save.
   * @returns {Promise<void>} A promise that resolves on completion.
   */
  public async save(config: IntegrationConfig): Promise<void> {
    logger.info(`Saving integration config for admin user: ${config.adminUserId}`);
    try {
      const docRef = db.collection(this.collectionPath).doc(config.adminUserId);
      await docRef.set(
        {
          ...config,
          // Convert Date objects to Firestore Timestamps for storage
          lastSyncTimestamp: config.lastSyncTimestamp ? new Date(config.lastSyncTimestamp) : null,
        },
        { merge: true },
      );
      logger.info(`Successfully saved integration config for admin user: ${config.adminUserId}`);
    } catch (error) {
      logger.error(`Error saving integration config for admin user ${config.adminUserId}:`, error);
      throw error;
    }
  }

  /**
   * Updates the status and error details of a specific integration configuration.
   *
   * @param {string} adminUserId - The ID of the document (admin user who configured it).
   * @param {'active' | 'error'} status - The new status.
   * @param {object} [errorDetails] - Optional error details to store.
   * @returns {Promise<void>} A promise that resolves on completion.
   */
  public async updateStatus(
    adminUserId: string,
    status: "active" | "error",
    errorDetails?: object,
  ): Promise<void> {
    logger.info(`Updating integration status for ${adminUserId} to '${status}'...`);
    try {
      const docRef = db.collection(this.collectionPath).doc(adminUserId);
      const updatePayload: { status: string; errorDetails?: object } = { status };
      if (status === "error" && errorDetails) {
        updatePayload.errorDetails = errorDetails;
      } else {
        // Clear error details if status is being set to active
        updatePayload.errorDetails = {}; 
      }
      await docRef.update(updatePayload);
      logger.info(`Successfully updated integration status for ${adminUserId}.`);
    } catch (error) {
      logger.error(`Error updating integration status for ${adminUserId}:`, error);
      throw error;
    }
  }

  /**
   * Updates the 'lastSyncTimestamp' for a specific integration configuration.
   * This is used as a cursor for the next export run.
   *
   * @param {string} adminUserId - The ID of the document.
   * @param {Date} timestamp - The timestamp of the last successfully exported record.
   * @returns {Promise<void>} A promise that resolves on completion.
   */
  public async updateLastSyncTimestamp(adminUserId: string, timestamp: Date): Promise<void> {
    logger.info(`Updating last sync timestamp for ${adminUserId} to ${timestamp.toISOString()}...`);
    try {
      const docRef = db.collection(this.collectionPath).doc(adminUserId);
      await docRef.update({ lastSyncTimestamp: timestamp });
      logger.info(`Successfully updated last sync timestamp for ${adminUserId}.`);
    } catch (error) {
      logger.error(`Error updating last sync timestamp for ${adminUserId}:`, error);
      throw error;
    }
  }

  /**
   * Maps a Firestore document snapshot to an IntegrationConfig domain entity.
   * @param {QueryDocumentSnapshot<DocumentData>} doc - The Firestore document snapshot.
   * @returns {IntegrationConfig} The mapped integration configuration.
   */
  private toIntegrationConfig(doc: QueryDocumentSnapshot<DocumentData>): IntegrationConfig {
    const data = doc.data();
    return {
      adminUserId: doc.id,
      tenantId: data.tenantId,
      sheetId: data.sheetId,
      status: data.status,
      lastSyncTimestamp: data.lastSyncTimestamp ? data.lastSyncTimestamp.toDate() : new Date(0), // Default to epoch if null
      errorDetails: data.errorDetails,
      // Refresh token name is stored, not the token itself
      refreshTokenSecretName: data.refreshTokenSecretName,
    };
  }
}