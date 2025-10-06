import { inject, injectable } from "tsyringe";
import { ITeamRepository } from "../../../domain/repositories/ITeamRepository";
import { CreateTeamDto, TeamDto } from "../../dtos/TeamDtos";
import { AuthContext } from "../../services/AuthorizationService";
import { IAuthorizationService } from "../../services/IAuthorizationService";
import { IAuditLogService } from "../../services/IAuditLogService";
import { IUserRepository } from "../../../domain/repositories/IUserRepository";
import { Team } from "../../../domain/entities/Team";
import { AlreadyExistsError, NotFoundError, ValidationError } from "../../errors";
import { TeamMapper } from "../../../infrastructure/persistence/firestore/mappers/TeamMapper";
import * as admin from "firebase-admin";

@injectable()
export class CreateTeam {
  constructor(
    @inject("ITeamRepository") private teamRepository: ITeamRepository,
    @inject("IUserRepository") private userRepository: IUserRepository,
    @inject("IAuthorizationService") private authorizationService: IAuthorizationService,
    @inject("IAuditLogService") private auditLogService: IAuditLogService,
    @inject("Firestore") private firestore: admin.firestore.Firestore,
  ) {}

  async execute(input: CreateTeamDto, authContext: AuthContext): Promise<TeamDto> {
    this.authorizationService.requireAdmin(authContext);

    if (!input.name || input.name.trim().length < 3) {
      throw new ValidationError("Team name is required and must be at least 3 characters long.");
    }
    if (!input.supervisorId) {
      throw new ValidationError("A Supervisor must be assigned.");
    }

    const normalizedName = input.name.trim().toLowerCase();
    const existingTeam = await this.teamRepository.findByNameInTenant(normalizedName, authContext.tenantId);
    if (existingTeam) {
      throw new AlreadyExistsError("A team with this name already exists in your organization.");
    }

    const supervisor = await this.userRepository.findById(input.supervisorId, authContext.tenantId);
    if (!supervisor || (supervisor.role !== "Supervisor" && supervisor.role !== "Admin")) {
      throw new NotFoundError("The selected supervisor does not exist or is not eligible.");
    }

    const newTeam = new Team({
      name: input.name.trim(),
      tenantId: authContext.tenantId,
      supervisorId: supervisor.id,
      memberIds: [], // A new team starts with no members
    });

    const batch = this.firestore.batch();

    this.teamRepository.save(newTeam, batch);

    this.auditLogService.log(
      {
        actor: authContext,
        action: "team.create",
        target: { type: "team", id: newTeam.id },
        details: { name: newTeam.name, supervisorId: newTeam.supervisorId },
      },
      batch,
    );

    await batch.commit();

    return TeamMapper.toDto(newTeam);
  }
}