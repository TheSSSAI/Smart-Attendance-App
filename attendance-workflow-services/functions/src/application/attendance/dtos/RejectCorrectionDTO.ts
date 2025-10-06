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
 * Zod schema for validating the input data for rejecting an attendance correction request.
 * A reason is mandatory and must meet a minimum length requirement.
 */
const RejectCorrectionDataSchema = z.object({
  recordId: z.string().min(1, "recordId is required."),
  reason: z.string().min(10, "A rejection reason of at least 10 characters is required."),
});

/**
 * Data Transfer Object (DTO) for rejecting an attendance correction request.
 * This class encapsulates the data required for the RejectCorrectionUseCase.
 * It includes validation logic to ensure data integrity at the application boundary.
 */
export class RejectCorrectionDTO {
  /**
   * The unique identifier of the attendance record whose correction is being rejected.
   */
  public readonly recordId: string;

  /**
   * The justification provided by the supervisor for rejecting the correction request.
   */
  public readonly reason: string;

  /**
   * The authenticated user performing the rejection action.
   */
  public readonly actor: Actor;

  /**
   * Private constructor to enforce object creation through the static `create` method.
   * @param recordId - The ID of the attendance record.
   * @param reason - The reason for rejection.
   * @param actor - The user performing the action.
   */
  private constructor(recordId: string, reason: string, actor: Actor) {
    this.recordId = recordId;
    this.reason = reason;
    this.actor = actor;
  }

  /**
   * Creates and validates a RejectCorrectionDTO from the raw input of a callable function.
   * Throws an HttpsError if the data is invalid or the user is not authenticated.
   *
   * @param data - The raw data payload from the callable function call.
   * @param context - The context of the callable function, containing auth information.
   * @returns A validated instance of RejectCorrectionDTO.
   */
  public static create(data: unknown, context: CallableContext): RejectCorrectionDTO {
    if (!context.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "The function must be called while authenticated.",
      );
    }

    const validationResult = RejectCorrectionDataSchema.safeParse(data);
    if (!validationResult.success) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Invalid data provided for attendance correction rejection.",
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

    return new RejectCorrectionDTO(
      validatedData.recordId,
      validatedData.reason,
      actorValidation.data,
    );
  }
}