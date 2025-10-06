import { Logging } from '@google-cloud/logging';
import { ILogger } from './logger.interface';
import { LogContext } from './logger.types';

// List of keys to redact from log context to prevent sensitive data leakage.
const SENSITIVE_KEYS = [
  'password',
  'token',
  'apiKey',
  'secret',
  'authorization',
  'credential',
];

/**
 * A structured logger implementation that wraps the Google Cloud Logging SDK.
 * It produces structured JSON logs compatible with Google Cloud's Operations Suite,
 * facilitating advanced filtering, monitoring, and alerting.
 *
 * @implements {ILogger}
 */
export class StructuredLogger implements ILogger {
  private readonly logging: Logging;
  private readonly logName = 'attendance-app-logs'; // A common log name for all services

  /**
   * @param serviceName The name of the service using the logger (e.g., 'identity-service').
   * This is included in every log entry for easy filtering.
   */
  constructor(private readonly serviceName: string) {
    // In a GCP environment, the project ID and credentials are automatically configured.
    this.logging = new Logging();
  }

  /**
   * Logs an informational message.
   * @param message The main log message.
   * @param context Optional structured data to include in the log entry.
   */
  public info(message: string, context?: LogContext): void {
    this.writeLog('INFO', message, context);
  }

  /**
   * Logs a warning message.
   * @param message The main warning message.
   * @param context Optional structured data to include in the log entry.
   */
  public warn(message: string, context?: LogContext): void {
    this.writeLog('WARNING', message, context);
  }

  /**
   * Logs an error message, including details from the caught exception.
   * @param message A high-level description of the error.
   * @param error The caught Error object.
   * @param context Optional structured data to include in the log entry.
   */
  public error(message: string, error: Error, context?: LogContext): void {
    const errorContext = {
      ...context,
      error: {
        name: error.name,
        message: error.message,
        stack: error.stack,
      },
    };
    this.writeLog('ERROR', message, errorContext);
  }

  /**
   * Sanitizes a context object by removing or redacting sensitive information.
   * @param context The context object to sanitize.
   * @returns A sanitized copy of the context object.
   */
  private sanitizeContext(context: LogContext): LogContext {
    const sanitizedContext: LogContext = {};
    for (const key in context) {
      if (Object.prototype.hasOwnProperty.call(context, key)) {
        if (
          SENSITIVE_KEYS.some(sensitiveKey =>
            key.toLowerCase().includes(sensitiveKey),
          )
        ) {
          sanitizedContext[key] = '[REDACTED]';
        } else if (
          typeof context[key] === 'object' &&
          context[key] !== null &&
          !Array.isArray(context[key])
        ) {
          sanitizedContext[key] = this.sanitizeContext(
            context[key] as LogContext,
          );
        } else {
          sanitizedContext[key] = context[key];
        }
      }
    }
    return sanitizedContext;
  }

  /**
   * Formats and writes the log entry to Google Cloud Logging.
   * @param severity The severity of the log entry (e.g., 'INFO', 'ERROR').
   * @param message The primary log message.
   * @param context Optional structured data.
   */
  private writeLog(
    severity: 'INFO' | 'WARNING' | 'ERROR' | 'DEBUG' | 'CRITICAL',
    message: string,
    context?: LogContext,
  ): void {
    const log = this.logging.log(this.logName);

    const payload = {
      service: this.serviceName,
      message,
      ...(context ? this.sanitizeContext(context) : {}),
    };

    const metadata = {
      resource: { type: 'cloud_function' },
      severity,
    };

    const entry = log.entry(metadata, payload);

    // Asynchronous write. We don't await this to prevent blocking the function's
    // execution. The library handles background sending and retries.
    log.write(entry).catch(err => {
      // Fallback to console.error if Google Cloud Logging fails.
      console.error('Failed to write to Google Cloud Logging:', err);
      console.error('Original Log Payload:', JSON.stringify(payload, null, 2));
    });
  }
}