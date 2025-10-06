import * as dotenv from "dotenv";
import * as path from "path";
import * as functions from "firebase-functions";

// Determine which .env file to load based on the environment
const envPath =
  process.env.NODE_ENV === "production"
    ? path.resolve(__dirname, "../../.env.production")
    : path.resolve(__dirname, "../../.env.development");

dotenv.config({ path: envPath });

/**
 * Interface for the application's environment configuration.
 */
interface EnvConfig {
  /** The Google Cloud Project ID. */
  gcpProjectId: string;
  /** The Client ID for the Google Cloud OAuth 2.0 Client. */
  googleClientId: string;
  /** The name of the secret in Google Secret Manager that holds the OAuth Client Secret. */
  googleClientSecretName: string;
  /** The redirect URI for the OAuth flow. Should be configured in GCP Console. */
  googleOAuthRedirectUri: string;
}

/**
 * Validates and retrieves environment variables.
 * Throws an error if a required environment variable is missing.
 *
 * @returns {EnvConfig} A validated configuration object.
 */
const getValidatedConfig = (): EnvConfig => {
  const config = {
    gcpProjectId: process.env.GCP_PROJECT_ID,
    googleClientId: process.env.GOOGLE_CLIENT_ID,
    googleClientSecretName: process.env.GOOGLE_CLIENT_SECRET_NAME,
    googleOAuthRedirectUri: process.env.GOOGLE_OAUTH_REDIRECT_URI,
  };

  const missingVars: string[] = [];
  for (const [key, value] of Object.entries(config)) {
    if (!value) {
      // Convert camelCase to SNAKE_CASE for the error message
      const envVarName = key.replace(/[A-Z]/g, (letter) => `_${letter}`).toUpperCase();
      missingVars.push(envVarName);
    }
  }

  if (missingVars.length > 0) {
    const errorMessage = `FATAL ERROR: Missing required environment variables: ${missingVars.join(
      ", ",
    )}. Please check your .env file or Cloud Function environment configuration.`;
    functions.logger.error(errorMessage);
    throw new Error(errorMessage);
  }

  return config as EnvConfig;
};

/**
 * A frozen, validated configuration object to be used throughout the application.
 * This ensures that the application fails fast if the environment is not configured correctly.
 */
export const env: EnvConfig = Object.freeze(getValidatedConfig());