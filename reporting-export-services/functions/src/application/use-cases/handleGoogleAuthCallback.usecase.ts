import * as functions from "firebase-functions";
import { IUseCase } from "../ports/IUseCase";
import { IIntegrationRepository } from "../../domain/repositories/IIntegrationRepository";
import { IGoogleAuthClient } from "../../infrastructure/services/GoogleAuthClient";
import { ISecretManagerClient } from "../../infrastructure/services/SecretManagerClient";
import { IntegrationConfig } from "../../domain/entities/IntegrationConfig";
import { IGoogleSheetsClient } from "../../infrastructure/services/GoogleSheetsClient";

export interface HandleGoogleAuthCallbackInput {
    code: string;
    sheetId: string;
    tenantId: string;
    adminUserId: string;
}

/**
 * @implements {IUseCase<HandleGoogleAuthCallbackInput, void>}
 * @description Handles the server-side logic for the OAuth 2.0 callback from Google.
 * Exchanges the authorization code for tokens, securely stores the refresh token,
 * and creates the integration configuration in Firestore.
 * Supports requirements: REQ-1-058, REQ-1-066
 */
export class HandleGoogleAuthCallbackUseCase implements IUseCase<HandleGoogleAuthCallbackInput, void> {
    private readonly logger = functions.logger;

    constructor(
        private readonly integrationRepository: IIntegrationRepository,
        private readonly googleAuthClient: IGoogleAuthClient,
        private readonly secretManagerClient: ISecretManagerClient,
        private readonly googleSheetsClient: IGoogleSheetsClient,
    ) { }

    /**
     * Executes the OAuth callback logic.
     * @param {HandleGoogleAuthCallbackInput} input The input data from the client, containing the auth code and context.
     * @returns {Promise<void>} A promise that resolves on success or throws an HttpsError on failure.
     */
    async execute(input: HandleGoogleAuthCallbackInput): Promise<void> {
        const { code, sheetId, tenantId, adminUserId } = input;

        this.logger.info(`[HandleGoogleAuthCallbackUseCase] Starting OAuth callback for tenant ${tenantId}`, {
            tenantId,
            adminUserId,
            sheetId,
        });

        if (!code || !sheetId || !tenantId || !adminUserId) {
            this.logger.error("[HandleGoogleAuthCallbackUseCase] Missing required parameters.", { input });
            throw new functions.https.HttpsError("invalid-argument", "Missing required parameters for Google Auth callback.");
        }

        let refreshToken: string | null | undefined;
        try {
            // 1. Exchange authorization code for tokens
            const tokens = await this.googleAuthClient.exchangeCodeForTokens(code);
            refreshToken = tokens.refresh_token;

            if (!refreshToken) {
                this.logger.error("[HandleGoogleAuthCallbackUseCase] Refresh token was not provided by Google. The user may have already authorized the app.", { tenantId });
                throw new functions.https.HttpsError("permission-denied", "A refresh token was not granted. Please revoke app access in your Google account and try again.");
            }

            // Verify access to the sheet with the new access token
            await this.googleSheetsClient.verifySheetAccess(sheetId, tokens.access_token);
            this.logger.info(`[HandleGoogleAuthCallbackUseCase] Verified write access to sheet ${sheetId} for tenant ${tenantId}.`);

            // 2. Securely store the refresh token
            const secretName = this.googleAuthClient.getSecretName(tenantId, adminUserId);
            await this.secretManagerClient.setSecret(secretName, refreshToken);
            this.logger.info(`[HandleGoogleAuthCallbackUseCase] Securely stored refresh token for tenant ${tenantId} in secret: ${secretName}`);

            // 3. Create or update the integration configuration in Firestore
            const integrationConfig: IntegrationConfig = {
                id: adminUserId, // Using adminUserId as the document ID for simplicity
                tenantId,
                adminUserId,
                sheetId,
                status: "active",
                secretName: secretName,
                lastSyncTimestamp: new Date(), // Set to now to prevent old records from syncing on first run
            };
            await this.integrationRepository.save(integrationConfig);

            this.logger.info(`[HandleGoogleAuthCallbackUseCase] Successfully created/updated integration config for tenant ${tenantId}`);
        } catch (error: any) {
            this.logger.error(
                `[HandleGoogleAuthCallbackUseCase] Error during OAuth callback for tenant ${tenantId}`,
                {
                    tenantId,
                    adminUserId,
                    error: error.message,
                    stack: error.stack,
                },
            );

            // It's crucial to not leave a refresh token stored if the process fails.
            // Attempt to clean up the secret if it was created.
            if (refreshToken) {
                try {
                    const secretName = this.googleAuthClient.getSecretName(tenantId, adminUserId);
                    await this.secretManagerClient.deleteSecret(secretName);
                    this.logger.warn(`[HandleGoogleAuthCallbackUseCase] Cleaned up secret ${secretName} after failed setup.`);
                } catch (cleanupError: any) {
                    this.logger.error(`[HandleGoogleAuthCallbackUseCase] CRITICAL: Failed to clean up secret after error. Manual intervention required.`, {
                        secretName: this.googleAuthClient.getSecretName(tenantId, adminUserId),
                        originalError: error.message,
                        cleanupError: cleanupError.message,
                    });
                }
            }

            if (error instanceof functions.https.HttpsError) {
                throw error;
            }

            throw new functions.https.HttpsError("internal", "An unexpected error occurred while setting up Google Sheets integration.");
        }
    }
}