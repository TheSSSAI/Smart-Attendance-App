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
 * Defines the schema for the data required to register a new organization tenant.
 * This DTO is used to validate the input for the `registerOrganization` callable function.
 *
 * Corresponds to requirements:
 * - REQ-1-032: Public registration for a new organization's first Admin.
 * - REQ-1-033: Atomic creation of tenant, user, and custom claims.
 * - REQ-1-024 / US-003: Support for data residency selection during tenant creation.
 */
export const TenantRegistrationSchema = z.object({
  /**
   * The desired name for the new organization. Must be globally unique.
   * Validated for uniqueness on the server-side.
   */
  orgName: z.string().min(3, { message: "Organization name must be at least 3 characters long." }).max(100),

  /**
   * The full name of the initial administrator for the new tenant.
   */
  adminName: z.string().min(2, { message: "Your name must be at least 2 characters long." }).max(100),

  /**
   * The email address for the initial administrator. This will be their login username.
   */
  email: z.string().email({ message: "Please enter a valid email address." }),

  /**
   * The password for the initial administrator account. Must meet complexity requirements.
   */
  password: passwordSchema,

  /**
   * The selected GCP region for data residency, fulfilling REQ-1-024.
   * This is a permanent choice made at the time of tenant creation.
   * The value must be one of the supported region identifiers (e.g., 'europe-west1').
   */
  region: z.string().min(1, { message: "Data residency region is required." }),
});

/**
 * The TypeScript type inferred from the TenantRegistrationSchema.
 * This provides static type checking for the tenant registration data structure.
 */
export type TenantRegistrationDto = z.infer<typeof TenantRegistrationSchema>;