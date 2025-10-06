/**
 * @fileoverview Barrel file for the logging module.
 *
 * This file serves as the public API for the structured logging module. It
 * exports the logger implementation, its interface, and related types.
 * Consuming services should import from this file to get access to the
 * standardized logging functionality, ensuring consistent log formats and
 * practices across all backend services.
 *
 * @see ./logger.types.ts for type definitions like LogContext.
 * @see ./logger.interface.ts for the ILogger contract.
 * @see ./logger.ts for the StructuredLogger class implementation.
 */

export * from './logger.types';
export * from './logger.interface';
export * from './logger';