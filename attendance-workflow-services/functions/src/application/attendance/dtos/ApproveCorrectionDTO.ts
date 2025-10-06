import { z } from "zod";
import * as functions from "firebase-functions";
import { CallableContext } from "firebase-functions/v1/https";

/**
 * Defines the shape of the actor (the authenticated user performing the action).
 * This is derived from the callable function's context.
 */
const ActorSchema = z.object({
  uid: z.string().min(1),
  role: z.string().min(1),
  tenantId: z.string().min(1),
});
type Actor = z.infer<typeof ActorSchema>;

/**
 * Zod schema for validating the input data for approving an attendance correction request.
 */
const ApproveCorrectionDataSchema = z.object({
  recordId: z.string().min(1, "recordId is required."),
});

/**
 * Data Transfer Object (DTO) for approving an attendance correction request.
 * This class encapsulates the data required for the ApproveCorrectionUseCase.
 * It includes validation logic to ensure data integrity at the application boundary.
 */
export class ApproveCorrectionDTO {
  /**
   * The unique identifier of the attendance record whose correction is being approved.
   */
  public readonly recordId: string;

  /**
   * The authenticated user performing the approval action.
   */
  public readonly actor: Actor;

  /**
   * Private constructor to enforce object creation through the static `create` method.
   * @param recordId - The ID of the attendance record.
   * @param actor - The user performing the action.
   */
  private constructor(recordId: string, actor: Actor) {
    this.recordId = recordId;
    this.actor = actor;
  }

  /**
   * Creates and validates an ApproveCorrectionDTO from the raw input of a callable function.
   * Throws an HttpsError if the data is invalid or the user is not authenticated.
   *
   * @param data - The raw data payload from the callable function call.
   * @param context - The context of the callable function, containing auth information.
   * @returns A validated instance of ApproveCorrectionDTO.
   */
  public static create(data: unknown, context: CallableContext): ApproveCorrectionDTO {
    if (!context.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "The function must be called while authenticated.",
      );
    }

    const validationResult = ApproveCorrectionDataSchema.safeParse(data);
    if (!validationResult.success) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Invalid data provided for attendance correction approval.",
        validationResult.error.format(),
      );
    }

    const validatedData = validationResult.data;
    const actor: Actor = {
      uid: context.auth.uid,
      role: context.auth.token.role || "",
      tenantId: context.auth.token.tenantId || "",
    };

    // Additional validation to ensure actor context is complete
    const actorValidation = ActorSchema.safeParse(actor);
    if (!actorValidation.success) {
      throw new functions.https.HttpsError(
        "failed-precondition",
        "User authentication token is missing required claims (role, tenantId).",
      );
    }

    return new ApproveCorrectionDTO(validatedData.recordId, actorValidation.data);
  }
}