import { SecretNotFoundError } from '../errors/custom.errors';

/**
 * @interface ISecretManagerClient
 * @description Defines the contract for a client that retrieves secrets from a secure secret
 * management service, such as Google Secret Manager. This abstraction ensures a consistent,
 * secure, and performant way for all backend services to access runtime secrets like API keys.
 *
 * @see {@link REQ-1-065} for the requirement to store secrets in a secret manager.
 * @see {@link REQ-1-067} for performance targets, which implementations should meet via caching.
 */
export interface ISecretManagerClient {
  /**
   * Asynchronously retrieves the string value of the latest version of a specified secret.
   * Implementations are expected to include caching mechanisms to improve performance and
   * reduce costs, as this method may be called frequently.
   *
   * @param {string} secretName The short name of the secret to fetch (e.g., "SENDGRID_API_KEY").
   * @returns {Promise<string>} A promise that resolves with the secret's value.
   * @throws {SecretNotFoundError} If the secret does not exist or the service account lacks permission to access it.
   * @throws {Error} For other unexpected errors during the retrieval process.
   */
  getSecret(secretName: string): Promise<string>;
}