/**
 * @fileoverview This is the entry point for all Firebase Cloud Functions for the
 * reporting-export-services microservice. It acts as the Composition Root for
 * the application, initializing dependencies and exporting the function triggers
 * to the Firebase runtime.
 *
 * This file adheres to the principle of a clean entry point:
 * 1. Initializes the Firebase Admin SDK.
 * 2. Creates the Dependency Injection (DI) container.
 * 3. Wires the DI container into the function trigger definitions from the
 *    presentation layer.
 * 4. Exports the configured functions for deployment.
 *
 * No business logic should reside in this file. Its sole responsibility is
 * application composition.
 */

import { setGlobalOptions } from "firebase-functions/v2";
import { initializeFirebaseApp } from "./config/firebase";
import { createContainer } from "./config/di";
import { handleOAuthCallback } from "./presentation/triggers/callable";
import { exportAttendanceToSheets } from "./presentation/triggers/scheduled";
import { env } from "./config/env";

// --- 1. One-time Initialization ---

// Initialize the Firebase Admin SDK. This is done once per instance.
initializeFirebaseApp();

// Set global options for all functions. This is a best practice for V2 functions
// to ensure consistent region, memory, and other settings.
// These settings can be overridden on a per-function basis if needed.
setGlobalOptions({
  region: env.GCP_REGION,
  memory: "256MiB", // Default memory for functions
});

// --- 2. Create Dependency Injection Container ---

// The DI container is created once and passed to the function triggers.
// This allows for dependency injection and makes the underlying business logic
// testable by decoupling it from the Firebase runtime.
const container = createContainer();

// --- 3. Wire Triggers and Export Functions ---

// Callable function for handling the server-side OAuth 2.0 flow.
// This is the secure backend endpoint that the admin dashboard calls
// after the user grants consent on Google's consent screen.
// Corresponds to REQ-1-058.
export const handleoauthattendance = handleOAuthCallback(container);

// Scheduled function for the main data export job.
// This function is triggered by Google Cloud Scheduler to periodically export
// approved attendance records to Google Sheets for all configured tenants.
// Corresponds to REQ-1-008, REQ-1-059, REQ-1-060.
export const exportattendancetosheets = exportAttendanceToSheets(container);