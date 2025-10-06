/**
 * Main entry point for all Firebase Functions for the Team & Schedule Management service.
 * This file should remain lean and only be used to export the functions defined
 * in the presentation layer. This approach keeps the codebase organized and scalable.
 *
 * @see /functions/src/presentation/http/teamFunctions.ts
 * @see /functions/src/presentation/http/eventFunctions.ts
 * @see /functions/src/presentation/events/firestore/eventTriggers.ts
 */

import "reflect-metadata";
import { setGlobalOptions } from "firebase-functions/v2";

// Import function handlers from the presentation layer
import * as teamFunctions from "./presentation/http/teamFunctions";
import * as eventFunctions from "./presentation/http/eventFunctions";
import * as eventTriggers from "./presentation/events/firestore/eventTriggers";

// Set global options for all functions, e.g., region.
// This helps in complying with data residency requirements like REQ-1-024.
// Assuming 'us-central1' as a default, but this can be parameterized.
setGlobalOptions({ region: "us-central1", maxInstances: 10 });

// --- Export Callable Functions (HTTPS API) ---
// These functions are invoked by client applications (Admin Web, Mobile App)
// and handle synchronous operations for team and event management.

export const createTeam = teamFunctions.createTeam;
export const updateTeam = teamFunctions.updateTeam;
export const deleteTeam = teamFunctions.deleteTeam;
export const addTeamMember = teamFunctions.addTeamMember;
export const removeTeamMember = teamFunctions.removeTeamMember;

export const createEvent = eventFunctions.createEvent;
export const updateEvent = eventFunctions.updateEvent;
export const deleteEvent = eventFunctions.deleteEvent;

// --- Export Trigger-based Functions (Background Processing) ---
// These functions are invoked by events within the Firebase ecosystem,
// such as new document creations in Firestore.

export const onEventCreated = eventTriggers.onEventCreated;

// To add more functions, define them in the presentation layer and export them here.