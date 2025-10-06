import { https, an } from 'firebase-functions/v1';
import { AuthenticatedContext, UnauthenticatedContext } from './context.types';

/**
 * @interface IContextUtils
 * @description Defines the contract for a utility that parses, validates, and provides a standardized
 * request context from various Firebase Function triggers. This ensures consistent and secure
 * access to authentication and tenancy information.
 *
 * This interface is a critical component for enforcing multi-tenancy and role-based access control
 * at the application layer, complementing Firestore security rules.
 *
 * @see {@link REQ-1-025} for multi-tenancy enforcement.
 * @see {@link REQ-1-068} for Role-Based Access Control (RBAC).
 */
export interface IContextUtils {
  /**
   * Parses the raw Firebase Function context (from either a Callable or HTTP trigger)
   * and returns a standardized, strongly-typed context object.
   *
   * For authenticated requests from callable functions, it validates the presence of
   * `uid`, `tenantId`, and `role` custom claims on the auth token.
   *
   * @param {https.CallableContext} context The raw context object from a Firebase Function trigger.
   * @returns {AuthenticatedContext} A standardized context object containing validated auth information.
   * @throws {AuthenticationError} If the context is missing the auth object or required custom claims (`uid`, `tenantId`, `role`).
   */
  getAuthenticatedContext(context: https.CallableContext): AuthenticatedContext;

  /**
   * Parses the raw Firebase Function context and returns a standardized context object,
   * allowing for both authenticated and unauthenticated states. This is useful for
   * public-facing functions or functions with optional authentication.
   *
   * @param {https.CallableContext} context The raw context object from a Firebase Function trigger.
   * @returns {AuthenticatedContext | UnauthenticatedContext} A standardized context object that is either authenticated or unauthenticated.
   */
  getContext(
    context: https.CallableContext,
  ): AuthenticatedContext | UnauthenticatedContext;
}