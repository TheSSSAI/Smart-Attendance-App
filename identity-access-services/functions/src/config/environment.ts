import { SecretManagerServiceClient } from "@google-cloud/secret-manager";
import * as functions from "firebase-functions";
import * as dotenv from "dotenv";

// Load environment variables from .env.dev file in local development
if (process.env.FUNCTIONS_EMULATOR === "true") {
  dotenv.config({ path: ".env.dev" });
}

/**
 * Defines the structure of the application's environment configuration.
 * This interface ensures type safety for all configuration variables.
 */
interface Environment {
  isProduction: boolean;
  isEmulated: boolean;
  gcp: {
    projectId: string;
  };
  sendgrid: {
    apiKey: string;
  };
}

const client = new SecretManagerServiceClient();

/**
 * Asynchronously fetches a secret value from Google Secret Manager.
 * @param {string} name The name of the secret to fetch.
 * @return {Promise<string>} A promise that resolves with the secret's payload.
 * @throws {Error} If the secret cannot be accessed or does not exist.
 */
async function getSecret(name: string): Promise<string> {
  const projectId = process.env.GCP_PROJECT;
  if (!projectId) {
    throw new Error("GCP_PROJECT environment variable not set. Cannot fetch secrets.");
  }
  const [version] = await client.accessSecretVersion({
    name: `projects/${projectId}/secrets/${name}/versions/latest`,
  });

  const payload = version.payload?.data?.toString();
  if (!payload) {
    throw new Error(`Secret ${name} has no payload or could not be accessed.`);
  }

  return payload;
}

/**
 * Asynchronously loads the application configuration.
 * In a real GCP environment, it fetches secrets from Google Secret Manager.
 * In the local emulator, it falls back to environment variables (loaded from .env.dev).
 * This function is designed to be called once at application startup.
 *
 * Fulfills REQ-1-065: "The system must not store any secrets...in source code or environment variables.
 * All such secrets shall be stored in Google Secret Manager."
 *
 * @return {Promise<Environment>} A promise that resolves with the fully loaded configuration.
 */
async function loadEnvironment(): Promise<Environment> {
  const isEmulated = process.env.FUNCTIONS_EMULATOR === "true";
  const projectId = process.env.GCP_PROJECT || "demo-project"; // Default for emulator

  try {
    let sendgridApiKey: string;

    if (isEmulated) {
      functions.logger.info("Running in emulator mode, loading secrets from environment variables.");
      sendgridApiKey = process.env.SENDGRID_API_KEY || "";
      if (!sendgridApiKey) {
        throw new Error("SENDGRID_API_KEY is not set in your .env.dev file for local development.");
      }
    } else {
      functions.logger.info("Running in deployed environment, loading secrets from Google Secret Manager.");
      // The value here is the NAME of the secret in Secret Manager, not the key itself.
      sendgridApiKey = await getSecret("SENDGRID_API_KEY");
    }

    return {
      isProduction: !isEmulated,
      isEmulated: isEmulated,
      gcp: {
        projectId,
      },
      sendgrid: {
        apiKey: sendgridApiKey,
      },
    };
  } catch (error) {
    functions.logger.error("!!! FAILED TO LOAD ENVIRONMENT CONFIGURATION. FUNCTION CANNOT START. !!!", error);
    // Throwing an error at the top level will prevent the function from initializing,
    // which is the desired behavior if configuration is missing.
    throw new Error("Could not load environment configuration. See function logs for details.");
  }
}

/**
 * A promise that resolves with the loaded environment configuration.
 * By exporting the promise, we ensure that the async loading operation is
 * performed only once when the module is first imported.
 * Subsequent imports will receive the already resolved promise.
 */
export const environmentPromise: Promise<Environment> = loadEnvironment();