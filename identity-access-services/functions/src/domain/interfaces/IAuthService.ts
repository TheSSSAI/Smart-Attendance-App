/**
 * @fileoverview Defines the contract for an Authentication service, abstracting the underlying identity provider (e.g., Firebase Auth).
 * This interface is a core component of the Domain layer, ensuring that the application's business logic
 * is decoupled from specific authentication infrastructure.
 *
 * @see REQ-1-033 for atomic user creation.
 * @see US-008 for session invalidation on deactivation.
 */

import { UserRecord } from "firebase-admin/auth";

/**
 * Represents the custom claims to be set on a user's authentication token.
 * These claims are fundamental to the system's RBAC and multi-tenancy security model.
 * @see REQ-1-021, REQ-1-025, REQ-1-064
 */
export interface CustomClaims {
  tenantId: string;
  role: 'Admin' | 'Supervisor' | 'Subordinate';
}

export interface IAuthService {
  /**
   * Creates a new user in the authentication provider.
   * @param email The user's email address.
   * @param password The user's password.
   * @returns A Promise that resolves with the newly created user's UID.
   * @throws Will throw an error if the user creation fails (e.g., email already exists).
   */
  createUser(email: string, password?: string): Promise<{ uid: string }>;

  /**
   * Deletes a user from the authentication provider.
   * This is a destructive action used for rolling back failed registrations.
   * @param uid The unique ID of the user to delete.
   * @returns A Promise that resolves when the user has been deleted.
   */
  deleteUser(uid: string): Promise<void>;

  /**
   * Sets custom claims on a user's authentication token.
   * This is a critical security operation that imbues the user's session with their
   * tenant and role information, which is then enforced by Firestore Security Rules.
   * @param uid The unique ID of the user.
   * @param claims The custom claims to set.
   * @returns A Promise that resolves when the claims have been set.
   */
  setCustomClaims(uid: string, claims: CustomClaims): Promise<void>;

  /**
   * Revokes all refresh tokens for a given user.
   * This effectively invalidates all active sessions for the user, forcing them to log in again.
   * Used for immediate access revocation upon deactivation.
   * @param uid The unique ID of the user.
   * @returns A Promise that resolves when the tokens have been revoked.
   */
  revokeRefreshTokens(uid: string): Promise<void>;

  /**
   * Retrieves a user record from the authentication provider by their UID.
   * @param uid The unique ID of the user to retrieve.
   * @returns A Promise that resolves with the UserRecord or null if not found.
   */
  getUser(uid: string): Promise<UserRecord | null>;

  /**
   * Disables or enables a user account in the authentication provider.
   * @param uid The unique ID of the user.
   * @param disabled The disabled state to set.
   * @returns A Promise that resolves when the user's disabled state is updated.
   */
  updateUserDisabledStatus(uid: string, disabled: boolean): Promise<void>;
}