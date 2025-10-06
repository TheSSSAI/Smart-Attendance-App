import { ApiResponse, ApiErrorPayload } from './response.types';
import { AppError } from '../errors/custom.errors';

/**
 * Creates a standardized success response object.
 *
 * @template T The type of the data payload.
 * @param {T} data The payload to include in the response.
 * @returns {ApiResponse<T>} A standardized success response object.
 */
export function createSuccessResponse<T>(data: T): ApiResponse<T> {
  return {
    success: true,
    data,
    error: null,
  };
}

/**
 * Creates a standardized error response object from an Error instance.
 * It intelligently extracts status codes and messages from custom AppError instances.
 *
 * @param {Error | AppError} error The error object to convert into a response.
 * @param {string} [defaultMessage='An unexpected error occurred.'] A fallback message for generic errors.
 * @returns {ApiResponse<null>} A standardized error response object.
 */
export function createErrorResponse(
  error: Error | AppError,
  defaultMessage = 'An unexpected error occurred.',
): ApiResponse<null> {
  let errorPayload: ApiErrorPayload;

  if (error instanceof AppError) {
    // For custom application errors, use the provided message and code.
    errorPayload = {
      message: error.message,
      code: error.name, // e.g., 'AuthenticationError', 'ValidationError'
    };
  } else {
    // For generic system errors, use a default message to avoid leaking implementation details.
    errorPayload = {
      message: defaultMessage,
      code: 'InternalServerError',
    };
  }

  return {
    success: false,
    data: null,
    error: errorPayload,
  };
}