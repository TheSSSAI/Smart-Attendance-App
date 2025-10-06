import { OAuth2Client } from "google-auth-library";
import { google } from "googleapis";
import { env } from "../../config/env";
import { ISecretManagerClient } from "./SecretManagerClient";
import * as functions from "firebase-functions";

/**
 * Interface defining the contract for a Google Authentication client.
 */
export interface IGoogleAuthClient {
  exchangeCodeForToken(code: string): Promise<{
    accessToken: string;
    refreshToken: string;
  }>;
  getAuthenticatedClient(refreshToken: string): Promise<OAuth2Client>;
}

/**
 * A client responsible for handling all OAuth 2.0 interactions with Google.
 */
export class GoogleAuthClient implements IGoogleAuthClient {
  private readonly secretManagerClient: ISecretManagerClient;

  constructor(secretManagerClient: ISecretManagerClient) {
    this.secretManagerClient = secretManagerClient;
  }

  /**
   * Exchanges a one-time authorization code for an access token and a refresh token.
   * @param {string} code The authorization code received from the client-side OAuth flow.
   * @returns {Promise<{ accessToken: string; refreshToken: string; }>} An object containing the tokens.
   * @throws {Error} If the token exchange fails.
   */
  public async exchangeCodeForToken(code: string): Promise<{
    accessToken: string;
    refreshToken: string;
  }> {
    const oAuth2Client = await this.createOAuth2Client();
    try {
      const { tokens } = await oAuth2Client.getToken(code);
      if (!tokens.refresh_token) {
        throw new Error(
          "Refresh token was not provided by Google. The user may have already granted consent.",
        );
      }
      if (!tokens.access_token) {
        throw new Error("Access token was not provided by Google.");
      }
      return {
        accessToken: tokens.access_token,
        refreshToken: tokens.refresh_token,
      };
    } catch (error: any) {
      functions.logger.error("Failed to exchange authorization code for tokens.", {
        error: error.message,
      });
      throw new Error(`Google token exchange failed: ${error.message}`);
    }
  }

  /**
   * Creates a fully authenticated OAuth2 client using a stored refresh token.
   * This client can be used to make authorized API calls to Google services.
   * @param {string} refreshToken The long-lived refresh token.
   * @returns {Promise<OAuth2Client>} A promise that resolves with an authenticated OAuth2Client.
   */
  public async getAuthenticatedClient(refreshToken: string): Promise<OAuth2Client> {
    const oAuth2Client = await this.createOAuth2Client();
    oAuth2Client.setCredentials({ refresh_token: refreshToken });
    return oAuth2Client;
  }

  /**
   * Private helper to create and configure a new OAuth2Client instance.
   * It securely fetches the client secret from Secret Manager.
   * @private
   * @returns {Promise<OAuth2Client>} A configured OAuth2Client instance.
   */
  private async createOAuth2Client(): Promise<OAuth2Client> {
    try {
      const clientSecret = await this.secretManagerClient.getSecret(env.googleClientSecretName);

      return new google.auth.OAuth2(
        env.googleClientId,
        clientSecret,
        env.googleOAuthRedirectUri,
      );
    } catch (error: any) {
      functions.logger.error("FATAL: Could not create OAuth2Client. Check secret manager configuration.", {
        secretName: env.googleClientSecretName,
        error: error.message,
      });
      throw new Error("Failed to initialize authentication client.");
    }
  }
}