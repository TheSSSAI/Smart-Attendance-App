/**
 * @file Defines the core types and interfaces for handling request context.
 * These types provide a standardized, type-safe representation of the caller's
 * identity and permissions, extracted from Firebase Function triggers.
 */

/**
 * Defines the possible user roles within the system, aligned with REQ-1-003.
 * Using a type alias provides type safety and autocompletion for role-based logic.
 */
export type UserRole = 'Admin' | 'Supervisor' | 'Subordinate';

/**
 * Represents the full, authenticated context of a request from a Firebase client.
 * This interface is used in protected functions where authentication is mandatory.
 * It guarantees the presence of `userId`, `tenantId`, and `role`.
 */
export interface AuthenticatedContext {
  /**
   * The unique Firebase Authentication UID of the user making the request.
   */
  readonly userId: string;

  /**
   * The unique ID of the tenant the user belongs to. This is critical for
   * enforcing multi-tenant data segregation, as per REQ-1-025.
   */
  readonly tenantId: string;

  /**
   * The role of the user, used for Role-Based Access Control (RBAC),
   * as per REQ-1-068.
   */
  readonly role: UserRole;
}

/**
 * Represents a general request context that may or may not be authenticated.
 * This is useful for public-facing functions or middleware that needs to
 * handle both authenticated and unauthenticated states.
 */
export interface FirebaseRequestContext {
  /**
   * The user's UID, if the request is authenticated. Otherwise, undefined.
   */
  readonly userId?: string;

  /**
   * The user's tenant ID, if the request is authenticated. Otherwise, undefined.
   */
  readonly tenantId?: string;

  /**
   * The user's role, if the request is authenticated. Otherwise, undefined.
   */
  readonly role?: UserRole;
}