import { inject, injectable } from "tsyringe";
import { ITeamRepository } from "../../../domain/repositories/ITeamRepository";
import { ManageTeamMembershipDto } from "../../dtos/TeamDtos";
import { AuthContext } from "../../services/AuthorizationService";
import { IAuthorizationService } from "../../services/IAuthorizationService";
import { IAuditLogService } from "../../services/IAuditLogService";
import { NotFoundError, ValidationError } from "../../errors";
import { IUserRepository } from "../../../domain/repositories/IUserRepository";
import * as admin from "firebase-admin";

@injectable()
export class ManageTeamMembership {
  constructor(
    @inject("ITeamRepository") private teamRepository: ITeamRepository,
    @inject("IUserRepository") private userRepository: IUserRepository,
    @inject("IAuthorizationService") private authorizationService: IAuthorizationService,
    @inject("IAuditLogService") private auditLogService: IAuditLogService,
    @inject("Firestore") private firestore: admin.firestore.Firestore,
  ) {}

  async execute(input: ManageTeamMembershipDto, authContext: AuthContext): Promise<void> {
    const { teamId, userId, action } = input;
    if (!teamId || !userId || !action) {
      throw new ValidationError("Team ID, User ID, and action ('add' or 'remove') are required.");
    }

    const team = await this.teamRepository.findById(teamId, authContext.tenantId);
    if (!team) {
      throw new NotFoundError("Team not found.");
    }

    // Authorization: Must be an Admin or the team's designated supervisor.
    this.authorizationService.canManageTeam(authContext, team);

    const user = await this.userRepository.findById(userId, authContext.tenantId);
    if (!user) {
      throw new NotFoundError("User not found.");
    }

    if (user.role !== "Subordinate") {
      throw new ValidationError("Only users with the 'Subordinate' role can be managed as team members.");
    }

    const batch = this.firestore.batch();
    let auditAction: "team.member.add" | "team.member.remove";

    if (action === "add") {
      auditAction = "team.member.add";
      team.addMember(user.id);
      user.addTeam(team.id);
    } else if (action === "remove") {
      auditAction = "team.member.remove";
      team.removeMember(user.id);
      user.removeTeam(team.id);
    } else {
      throw new ValidationError("Invalid action. Must be 'add' or 'remove'.");
    }

    // Save both updated entities
    this.teamRepository.save(team, batch);
    this.userRepository.save(user, batch);

    // Log the action
    this.auditLogService.log(
      {
        actor: authContext,
        action: auditAction,
        target: { type: "team", id: team.id },
        details: {
          teamName: team.name,
          affectedUserId: user.id,
          affectedUserName: user.fullName ?? user.email,
        },
      },
      batch,
    );

    await batch.commit();
  }
}