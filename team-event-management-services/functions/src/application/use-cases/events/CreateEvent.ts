import { inject, injectable } from "tsyringe";
import { IEventRepository } from "../../../domain/repositories/IEventRepository";
import { CreateEventDto, EventDto } from "../../dtos/EventDtos";
import { AuthContext } from "../../services/AuthorizationService";
import { IAuthorizationService } from "../../services/IAuthorizationService";
import { IAuditLogService } from "../../services/IAuditLogService";
import { IUserRepository } from "../../../domain/repositories/IUserRepository";
import { ITeamRepository } from "../../../domain/repositories/ITeamRepository";
import { Event } from "../../../domain/entities/Event";
import { NotFoundError, ValidationError } from "../../errors";
import { EventMapper } from "../../../infrastructure/persistence/firestore/mappers/EventMapper";
import * as admin from "firebase-admin";

@injectable()
export class CreateEvent {
  constructor(
    @inject("IEventRepository") private eventRepository: IEventRepository,
    @inject("IUserRepository") private userRepository: IUserRepository,
    @inject("ITeamRepository") private teamRepository: ITeamRepository,
    @inject("IAuthorizationService") private authorizationService: IAuthorizationService,
    @inject("IAuditLogService") private auditLogService: IAuditLogService,
    @inject("Firestore") private firestore: admin.firestore.Firestore,
  ) {}

  async execute(input: CreateEventDto, authContext: AuthContext): Promise<EventDto> {
    this.authorizationService.requireSupervisorOrAdmin(authContext);

    if (!input.title || input.title.trim().length === 0) {
      throw new ValidationError("Event title is required.");
    }
    if (!input.startTime || !input.endTime) {
      throw new ValidationError("Start and end times are required.");
    }
    if (new Date(input.startTime) >= new Date(input.endTime)) {
      throw new ValidationError("End time must be after start time.");
    }

    const assignedUserIds = input.assignedUserIds ?? [];
    const assignedTeamIds = input.assignedTeamIds ?? [];

    if (assignedUserIds.length > 0) {
      const users = await this.userRepository.findUsersByIds(assignedUserIds, authContext.tenantId);
      if (users.length !== assignedUserIds.length) {
        throw new NotFoundError("One or more assigned users were not found.");
      }
    }

    if (assignedTeamIds.length > 0) {
      const teams = await this.teamRepository.findTeamsByIds(assignedTeamIds, authContext.tenantId);
      if (teams.length !== assignedTeamIds.length) {
        throw new NotFoundError("One or more assigned teams were not found.");
      }
      // If caller is a supervisor, ensure they are allowed to assign to these teams
      if (authContext.role === "Supervisor") {
        for (const team of teams) {
          if (team.supervisorId !== authContext.uid) {
            throw new ValidationError(`You are not authorized to assign events to team '${team.name}'.`);
          }
        }
      }
    }

    const newEvent = new Event({
      tenantId: authContext.tenantId,
      createdByUserId: authContext.uid,
      title: input.title,
      description: input.description ?? "",
      startTime: new Date(input.startTime),
      endTime: new Date(input.endTime),
      assignedUserIds,
      assignedTeamIds,
      recurrenceRule: input.recurrenceRule,
    });

    // Note: If recurrenceRule is present, a separate triggered function
    // (`onEventCreated` trigger calling a recurrence expansion service)
    // will be responsible for creating the individual event instances.
    // This use case only creates the master event.

    const batch = this.firestore.batch();
    this.eventRepository.save(newEvent, batch);

    this.auditLogService.log(
      {
        actor: authContext,
        action: "event.create",
        target: { type: "event", id: newEvent.id },
        details: { eventTitle: newEvent.title, startTime: newEvent.startTime },
      },
      batch,
    );

    await batch.commit();

    return EventMapper.toDto(newEvent);
  }
}