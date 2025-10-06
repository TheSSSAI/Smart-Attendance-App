/**
 * @fileoverview Barrel file for the context module.
 *
 * This file serves as the public API for the context utility module. It exports
 * all necessary types, interfaces, and utility functions related to parsing
 * and handling Firebase Function request contexts. By exporting everything
 * from this single file, we provide a clean and consistent import path for
 * consuming services.
 *
 * @see ./context.types.ts for type definitions.
 * @see ./context.interface.ts for interface contracts.
 * @see ./context.utils.ts for implementation of context parsing logic.
 */

export * from './context.types';
export * from './context.interface';
export * from './context.utils';