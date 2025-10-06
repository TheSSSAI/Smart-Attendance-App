/**
 * @fileoverview Defines the IntegrationConfig domain entity.
 * This entity encapsulates the state and behavior of a tenant's integration
 * with an external service, specifically Google Sheets for data export.
 * It follows Domain-Driven Design principles by including state transition logic.
 *
 * @see REQ-1-008, REQ-1-058, REQ-1-060
 */

/**
 * Represents the possible operational statuses of an integration configuration.
 * - 'active': The integration is configured and running correctly.
 * - 'error': The integration has encountered a persistent, non-transient error and requires manual intervention.
 * - 'pending_configuration': The initial setup has started but is not yet complete.
 */
export type IntegrationStatus = "active" | "error" | "pending_configuration";

/**
 * A flexible object structure to hold details about an integration error.
 */
export type ErrorDetails = {
  /** A machine-readable error code (e.g., 'PERMISSION_REVOKED', 'SHEET_NOT_FOUND'). */
  code: string;
  /** A user-friendly message explaining the error. */
  message: string;
  /** The timestamp when the error occurred. */
  timestamp: Date;
};

/**
 * Represents the configuration for a single tenant's Google Sheets integration.
 * This class is a domain entity, responsible for managing its own state.
 */
export class IntegrationConfig {
  /** The unique identifier for this configuration document. Often the ID of the Admin user who set it up. */
  public readonly id: string;
  /** The ID of the tenant this configuration belongs to. */
  public readonly tenantId: string;
  /** The ID of the Google Sheet to which data is exported. */
  public sheetId: string;
  /** The current operational status of the integration. */
  public status: IntegrationStatus;
  /** The timestamp of the last successfully exported record. Used as a cursor for subsequent runs. */
  public lastSyncTimestamp: Date | null;
  /** Details of the last error encountered, if any. */
  public errorDetails: ErrorDetails | null;
  /** The name of the secret in Google Secret Manager that stores the OAuth refresh token. */
  public readonly refreshTokenSecretName: string;

  /**
   * Constructs an instance of the IntegrationConfig entity.
   * @param id The unique identifier for the configuration.
   * @param tenantId The ID of the associated tenant.
   * @param sheetId The ID of the target Google Sheet.
   * @param status The initial status of the integration.
   * @param lastSyncTimestamp The timestamp of the last successful sync.
   * @param errorDetails Any existing error details.
   * @param refreshTokenSecretName The name of the secret holding the refresh token.
   */
  constructor(
    id: string,
    tenantId: string,
    sheetId: string,
    status: IntegrationStatus,
    lastSyncTimestamp: Date | null,
    errorDetails: ErrorDetails | null,
    refreshTokenSecretName: string,
  ) {
    if (!id || !tenantId || !refreshTokenSecretName) {
      throw new Error(
        "IntegrationConfig requires id, tenantId, and refreshTokenSecretName.",
      );
    }
    this.id = id;
    this.tenantId = tenantId;
    this.sheetId = sheetId;
    this.status = status;
    this.lastSyncTimestamp = lastSyncTimestamp;
    this.errorDetails = errorDetails;
    this.refreshTokenSecretName = refreshTokenSecretName;
  }

  /**
   * Marks the integration as having failed with a persistent error.
   * This is a state transition that should be triggered when an unrecoverable error occurs,
   * requiring administrator intervention.
   * @param code A machine-readable error code.
   * @param message A user-friendly explanation of the failure.
   * @see REQ-1-060
   */
  public markAsFailed(code: string, message: string): void {
    this.status = "error";
    this.errorDetails = {
      code,
      message,
      timestamp: new Date(),
    };
  }

  /**
   * Marks the integration as active, typically after a successful configuration
   * or recovery from an error state. This clears any previous error details.
   */
  public markAsActive(): void {
    this.status = "active";
    this.errorDetails = null;
  }

  /**
   * Updates the last successful synchronization timestamp.
   * This is critical for ensuring that subsequent export runs only process new data.
   * @param timestamp The timestamp of the last record that was successfully exported.
   * @see REQ-1-059
   */
  public updateSyncTimestamp(timestamp: Date): void {
    this.lastSyncTimestamp = timestamp;
  }

  /**
   * Updates the target Google Sheet ID.
   * This would be used during a recovery flow where the original sheet was deleted.
   * @param newSheetId The ID of the new Google Sheet.
   */
  public updateSheetId(newSheetId: string): void {
    if (!newSheetId) {
      throw new Error("Sheet ID cannot be empty.");
    }
    this.sheetId = newSheetId;
  }
}