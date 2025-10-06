import { sheets_v4, google } from "googleapis";
import { OAuth2Client } from "google-auth-library";
import * as functions from "firebase-functions";

/**
 * Custom error for when a requested Google Sheet is not found.
 */
export class SheetNotFoundError extends Error {
  constructor(message: string) {
    super(message);
    this.name = "SheetNotFoundError";
  }
}

/**
 * Custom error for when permissions are insufficient to access a Google Sheet.
 */
export class SheetPermissionError extends Error {
  constructor(message: string) {
    super(message);
    this.name = "SheetPermissionError";
  }
}

/**
 * Interface defining the contract for a Google Sheets client.
 * This allows for mocking and dependency inversion.
 */
export interface IGoogleSheetsClient {
  appendData(sheetId: string, data: string[][]): Promise<void>;
  validateSheetAccess(sheetId: string): Promise<void>;
}

/**
 * A client wrapper for all interactions with the Google Sheets API.
 * It encapsulates API calls and translates errors into application-specific exceptions.
 */
export class GoogleSheetsClient implements IGoogleSheetsClient {
  private readonly sheets: sheets_v4.Sheets;

  /**
   * Constructs a new GoogleSheetsClient.
   * @param {OAuth2Client} authClient An authenticated OAuth2 client instance.
   */
  constructor(authClient: OAuth2Client) {
    this.sheets = google.sheets({ version: "v4", auth: authClient });
  }

  /**
   * Appends rows of data to a specified Google Sheet.
   * It appends data to the first sheet ('A1' notation) in the first available rows.
   *
   * @param {string} sheetId The ID of the target Google Sheet.
   * @param {string[][]} data A 2D array of strings representing rows and cells.
   * @throws {SheetNotFoundError} If the sheet with the given ID cannot be found.
   * @throws {SheetPermissionError} If the authenticated user lacks permission.
   * @throws {Error} For other unexpected API errors.
   */
  public async appendData(sheetId: string, data: string[][]): Promise<void> {
    if (data.length === 0) {
      functions.logger.info(`No data to append for sheetId: ${sheetId}. Skipping.`);
      return;
    }

    try {
      await this.sheets.spreadsheets.values.append({
        spreadsheetId: sheetId,
        range: "A1", // Appends to the first empty row of the first sheet
        valueInputOption: "USER_ENTERED", // Parses values as if a user typed them
        insertDataOption: "INSERT_ROWS",
        requestBody: {
          values: data,
        },
      });
      functions.logger.info(`Successfully appended ${data.length} rows to sheetId: ${sheetId}.`);
    } catch (error: any) {
      this.handleApiError(error, sheetId);
    }
  }

  /**
   * Validates that the client has write access to the specified sheet by attempting a small, non-destructive read.
   * @param {string} sheetId The ID of the sheet to validate.
   * @throws {SheetNotFoundError} If the sheet doesn't exist.
   * @throws {SheetPermissionError} If access is denied.
   * @throws {Error} For other errors.
   */
  public async validateSheetAccess(sheetId: string): Promise<void> {
    try {
      await this.sheets.spreadsheets.values.get({
        spreadsheetId: sheetId,
        range: "A1:A1", // A small, non-intrusive read to check permissions
      });
      functions.logger.info(`Successfully validated access to sheetId: ${sheetId}.`);
    } catch (error: any) {
      this.handleApiError(error, sheetId);
    }
  }

  /**
   * A helper method to parse Google API errors and throw application-specific exceptions.
   * @param {any} error The error object from the googleapis library.
   * @param {string} sheetId The sheet ID involved in the error, for logging.
   */
  private handleApiError(error: any, sheetId: string): never {
    const statusCode = error.response?.status;
    const errorMessage = error.message || "An unknown error occurred with the Google Sheets API.";
    functions.logger.error(`Google Sheets API Error for sheetId ${sheetId}:`, {
      statusCode,
      message: errorMessage,
      errorDetails: error.response?.data?.error,
    });

    if (statusCode === 404) {
      throw new SheetNotFoundError(`The Google Sheet with ID '${sheetId}' was not found.`);
    }
    if (statusCode === 403) {
      throw new SheetPermissionError(
        `Permission denied for Google Sheet with ID '${sheetId}'. The token may be revoked or permissions may have changed.`,
      );
    }

    throw new Error(`Google Sheets API request failed: ${errorMessage}`);
  }
}