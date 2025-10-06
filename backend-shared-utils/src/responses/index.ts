/**
 * @fileoverview Barrel file for the responses module.
 *
 * This file exposes the public API for creating standardized API responses.
 * It exports the response type definitions and utility functions for
 * generating consistent success and error JSON payloads. All backend
 * services should use these utilities to ensure a uniform API response
 * structure for all client interactions.
 *
 * @see ./response.types.ts for the ApiResponse interface.
 * @see ./response.utils.ts for the response creation functions.
 */

export * from './response.types';
export * from './response.utils';