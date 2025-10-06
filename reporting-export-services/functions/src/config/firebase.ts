import * as admin from "firebase-admin";
import { getFirestore } from "firebase-admin/firestore";
import { logger } from "firebase-functions/v2";
import { env } from "./env";

/**
 * Initializes the Firebase Admin SDK.
 * This function ensures that the SDK is initialized only once, making it safe
 * to call from multiple places. It uses service account credentials for
 * authentication, which are automatically available in the Firebase/GCP runtime.
 */
const initializeFirebaseApp = () => {
  if (admin.apps.length === 0) {
    logger.info("Initializing Firebase Admin SDK...");
    admin.initializeApp({
      // Credentials are automatically sourced from the environment in production.
      // For local development with emulators, the GOOGLE_APPLICATION_CREDENTIALS
      // environment variable should be set.
    });
    logger.info("Firebase Admin SDK initialized successfully.");
  } else {
    logger.info("Firebase Admin SDK already initialized.");
  }
};

// Initialize the app when the module is loaded.
initializeFirebaseApp();

/**
 * The initialized Firebase Admin SDK instance.
 * Use this for interacting with Firebase services like Auth.
 */
export const firebaseAdmin = admin;

/**
 * The initialized Firestore database instance.
 * Use this for all database operations. It is configured to handle Timestamp
 * objects correctly.
 */
export const db = getFirestore();

// Apply Firestore settings if needed. This is a good place to configure them globally.
db.settings({
  ignoreUndefinedProperties: true, // Recommended for Cloud Functions to avoid crashes on undefined fields
});

logger.info(
  `Firebase configured for project: ${
    env.GCP_PROJECT || "unknown (local emulator?)"
  }`,
);