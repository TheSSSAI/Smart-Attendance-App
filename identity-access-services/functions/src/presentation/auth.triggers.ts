import * as functions from "firebase-functions/v2/identity";
import { UserRecord } from "firebase-admin/auth";
import { logger } from "firebase-functions";
import { IUserRepository } from "@/domain/interfaces/IUserRepository";
import { FirestoreUserRepository } from "@/infrastructure/persistence/FirestoreUserRepository";
import { User } from "@/domain/entities/User";
import { IAuthService } from "@/domain/interfaces/IAuthService";
import { FirebaseAuthService } from "@/infrastructure/security/FirebaseAuthService";

// Manual Dependency Injection at the module level for performance
// These instances can be reused across function invocations in the same container.
const userRepository: IUserRepository = new FirestoreUserRepository();
const authService: IAuthService = new FirebaseAuthService();

/**
 * beforeCreate Auth Trigger
 *
 * This blocking function runs before a new user is saved to Firebase Authentication.
 * Its primary responsibility is to enforce the tenant-specific or default password policy.
 * This is a critical security control as defined in REQ-1-031 and US-027.
 *
 * @param {functions.AuthBlockingEvent} event - The event payload from Firebase Auth.
 * @returns {Promise<void>} Throws an HttpsError if validation fails, blocking user creation.
 */
export const beforeCreate = functions.beforeUserCreated(async (event: functions.AuthBlockingEvent): Promise<void> => {
  logger.info(`beforeCreate trigger started for email: ${event.data.email}`);

  // TODO: Implement password policy check as per US-073 and REQ-1-031
  // This is a placeholder for a more complex implementation that would:
  // 1. Determine the tenantId for the new user. This is non-trivial.
  //    - For an invited user, it would involve looking up the user by email in Firestore to find their tenant.
  //    - For a new organization registration, a default policy would apply.
  // 2. Fetch the password policy for that tenant from Firestore.
  // 3. Validate event.data.password against the fetched policy.
  // 4. If invalid, throw a functions.HttpsError.
  //
  // Example (simplified):
  // const password = event.data.password;
  // if (!password || password.length < 8) {
  //   throw new functions.HttpsError(
  //     "invalid-argument",
  //     "Password must be at least 8 characters long."
  //   );
  // }

  logger.info(`beforeCreate trigger completed for email: ${event.data.email}`);
});

/**
 * beforeSignIn Auth Trigger
 *
 * This blocking function runs before a user is issued an ID token (i.e., completes a sign-in).
 * It enforces the business rule that only users with an 'active' status can log in,
 * fulfilling REQ-1-037 and US-010.
 *
 * @param {functions.AuthBlockingEvent} event - The event payload from Firebase Auth.
 * @returns {Promise<void>} Throws an HttpsError if the user is not active, blocking sign-in.
 */
export const beforeSignIn = functions.beforeUserSignedIn(async (event: functions.AuthBlockingEvent): Promise<void> => {
  const user: UserRecord = event.data;
  logger.info(`beforeSignIn trigger started for user UID: ${user.uid}`);

  try {
    const userProfile: User | null = await userRepository.findById(user.uid);

    if (!userProfile) {
      // This can happen during the very first sign-in of a new organization's admin,
      // as the Firestore document might not be created yet. We allow this to proceed.
      // The application logic should handle the final user state.
      // Also handles cases where a user might exist in Auth but not in Firestore due to an error.
      logger.warn(`beforeSignIn: User profile not found in Firestore for UID: ${user.uid}. Allowing sign-in to proceed for registration completion.`);
      return;
    }

    // Block login for any user whose status is not 'active'.
    if (userProfile.status !== "active") {
      logger.warn(`beforeSignIn: Blocking sign-in for user UID: ${user.uid} with status: ${userProfile.status}`);
      let errorMessage = "Your account is not active. Please contact your administrator.";
      if (userProfile.status === "deactivated") {
        errorMessage = "Your account has been deactivated. Please contact your administrator.";
      } else if (userProfile.status === "invited") {
        errorMessage = "Your account has not been activated yet. Please use the registration link sent to your email.";
      }

      // This specific error is recognized by Firebase Auth clients.
      throw new functions.HttpsError("permission-denied", errorMessage);
    }
    
    // If user is active, we check if their custom claims are set. If not, this is a good
    // place to refresh them to ensure they are up-to-date.
    const tenantIdClaim = user.customClaims?.tenantId;
    const roleClaim = user.customClaims?.role;

    if (userProfile.tenantId !== tenantIdClaim || userProfile.role !== roleClaim) {
        logger.info(`beforeSignIn: Custom claims for user ${user.uid} are outdated. Refreshing claims.`);
        await authService.setCustomClaims(user.uid, {
            tenantId: userProfile.tenantId,
            role: userProfile.role,
        });
    }


    logger.info(`beforeSignIn trigger completed successfully for user UID: ${user.uid}`);
  } catch (error: any) {
    logger.error(`beforeSignIn: Error processing user UID: ${user.uid}`, { error });
    // Re-throw HttpsError to block the user, otherwise throw a generic error.
    if (error instanceof functions.HttpsError) {
      throw error;
    }
    throw new functions.HttpsError("internal", "An unexpected error occurred during sign-in.");
  }
});