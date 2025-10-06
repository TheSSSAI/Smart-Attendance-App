import { inject, injectable } from "tsyringe";
import { ITeamRepository } from "../../../domain/repositories/ITeamRepository";
import { DeleteTeamDto } from "../../dtos/TeamDtos";
import { AuthContext } from "../../services/AuthorizationService";
import { IAuthorizationService } from "../../services/IAuthorizationService";
import { IAuditLogService } from "../../services/IAuditLogService";
import { NotFoundError, ValidationError } from "../../errors";
import { IUserRepository } from "../../../domain/repositories/IUserRepository";
import { IEventRepository } from "../../../domain/repositories/IEventRepository";
import * as admin from "firebase-admin";

@injectable()
export class DeleteTeam {
  constructor(
    @inject("ITeamRepository") private teamRepository: ITeamRepository,
    @inject("IUserRepository") private userRepository: IUserRepository,
    @inject("IEventRepository") private eventRepository: IEventRepository,
    @inject("IAuthorizationService") private authorizationService: IAuthorizationService,
    @inject("IAuditLogService") private auditLogService: IAuditLogService,
    @inject("Firestore") private firestore: admin.firestore.Firestore,
  ) {}

  async execute(input: DeleteTeamDto, authContext: AuthContext): Promise<void> {
    this.authorizationService.requireAdmin(authContext);

    if (!input.teamId) {
      throw new ValidationError("Team ID is required.");
    }

    const teamToDelete = await this.teamRepository.findById(input.teamId, authContext.tenantId);
    if (!teamToDelete) {
      throw new NotFoundError("Team not found.");
    }

    const batch = this.firestore.batch();

    // 1. Un-assign members from the team
    if (teamToDelete.memberIds.length > 0) {
      const members = await this.userRepository.findUsersByIds(teamToDelete.memberIds, authContext.tenantId);
      for (const member of members) {
        member.removeTeam(teamToDelete.id);
        this.userRepository.save(member, batch);
      }
    }

    // 2. Un-assign team from events
    const assignedEvents = await this.eventRepository.findEventsByTeamId(teamToDelete.id, authContext.tenantId);
    for (const event of assignedEvents) {
      event.unassignTeam(teamToDelete.id);
      this.eventRepository.save(event, batch);
    }

    // 3. Delete the team itself
    this.teamRepository.delete(teamToDelete.id, authContext.tenantId, batch);

    // 4. Log the deletion
    this.auditLogService.log(
      {
        actor: authContext,
        action: "team.delete",
        target: { type: "team", id: teamToDelete.id },
        details: { deletedTeam: { name: teamToDelete.name, supervisorId: teamToDelete.supervisorId } },
      },
      batch,
    );

    // 5. Commit all changes atomically
    await batch.commit();
  }
}