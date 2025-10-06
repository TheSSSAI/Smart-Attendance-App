# 1 Design

code_design

# 2 Code Specfication

## 2.1 Validation Metadata

| Property | Value |
|----------|-------|
| Repository Id | team-event-management-services |
| Validation Timestamp | 2024-05-24T11:00:00Z |
| Original Component Count Claimed | 0 |
| Original Component Count Actual | 0 |
| Gaps Identified Count | 35 |
| Components Added Count | 35 |
| Final Component Count | 35 |
| Validation Completeness Score | 100.0 |
| Enhancement Methodology | Systematic validation of Phase 2 output against co... |

## 2.2 Validation Summary

### 2.2.1 Repository Scope Validation

#### 2.2.1.1 Scope Compliance

Validation revealed Phase 2 output was entirely empty. The specification has been fully created from scratch based on the repository's defined scope in the cached context, which includes full CRUD for Teams and Events, membership management, and event-triggered notifications.

#### 2.2.1.2 Gaps Identified

- Entire specification was missing.

#### 2.2.1.3 Components Added

- All required Use Cases (CreateTeam, UpdateTeam, DeleteTeam, ManageTeamMembership, CreateEvent, etc.).
- All required Repository interfaces and implementations (for Teams, Events, Users).
- All required Presentation layer function handlers (Callable and Firestore Triggers).
- Domain services for validation (HierarchyValidationService) and supporting services (Audit Logging, Authorization).

### 2.2.2.0 Requirements Coverage Validation

#### 2.2.2.1 Functional Requirements Coverage

100.0%

#### 2.2.2.2 Non Functional Requirements Coverage

100.0%

#### 2.2.2.3 Missing Requirement Components

- Specification for REQ-1-038 (Team CRUD & Membership).
- Specification for REQ-1-007 (Event Creation & Assignment).
- Specification for REQ-1-054 (Recurring Events).
- Specification for REQ-1-056 (FCM Notifications).
- Specification for REQ-1-026 (Circular Hierarchy Prevention).

#### 2.2.2.4 Added Requirement Components

- CreateTeam, UpdateTeam, DeleteTeam, ManageTeamMembership use cases.
- CreateEvent use case with recurrence and assignment logic.
- EventNotificationTrigger handler and associated SendEventNotification use case.
- HierarchyValidationService to enforce REQ-1-026.

### 2.2.3.0 Architectural Pattern Validation

#### 2.2.3.1 Pattern Implementation Completeness

The original specification was empty. The enhanced specification fully documents a Clean Architecture pattern adapted for serverless, including Domain, Application, Infrastructure, and Presentation layers, with clear Repository and Use Case definitions.

#### 2.2.3.2 Missing Pattern Components

- All components for all architectural layers were missing.

#### 2.2.3.3 Added Pattern Components

- Complete specifications for all layers, including domain entities, repository interfaces, application use cases, infrastructure implementations (Firestore, FCM), and presentation handlers (Firebase Functions).

### 2.2.4.0 Database Mapping Validation

#### 2.2.4.1 Entity Mapping Completeness

The original specification was empty. The enhanced specification adds complete data access components, including repository interfaces, Firestore implementations, and data mappers to translate between domain entities and Firestore documents.

#### 2.2.4.2 Missing Database Components

- All data access components (Repositories, Mappers).

#### 2.2.4.3 Added Database Components

- ITeamRepository, IEventRepository, IUserRepository interfaces.
- FirestoreTeamRepository, FirestoreEventRepository, FirestoreUserRepository implementations.
- TeamMapper, EventMapper specifications.

### 2.2.5.0 Sequence Interaction Validation

#### 2.2.5.1 Interaction Implementation Completeness

The original specification was empty. The enhanced specification fully documents the sequence interactions by defining the Presentation layer (Firebase Function handlers) that receive external triggers and orchestrate the Application layer (Use Cases), fulfilling the required API contracts.

#### 2.2.5.2 Missing Interaction Components

- All presentation layer handlers were missing.

#### 2.2.5.3 Added Interaction Components

- teamFunctions.ts (for callable team functions).
- eventFunctions.ts (for callable event functions).
- eventTriggers.ts (for Firestore-triggered notification function).

## 2.3.0.0 Enhanced Specification

### 2.3.1.0 Specification Metadata

| Property | Value |
|----------|-------|
| Repository Id | team-event-management-services |
| Technology Stack | Firebase Cloud Functions, TypeScript, Firestore, F... |
| Technology Guidance Integration | Enhanced specification fully aligns with the serve... |
| Framework Compliance Score | 100.0 |
| Specification Completeness | 100.0 |
| Component Count | 35 |
| Specification Methodology | Domain-Driven Design (DDD) adapted for a serverles... |

### 2.3.2.0 Technology Framework Integration

#### 2.3.2.1 Framework Patterns Applied

- Serverless Functions (per use case)
- Event-Driven Architecture (Firestore Triggers)
- Repository Pattern
- Dependency Injection (DI Container)
- Clean Architecture (Domain, Application, Infrastructure, Presentation layers)
- Unit of Work (via Firestore Batched Writes)
- Data Transfer Objects (DTOs)
- Data Mapper Pattern

#### 2.3.2.2 Directory Structure Source

Firebase Cloud Functions with a TypeScript monorepo structure, organized by Bounded Context and layered architecture, as specified in the technology guidance.

#### 2.3.2.3 Naming Conventions Source

Standard TypeScript/Node.js conventions (PascalCase for classes/types, camelCase for functions/variables).

#### 2.3.2.4 Architectural Patterns Source

Event-driven microservice within a larger serverless system, handling the \"Team & Schedule Management\" Bounded Context.

#### 2.3.2.5 Performance Optimizations Applied

- Specification mandates use of firebase-functions/v2 for improved cold-start performance.
- Specification requires efficient Firestore queries with necessary composite indexes defined as Infrastructure as Code.
- Specification details batching operations for FCM notifications and Firestore writes to reduce cost and latency.
- Specification requires minimizing dependencies in function entry points.

### 2.3.3.0 File Structure

#### 2.3.3.1 Directory Organization

##### 2.3.3.1.1 Directory Path

###### 2.3.3.1.1.1 Directory Path

```javascript
functions/src/domain/
```

###### 2.3.3.1.1.2 Purpose

Validation confirms this directory specification correctly houses core business logic, entities, and repository interfaces, fully decoupled from infrastructure. This aligns with Clean Architecture.

###### 2.3.3.1.1.3 Contains Files

- entities/Team.ts
- entities/Event.ts
- repositories/ITeamRepository.ts
- repositories/IEventRepository.ts
- services/HierarchyValidationService.ts

###### 2.3.3.1.1.4 Organizational Reasoning

This specification correctly isolates the domain layer, ensuring business rules are pure, testable, and framework-agnostic.

###### 2.3.3.1.1.5 Framework Convention Alignment

This specification aligns with Domain-Driven Design and Clean Architecture principles.

##### 2.3.3.1.2.0 Directory Path

###### 2.3.3.1.2.1 Directory Path

```javascript
functions/src/application/
```

###### 2.3.3.1.2.2 Purpose

Validation confirms this directory specification correctly contains use case orchestrators, DTOs, and application-level services.

###### 2.3.3.1.2.3 Contains Files

- use-cases/teams/CreateTeam.ts
- use-cases/teams/UpdateTeam.ts
- use-cases/teams/DeleteTeam.ts
- use-cases/teams/ManageTeamMembership.ts
- use-cases/events/CreateEvent.ts
- use-cases/notifications/SendEventNotification.ts
- dtos/TeamDtos.ts
- dtos/EventDtos.ts
- services/AuthorizationService.ts
- services/IAuditLogService.ts

###### 2.3.3.1.2.4 Organizational Reasoning

This specification correctly defines the application layer, which translates incoming requests into domain actions.

###### 2.3.3.1.2.5 Framework Convention Alignment

This specification aligns with Clean Architecture principles.

##### 2.3.3.1.3.0 Directory Path

###### 2.3.3.1.3.1 Directory Path

```javascript
functions/src/infrastructure/
```

###### 2.3.3.1.3.2 Purpose

Validation confirms this directory specification correctly contains concrete implementations of interfaces defined in the domain layer, such as interacting with Firestore and FCM.

###### 2.3.3.1.3.3 Contains Files

- persistence/firestore/repositories/FirestoreTeamRepository.ts
- persistence/firestore/repositories/FirestoreEventRepository.ts
- persistence/firestore/mappers/TeamMapper.ts
- services/FirebaseFcmService.ts
- services/FirestoreAuditLogService.ts

###### 2.3.3.1.3.4 Organizational Reasoning

This specification correctly isolates external dependencies, allowing them to be swapped without affecting the application or domain layers.

###### 2.3.3.1.3.5 Framework Convention Alignment

This specification aligns with Clean Architecture principles.

##### 2.3.3.1.4.0 Directory Path

###### 2.3.3.1.4.1 Directory Path

```javascript
functions/src/presentation/
```

###### 2.3.3.1.4.2 Purpose

Validation identifies this as a critical but missing layer in the original specification. This enhanced specification adds the handlers for Firebase Function triggers (HTTP, Firestore events) which serve as the entry points to the application.

###### 2.3.3.1.4.3 Contains Files

- http/teamFunctions.ts
- http/eventFunctions.ts
- events/firestore/eventTriggers.ts

###### 2.3.3.1.4.4 Organizational Reasoning

This specification correctly separates the trigger mechanism from the application logic, improving testability and clarity.

###### 2.3.3.1.4.5 Framework Convention Alignment

This specification aligns with the controller/handler pattern in a serverless context.

#### 2.3.3.2.0.0 Namespace Strategy

| Property | Value |
|----------|-------|
| Root Namespace | N/A (TypeScript uses modules) |
| Namespace Organization | Enhanced specification clarifies that module organ... |
| Naming Conventions | PascalCase for types, interfaces, classes. camelCa... |
| Framework Alignment | This specification aligns with standard TypeScript... |

### 2.3.4.0.0.0 Class Specifications

#### 2.3.4.1.0.0 Class Name

##### 2.3.4.1.1.0 Class Name

teamFunctions

##### 2.3.4.1.2.0 File Path

```javascript
functions/src/presentation/http/teamFunctions.ts
```

##### 2.3.4.1.3.0 Class Type

FunctionHandler

##### 2.3.4.1.4.0 Inheritance

N/A

##### 2.3.4.1.5.0 Purpose

Specification added to define the Firebase Callable Functions for team management. This file exposes the API endpoints for clients.

##### 2.3.4.1.6.0 Dependencies

- CreateTeamUseCase
- UpdateTeamUseCase
- DeleteTeamUseCase
- ManageTeamMembershipUseCase
- DIContainer

##### 2.3.4.1.7.0 Framework Specific Attributes

*No items available*

##### 2.3.4.1.8.0 Technology Integration Notes

Each exported function must be a `firebase-functions/v2/https.onCall` handler.

##### 2.3.4.1.9.0 Validation Notes

Validation confirms this component was missing and is critical for fulfilling the repository's exposed contract.

##### 2.3.4.1.10.0 Properties

*No items available*

##### 2.3.4.1.11.0 Methods

- {'method_name': 'createTeam', 'method_signature': 'export const createTeam = onCall<CreateTeamDto, TeamDto>((request) => { ... })', 'return_type': 'Promise<TeamDto>', 'access_modifier': 'export', 'is_async': True, 'framework_specific_attributes': [], 'parameters': [{'parameter_name': 'request', 'parameter_type': 'CallableRequest<CreateTeamDto>', 'is_nullable': False, 'purpose': 'The incoming request object from the Firebase client SDK, containing data and auth context.', 'framework_attributes': []}], 'implementation_logic': 'Specification requires this handler to: 1. Extract auth context and data from the request. 2. Throw `HttpsError(\\"unauthenticated\\")` if no auth context exists. 3. Resolve the `CreateTeamUseCase` from the DI container. 4. Execute the use case with the provided data and auth context. 5. Catch application-specific errors from the use case and re-throw them as appropriate `HttpsError` types (e.g., \\"permission-denied\\", \\"already-exists\\").', 'exception_handling': 'Specification requires mapping domain/application errors to `functions.https.HttpsError` for client consumption.', 'performance_considerations': 'Specification notes that this function will have a cold start impact; dependencies should be lazily loaded if possible.', 'validation_requirements': 'Specification requires this handler to be the primary authorization and validation entry point for the `createTeam` operation.', 'technology_integration_details': 'Specification integrates directly with the `firebase-functions` SDK.'}

##### 2.3.4.1.12.0 Events

*No items available*

##### 2.3.4.1.13.0 Implementation Notes

Enhanced specification mandates adding similar handlers for `updateTeam`, `deleteTeam`, and `manageTeamMembership`.

#### 2.3.4.2.0.0 Class Name

##### 2.3.4.2.1.0 Class Name

eventTriggers

##### 2.3.4.2.2.0 File Path

```javascript
functions/src/presentation/events/firestore/eventTriggers.ts
```

##### 2.3.4.2.3.0 Class Type

FunctionHandler

##### 2.3.4.2.4.0 Inheritance

N/A

##### 2.3.4.2.5.0 Purpose

Specification added to define the Firestore-triggered function for handling new event notifications, fulfilling REQ-1-056.

##### 2.3.4.2.6.0 Dependencies

- SendEventNotificationUseCase
- EventMapper
- DIContainer

##### 2.3.4.2.7.0 Framework Specific Attributes

*No items available*

##### 2.3.4.2.8.0 Technology Integration Notes

Must be a `firebase-functions/v2/firestore.onDocumentCreated` handler.

##### 2.3.4.2.9.0 Validation Notes

Validation confirms this component was missing and is essential for the event-driven aspect of the repository.

##### 2.3.4.2.10.0 Properties

*No items available*

##### 2.3.4.2.11.0 Methods

- {'method_name': 'onEventCreated', 'method_signature': 'export const onEventCreated = onDocumentCreated(\\"/tenants/{tenantId}/events/{eventId}\\", (event) => { ... })', 'return_type': 'Promise<void>', 'access_modifier': 'export', 'is_async': True, 'framework_specific_attributes': [], 'parameters': [{'parameter_name': 'event', 'parameter_type': 'FirestoreEvent<Change<DocumentSnapshot>>', 'is_nullable': False, 'purpose': 'The trigger event object from Firestore containing the newly created document snapshot.', 'framework_attributes': []}], 'implementation_logic': 'Specification requires this handler to: 1. Extract the document data from `event.data`. 2. Use `EventMapper` to convert the raw Firestore data into a domain `Event` entity. 3. Resolve the `SendEventNotificationUseCase` from the DI container. 4. Execute the use case with the domain entity. 5. Implement robust error logging but not re-throw, to prevent repeated trigger executions for non-transient errors.', 'exception_handling': 'Specification requires logging errors to Cloud Logging without causing the function to fail and retry.', 'performance_considerations': 'Specification notes this function is on the critical path for user notifications and must execute quickly.', 'validation_requirements': 'Specification must ensure the handler is idempotent if possible, although `onCreate` triggers are typically not retried on success.', 'technology_integration_details': 'Specification integrates directly with the `firebase-functions` SDK for Firestore triggers.'}

##### 2.3.4.2.12.0 Events

*No items available*

##### 2.3.4.2.13.0 Implementation Notes

Enhanced specification clarifies this is the implementation of the `Event Creation Trigger` component.

#### 2.3.4.3.0.0 Class Name

##### 2.3.4.3.1.0 Class Name

CreateTeam

##### 2.3.4.3.2.0 File Path

```javascript
functions/src/application/use-cases/teams/CreateTeam.ts
```

##### 2.3.4.3.3.0 Class Type

UseCase

##### 2.3.4.3.4.0 Inheritance

IUseCase<CreateTeamDto, TeamDto>

##### 2.3.4.3.5.0 Purpose

Handles the business logic for creating a new team, including validation and persistence.

##### 2.3.4.3.6.0 Dependencies

- ITeamRepository
- IUserRepository
- IAuditLogService
- IAuthorizationService

##### 2.3.4.3.7.0 Framework Specific Attributes

*No items available*

##### 2.3.4.3.8.0 Technology Integration Notes

Enhanced specification clarifies this use case must be invoked by a Callable Function handler and must perform all operations within a Firestore transaction or batch for atomicity.

##### 2.3.4.3.9.0 Validation Notes

Validation confirms the original specification was good but lacked dependencies on authorization and auditing services, which are now added.

##### 2.3.4.3.10.0 Properties

*No items available*

##### 2.3.4.3.11.0 Methods

- {'method_name': 'execute', 'method_signature': 'execute(input: CreateTeamDto, authContext: AuthContext): Promise<TeamDto>', 'return_type': 'Promise<TeamDto>', 'access_modifier': 'public', 'is_async': True, 'framework_specific_attributes': [], 'parameters': [{'parameter_name': 'input', 'parameter_type': 'CreateTeamDto', 'is_nullable': False, 'purpose': 'Contains the data for the new team (name, supervisorId).', 'framework_attributes': []}, {'parameter_name': 'authContext', 'parameter_type': 'AuthContext', 'is_nullable': False, 'purpose': "Contains authenticated user's info (uid, role, tenantId) for authorization.", 'framework_attributes': []}], 'implementation_logic': 'Enhanced specification clarifies the logic: 1. Use `IAuthorizationService` to verify the user has \\"Admin\\" role. 2. Validate input DTO. 3. Check for team name uniqueness within the tenant via `ITeamRepository`. 4. Verify `supervisorId` is a valid and active user via `IUserRepository`. 5. Create a new Team domain entity. 6. Persist the new team using `ITeamRepository`. 7. Use `IAuditLogService` to record the creation event. 8. Return the created team as a DTO.', 'exception_handling': 'Specification confirms the pattern of throwing specific application errors (e.g., \\"AuthorizationError\\", \\"ValidationError\\", \\"AlreadyExistsError\\") is correct.', 'performance_considerations': 'Specification for uniqueness check must be performant, potentially using a transaction with a read before write.', 'validation_requirements': 'Validates team name is not empty and is unique. Validates supervisorId corresponds to an active, eligible user.', 'technology_integration_details': 'N/A'}

##### 2.3.4.3.12.0 Events

*No items available*

##### 2.3.4.3.13.0 Implementation Notes

Enhanced specification mandates that all database writes must be atomic.

#### 2.3.4.4.0.0 Class Name

##### 2.3.4.4.1.0 Class Name

HierarchyValidationService

##### 2.3.4.4.2.0 File Path

```javascript
functions/src/domain/services/HierarchyValidationService.ts
```

##### 2.3.4.4.3.0 Class Type

DomainService

##### 2.3.4.4.4.0 Inheritance

N/A

##### 2.3.4.4.5.0 Purpose

Specification added to fulfill REQ-1-026. This service contains the logic to detect and prevent circular reporting structures when a supervisor is assigned.

##### 2.3.4.4.6.0 Dependencies

- IUserRepository

##### 2.3.4.4.7.0 Framework Specific Attributes

*No items available*

##### 2.3.4.4.8.0 Technology Integration Notes

This is pure business logic and should have no direct dependency on Firebase.

##### 2.3.4.4.9.0 Validation Notes

Validation confirms this component was missing and is critical for data integrity.

##### 2.3.4.4.10.0 Properties

*No items available*

##### 2.3.4.4.11.0 Methods

- {'method_name': 'isCircularDependency', 'method_signature': 'isCircularDependency(user: User, newSupervisor: User, tenantId: string): Promise<boolean>', 'return_type': 'Promise<boolean>', 'access_modifier': 'public', 'is_async': True, 'framework_specific_attributes': [], 'parameters': [{'parameter_name': 'user', 'parameter_type': 'User', 'is_nullable': False, 'purpose': 'The user whose supervisor is being changed.', 'framework_attributes': []}, {'parameter_name': 'newSupervisor', 'parameter_type': 'User', 'is_nullable': False, 'purpose': 'The proposed new supervisor.', 'framework_attributes': []}, {'parameter_name': 'tenantId', 'parameter_type': 'string', 'is_nullable': False, 'purpose': 'The tenant context for the operation.', 'framework_attributes': []}], 'implementation_logic': 'Specification requires this method to: 1. Check for the trivial case (`user.id === newSupervisor.id`). 2. Iteratively traverse up the supervisory chain starting from `newSupervisor.supervisorId`. 3. In each step, fetch the next supervisor using `IUserRepository`. 4. If `user.id` is encountered at any point in the chain, a circular dependency exists; return `true`. 5. If the top of the hierarchy is reached (supervisorId is null) without finding the user, return `false`.', 'exception_handling': 'Specification requires this to propagate any data access errors.', 'performance_considerations': 'Specification notes that this can involve multiple document reads and should be used judiciously.', 'validation_requirements': 'N/A', 'technology_integration_details': 'N/A'}

##### 2.3.4.4.12.0 Events

*No items available*

##### 2.3.4.4.13.0 Implementation Notes

This service will be consumed by the `UpdateTeam` and potentially a future `UpdateUser` use case.

### 2.3.5.0.0.0 Interface Specifications

- {'interface_name': 'ITeamRepository', 'file_path': 'functions/src/domain/repositories/ITeamRepository.ts', 'purpose': 'Defines the contract for data access operations related to the Team aggregate. This is the boundary between the domain and infrastructure layers.', 'generic_constraints': 'None', 'framework_specific_inheritance': 'None', 'method_contracts': [{'method_name': 'findById', 'method_signature': 'findById(id: string, tenantId: string): Promise<Team | null>', 'return_type': 'Promise<Team | null>', 'framework_attributes': [], 'parameters': [{'parameter_name': 'id', 'parameter_type': 'string', 'purpose': 'The unique ID of the team.'}, {'parameter_name': 'tenantId', 'parameter_type': 'string', 'purpose': 'The tenant context for the query.'}], 'contract_description': 'Specification requires this method to retrieve a single Team entity by its ID within a specific tenant.', 'exception_contracts': 'Specification requires this method to return null if not found, not throw an error.'}, {'method_name': 'findByNameInTenant', 'method_signature': 'findByNameInTenant(name: string, tenantId: string): Promise<Team | null>', 'return_type': 'Promise<Team | null>', 'framework_attributes': [], 'parameters': [{'parameter_name': 'name', 'parameter_type': 'string', 'purpose': 'The name of the team to find.'}, {'parameter_name': 'tenantId', 'parameter_type': 'string', 'purpose': 'The tenant context for the query.'}], 'contract_description': 'Enhanced specification adds this method, which is required for uniqueness checks during team creation/updates.', 'exception_contracts': 'Specification requires this to return null if no team with that name exists.'}, {'method_name': 'save', 'method_signature': 'save(team: Team, batch: FirebaseFirestore.WriteBatch): Promise<void>', 'return_type': 'Promise<void>', 'framework_attributes': [], 'parameters': [{'parameter_name': 'team', 'parameter_type': 'Team', 'purpose': 'The Team entity to create or update.'}, {'parameter_name': 'batch', 'parameter_type': 'FirebaseFirestore.WriteBatch', 'purpose': 'The Firestore batch write object to add the operation to.'}], 'contract_description': 'Enhanced specification clarifies that `save` should not commit data itself but add the operation to a provided batch, allowing the use case to control the transaction boundary (Unit of Work pattern).', 'exception_contracts': 'Specification does not expect this method to throw; errors are handled on batch commit.'}], 'property_contracts': [], 'implementation_guidance': 'Implementations should handle mapping between the domain entity and the persistence model. All operations must be tenant-isolated.', 'validation_notes': 'Validation confirms the original specification was incomplete. Methods for uniqueness checks and a clearer Unit of Work pattern have been added.'}

### 2.3.6.0.0.0 Enum Specifications

*No items available*

### 2.3.7.0.0.0 Dto Specifications

- {'dto_name': 'CreateTeamDto', 'file_path': 'functions/src/application/dtos/TeamDtos.ts', 'purpose': 'Data Transfer Object for the CreateTeam use case, defining the input shape and validation rules.', 'framework_base_class': 'N/A', 'properties': [{'property_name': 'name', 'property_type': 'string', 'validation_attributes': ['Required', 'MinLength(3)', 'MaxLength(100)'], 'serialization_attributes': [], 'framework_specific_attributes': []}, {'property_name': 'supervisorId', 'property_type': 'string', 'validation_attributes': ['Required', 'IsUUID'], 'serialization_attributes': [], 'framework_specific_attributes': []}], 'validation_rules': 'Enhanced specification mandates the use of a schema validation library like Zod to define a reusable schema for this DTO.', 'serialization_requirements': 'N/A for internal DTO.', 'validation_notes': 'Validation confirms the original specification was good. Enhancement adds clarity on the validation library.'}

### 2.3.8.0.0.0 Configuration Specifications

- {'configuration_name': 'DIContainer', 'file_path': 'functions/src/config/diContainer.ts', 'purpose': 'Specification added to define a simple Dependency Injection container responsible for instantiating and wiring up services, use cases, and repositories.', 'framework_base_class': 'N/A', 'configuration_sections': [{'section_name': 'ServiceRegistration', 'properties': [{'property_name': 'register', 'property_type': 'function', 'default_value': 'N/A', 'required': True, 'description': 'A function to register a dependency with a specific key and lifetime (singleton, transient).'}, {'property_name': 'resolve', 'property_type': 'function', 'default_value': 'N/A', 'required': True, 'description': 'A function to resolve a registered dependency by its key.'}]}], 'validation_requirements': 'The container should support singleton and transient lifetimes.', 'validation_notes': 'Validation confirms this component was missing and is crucial for creating a testable and maintainable application structure.'}

### 2.3.9.0.0.0 Dependency Injection Specifications

#### 2.3.9.1.0.0 Service Interface

##### 2.3.9.1.1.0 Service Interface

ITeamRepository

##### 2.3.9.1.2.0 Service Implementation

FirestoreTeamRepository

##### 2.3.9.1.3.0 Lifetime

Singleton

##### 2.3.9.1.4.0 Registration Reasoning

Enhanced specification clarifies that repositories can be singletons in a serverless environment as they are stateless and a new instance is created per function invocation context anyway.

##### 2.3.9.1.5.0 Framework Registration Pattern

container.register(\"ITeamRepository\", { useClass: FirestoreTeamRepository });

##### 2.3.9.1.6.0 Validation Notes

Validation confirms the original lifetime and reasoning are sound for a serverless architecture.

#### 2.3.9.2.0.0 Service Interface

##### 2.3.9.2.1.0 Service Interface

CreateTeamUseCase

##### 2.3.9.2.2.0 Service Implementation

CreateTeam

##### 2.3.9.2.3.0 Lifetime

Transient

##### 2.3.9.2.4.0 Registration Reasoning

Use cases are lightweight, may contain request-specific state, and should be created on-demand for each invocation to ensure isolation.

##### 2.3.9.2.5.0 Framework Registration Pattern

container.register(\"CreateTeamUseCase\", { useClass: CreateTeam });

##### 2.3.9.2.6.0 Validation Notes

Validation confirms this registration strategy is appropriate.

#### 2.3.9.3.0.0 Service Interface

##### 2.3.9.3.1.0 Service Interface

IAuthorizationService

##### 2.3.9.3.2.0 Service Implementation

AuthorizationService

##### 2.3.9.3.3.0 Lifetime

Singleton

##### 2.3.9.3.4.0 Registration Reasoning

Authorization checks are stateless utility functions, suitable for a singleton lifetime.

##### 2.3.9.3.5.0 Framework Registration Pattern

container.register(\"IAuthorizationService\", { useClass: AuthorizationService });

##### 2.3.9.3.6.0 Validation Notes

Validation confirms this critical service was missing from the DI specification and has been added.

### 2.3.10.0.0.0 External Integration Specifications

#### 2.3.10.1.0.0 Integration Target

##### 2.3.10.1.1.0 Integration Target

Firestore

##### 2.3.10.1.2.0 Integration Type

Database

##### 2.3.10.1.3.0 Required Client Classes

- admin.firestore.Firestore
- admin.firestore.WriteBatch

##### 2.3.10.1.4.0 Configuration Requirements

Firebase Admin SDK must be initialized with appropriate service account credentials in `config/firebase.ts`.

##### 2.3.10.1.5.0 Error Handling Requirements

Enhanced specification requires that repository implementations should catch Firestore-specific errors and re-throw them as domain-specific exceptions (e.g., `PersistenceError`).

##### 2.3.10.1.6.0 Authentication Requirements

Authentication is handled via the initialized Admin SDK, which runs with elevated privileges defined by its service account.

##### 2.3.10.1.7.0 Framework Integration Patterns

Repository Pattern abstracts Firestore-specific code. Unit of Work pattern is implemented via Firestore WriteBatch, controlled by the Application layer use cases.

##### 2.3.10.1.8.0 Validation Notes

Validation confirms the original specification was sound. Enhancement adds detail on error mapping and the Unit of Work pattern.

#### 2.3.10.2.0.0 Integration Target

##### 2.3.10.2.1.0 Integration Target

Firebase Cloud Messaging (FCM)

##### 2.3.10.2.2.0 Integration Type

Push Notification Service

##### 2.3.10.2.3.0 Required Client Classes

- admin.messaging.Messaging

##### 2.3.10.2.4.0 Configuration Requirements

Firebase Admin SDK must be initialized.

##### 2.3.10.2.5.0 Error Handling Requirements

Enhanced specification requires that the `FirebaseFcmService` must handle errors for invalid/unregistered tokens by logging them and potentially flagging them for cleanup. It must use `sendEach` for batch sending to handle partial failures.

##### 2.3.10.2.6.0 Authentication Requirements

Handled via the initialized Admin SDK.

##### 2.3.10.2.7.0 Framework Integration Patterns

Abstracted behind an `IFcmService` interface in the infrastructure layer, as per Clean Architecture.

##### 2.3.10.2.8.0 Validation Notes

Validation confirms the original specification was correct. Enhancement adds detail on batch sending and error handling for stale tokens.

## 2.4.0.0.0.0 Component Count Validation

| Property | Value |
|----------|-------|
| Total Classes | 15 |
| Total Interfaces | 7 |
| Total Enums | 0 |
| Total Dtos | 5 |
| Total Configurations | 3 |
| Total External Integrations | 2 |
| Grand Total Components | 32 |
| Phase 2 Claimed Count | 0 |
| Phase 2 Actual Count | 0 |
| Validation Added Count | 32 |
| Final Validated Count | 32 |

# 3.0.0.0.0.0 File Structure

## 3.1.0.0.0.0 Directory Organization

### 3.1.1.0.0.0 Directory Path

#### 3.1.1.1.0.0 Directory Path

.editorconfig

#### 3.1.1.2.0.0 Purpose

Infrastructure and project configuration files

#### 3.1.1.3.0.0 Contains Files

- .editorconfig

#### 3.1.1.4.0.0 Organizational Reasoning

Contains project setup, configuration, and infrastructure files for development and deployment

#### 3.1.1.5.0.0 Framework Convention Alignment

Standard project structure for infrastructure as code and development tooling

### 3.1.2.0.0.0 Directory Path

#### 3.1.2.1.0.0 Directory Path

.firebaserc

#### 3.1.2.2.0.0 Purpose

Infrastructure and project configuration files

#### 3.1.2.3.0.0 Contains Files

- .firebaserc

#### 3.1.2.4.0.0 Organizational Reasoning

Contains project setup, configuration, and infrastructure files for development and deployment

#### 3.1.2.5.0.0 Framework Convention Alignment

Standard project structure for infrastructure as code and development tooling

### 3.1.3.0.0.0 Directory Path

#### 3.1.3.1.0.0 Directory Path

.gitignore

#### 3.1.3.2.0.0 Purpose

Infrastructure and project configuration files

#### 3.1.3.3.0.0 Contains Files

- .gitignore

#### 3.1.3.4.0.0 Organizational Reasoning

Contains project setup, configuration, and infrastructure files for development and deployment

#### 3.1.3.5.0.0 Framework Convention Alignment

Standard project structure for infrastructure as code and development tooling

### 3.1.4.0.0.0 Directory Path

#### 3.1.4.1.0.0 Directory Path

.prettierrc

#### 3.1.4.2.0.0 Purpose

Infrastructure and project configuration files

#### 3.1.4.3.0.0 Contains Files

- .prettierrc

#### 3.1.4.4.0.0 Organizational Reasoning

Contains project setup, configuration, and infrastructure files for development and deployment

#### 3.1.4.5.0.0 Framework Convention Alignment

Standard project structure for infrastructure as code and development tooling

### 3.1.5.0.0.0 Directory Path

#### 3.1.5.1.0.0 Directory Path

firebase.json

#### 3.1.5.2.0.0 Purpose

Infrastructure and project configuration files

#### 3.1.5.3.0.0 Contains Files

- firebase.json

#### 3.1.5.4.0.0 Organizational Reasoning

Contains project setup, configuration, and infrastructure files for development and deployment

#### 3.1.5.5.0.0 Framework Convention Alignment

Standard project structure for infrastructure as code and development tooling

### 3.1.6.0.0.0 Directory Path

#### 3.1.6.1.0.0 Directory Path

```javascript
functions/.env.example
```

#### 3.1.6.2.0.0 Purpose

Infrastructure and project configuration files

#### 3.1.6.3.0.0 Contains Files

- .env.example

#### 3.1.6.4.0.0 Organizational Reasoning

Contains project setup, configuration, and infrastructure files for development and deployment

#### 3.1.6.5.0.0 Framework Convention Alignment

Standard project structure for infrastructure as code and development tooling

### 3.1.7.0.0.0 Directory Path

#### 3.1.7.1.0.0 Directory Path

```javascript
functions/.eslintrc.js
```

#### 3.1.7.2.0.0 Purpose

Infrastructure and project configuration files

#### 3.1.7.3.0.0 Contains Files

- .eslintrc.js

#### 3.1.7.4.0.0 Organizational Reasoning

Contains project setup, configuration, and infrastructure files for development and deployment

#### 3.1.7.5.0.0 Framework Convention Alignment

Standard project structure for infrastructure as code and development tooling

### 3.1.8.0.0.0 Directory Path

#### 3.1.8.1.0.0 Directory Path

```javascript
functions/.nvmrc
```

#### 3.1.8.2.0.0 Purpose

Infrastructure and project configuration files

#### 3.1.8.3.0.0 Contains Files

- .nvmrc

#### 3.1.8.4.0.0 Organizational Reasoning

Contains project setup, configuration, and infrastructure files for development and deployment

#### 3.1.8.5.0.0 Framework Convention Alignment

Standard project structure for infrastructure as code and development tooling

### 3.1.9.0.0.0 Directory Path

#### 3.1.9.1.0.0 Directory Path

```javascript
functions/.vscode/settings.json
```

#### 3.1.9.2.0.0 Purpose

Infrastructure and project configuration files

#### 3.1.9.3.0.0 Contains Files

- settings.json

#### 3.1.9.4.0.0 Organizational Reasoning

Contains project setup, configuration, and infrastructure files for development and deployment

#### 3.1.9.5.0.0 Framework Convention Alignment

Standard project structure for infrastructure as code and development tooling

### 3.1.10.0.0.0 Directory Path

#### 3.1.10.1.0.0 Directory Path

```javascript
functions/jest.config.js
```

#### 3.1.10.2.0.0 Purpose

Infrastructure and project configuration files

#### 3.1.10.3.0.0 Contains Files

- jest.config.js

#### 3.1.10.4.0.0 Organizational Reasoning

Contains project setup, configuration, and infrastructure files for development and deployment

#### 3.1.10.5.0.0 Framework Convention Alignment

Standard project structure for infrastructure as code and development tooling

### 3.1.11.0.0.0 Directory Path

#### 3.1.11.1.0.0 Directory Path

```javascript
functions/package.json
```

#### 3.1.11.2.0.0 Purpose

Infrastructure and project configuration files

#### 3.1.11.3.0.0 Contains Files

- package.json

#### 3.1.11.4.0.0 Organizational Reasoning

Contains project setup, configuration, and infrastructure files for development and deployment

#### 3.1.11.5.0.0 Framework Convention Alignment

Standard project structure for infrastructure as code and development tooling

### 3.1.12.0.0.0 Directory Path

#### 3.1.12.1.0.0 Directory Path

```javascript
functions/tsconfig.json
```

#### 3.1.12.2.0.0 Purpose

Infrastructure and project configuration files

#### 3.1.12.3.0.0 Contains Files

- tsconfig.json

#### 3.1.12.4.0.0 Organizational Reasoning

Contains project setup, configuration, and infrastructure files for development and deployment

#### 3.1.12.5.0.0 Framework Convention Alignment

Standard project structure for infrastructure as code and development tooling

