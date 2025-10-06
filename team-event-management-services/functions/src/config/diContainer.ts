import {
  ITeamRepository,
  IEventRepository,
  IUserRepository,
} from "../domain/repositories";
import { HierarchyValidationService } from "../domain/services/HierarchyValidationService";
import {
  FirestoreTeamRepository,
  FirestoreEventRepository,
  FirestoreUserRepository,
} from "../infrastructure/persistence/firestore/repositories";
import { FirebaseFcmService } from "../infrastructure/services/FirebaseFcmService";
import { FirestoreAuditLogService } from "../infrastructure/services/FirestoreAuditLogService";
import { AuthorizationService } from "../application/services/AuthorizationService";
import { IAuditLogService } from "../application/services/IAuditLogService";
import { CreateTeam } from "../application/use-cases/teams/CreateTeam";
import { UpdateTeam } from "../application/use-cases/teams/UpdateTeam";
import { DeleteTeam } from "../application/use-cases/teams/DeleteTeam";
import { ManageTeamMembership } from "../application/use-cases/teams/ManageTeamMembership";
import { CreateEvent } from "../application/use-cases/events/CreateEvent";
import { SendEventNotification } from "../application/use-cases/notifications/SendEventNotification";
import { IFcmService } from "../domain/repositories/IFcmService";

type Factory<T> = () => T;

class DiContainer {
  private registry = new Map<string, Factory<any>>();

  public register<T>(token: string, factory: Factory<T>): void {
    this.registry.set(token, factory);
  }

  public resolve<T>(token: string): T {
    const factory = this.registry.get(token);
    if (!factory) {
      throw new Error(`No factory registered for token: ${token}`);
    }
    return factory();
  }
}

const diContainer = new DiContainer();

// Infrastructure Services (Singletons)
diContainer.register<ITeamRepository>(
  "ITeamRepository",
  () => new FirestoreTeamRepository(),
);
diContainer.register<IEventRepository>(
  "IEventRepository",
  () => new FirestoreEventRepository(),
);
diContainer.register<IUserRepository>(
  "IUserRepository",
  () => new FirestoreUserRepository(),
);
diContainer.register<IAuditLogService>(
  "IAuditLogService",
  () => new FirestoreAuditLogService(),
);
diContainer.register<IFcmService>(
  "IFcmService",
  () => new FirebaseFcmService(),
);

// Domain & Application Services (Singletons)
diContainer.register<HierarchyValidationService>("HierarchyValidationService", () => {
  const userRepository = diContainer.resolve<IUserRepository>("IUserRepository");
  return new HierarchyValidationService(userRepository);
});

diContainer.register<AuthorizationService>("AuthorizationService", () => {
  const teamRepository = diContainer.resolve<ITeamRepository>("ITeamRepository");
  return new AuthorizationService(teamRepository);
});

// Application Use Cases (Transients - new instance per resolution)
diContainer.register<CreateTeam>("CreateTeamUseCase", () => {
  return new CreateTeam(
    diContainer.resolve<ITeamRepository>("ITeamRepository"),
    diContainer.resolve<IUserRepository>("IUserRepository"),
    diContainer.resolve<IAuditLogService>("IAuditLogService"),
    diContainer.resolve<AuthorizationService>("AuthorizationService"),
  );
});

diContainer.register<UpdateTeam>("UpdateTeamUseCase", () => {
  return new UpdateTeam(
    diContainer.resolve<ITeamRepository>("ITeamRepository"),
    diContainer.resolve<IUserRepository>("IUserRepository"),
    diContainer.resolve<IAuditLogService>("IAuditLogService"),
    diContainer.resolve<AuthorizationService>("AuthorizationService"),
    diContainer.resolve<HierarchyValidationService>("HierarchyValidationService"),
  );
});

diContainer.register<DeleteTeam>("DeleteTeamUseCase", () => {
  return new DeleteTeam(
    diContainer.resolve<ITeamRepository>("ITeamRepository"),
    diContainer.resolve<IEventRepository>("IEventRepository"),
    diContainer.resolve<IUserRepository>("IUserRepository"),
    diContainer.resolve<IAuditLogService>("IAuditLogService"),
    diContainer.resolve<AuthorizationService>("AuthorizationService"),
  );
});

diContainer.register<ManageTeamMembership>("ManageTeamMembershipUseCase", () => {
  return new ManageTeamMembership(
    diContainer.resolve<ITeamRepository>("ITeamRepository"),
    diContainer.resolve<IUserRepository>("IUserRepository"),
    diContainer.resolve<IAuditLogService>("IAuditLogService"),
    diContainer.resolve<AuthorizationService>("AuthorizationService"),
  );
});

diContainer.register<CreateEvent>("CreateEventUseCase", () => {
  return new CreateEvent(
    diContainer.resolve<IEventRepository>("IEventRepository"),
    diContainer.resolve<IUserRepository>("IUserRepository"),
    diContainer.resolve<ITeamRepository>("ITeamRepository"),
    diContainer.resolve<IAuditLogService>("IAuditLogService"),
    diContainer.resolve<AuthorizationService>("AuthorizationService"),
  );
});

diContainer.register<SendEventNotification>("SendEventNotificationUseCase", () => {
  return new SendEventNotification(
    diContainer.resolve<IUserRepository>("IUserRepository"),
    diContainer.resolve<ITeamRepository>("ITeamRepository"),
    diContainer.resolve<IFcmService>("IFcmService"),
  );
});

export { diContainer };