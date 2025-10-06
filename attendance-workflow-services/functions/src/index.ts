/**
 * @fileoverview Main entry point for Firebase Cloud Functions deployment.
 * This file acts as the Composition Root for the serverless application. It imports all
 * function triggers defined in the presentation layer and exports them for deployment.
 * This approach keeps the root file clean and delegates the responsibility of function
 * definition and dependency injection to the respective trigger files, adhering to
 * the Single Responsibility Principle and Clean Architecture.
 *
 * @see callable.triggers.ts for user-invoked HTTPS functions.
 * @see firestore.triggers.ts for event-driven functions reacting to database changes.
 * @see scheduler.triggers.ts for time-based, scheduled job functions.
 */

import { initializeApp } from "firebase-admin/app";
import { setGlobalOptions } from "firebase-functions/v2";

// Import all defined function triggers from the presentation layer.
import * as callableTriggers from "./presentation/attendance/triggers/callable.triggers";
import * as firestoreTriggers from "./presentation/attendance/triggers/firestore.triggers";
import * as schedulerTriggers from "./presentation/attendance/triggers/scheduler.triggers";

// Initialize the Firebase Admin SDK. This must be done once per deployment.
// The SDK will automatically use the service account credentials provided by
// the Firebase runtime environment.
initializeApp();

// Set global options for all functions.
// This can be used to configure settings like region, memory, etc., for all functions
// defined in this file, promoting consistency.
// Example: setGlobalOptions({ region: "us-central1", memory: "256MiB" });
// Per REQ-1-024 (Data Residency), region might be set per-function in a multi-region
// architecture, but a default can be set here.
setGlobalOptions({ region: "us-central1" });


// Aggregate all imported functions into a single exports object.
// The Firebase CLI deployment tool looks for functions exported from this file.
// Using the spread syntax (...) is a clean and scalable way to combine functions
// from multiple files without having to list each one individually.
// This structure allows for clear separation of concerns based on trigger type.

export const attendance = {
  ...callableTriggers,
  ...firestoreTriggers,
  ...schedulerTriggers,
};