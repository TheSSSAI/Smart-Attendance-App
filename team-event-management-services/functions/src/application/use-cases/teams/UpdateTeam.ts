import { inject, injectable } from "tsyringe";
import { ITeamRepository } from "../../../domain/repositories/ITeamRepository";
import { UpdateTeamDto, TeamDto } from "../../dtos/TeamDtos";
import { AuthContext } from "../../services/AuthorizationService";
import { IAuthorizationService } from "../../services/IAuthorizationService";
import { IAuditLogService } from "../../services/IAuditLogService";
import { IUserRepository } from "../../../domain/repositories/IUserRepository";
import { AlreadyExistsError, NotFoundError, ValidationError } from "../../errors";
import { TeamMapper } from "../../../infrastructure/persistence/firestore/mappers/TeamMapper";
import * as admin from "firebase-admin";

@injectable()
export class UpdateTeam {
  constructor(
    @inject("ITeamRepository") private teamRepository: ITeamRepository,
    @inject("IUserRepository") private userRepository: IUserRepository,
    @inject("IAuthorizationService") private authorizationService: IAuthorizationService,
    @inject("IAuditLogService") private auditLogService: IAuditLogService,
    @inject("Firestore") private firestore: admin.firestore.Firestore,
  ) {}

  async execute(input: UpdateTeamDto, authContext: AuthContext): Promise<TeamDto> {
    this.authorizationService.requireAdmin(authContext);

    if (!input.teamId) {
      throw new ValidationError("Team ID is required.");
    }

    const team = await this.teamRepository.findById(input.teamId, authContext.tenantId);
    if (!team) {
      throw new NotFoundError("Team not found.");
    }

    const oldValues = {
      name: team.name,
      supervisorId: team.supervisorId,
    };
    const newValues: Partial<typeof oldValues> = {};
    let hasChanges = false;

    if (input.name !== undefined && input.name.trim() !== team.name) {
      const trimmedName = input.name.trim();
      if (trimmedName.length < 3) {
        throw new ValidationError("Team name must be at least 3 characters long.");
      }
      const normalizedName = trimmedName.toLowerCase();
      const existingTeam = await this.teamRepository.findByNameInTenant(normalizedName, authContext.tenantId);
      if (existingTeam && existingTeam.id !== team.id) {
        throw new AlreadyExistsError("A team with this name already exists in your organization.");
      }
      team.name = trimmedName;
      newValues.name = trimmedName;
      hasChanges = true;
    }

    if (input.supervisorId !== undefined && input.supervisorId !== team.supervisorId) {
      const newSupervisor = await this.userRepository.findById(input.supervisorId, authContext.tenantId);
      if (!newSupervisor || (newSupervisor.role !== "Supervisor" && newSupervisor.role !== "Admin")) {
        throw new NotFoundError("The selected supervisor does not exist or is not eligible.");
      }
      team.supervisorId = newSupervisor.id;
      newValues.supervisorId = newSupervisor.id;
      hasChanges = true;
    }

    if (!hasChanges) {
      return TeamMapper.toDto(team); // No changes, no need to write to DB
    }

    const batch = this.firestore.batch();

    this.teamRepository.save(team, batch);

    this.auditLogService.log(
      {
        actor: authContext,
        action: "team.update",
        target: { type: "team", id: team.id },
        details: { oldValue: oldValues, newValue: newValues },
      },
      batch,
    );

    await batch.commit();

    return TeamMapper.toDto(team);
  }
}