import { https, an } from 'firebase-functions/v1';

/**
 * @type IErrorHandler
 * @description Defines the contract for a higher-order function that wraps a Firebase Cloud Function handler.
 * Its purpose is to provide a standardized `try...catch` block, ensuring that all errors are
 * caught, logged consistently using a structured logger, and returned to the client as a
 * standardized error response. This reduces boilerplate code and enforces uniform error handling.
 *
 * @template T - The type of the data expected by the original function handler.
 * @template U - The return type of the original function handler (Promise<any>).
 * @param {(data: T, context: https.CallableContext) => U} handler The original Firebase Cloud Function handler to be wrapped.
 * @returns {(data: T, context: https.CallableContext) => U} A new function that wraps the original handler with error handling logic.
 *
 * @see {@link REQ-1-076} for comprehensive monitoring and logging requirements.
 */
export type IErrorHandler = <T, U extends Promise<any>>(
  handler: (data: T, context: https.CallableContext) => U,
) => (data: T, context: https.CallableContext) => U;