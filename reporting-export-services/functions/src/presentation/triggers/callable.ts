import * as functions from "firebase-functions";
import { HttpsError } from "firebase-functions/v2/https";
import { createContainer } from "../../config/di";
import { env } from "../../config/env";

/**
 * A callable Cloud Function that handles the server-side logic for the
 * OAuth 2.0 authorization code flow.
 *
 * It receives a one-time authorization code from the client, exchanges it
 * for a refresh token and access token, and securely stores the refresh token.
 * This implements the backend part of REQ-1-058.
 *
 * @throws {HttpsError} - 'unauthenticated' if the user is not logged in.
 * @throws {HttpsError} - 'permission-denied' if the user is not an Admin.
 * @throws {HttpsError} - 'invalid-argument' if the required data (authCode, sheetId) is missing.
 * @throws {HttpsError} - 'internal' for any unexpected server errors.
 */
export const handleGoogleAuthCallback = functions
  .region(env.firebase.region)
  .runWith({
    memory: "256MB",
    timeoutSeconds: 30,
    secrets: [env.secrets.googleClientSecretName],
  })
  .https.onCall(async (data, context) => {
    // 1. Authentication and Authorization Check
    if (!context.auth) {
      throw new HttpsError(
        "unauthenticated",
        "The function must be called while authenticated.",
      );
    }
    if (context.auth.token.role !== "Admin") {
      throw new HttpsError(
        "permission-denied",
        "Only Admins can set up integrations.",
      );
    }

    const { authCode, sheetId } = data;
    const tenantId = context.auth.token.tenantId;
    const adminUserId = context.auth.uid;

    // 2. Input Validation
    if (!authCode || typeof authCode !== "string") {
      throw new HttpsError(
        "invalid-argument",
        "The function must be called with a string 'authCode' argument.",
      );
    }
    if (!sheetId || typeof sheetId !== "string") {
      throw new HttpsError(
        "invalid-argument",
        "The function must be called with a string 'sheetId' argument.",
      );
    }
    if (!tenantId) {
      throw new HttpsError(
        "permission-denied",
        "Tenant ID is missing from the authentication token.",
      );
    }

    functions.logger.info(
      `Handling Google Auth Callback for tenant: ${tenantId}, admin: ${adminUserId}`,
    );

    try {
      // 3. Dependency Resolution and Use Case Execution
      const container = createContainer();
      const useCase = container.getHandleGoogleAuthCallbackUseCase();

      await useCase.execute({
        code: authCode,
        sheetId: sheetId,
        tenantId: tenantId,
        adminUserId: adminUserId,
      });

      functions.logger.info(
        `Successfully configured Google Sheets integration for tenant: ${tenantId}`,
      );
      return { success: true };
    } catch (error) {
      // 4. Error Handling
      functions.logger.error(
        `Error in handleGoogleAuthCallback for tenant ${tenantId}:`,
        error,
      );
      if (error instanceof HttpsError) {
        throw error; // Re-throw HttpsError instances directly
      }
      // For all other errors, throw a generic internal error to avoid leaking implementation details.
      throw new HttpsError(
        "internal",
        "An unexpected error occurred while setting up the integration.",
      );
    }
  });

/**
 * Placeholder for a callable function that could fetch aggregated report data.
 * This demonstrates how other callable functions would be structured.
 */
export const getReportData = functions
  .region(env.firebase.region)
  .https.onCall(async (data, context) => {
    if (!context.auth || context.auth.token.role !== "Admin") {
      throw new HttpsError(
        "permission-denied",
        "You must be an admin to access reports.",
      );
    }

    const tenantId = context.auth.token.tenantId;
    // const { reportType, dateRange } = data; // Example input

    try {
      const container = createContainer();
      const useCase = container.getGetAggregatedReportDataUseCase();
      const reportData = await useCase.execute({ tenantId });
      return reportData;
    } catch (error) {
      functions.logger.error(
        `Error fetching report data for tenant ${tenantId}:`,
        error,
      );
      throw new HttpsError(
        "internal",
        "Failed to retrieve report data.",
      );
    }
  });