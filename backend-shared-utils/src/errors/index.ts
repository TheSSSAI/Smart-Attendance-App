/**
 * @fileoverview Barrel file for the errors module.
 *
 * This file is the public entry point for all error-handling utilities. It
 * exports custom error classes, interfaces, and the main error handler
 * higher-order function. This allows consuming services to import all
 * error-related components from a single, consistent location, promoting
 * standardized error management across the backend.
 *
 * @see ./custom.errors.ts for custom application error class definitions.
 * @see ./error.interface.ts for the error handler interface contract.
 * @see ./error.handler.ts for the higher-order function implementation.
 */

export * from './custom.errors';
export * from './error.interface';
export * from './error.handler';