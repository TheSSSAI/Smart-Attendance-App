/**
 * @fileoverview
 * This is the main entry point for the backend-shared-utils library.
 * It serves as a barrel file, re-exporting all the public-facing utilities
 * from the various modules within the library.
 *
 * Consuming services should import from this top-level module to ensure
 * they are decoupled from the internal file structure of the library.
 *
 * Example Usage in a consumer (e.g., another Cloud Function):
 *
 * import {
 *   StructuredLogger,
 *   getAuthenticatedContext,
 *   withErrorHandler,
 *   SecretManagerClient,
 *   createSuccessResponse,
 *   AppError,
 * } from '@attendance-app/backend-shared-utils';
 *
 */

// Export all context-related utilities, interfaces, and types.
// This includes context parsers and standardized context type definitions.
export * from './context';

// Export all error-related utilities, interfaces, and custom error classes.
// This includes the global error handler and specific error types like
// AppError, AuthenticationError, etc.
export * from './errors';

// Export all logging-related utilities, interfaces, and types.
// This primarily exposes the ILogger interface and the StructuredLogger class.
export * from './logging';

// Export all standardized API response utilities and types.
// This provides helper functions to create consistent success and error
// JSON responses across all microservices.
export * from './responses';

// Export all secret management-related utilities and interfaces.
// This exposes the ISecretManagerClient interface and its singleton implementation
// for securely accessing runtime secrets.
export * from './secrets';