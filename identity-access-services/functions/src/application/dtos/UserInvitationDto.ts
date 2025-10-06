import * as z from "zod";

/**
 * Defines the schema for the data required to invite a new user to an organization.
 * This DTO is used to validate the input for the `inviteUser` callable function.
 *
 * Corresponds to requirement REQ-1-036, where an Admin invites a new user
 * by providing their email and assigning a role.
 */
export const UserInvitationSchema = z.object({
  /**
   * The email address of the user to be invited. An invitation link will be sent here.
   */
  email: z.string().email({ message: "Please enter a valid email address." }),

  /**
   * The role to be assigned to the new user.
   * Based on REQ-1-003, the primary assignable roles are 'Supervisor' and 'Subordinate'.
   * 'Admin' role is typically assigned only to the initial tenant creator.
   */
  role: z.enum(["Supervisor", "Subordinate"], {
    errorMap: () => ({ message: "A valid role ('Supervisor' or 'Subordinate') must be selected." }),
  }),
});

/**
 * The TypeScript type inferred from the UserInvitationSchema.
 * This provides static type checking for the user invitation data structure.
 */
export type UserInvitationDto = z.infer<typeof UserInvitationSchema>;