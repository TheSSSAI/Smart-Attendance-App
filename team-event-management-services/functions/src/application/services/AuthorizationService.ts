import { AuthContext } from "@/domain/auth/AuthContext";
import { Team } from "@/domain/entities/Team";
import { User } from "@/domain/entities/User";
import { injectable } from "inversify";
import "reflect-metadata";

export class AuthorizationError extends Error {
  constructor(message: string) {
    super(message);
    this.name = "AuthorizationError";
  }
}

export interface IAuthorizationService {
  requireAdmin(authContext: AuthContext): void;
  requireSupervisor(authContext: AuthContext): void;
  canManageTeam(authContext: AuthContext, team: Team): boolean;
  canManageUser(authContext: AuthContext, targetUser: User): boolean;
}

@injectable()
export class AuthorizationService implements IAuthorizationService {
  /**
   * Throws an AuthorizationError if the user is not an Admin.
   * @param authContext The user's authentication context.
   */
  requireAdmin(authContext: AuthContext): void {
    if (authContext.role !== "Admin") {
      throw new AuthorizationError("This action requires Admin privileges.");
    }
  }

  /**
   * Throws an AuthorizationError if the user is not a Supervisor or an Admin.
   * @param authContext The user's authentication context.
   */
  requireSupervisor(authContext: AuthContext): void {
    if (authContext.role !== "Supervisor" && authContext.role !== "Admin") {
      throw new AuthorizationError(
        "This action requires Supervisor or Admin privileges."
      );
    }
  }

  /**
   * Checks if a user has permission to manage a specific team.
   * Admins can manage any team. Supervisors can only manage teams they are assigned to.
   * @param authContext The user's authentication context.
   * @param team The target Team entity.
   * @returns True if the user can manage the team, false otherwise.
   */
  canManageTeam(authContext: AuthContext, team: Team): boolean {
    if (authContext.role === "Admin") {
      return true;
    }
    if (authContext.role === "Supervisor" && team.supervisorId === authContext.uid) {
      return true;
    }
    return false;
  }

  /**
   * Checks if a user has permission to manage a target user.
   * Admins can manage any user. Supervisors can manage their direct subordinates.
   * @param authContext The user's authentication context.
   * @param targetUser The target User entity.
   * @returns True if the user can manage the target user, false otherwise.
   */
  canManageUser(authContext: AuthContext, targetUser: User): boolean {
    if (authContext.role === "Admin") {
      return true;
    }
    if (authContext.role === "Supervisor" && targetUser.supervisorId === authContext.uid) {
        return true;
    }
    return false;
  }
}