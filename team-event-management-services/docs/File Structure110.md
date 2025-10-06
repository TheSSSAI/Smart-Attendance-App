# 1 Dependency Levels

## 1.1 Level

### 1.1.1 Level

🔹 0

### 1.1.2 Files

- functions/src/domain/entities/Team.ts
- functions/src/domain/entities/Event.ts
- functions/src/application/dtos/TeamDtos.ts
- functions/src/application/dtos/EventDtos.ts
- functions/src/application/services/IAuditLogService.ts

## 1.2.0 Level

### 1.2.1 Level

🔹 1

### 1.2.2 Files

- functions/src/domain/repositories/ITeamRepository.ts
- functions/src/domain/repositories/IEventRepository.ts
- functions/src/domain/repositories/IUserRepository.ts

## 1.3.0 Level

### 1.3.1 Level

🔹 2

### 1.3.2 Files

- functions/src/domain/services/HierarchyValidationService.ts
- functions/src/infrastructure/persistence/firestore/mappers/TeamMapper.ts
- functions/src/infrastructure/persistence/firestore/mappers/EventMapper.ts

## 1.4.0 Level

### 1.4.1 Level

🔹 3

### 1.4.2 Files

- functions/src/infrastructure/persistence/firestore/repositories/FirestoreTeamRepository.ts
- functions/src/infrastructure/persistence/firestore/repositories/FirestoreEventRepository.ts
- functions/src/infrastructure/persistence/firestore/repositories/FirestoreUserRepository.ts
- functions/src/infrastructure/services/FirebaseFcmService.ts
- functions/src/infrastructure/services/FirestoreAuditLogService.ts
- functions/src/application/services/AuthorizationService.ts

## 1.5.0 Level

### 1.5.1 Level

🔹 4

### 1.5.2 Files

- functions/src/application/use-cases/teams/CreateTeam.ts
- functions/src/application/use-cases/teams/UpdateTeam.ts
- functions/src/application/use-cases/teams/DeleteTeam.ts
- functions/src/application/use-cases/teams/ManageTeamMembership.ts
- functions/src/application/use-cases/events/CreateEvent.ts
- functions/src/application/use-cases/notifications/SendEventNotification.ts

## 1.6.0 Level

### 1.6.1 Level

🔹 5

### 1.6.2 Files

- functions/src/config/diContainer.ts
- functions/src/presentation/http/teamFunctions.ts
- functions/src/presentation/http/eventFunctions.ts
- functions/src/presentation/events/firestore/eventTriggers.ts

## 1.7.0 Level

### 1.7.1 Level

🔹 6

### 1.7.2 Files

- functions/src/index.ts
- .editorconfig
- .firebaserc
- .gitignore
- .prettierrc
- firebase.json
- functions/.env.example
- functions/.eslintrc.js
- functions/.nvmrc
- functions/.vscode/settings.json
- functions/jest.config.js
- functions/package.json
- functions/tsconfig.json

# 2.0.0 Total Files

41

# 3.0.0 Generation Order

- 0
- 1
- 2
- 3
- 4
- 5
- 6

