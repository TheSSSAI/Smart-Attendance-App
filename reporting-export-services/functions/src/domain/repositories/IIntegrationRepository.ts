import type { IntegrationConfig } from "../entities/IntegrationConfig";

/**
 * @interface IIntegrationRepository
 * @description Defines the contract for a repository that manages the persistence
 * of Google Sheets integration configurations. This interface abstracts the underlying
 * data storage mechanism (e.g., Firestore) from the application's business logic.
 */
export interface IIntegrationRepository {
  /**
   * Retrieves all integration configurations that are currently active.
   * This is used by the scheduled export job to identify which tenants to process.
   *
   * @returns {Promise<IntegrationConfig[]>} A promise that resolves to an array of active IntegrationConfig objects.
   * Resolves to an empty array if no active integrations are found.
   * @throws {Error} Throws an error if the data retrieval from the underlying storage fails.
   */
  getActiveIntegrations(): Promise<IntegrationConfig[]>;

  /**
   * Updates the status and optional error details of a specific integration configuration.
   * This method is crucial for managing the state of the integration, especially for handling
   * failures as per REQ-1-060.
   *
   * @param {string} id - The unique identifier for the integration configuration (e.g., adminUserId).
   * @param {IntegrationConfig['status']} status - The new status to set ('active' or 'error').
   * @param {object} [errorDetails] - A serializable object containing details of the error, if the status is 'error'.
   * @returns {Promise<void>} A promise that resolves when the update is complete.
   * @throws {Error} Throws an error if the update operation fails or the specified configuration does not exist.
   */
  updateStatus(
    id: string,
    status: IntegrationConfig["status"],
    errorDetails?: object
  ): Promise<void>;

  /**
   * Updates the last synchronization timestamp for a given integration.
   * This acts as a cursor for the next export run, ensuring that only new records are processed,
   * which is essential for idempotency and efficiency as per REQ-1-059's assumptions.
   *
   * @param {string} id - The unique identifier for the integration configuration (e.g., adminUserId).
   * @param {Date} timestamp - The timestamp of the last successfully exported record.
   * @returns {Promise<void>} A promise that resolves when the update is complete.
   * @throws {Error} Throws an error if the update operation fails or the specified configuration does not exist.
   */
  updateLastSyncTimestamp(id: string, timestamp: Date): Promise<void>;

  /**
   * Finds a single integration configuration by its unique identifier.
   *
   * @param {string} id - The unique identifier for the integration configuration (e.g., adminUserId).
   * @returns {Promise<IntegrationConfig | null>} A promise that resolves to the IntegrationConfig object if found, otherwise null.
   * @throws {Error} Throws an error if the data retrieval fails.
   */
  findById(id: string): Promise<IntegrationConfig | null>;

  /**
   * Saves or creates an integration configuration.
   * This is used during the initial setup of the integration via the OAuth callback.
   *
   * @param {IntegrationConfig} config - The IntegrationConfig object to save.
   * @returns {Promise<void>} A promise that resolves when the save operation is complete.
   * @throws {Error} Throws an error if the save operation fails.
   */
  save(config: IntegrationConfig): Promise<void>;
}