import * as z from "zod";

/**
 * REQ-1-031: The system shall enforce a mandatory password policy for all users.
 * Passwords must meet the following criteria: a minimum length of 8 characters,
 * at least one uppercase letter (A-Z), at least one lowercase letter (a-z),
 * at least one number (0-9), and at least one special character (e.g., !@#$%).
 */
const passwordSchema = z
  .string()
  .min(8, { message: "Password must be at least 8 characters long." })
  .regex(/[a-z]/, { message: "Password must contain at least one lowercase letter." })
  .regex(/[A-Z]/, { message: "Password must contain at least one uppercase letter." })
  .regex(/[0-9]/, { message: "Password must contain at least one number." })
  .regex(/[^a-zA-Z0-9]/, { message: "Password must contain at least one special character." });

/**
 * Defines the schema for the data required for an invited user to complete their registration.
 * This DTO is used to validate the input for the `completeRegistration` callable function.
 *
 * Corresponds to requirement REQ-1-037, where an invited user follows a registration link
 * and sets their password to activate their account.
 */
export const CompleteRegistrationSchema = z.object({
  /**
   * The unique, time-limited token from the user's invitation link.
   * This token is used to identify and validate the registration attempt.
   */
  token: z.string().min(1, { message: "Registration token is required." }),

  /**
   * The new password chosen by the user. It must adhere to the system's password policy.
   */
  password: passwordSchema,
});

/**
 * The TypeScript type inferred from the CompleteRegistrationSchema.
 * This provides static type checking for the registration completion data structure.
 */
export type CompleteRegistrationDto = z.infer<typeof CompleteRegistrationSchema>;