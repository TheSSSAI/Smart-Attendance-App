import { z } from "zod";

// DTO for representing a Team in API responses
export const teamDtoSchema = z.object({
  id: z.string().uuid(),
  tenantId: z.string(),
  name: z.string(),
  supervisorId: z.string().uuid(),
  memberIds: z.array(z.string().uuid()),
});
export type TeamDto = z.infer<typeof teamDtoSchema>;


// DTO for creating a new Team
export const createTeamDtoSchema = z.object({
  name: z.string().min(3, "Team name must be at least 3 characters long.").max(100, "Team name must be 100 characters or less."),
  supervisorId: z.string().uuid("Invalid supervisor ID format."),
});
export type CreateTeamDto = z.infer<typeof createTeamDtoSchema>;


// DTO for updating an existing Team
export const updateTeamDtoSchema = z.object({
  teamId: z.string().uuid(),
  name: z.string().min(3).max(100).optional(),
  supervisorId: z.string().uuid().optional(),
});
export type UpdateTeamDto = z.infer<typeof updateTeamDtoSchema>;


// DTO for managing team membership
export const manageTeamMembershipActionSchema = z.enum(["add", "remove"]);
export const manageTeamMembershipDtoSchema = z.object({
  teamId: z.string().uuid("Invalid team ID format."),
  userId: z.string().uuid("Invalid user ID format."),
  action: manageTeamMembershipActionSchema,
});
export type ManageTeamMembershipDto = z.infer<typeof manageTeamMembershipDtoSchema>;