import { LogContext } from './logger.types';

/**
 * @interface ILogger
 * @description Defines the contract for a standardized, structured logger. Implementations of this
 * interface are responsible for producing logs in a format (e.g., JSON) that is compatible with
 * cloud logging services like Google Cloud Logging, enabling effective monitoring, searching,
 * and alerting.
 *
 * @see {@link REQ-1-076} for comprehensive monitoring and logging requirements.
 */
export interface ILogger {
  /**
   * Logs an informational message. This is used for general operational messages and to
   * track the flow of an application.
   *
   * @param {string} message The primary log message.
   * @param {LogContext} [context] Optional structured data to include in the log entry for additional context.
   */
  info(message: string, context?: LogContext): void;

  /**
   * Logs a warning message. This is used for events that are not necessarily errors but are
   * unexpected or could indicate a potential future problem.
   *
   * @param {string} message The primary warning message.
   * @param {LogContext} [context] Optional structured data to include in the log entry.
   */
  warn(message: string, context?: LogContext): void;

  /**
   * Logs an error message. This is used for runtime errors, exceptions, and failed operations.
   * The implementation must ensure that the Error object, including its stack trace, is
   * properly serialized to facilitate debugging and error rate alerting.
   *
   * @param {string} message A high-level description of the error.
   * @param {Error} error The caught exception or Error object.
   * @param {LogContext} [context] Optional structured data to provide more context about the state of the system when the error occurred.
   */
  error(message: string, error: Error, context?: LogContext): void;
}