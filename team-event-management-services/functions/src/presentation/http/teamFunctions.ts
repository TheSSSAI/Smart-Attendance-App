import * as functions from "firebase-functions";
import { onCall, HttpsError } from "firebase-functions/v2/https";
import { diContainer } from "../../config/diContainer";
import { CreateTeam } from "../../application/use-cases/teams/CreateTeam";
import { UpdateTeam } from "../../application/use-cases/teams/UpdateTeam";
import { DeleteTeam } from "../../application/use-cases/teams/DeleteTeam";
import { ManageTeamMembership } from "../../application/use-cases/teams/ManageTeamMembership";
import {
  CreateTeamDto,
  UpdateTeamDto,
  DeleteTeamDto,
  ManageTeamMembershipDto,
  TeamDto,
} from "../../application/dtos/TeamDtos";
import {
  ApplicationError,
  AuthorizationError,
  ValidationError,
  NotFoundError,
  AlreadyExistsError,
} from "../../application/errors";

const logger = functions.logger;

/**
 * A helper function to handle common callable function logic like authentication checks and error mapping.
 * @param useCaseToken The token for the use case to resolve from the DI container.
 * @param handler The core logic to execute.
 * @returns A callable function handler.
 */
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
        if (error instanceof AlreadyExistsError) {
          throw new HttpsError("already-exists", error.message);
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
 * Creates a new team within the organization.
 * @param {CreateTeamDto} data - The data for the new team.
 * @returns {Promise<TeamDto>} The created team.
 * @throws {HttpsError} 'unauthenticated' if the user is not logged in.
 * @throws {HttpsError} 'permission-denied' if the user is not an Admin.
 * @throws {HttpsError} 'invalid-argument' if the input data is invalid.
 * @throws {HttpsError} 'already-exists' if a team with the same name already exists.
 */
export const createTeam = createCallableHandler<CreateTeamDto, TeamDto>(
  "CreateTeamUseCase",
  async (useCase: CreateTeam, data, context) => {
    return useCase.execute(data, context.auth!);
  },
);

/**
 * Updates an existing team's name or supervisor.
 * @param {UpdateTeamDto} data - The data to update the team with.
 * @returns {Promise<TeamDto>} The updated team.
 * @throws {HttpsError} 'unauthenticated' if the user is not logged in.
 * @throws {HttpsError} 'permission-denied' if the user is not an Admin.
 * @throws {HttpsError} 'invalid-argument' if the input data is invalid or creates a circular dependency.
 * @throws {HttpsError} 'not-found' if the team or specified supervisor does not exist.
 */
export const updateTeam = createCallableHandler<UpdateTeamDto, TeamDto>(
  "UpdateTeamUseCase",
  async (useCase: UpdateTeam, data, context) => {
    return useCase.execute(data, context.auth!);
  },
);

/**
 * Deletes an existing team.
 * @param {DeleteTeamDto} data - The ID of the team to delete.
 * @returns {Promise<void>}
 * @throws {HttpsError} 'unauthenticated' if the user is not logged in.
 * @throws {HttpsError} 'permission-denied' if the user is not an Admin.
 * @throws {HttpsError} 'not-found' if the team does not exist.
 */
export const deleteTeam = createCallableHandler<DeleteTeamDto, void>(
  "DeleteTeamUseCase",
  async (useCase: DeleteTeam, data, context) => {
    await useCase.execute(data, context.auth!);
  },
);

/**
 * Adds or removes a member from a team.
 * @param {ManageTeamMembershipDto} data - The details of the membership change.
 * @returns {Promise<void>}
 * @throws {HttpsError} 'unauthenticated' if the user is not logged in.
 * @throws {HttpsError} 'permission-denied' if the user is not an Admin or the team's supervisor.
 * @throws {HttpsError} 'not-found' if the team or user does not exist.
 * @throws {HttpsError} 'invalid-argument' if the action is invalid (e.g., adding an existing member).
 */
export const manageTeamMembership = createCallableHandler<
  ManageTeamMembershipDto,
  void
>("ManageTeamMembershipUseCase", async (useCase: ManageTeamMembership, data, context) => {
  await useCase.execute(data, context.auth!);
});