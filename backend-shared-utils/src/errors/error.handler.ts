import { https, logger as functionsLogger } from 'firebase-functions';
import { ILogger } from '../logging/logger.interface';
import { createErrorResponse } from '../responses/response.utils';
import { ApiResponse } from '../responses/response.types';
import { AppError, AuthenticationError, AuthorizationError, NotFoundError, ValidationError } from './custom.errors';
import { CallableHandler, IErrorHandlerFactory } from './error.interface';

/**
 * Factory function to create a configured error handler.
 * This follows the Dependency Injection pattern, allowing the logger to be injected.
 *
 * @param {ILogger} logger - An instance of a logger conforming to the ILogger interface.
 * @returns {IErrorHandlerFactory} An object containing higher-order functions to wrap different types of Cloud Functions.
 */
export const createErrorHandler = (logger: ILogger): IErrorHandlerFactory => {
  /**
   * A higher-order function that wraps a Firebase Callable Function handler
   * with standardized error handling, logging, and response formatting.
   *
   * @template T - The type of the data expected by the handler.
   * @template U - The type of the data returned by the handler on success.
   * @param {CallableHandler<T, U>} handler - The core business logic of the callable function.
   * @returns {https.HttpsFunction} A new function that can be exported as a Firebase Callable Function.
   */
  const onCall = <T, U>(handler: CallableHandler<T, U>): https.HttpsFunction => {
    return https.onCall(async (data: T, context: https.CallableContext): Promise<ApiResponse<U | null>> => {
      try {
        // Execute the core business logic
        return await handler(data, context);
      } catch (error: unknown) {
        // Centralized error handling logic
        const requestContext = {
          auth: context.auth,
          functionName: process.env.FUNCTION_NAME || 'unknown_callable_function',
          trace: context.instanceIdToken, // For linking logs
        };
        
        if (error instanceof AppError) {
          // Handle known, application-specific errors
          const logContext = { ...requestContext, ...error.context, statusCode: error.statusCode };

          if (error.statusCode >= 500) {
            logger.error(error.message, error, logContext);
          } else {
            // Log 4xx errors as warnings, as they are often client-side issues
            logger.warn(error.message, logContext);
          }
          
          // For callable functions, we throw an HttpsError which the client SDK understands.
          // This allows clients to easily catch specific error codes.
          let code: https.FunctionsErrorCode = 'internal';
          if (error instanceof AuthenticationError) code = 'unauthenticated';
          else if (error instanceof AuthorizationError) code = 'permission-denied';
          else if (error instanceof NotFoundError) code = 'not-found';
          else if (error instanceof ValidationError) code = 'invalid-argument';

          throw new https.HttpsError(code, error.message, error.context);

        } else if (error instanceof Error) {
          // Handle unexpected, generic JavaScript errors
          logger.error('An unexpected error occurred in callable function.', error, requestContext);
          throw new https.HttpsError(
            'internal', 
            'An unexpected server error occurred. Please try again later.',
          );
        } else {
          // Handle cases where a non-Error object was thrown
          logger.error(
            'An unexpected non-error object was thrown.', 
            new Error(JSON.stringify(error)), 
            requestContext
          );
          throw new https.HttpsError(
            'internal', 
            'An unexpected server error occurred. Please try again later.',
          );
        }
      }
    });
  };

  /**
   * A higher-order function that wraps a Firebase HTTP onRequest Function handler.
   * This is a simplified example for Express-style (req, res) handlers.
   *
   * Note: This is a placeholder for v1/v2 HTTP functions. The logic would be more complex,
   * involving Express middleware patterns. For this project, we primarily focus on `onCall`.
   * However, a basic implementation is provided for completeness.
   *
   * @param handler The core business logic of the HTTP function.
   * @returns An HTTP request handler function.
   */
  const onRequest = (
    handler: (req: https.Request, res: any) => Promise<void> | void,
  ): ((req: https.Request, res: any) => Promise<void>) => {
    return async (req: https.Request, res: any): Promise<void> => {
      try {
        await handler(req, res);
      } catch (error: unknown) {
        const requestContext = {
          functionName: process.env.FUNCTION_NAME || 'unknown_http_function',
          path: req.path,
          method: req.method,
        };

        if (error instanceof AppError) {
          logger.warn(error.message, { ...requestContext, ...error.context, statusCode: error.statusCode });
          const errorResponse = createErrorResponse(error.message, String(error.statusCode));
          res.status(error.statusCode).json(errorResponse);
        } else if (error instanceof Error) {
          logger.error('An unexpected error occurred in HTTP function.', error, requestContext);
          const errorResponse = createErrorResponse('An unexpected server error occurred.', '500');
          res.status(500).json(errorResponse);
        } else {
          logger.error(
            'An unexpected non-error object was thrown in HTTP function.',
            new Error(JSON.stringify(error)),
            requestContext
          );
          const errorResponse = createErrorResponse('An unexpected server error occurred.', '500');
          res.status(500).json(errorResponse);
        }
      }
    };
  };

  return { onCall, onRequest };
};

/**
 * A default, global error handler instance created with the base Firebase logger.
 * This can be used for quick setup in functions if a custom-configured logger is not needed.
 * It's generally recommended to create a specific logger and error handler for each service.
 */
const defaultLogger: ILogger = {
  info: (message: string, context?: object) => functionsLogger.info(message, context),
  warn: (message: string, context?: object) => functionsLogger.warn(message, context),
  error: (message: string, error?: Error, context?: object) => functionsLogger.error(message, { error, ...context }),
};

export const defaultErrorHandler = createErrorHandler(defaultLogger);