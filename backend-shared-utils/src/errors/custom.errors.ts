/**
 * @file Defines a hierarchy of custom error classes for standardized error handling.
 * This allows for consistent error responses, logging, and control flow throughout
 * the backend services. Using specific error classes enables robust `try...catch`
 * blocks that can react differently to different types of exceptions.
 */

/**
 * Base class for all custom application errors. It ensures that every error
 * includes a user-friendly message, an appropriate HTTP status code, and
 * optional structured context for logging.
 */
export class AppError extends Error {
  /**
   * The HTTP status code appropriate for this error.
   */
  public readonly statusCode: number;

  /**
   * Optional structured data providing more context about the error,
   * useful for logging and debugging.
   */
  public readonly context?: Record<string, any>;

  /**
   * Constructs a new AppError.
   * @param message A user-friendly error message.
   * @param statusCode The HTTP status code to be returned.
   * @param context Additional structured data about the error.
   */
  constructor(
    message: string,
    statusCode: number,
    context?: Record<string, any>,
  ) {
    super(message);
    this.name = this.constructor.name;
    this.statusCode = statusCode;
    this.context = context;

    // This ensures the stack trace is captured correctly in V8.
    if (Error.captureStackTrace) {
      Error.captureStackTrace(this, this.constructor);
    }
  }
}

/**
 * Represents a validation error (HTTP 400 - Bad Request).
 * Used when user-provided data fails validation checks.
 */
export class ValidationError extends AppError {
  constructor(message: string, context?: Record<string, any>) {
    super(message, 400, context);
  }
}

/**
 * Represents an authentication error (HTTP 401 - Unauthorized).
 * Used when a user is not authenticated but authentication is required.
 */
export class AuthenticationError extends AppError {
  constructor(message: string = 'Authentication required.', context?: Record<string, any>) {
    super(message, 401, context);
  }
}

/**
 * Represents an authorization error (HTTP 403 - Forbidden).
 * Used when an authenticated user does not have permission to perform an action.
 */
export class AuthorizationError extends AppError {
  constructor(message: string = 'You do not have permission to perform this action.', context?: Record<string, any>) {
    super(message, 403, context);
  }
}

/**
 * Represents a "not found" error (HTTP 404 - Not Found).
 * Used when a requested resource does not exist.
 */
export class NotFoundError extends AppError {
  constructor(message: string, context?: Record<string, any>) {
    super(message, 404, context);
  }
}

/**
 * Represents a conflict error (HTTP 409 - Conflict).
 * Used when an action cannot be completed because of a conflict with the
 * current state of the resource (e.g., creating a user that already exists).
 */
export class ConflictError extends AppError {
  constructor(message: string, context?: Record<string, any>) {
    super(message, 409, context);
  }
}

/**
 * Represents an internal server error (HTTP 500).
 * Used to wrap unexpected or unknown errors, preventing internal details
 * from leaking to the client.
 */
export class InternalServerError extends AppError {
  constructor(message: string = 'An unexpected internal server error occurred.', context?: Record<string, any>) {
    super(message, 500, context);
  }
}