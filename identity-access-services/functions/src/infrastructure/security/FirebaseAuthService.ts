import * as admin from "firebase-admin";
import { IAuthService } from "../../domain/interfaces/IAuthService";
import { UserRecord } from "firebase-admin/auth";
import { injectable } from "tsyringe";
import { AppError } from "../../domain/errors/AppError";
import { ErrorCode } from "../../domain/errors/ErrorCode";

@injectable()
export class FirebaseAuthService implements IAuthService {
  private readonly auth: admin.auth.Auth;

  constructor() {
    if (!admin.apps.length) {
      admin.initializeApp();
    }
    this.auth = admin.auth();
  }

  /**
   * Creates a new user in Firebase Authentication.
   * @param email The user's email.
   * @param password The user's password.
   * @returns A promise that resolves with the new user's UID.
   * @throws {AppError} if the email is already in use or another error occurs.
   */
  async createUser(email: string, password?: string): Promise<{ uid: string }> {
    try {
      const userRecord = await this.auth.createUser({
        email,
        password,
        emailVerified: false, // Email verification can be a separate flow if needed
        disabled: false,
      });
      return { uid: userRecord.uid };
    } catch (error: any) {
      if (error.code === "auth/email-already-exists") {
        throw new AppError(ErrorCode.EmailAlreadyExists, "The email address is already in use by another account.");
      }
      throw new AppError(ErrorCode.AuthServiceError, "Failed to create user in authentication service.", error);
    }
  }

  /**
   * Sets custom claims for a user, which are embedded in their ID token.
   * This is a critical security operation.
   * @param uid The user's UID.
   * @param claims The claims to set (e.g., { tenantId: '...', role: '...' }).
   * @returns A promise that resolves when the claims are set.
   * @throws {AppError} if the user is not found or the operation fails.
   */
  async setCustomClaims(uid: string, claims: { [key: string]: any }): Promise<void> {
    try {
      await this.auth.setCustomUserClaims(uid, claims);
    } catch (error: any) {
      if (error.code === "auth/user-not-found") {
        throw new AppError(ErrorCode.UserNotFound, `User with UID ${uid} not found in authentication service.`);
      }
      throw new AppError(ErrorCode.AuthServiceError, "Failed to set custom claims.", error);
    }
  }

  /**
   * Revokes all refresh tokens for a given user, effectively logging them out of all devices.
   * @param uid The user's UID.
   * @returns A promise that resolves when tokens are revoked.
   * @throws {AppError} if the user is not found or the operation fails.
   */
  async revokeRefreshTokens(uid: string): Promise<void> {
    try {
      await this.auth.revokeRefreshTokens(uid);
    } catch (error: any) {
      if (error.code === "auth/user-not-found") {
        throw new AppError(ErrorCode.UserNotFound, `User with UID ${uid} not found in authentication service.`);
      }
      throw new AppError(ErrorCode.AuthServiceError, "Failed to revoke refresh tokens.", error);
    }
  }

  /**
   * Deletes a user from Firebase Authentication. This is an irreversible action.
   * @param uid The user's UID to delete.
   * @returns A promise that resolves on successful deletion.
   * @throws {AppError} if the operation fails.
   */
  async deleteUser(uid: string): Promise<void> {
    try {
      await this.auth.deleteUser(uid);
    } catch (error: any) {
      // User not found is not an error in this context, as the desired state is "user does not exist".
      if (error.code === "auth/user-not-found") {
        console.warn(`Attempted to delete non-existent auth user with UID: ${uid}`);
        return;
      }
      throw new AppError(ErrorCode.AuthServiceError, `Failed to delete auth user with UID: ${uid}`, error);
    }
  }

  /**
   * Retrieves a user record from Firebase Authentication by their email.
   * @param email The email of the user to retrieve.
   * @returns A promise that resolves with the UserRecord or null if not found.
   * @throws {AppError} for unexpected errors.
   */
  async getUserByEmail(email: string): Promise<UserRecord | null> {
    try {
      const userRecord = await this.auth.getUserByEmail(email);
      return userRecord;
    } catch (error: any) {
      if (error.code === "auth/user-not-found") {
        return null;
      }
      throw new AppError(ErrorCode.AuthServiceError, `Failed to get user by email from authentication service.`, error);
    }
  }

  /**
   * Updates a user's properties in Firebase Authentication.
   * @param uid The UID of the user to update.
   * @param properties The properties to update (e.g., password, disabled).
   * @returns A promise that resolves with the updated UserRecord.
   * @throws {AppError} if the user is not found or the update fails.
   */
  async updateUser(uid: string, properties: { password?: string; disabled?: boolean }): Promise<UserRecord> {
    try {
      const userRecord = await this.auth.updateUser(uid, properties);
      return userRecord;
    } catch (error: any) {
      if (error.code === "auth/user-not-found") {
        throw new AppError(ErrorCode.UserNotFound, `User with UID ${uid} not found in authentication service.`);
      }
      throw new AppError(ErrorCode.AuthServiceError, "Failed to update user in authentication service.", error);
    }
  }
}