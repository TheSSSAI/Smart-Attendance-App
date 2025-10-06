import * as functions from "firebase-functions";
import { onCall, HttpsError } from "firebase-functions/v2/https";
import { diContainer } from "../../config/diContainer";
import { CreateEvent } from "../../application/use-cases/events/CreateEvent";
import { CreateEventDto, EventDto } from "../../application/dtos/EventDtos";
import {
  ApplicationError,
  AuthorizationError,
  ValidationError,
  NotFoundError,
} from "../../application/errors";

const logger = functions.logger;

// Note: A more robust implementation would share this helper with teamFunctions.ts
// via a shared utility library. For this isolated example, it's duplicated.
function createCallableHandler<TRequest, TResponse>(
  useCaseToken: string,
  handler: (
    useCase: any,
    data: TRequest,
    context: functions.https.CallableContext
  ) => Promise<TResponse>,
) {
  return onCall(async (request: functions.https.Request<TRequest>) => {
    if (!request.auth) {
      logger.warn("Unauthenticated call attempted.", { useCaseToken });
      throw new HttpsError(
        "unauthenticated",
        "The function must be called while authenticated.",
      );
    }
    try {
      const useCase = diContainer.resolve<any>(useCaseToken);
      return await handler(useCase, request.data, request as any);
    } catch (error) {
      if (error instanceof ApplicationError) {
        logger.warn(`Application error in ${useCaseToken}:`, {
          error: error.message,
          data: request.data,
          auth: request.auth.uid,
        });
        if (error instanceof AuthorizationError) {
          throw new HttpsError("permission-denied", error.message);
        }
        if (error instanceof ValidationError) {
          throw new HttpsError("invalid-argument", error.message);
        }
        if (error instanceof NotFoundError) {
          throw new HttpsError("not-found", error.message);
        }
      }

      logger.error(`Unexpected error in ${useCaseToken}:`, {
        error,
        data: request.data,
        auth: request.auth.uid,
      });
      throw new HttpsError(
        "internal",
        "An unexpected error occurred. Please try again later.",
      );
    }
  });
}

/**
 * Creates a new event.
 * @param {CreateEventDto} data - The data for the new event, including assignments and recurrence.
 * @returns {Promise<EventDto>} The created event (or master event for a recurring series).
 * @throws {HttpsError} 'unauthenticated' if the user is not logged in.
 * @throws {HttpsError} 'permission-denied' if the user is not an Admin or Supervisor.
 * @throws {HttpsError} 'invalid-argument' if the input data is invalid.
 * @throws {HttpsError} 'not-found' if any assigned users or teams do not exist.
 */
export const createEvent = createCallableHandler<CreateEventDto, EventDto>(
  "CreateEventUseCase",
  async (useCase: CreateEvent, data, context) => {
    return useCase.execute(data, context.auth!);
  },
);

// In a full implementation, updateEvent and deleteEvent would also be defined here,
// following the same pattern. They would resolve their respective use cases
// (e.g., 'UpdateEventUseCase', 'DeleteEventUseCase') and execute them.

/*
// Example placeholder for updateEvent
export const updateEvent = createCallableHandler<UpdateEventDto, EventDto>(
    "UpdateEventUseCase",
    async (useCase: UpdateEvent, data, context) => {
        return useCase.execute(data, context.auth!);
    }
);

// Example placeholder for deleteEvent
export const deleteEvent = createCallableHandler<DeleteEventDto, void>(
    "DeleteEventUseCase",
    async (useCase: DeleteEvent, data, context) => {
        await useCase.execute(data, context.auth!);
    }
);
*/