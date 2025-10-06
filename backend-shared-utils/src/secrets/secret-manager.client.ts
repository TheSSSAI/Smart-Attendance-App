import { SecretManagerServiceClient } from '@google-cloud/secret-manager';
import { ISecretManagerClient } from './secret-manager.interface';
import { AppError, SecretNotFoundError } from '../errors/custom.errors';

/**
 * A singleton client for Google Secret Manager with in-memory caching.
 * This class provides a performant and simplified interface for fetching secrets,
 * fulfilling REQ-1-065 and performance NFRs.
 *
 * @implements {ISecretManagerClient}
 */
export class SecretManagerClient implements ISecretManagerClient {
  private static instance: SecretManagerClient;
  private client: SecretManagerServiceClient;
  private cache: Map<string, string>;
  private projectId: string;

  /**
   * The constructor is private to enforce the singleton pattern.
   * Use SecretManagerClient.getInstance() to get an instance.
   */
  private constructor() {
    this.client = new SecretManagerServiceClient();
    this.cache = new Map<string, string>();

    // GCLOUD_PROJECT is an environment variable automatically set in GCP environments.
    const gcpProjectId = process.env.GCLOUD_PROJECT;
    if (!gcpProjectId) {
      // This will only happen in local development if not emulated/set.
      console.warn(
        'GCLOUD_PROJECT environment variable not set. Secret Manager may not work correctly.',
      );
      this.projectId = 'local-project'; // Fallback for local testing
    } else {
      this.projectId = gcpProjectId;
    }
  }

  /**
   * Gets the singleton instance of the SecretManagerClient.
   * @returns {SecretManagerClient} The singleton instance.
   */
  public static getInstance(): SecretManagerClient {
    if (!SecretManagerClient.instance) {
      SecretManagerClient.instance = new SecretManagerClient();
    }
    return SecretManagerClient.instance;
  }

  /**
   * Retrieves the value of a secret from Google Secret Manager.
   * It first checks an in-memory cache. On a cache miss, it fetches the secret
   * from the API, caches it, and then returns the value.
   *
   * @param {string} secretName The short name of the secret (e.g., 'SENDGRID_API_KEY').
   * @returns {Promise<string>} A promise that resolves with the secret's string value.
   * @throws {SecretNotFoundError} If the secret does not exist or cannot be accessed.
   * @throws {AppError} For other GCP-related errors.
   */
  public async getSecret(secretName: string): Promise<string> {
    if (this.cache.has(secretName)) {
      return this.cache.get(secretName)!;
    }

    const name = `projects/${this.projectId}/secrets/${secretName}/versions/latest`;

    try {
      const [version] = await this.client.accessSecretVersion({ name });
      const payload = version.payload?.data?.toString();

      if (!payload) {
        throw new SecretNotFoundError(`Secret "${secretName}" has no payload.`);
      }

      this.cache.set(secretName, payload);
      return payload;
    } catch (error: any) {
      // Google Cloud SDK errors have a 'code' property.
      // 5 corresponds to NOT_FOUND.
      if (error.code === 5) {
        throw new SecretNotFoundError(
          `Secret "${secretName}" not found or the service account does not have permission.`,
          { originalError: error.message },
        );
      }
      // For other errors (permissions, network, etc.), throw a generic AppError.
      throw new AppError(
        `Failed to retrieve secret "${secretName}" from Secret Manager.`,
        500,
        { originalError: error.message },
      );
    }
  }
}