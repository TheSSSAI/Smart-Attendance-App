/**
 * @fileoverview Main entry point for Firebase Cloud Functions for the Identity & Access Management service.
 * This file aggregates all function triggers from the presentation layer and exports them for deployment.
 * It follows the Clean Architecture principle by separating the function definitions (presentation)
 * from this top-level export file.
 *
 * It also sets global options for all functions, such as the deployment region, to ensure consistency.
 *
 * @author [Your Name]
 * @version 1.0.0
 * @see auth.triggers.ts - for Firebase Auth event-triggered functions.
 * @see identity.callable.ts - for client-callable HTTPS functions.
 * @see maintenance.scheduled.ts - for scheduled, time-based functions.
 */

import { setGlobalOptions } from "firebase-functions/v2";
import * as authTriggers from "./presentation/auth.triggers";
import * as identityCallables from "./presentation/identity.callable";
import * as maintenanceScheduled from "./presentation/maintenance.scheduled";
import { environment } from "./config/environment";

// Set global options for all functions deployed from this file.
// This ensures consistency in deployment region, memory allocation, etc.
// The region is sourced from environment configuration to allow for different settings
// per environment (dev, staging, prod).
setGlobalOptions({ region: environment.region });

/**
 * Aggregates all cloud functions from the presentation layer into a single export
 * object that the Firebase CLI can deploy.
 *
 * This pattern keeps the root index file clean and focused on composition,
 * while the actual function logic resides in their respective trigger-type files
 * within the presentation layer.
 */
const identityAccessService = {
  ...authTriggers,
  ...identityCallables,
  ...maintenanceScheduled,
};

export { identityAccessService };