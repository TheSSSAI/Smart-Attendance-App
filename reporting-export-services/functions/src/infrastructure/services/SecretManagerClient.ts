import { SecretManagerServiceClient } from "@google-cloud/secret-manager";
import { env } from "../../config/env";
import * as functions from "firebase-functions";

/**
 * Custom error for when a requested secret is not found.
 */
export class SecretNotFoundError extends Error {
  constructor(message: string) {
    super(message);
    this.name = "SecretNotFoundError";
  }
}

/**
 * Interface defining the contract for a Secret Manager client.
 */
export interface ISecretManagerClient {
  getSecret(secretName: string): Promise<string>;
  setSecret(secretName: string, secretValue: string): Promise<void>;
}

let memoizedClient: SecretManagerServiceClient;

/**
 * A client wrapper for all interactions with Google Cloud Secret Manager.
 * Complies with REQ-1-065 for secure secret storage.
 */
export class SecretManagerClient implements ISecretManagerClient {
  private readonly client: SecretManagerServiceClient;
  private readonly projectId: string;

  constructor() {
    // Memoize the client to improve performance on warm function invocations
    if (!memoizedClient) {
      memoizedClient = new SecretManagerServiceClient();
    }
    this.client = memoizedClient;
    this.projectId = env.gcpProjectId;
  }

  /**
   * Retrieves the latest version of a secret from Secret Manager.
   * @param {string} secretName The short name of the secret.
   * @returns {Promise<string>} The secret's value as a UTF-8 string.
   * @throws {SecretNotFoundError} If the secret or its version does not exist.
   * @throws {Error} For other GCP API errors.
   */
  public async getSecret(secretName: string): Promise<string> {
    const name = `projects/${this.projectId}/secrets/${secretName}/versions/latest`;
    try {
      const [version] = await this.client.accessSecretVersion({ name });
      const payload = version.payload?.data?.toString("utf8");

      if (!payload) {
        throw new SecretNotFoundError(`Secret '${secretName}' has no payload or is empty.`);
      }

      return payload;
    } catch (error: any) {
      functions.logger.error(`Failed to access secret: ${secretName}`, { error: error.message });
      if (error.code === 5) {
        // gRPC code for NOT_FOUND
        throw new SecretNotFoundError(`Secret '${secretName}' not found or you lack permissions to access it.`);
      }
      throw error;
    }
  }

  /**
   * Creates a new secret or adds a new version to an existing secret.
   * This method is idempotent for secret creation.
   * @param {string} secretName The short name of the secret.
   * @param {string} secretValue The value to store in the new secret version.
   * @throws {Error} If the operation fails due to permissions or other API errors.
   */
  public async setSecret(secretName: string, secretValue: string): Promise<void> {
    try {
      // First, attempt to create the secret. This is idempotent and will fail gracefully if it exists.
      await this.createSecretIfNotExists(secretName);

      // Now, add the new version with the payload.
      const parent = `projects/${this.projectId}/secrets/${secretName}`;
      const payload = {
        data: Buffer.from(secretValue, "utf8"),
      };

      await this.client.addSecretVersion({ parent, payload });
      functions.logger.info(`Successfully added new version to secret: ${secretName}`);
    } catch (error: any) {
      functions.logger.error(`Failed to set secret: ${secretName}`, { error: error.message });
      throw new Error(`Could not set secret value for ${secretName}: ${error.message}`);
    }
  }

  /**
   * Private helper to create a secret if it doesn't already exist.
   * @param secretName The short name of the secret.
   */
  private async createSecretIfNotExists(secretName: string): Promise<void> {
    const parent = `projects/${this.projectId}`;
    const name = `${parent}/secrets/${secretName}`;

    try {
      // Attempt to get the secret to see if it exists
      await this.client.getSecret({ name });
      functions.logger.info(`Secret ${secretName} already exists. Skipping creation.`);
    } catch (error: any) {
      if (error.code === 5) {
        // gRPC code for NOT_FOUND, so we need to create it
        functions.logger.info(`Secret ${secretName} not found. Creating...`);
        await this.client.createSecret({
          parent,
          secretId: secretName,
          secret: {
            replication: {
              automatic: {},
            },
          },
        });
        functions.logger.info(`Successfully created secret: ${secretName}`);
      } else {
        // Another error occurred
        throw error;
      }
    }
  }
}