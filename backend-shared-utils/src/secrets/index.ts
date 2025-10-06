/**
 * @fileoverview Barrel file for the secrets module.
 *
 * This file provides the public interface for the secret management client.
 * It exports the client's interface and the singleton instance of the client
 * implementation. Consuming services should import the singleton instance
 * from this file to ensure a single, cached connection to Google Secret
 * Manager per function instance, which is critical for performance.
 *
 * @see ./secret-manager.interface.ts for the ISecretManagerClient contract.
 * @see ./secret-manager.client.ts for the client implementation and singleton instance.
 */

export * from './secret-manager.interface';
export * from './secret-manager.client';