/**
 * @file Defines the standardized types and interfaces for API responses.
 * Using a consistent response structure across all Cloud Functions simplifies
 * client-side handling, improves predictability, and standardizes error reporting.
 */

/**
 * Defines the structure of a standardized error object to be included
 * in an API response when an operation fails.
 */
export interface ApiError {
  /**
   * A user-friendly error message explaining what went wrong.
   */
  readonly message: string;

  /**
   * An optional, machine-readable error code (e.g., 'auth/user-not-found').
   */
  readonly code?: string;

  /**
   * Optional additional details about the error, such as validation failures.
   * This can be a string, an array, or an object.
   */
  readonly details?: any;
}

/**
 * Defines the standardized structure for all JSON responses from Cloud Functions.
 * It uses a generic type `T` to allow for a strongly-typed `data` payload.
 *
 * @template T The type of the data payload for a successful response.
 */
export interface ApiResponse<T = any> {
  /**
   * A boolean indicating whether the operation was successful.
   * `true` for success, `false` for failure.
   */
  readonly success: boolean;

  /**
   * The response payload for successful operations.
   * It is of type `T` and is `null` for failed operations.
   */
  readonly data: T | null;

  /**
   * The error payload for failed operations.
   * It is of type `ApiError` and is `null` for successful operations.
   */
  readonly error: ApiError | null;
}