/**
 * @file Defines the types and interfaces for the structured logging system.
 * These types ensure consistency in the data passed to the logger and the
 * structure of the final log entries sent to Google Cloud Logging.
 */

/**
 * Defines the severity levels for log entries, aligned with standard logging
 * practices and Google Cloud Logging's recognized severity levels.
 */
export type LogLevel = 'DEBUG' | 'INFO' | 'WARNING' | 'ERROR' | 'CRITICAL';

/**
 * A flexible type for passing additional structured metadata to the logger.
 * This allows any serializable object to be included in the log payload,
 * providing rich context for debugging and analysis.
 */
export type LogContext = Record<string, any>;

/**
 * Defines the structure of a log entry's service context, which provides
 * information about the source of the log.
 */
export interface ServiceContext {
  /**
   * The name of the service that generated the log entry (e.g., 'identity-service').
   */
  service: string;
  /**
   * The version of the service.
   */
  version?: string;
}

/**
 * Represents a structured log entry as it will be sent to Google Cloud Logging.
 * This structure is designed to be fully compatible with Cloud Logging's
 * features, including log-based metrics, alerting, and structured payload searching.
 * This directly supports REQ-1-076.
 */
export interface LogEntry {
  /**
   * The severity of the log message.
   */
  severity: LogLevel;

  /**
   * The primary log message.
   */
  message: string;

  /**
   * The context of the service producing the log.
   */
  serviceContext: ServiceContext;

  /**
   * Information about the HTTP request associated with the log entry, if any.
   */
  httpRequest?: {
    requestMethod?: string;
    requestUrl?: string;
    remoteIp?: string;
    userAgent?: string;
    status?: number;
  };

  /**
   * The authenticated user context associated with the log.
   */
  userContext?: {
    userId?: string;
    tenantId?: string;
    role?: string;
  };

  /**
   * The structured error payload, including stack trace.
   * This is critical for error reporting and alerting.
   */
  error?: {
    name: string;
    message: string;
    stack: string;
  };

  /**

   * The Google Cloud Trace ID, used to correlate logs across a single request.
   */
  trace?: string;

  /**
   * Any additional, arbitrary structured data to be included with the log.
   */
  context?: LogContext;
}