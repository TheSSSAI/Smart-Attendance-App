import * as functions from 'firebase-functions';
import {
  AuthenticatedContext,
  FirebaseRequestContext,
} from './context.types';
import { IContextUtils } from './context.interface';
import { AuthenticationError, InvalidContextError } from '../errors/custom.errors';

/**
 * Implements the IContextUtils interface to provide utility functions for parsing
 * and validating Firebase Functions request contexts.
 * This ensures consistent and secure handling of user identity and tenancy information.
 *
 * @implements {IContextUtils}
 */
class ContextUtils implements IContextUtils {
  /**
   * Parses the raw context from a Firebase Function, validates the presence of required
   * authentication claims, and returns a standardized, typed context object.
   *
   * @param {functions.https.CallableContext} context The raw context object from a Firebase Callable Function.
   * @returns {FirebaseRequestContext} A standardized context object.
   * @throws {AuthenticationError} If the user is not authenticated.
   */
  public getContext(
    context: functions.https.CallableContext,
  ): FirebaseRequestContext {
    if (!context.auth) {
      // Unauthenticated context
      return {
        isAuthenticated: false,
        userId: undefined,
        tenantId: undefined,
        role: undefined,
      };
    }

    // Authenticated context, proceed with validation
    const { uid: userId } = context.auth;
    const { tenantId, role } = context.auth.token;

    if (!userId || !tenantId || !role) {
      throw new InvalidContextError(
        'Authentication token is missing required claims (tenantId, role).',
        {
          hasUserId: !!userId,
          hasTenantId: !!tenantId,
          hasRole: !!role,
        },
      );
    }

    return {
      isAuthenticated: true,
      userId,
      tenantId,
      role,
    };
  }

  /**
   * A stricter version of getContext that specifically requires an authenticated context.
   * It serves as a guard at the beginning of protected functions.
   *
   * @param {functions.https.CallableContext} context The raw context object from a Firebase Callable Function.
   * @returns {AuthenticatedContext} A standardized context object guaranteed to have auth properties.
   * @throws {AuthenticationError} If the user is not authenticated.
   * @throws {InvalidContextError} If required custom claims are missing.
   */
  public getAuthenticatedContext(
    context: functions.https.CallableContext,
  ): AuthenticatedContext {
    const parsedContext = this.getContext(context);

    if (!parsedContext.isAuthenticated) {
      throw new AuthenticationError('User is not authenticated.');
    }

    // Type assertion is safe here due to the isAuthenticated check and the logic in getContext
    return parsedContext as AuthenticatedContext;
  }
}

/**
 * Singleton instance of the ContextUtils.
 * This ensures that the utility functions are accessed through a single, consistent point.
 */
export const contextUtils = new ContextUtils();