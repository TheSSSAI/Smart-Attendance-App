# 1 Integration Specifications

## 1.1 Extraction Metadata

| Property | Value |
|----------|-------|
| Repository Id | REPO-SVC-TEAM-005 |
| Extraction Timestamp | 2024-05-24T10:00:00Z |
| Mapping Validation Score | 100% |
| Context Completeness Score | 98% |
| Implementation Readiness Level | High |

## 1.2 Relevant Requirements

### 1.2.1 Requirement Id

#### 1.2.1.1 Requirement Id

REQ-1-038

#### 1.2.1.2 Requirement Text

The Admin web dashboard must include a team management section that allows Admins to perform full CRUD (Create, Read, Update, Delete) operations on teams. When creating a team, an Admin must specify a team name and assign a Supervisor. Both Admins and the designated Supervisor of a team must have the ability to manage the team's membership by adding or removing Subordinates.

#### 1.2.1.3 Validation Criteria

- As an Admin, create a new team, name it, and assign a Supervisor.
- As an Admin, add two members to the team.
- Log in as the assigned Supervisor and verify the ability to remove one member and add a different one.
- As an Admin, delete the team and verify it is removed from the system.

#### 1.2.1.4 Implementation Implications

- The service must expose secure callable functions for createTeam, updateTeam, deleteTeam, addTeamMember, and removeTeamMember.
- Business logic must validate that the caller has the appropriate 'Admin' or 'Supervisor' role and is authorized to manage the specific team.
- Updates to team membership must be atomic, updating both the team's member list and the user's team list.

#### 1.2.1.5 Extraction Reasoning

This requirement directly defines the core responsibilities of the repository regarding team creation and membership management, as stated in its description. The service will provide the backend API for these frontend actions.

### 1.2.2.0 Requirement Id

#### 1.2.2.1 Requirement Id

REQ-1-007

#### 1.2.2.2 Requirement Text

The system shall provide functionality for authorized users (Supervisors and Admins) to create events within a calendar interface. These events must be assignable to specific individuals, multiple individuals, or entire pre-defined teams.

#### 1.2.2.3 Validation Criteria

- Verify a Supervisor can create a new event with a title, description, start time, and end time.
- Verify the event can be assigned to one or more subordinates.
- Verify the event can be assigned to a team, which implicitly assigns it to all team members.

#### 1.2.2.4 Implementation Implications

- The service must expose a callable function, createEvent, that accepts event data including assignments.
- The service must also provide updateEvent and deleteEvent functions to fulfill the event lifecycle management responsibility.
- Event creation logic must correctly handle assignments to both individual userIds and teamIds.

#### 1.2.2.5 Extraction Reasoning

This requirement is a primary driver for the repository, defining its event management and scheduling capabilities, which is a core part of its bounded context.

### 1.2.3.0 Requirement Id

#### 1.2.3.1 Requirement Id

REQ-1-054

#### 1.2.3.2 Requirement Text

The system shall also support creating recurring events, allowing the Supervisor to specify recurrence patterns such as daily, weekly (e.g., every Monday and Wednesday), or monthly (e.g., on the 15th of every month).

#### 1.2.3.3 Validation Criteria

- Create a weekly recurring event for every Tuesday.
- Check the calendar for the next four Tuesdays and verify the event appears on each of them.

#### 1.2.3.4 Implementation Implications

- The createEvent function must be able to process recurrence rules (e.g., RRULE strings).
- A separate, event-triggered function may be required to expand recurrence rules into individual event documents in Firestore for easier querying by clients.

#### 1.2.3.5 Extraction Reasoning

This requirement explicitly adds 'recurring events' to the repository's scope, as mentioned in its description, detailing a key feature of the event management functionality.

### 1.2.4.0 Requirement Id

#### 1.2.4.1 Requirement Id

REQ-1-056

#### 1.2.4.2 Requirement Text

When a Supervisor creates a new event and assigns it to a user, the system must trigger a Firebase Cloud Messaging (FCM) push notification to be sent to that user's registered device(s) to inform them of the new event.

#### 1.2.4.3 Validation Criteria

- As a Supervisor, create a new event and assign it to the Subordinate.
- Verify the Subordinate's device receives a push notification about the new event.

#### 1.2.4.4 Implementation Implications

- The service must include a Firestore trigger (onCreate on the events collection) that initiates the notification process.
- The trigger logic must resolve all individual user IDs from both direct and team-based assignments.
- The service must integrate with the FCM Admin SDK to send notifications to the resolved user list.

#### 1.2.4.5 Extraction Reasoning

This requirement is explicitly listed in the repository's description. It defines the primary reactive, event-driven function of this service.

### 1.2.5.0 Requirement Id

#### 1.2.5.1 Requirement Id

REQ-1-026

#### 1.2.5.2 Requirement Text

The system must implement a business rule to prevent the creation of circular reporting hierarchies. When an Admin or Supervisor attempts to assign a supervisor to a user, the system must validate that this assignment does not result in a loop.

#### 1.2.5.3 Validation Criteria

- Create a scenario where User A reports to User B. Attempt to set User B's supervisor to User A and verify the system returns an error.

#### 1.2.5.4 Implementation Implications

- A utility function must be implemented within this service to traverse a user's supervisory chain.
- The createTeam and updateTeam callable functions must invoke this validation logic whenever a supervisorId is assigned or changed.

#### 1.2.5.5 Extraction Reasoning

Since this service is responsible for assigning supervisors to teams, it must own or invoke the logic to enforce this critical data integrity rule to maintain a valid organizational structure.

## 1.3.0.0 Relevant Components

### 1.3.1.0 Component Name

#### 1.3.1.1 Component Name

Team Management Functions

#### 1.3.1.2 Component Specification

A set of Firebase Callable Functions that handle all CRUD and membership management operations for Teams. These functions act as the secure API endpoint for the Admin and Supervisor frontends.

#### 1.3.1.3 Implementation Requirements

- Implement functions: createTeam, updateTeam, deleteTeam, addTeamMember, removeTeamMember.
- Each function must validate the caller's role (Admin or Supervisor) and their authority over the target team using Firebase Auth custom claims.
- All data modifications must be performed within Firestore transactions to ensure atomicity.

#### 1.3.1.4 Architectural Context

Belongs to the application-services-layer. Fulfills the synchronous, client-initiated part of the repository's responsibilities.

#### 1.3.1.5 Extraction Reasoning

This component directly implements the team management responsibilities outlined in REQ-1-038 and REQ-1-015 and is a core part of the service's exposed contract.

### 1.3.2.0 Component Name

#### 1.3.2.1 Component Name

Event Management Functions

#### 1.3.2.2 Component Specification

A set of Firebase Callable Functions that handle the creation, update, and deletion of calendar events, including support for recurrence rules and assignments.

#### 1.3.2.3 Implementation Requirements

- Implement functions: createEvent, updateEvent, deleteEvent.
- Each function must validate the caller's role (Admin or Supervisor) via Auth custom claims.
- The createEvent function must parse and handle event data, including assignments and recurrence rules as specified in REQ-1-007 and REQ-1-054.

#### 1.3.2.4 Architectural Context

Belongs to the application-services-layer. Provides the API for the scheduling and event creation features of the application.

#### 1.3.2.5 Extraction Reasoning

This component is necessary to fulfill the event management requirements (REQ-1-007, REQ-1-054) and is part of the service's exposed API contract.

### 1.3.3.0 Component Name

#### 1.3.3.1 Component Name

Event Notification Trigger

#### 1.3.3.2 Component Specification

A Firestore-triggered Cloud Function that listens for new documents in the events collection. It is responsible for fanning out push notifications to all assigned users.

#### 1.3.3.3 Implementation Requirements

- Implement an onCreate trigger for the path /tenants/{tenantId}/events/{eventId}.
- The function logic must read the assignedUserIds and assignedTeamIds from the new event document.
- It must query the teams and users collections to build a final, de-duplicated list of recipient user IDs.
- For each recipient, it must fetch their FCM token(s) and send a notification using the FCM Admin SDK.

#### 1.3.3.4 Architectural Context

Belongs to the application-services-layer. Fulfills the asynchronous, event-driven responsibility of the repository.

#### 1.3.3.5 Extraction Reasoning

This component is the direct implementation of REQ-1-056 and is a key part of the service's event-driven architecture.

## 1.4.0.0 Architectural Layers

- {'layer_name': 'Application Services Layer', 'layer_responsibilities': "This layer contains all custom serverless backend logic. Its responsibilities include executing trusted business logic, handling scheduled tasks, and integrating with third-party services. This repository implements the 'Team & Schedule Management' portion of this layer.", 'layer_constraints': ['Logic must be stateless and executed within the Firebase Cloud Functions environment.', 'All state must be persisted in the Data & Persistence Layer (Firestore).'], 'implementation_patterns': ['Serverless Functions', 'Event-Driven Architecture (via Firestore Triggers)'], 'extraction_reasoning': "The repository is explicitly mapped to this layer. Its responsibilities of providing a callable API and handling database triggers perfectly align with the layer's definition in the system architecture."}

## 1.5.0.0 Dependency Interfaces

### 1.5.1.0 Interface Name

#### 1.5.1.1 Interface Name

Data Model Schemas

#### 1.5.1.2 Source Repository

REPO-LIB-CORE-001

#### 1.5.1.3 Method Contracts

- {'method_name': 'N/A (Type Definitions)', 'method_signature': 'export const teamSchema = z.object({...}); export type Team = z.infer<typeof teamSchema>;', 'method_purpose': 'Provides standardized, version-controlled TypeScript types and Zod validation schemas for core domain entities like Team, Event, and User, ensuring type safety and consistency across services.', 'integration_context': 'Consumed at build-time via TypeScript imports in all service files that handle domain objects. Used for input validation and to type data access layer interactions.'}

#### 1.5.1.4 Integration Pattern

Compile-Time Library Import

#### 1.5.1.5 Communication Protocol

NPM Package / TypeScript Modules

#### 1.5.1.6 Extraction Reasoning

As a backend service in a microservice architecture, this repository must depend on a shared library for core data contracts to ensure system-wide data consistency, as mandated by Clean Architecture principles.

### 1.5.2.0 Interface Name

#### 1.5.2.1 Interface Name

Shared Backend Utilities

#### 1.5.2.2 Source Repository

REPO-LIB-BACKEND-002

#### 1.5.2.3 Method Contracts

##### 1.5.2.3.1 Method Name

###### 1.5.2.3.1.1 Method Name

ILogger

###### 1.5.2.3.1.2 Method Signature

{ info(message: string, context?: object): void; error(message: string, error: Error, context?: object): void; }

###### 1.5.2.3.1.3 Method Purpose

Provides a standardized, structured logging service for all Cloud Functions, ensuring consistent log formats for monitoring and alerting (REQ-1-076).

###### 1.5.2.3.1.4 Integration Context

Used throughout all use cases and handlers to log informational messages and exceptions.

##### 1.5.2.3.2.0 Method Name

###### 1.5.2.3.2.1 Method Name

IContextUtils

###### 1.5.2.3.2.2 Method Signature

{ getContext(context: CallableContext): AuthContext; }

###### 1.5.2.3.2.3 Method Purpose

Provides a standardized utility to parse and validate the Firebase Authentication context, securely extracting `tenantId`, `userId`, and `role` for RBAC and multi-tenancy checks.

###### 1.5.2.3.2.4 Integration Context

Called at the entry point of every secure callable function to establish the security context for the operation.

##### 1.5.2.3.3.0 Method Name

###### 1.5.2.3.3.1 Method Name

IFcmService

###### 1.5.2.3.3.2 Method Signature

{ sendNotification(userId: string, payload: FcmPayload): Promise<void>; sendToMultipleDevices(tokens: string[], payload: FcmPayload): Promise<void>; }

###### 1.5.2.3.3.3 Method Purpose

Provides a reusable, abstracted service for sending Firebase Cloud Messaging push notifications, handling the details of fetching user FCM tokens and managing API calls.

###### 1.5.2.3.3.4 Integration Context

Called by the 'Event Notification Trigger' after resolving the list of users to be notified (REQ-1-056).

#### 1.5.2.4.0.0 Integration Pattern

Compile-Time Library Import

#### 1.5.2.5.0.0 Communication Protocol

NPM Package / TypeScript Modules

#### 1.5.2.6.0.0 Extraction Reasoning

This service is a backend Cloud Function and requires foundational utilities for logging, security context parsing, and external service integration (FCM) to ensure consistency, maintainability, and compliance with NFRs.

### 1.5.3.0.0.0 Interface Name

#### 1.5.3.1.0.0 Interface Name

User Data (Owned by Identity Service)

#### 1.5.3.2.0.0 Source Repository

REPO-SVC-IDENTITY-003

#### 1.5.3.3.0.0 Method Contracts

- {'method_name': 'Read User Data', 'method_signature': "firestore.collection('users').where('supervisorId', '==', ...).get()", 'method_purpose': 'This service needs to read user data to validate supervisor hierarchies (REQ-1-026) and to resolve team members to user IDs and FCM tokens for notifications (REQ-1-056).', 'integration_context': 'Used within various use cases like `updateTeam` and `sendEventNotification`.'}

#### 1.5.3.4.0.0 Integration Pattern

Shared Database (Firestore)

#### 1.5.3.5.0.0 Communication Protocol

Firebase Admin SDK

#### 1.5.3.6.0.0 Extraction Reasoning

While services are decoupled at the logic level, they share the same database. This service has a critical data-level dependency on the `users` collection, which is managed and owned by the `identity-access-services` (REPO-SVC-IDENTITY-003). All interactions are read-only.

## 1.6.0.0.0.0 Exposed Interfaces

### 1.6.1.0.0.0 Interface Name

#### 1.6.1.1.0.0 Interface Name

Team & Event Management API

#### 1.6.1.2.0.0 Consumer Repositories

- REPO-APP-ADMIN-011
- REPO-APP-MOBILE-010

#### 1.6.1.3.0.0 Method Contracts

##### 1.6.1.3.1.0 Method Name

###### 1.6.1.3.1.1 Method Name

createTeam

###### 1.6.1.3.1.2 Method Signature

(data: { name: string; supervisorId: string; }, context: CallableContext): Promise<Team>

###### 1.6.1.3.1.3 Method Purpose

Creates a new team within the caller's tenant. Enforces unique name and valid supervisor assignment.

###### 1.6.1.3.1.4 Implementation Requirements

Must validate that context.auth.token.role is 'Admin'. Must check for team name uniqueness within the tenant. Must create an audit log entry.

##### 1.6.1.3.2.0 Method Name

###### 1.6.1.3.2.1 Method Name

updateTeam

###### 1.6.1.3.2.2 Method Signature

(data: { teamId: string; name?: string; supervisorId?: string; }, context: CallableContext): Promise<void>

###### 1.6.1.3.2.3 Method Purpose

Updates a team's name or assigned supervisor. Enforces hierarchy validation rules.

###### 1.6.1.3.2.4 Implementation Requirements

Must validate caller is 'Admin'. Must invoke circular dependency check (REQ-1-026) if supervisorId is changed. Must create an audit log entry.

##### 1.6.1.3.3.0 Method Name

###### 1.6.1.3.3.1 Method Name

deleteTeam

###### 1.6.1.3.3.2 Method Signature

(data: { teamId: string; }, context: CallableContext): Promise<void>

###### 1.6.1.3.3.3 Method Purpose

Deletes a team and un-assigns all members.

###### 1.6.1.3.3.4 Implementation Requirements

Must validate caller is 'Admin'. Must perform a batched write to remove the team ID from all member user documents. Must create an audit log entry.

##### 1.6.1.3.4.0 Method Name

###### 1.6.1.3.4.1 Method Name

manageTeamMembership

###### 1.6.1.3.4.2 Method Signature

(data: { teamId: string; userId: string; action: 'add' | 'remove'; }, context: CallableContext): Promise<void>

###### 1.6.1.3.4.3 Method Purpose

Adds or removes a subordinate from a team.

###### 1.6.1.3.4.4 Implementation Requirements

Must validate caller is the team's designated 'Supervisor' or an 'Admin'. Must perform an atomic update on both the team and user documents.

##### 1.6.1.3.5.0 Method Name

###### 1.6.1.3.5.1 Method Name

createEvent

###### 1.6.1.3.5.2 Method Signature

(data: EventData, context: CallableContext): Promise<Event>

###### 1.6.1.3.5.3 Method Purpose

Creates a new single or recurring event and assigns it to users/teams.

###### 1.6.1.3.5.4 Implementation Requirements

Must validate caller is 'Supervisor' or 'Admin'. Must correctly handle and store assignment and recurrence data (REQ-1-007, REQ-1-054).

##### 1.6.1.3.6.0 Method Name

###### 1.6.1.3.6.1 Method Name

updateEvent

###### 1.6.1.3.6.2 Method Signature

(data: { eventId: string; ...updates }, context: CallableContext): Promise<void>

###### 1.6.1.3.6.3 Method Purpose

Updates an existing event's details or assignments.

###### 1.6.1.3.6.4 Implementation Requirements

Must validate caller is 'Supervisor' or 'Admin' and has authority over the event.

##### 1.6.1.3.7.0 Method Name

###### 1.6.1.3.7.1 Method Name

deleteEvent

###### 1.6.1.3.7.2 Method Signature

(data: { eventId: string; }, context: CallableContext): Promise<void>

###### 1.6.1.3.7.3 Method Purpose

Deletes an event.

###### 1.6.1.3.7.4 Implementation Requirements

Must validate caller is 'Supervisor' or 'Admin' and has authority over the event.

#### 1.6.1.4.0.0 Service Level Requirements

- p95 latency for all functions must be under 500ms (REQ-1-067).

#### 1.6.1.5.0.0 Implementation Constraints

- All functions must be implemented as Firebase Callable Functions.
- Functions must perform authorization checks on the context.auth object to verify the user's role and tenant.

#### 1.6.1.6.0.0 Extraction Reasoning

This interface represents the synchronous, client-callable API surface of the repository. The methods are derived from the repository's responsibilities and the explicit/implicit requirements for team and event CRUD operations (REQ-1-038, REQ-1-007).

### 1.6.2.0.0.0 Interface Name

#### 1.6.2.1.0.0 Interface Name

Event Creation Trigger

#### 1.6.2.2.0.0 Consumer Repositories

- Firestore

#### 1.6.2.3.0.0 Method Contracts

- {'method_name': 'onEventCreate', 'method_signature': '(snapshot: DocumentSnapshot, context: EventContext): Promise<void>', 'method_purpose': 'Triggered on new event creation. Resolves all assigned users (both direct and via team) and sends them an FCM push notification.', 'implementation_requirements': 'Must be an onCreate Firestore trigger. Must efficiently query related collections (teams, users) to gather recipient FCM tokens. Must handle de-duplication of recipients.'}

#### 1.6.2.4.0.0 Service Level Requirements

- Function must complete execution within 30 seconds.

#### 1.6.2.5.0.0 Implementation Constraints

- Must be idempotent to handle potential duplicate triggers from Firestore.

#### 1.6.2.6.0.0 Extraction Reasoning

This interface represents the asynchronous, event-driven functionality of the service, directly implementing REQ-1-056 as specified in the repository definition.

## 1.7.0.0.0.0 Technology Context

### 1.7.1.0.0.0 Framework Requirements

Firebase Cloud Functions written in TypeScript, utilizing the firebase-admin and firebase-functions SDKs.

### 1.7.2.0.0.0 Integration Technologies

- Firestore
- Firebase Cloud Messaging (FCM)

### 1.7.3.0.0.0 Performance Constraints

Functions must be optimized for low latency (<500ms p95 for callable functions) and efficient Firestore document reads to manage costs. Hierarchy traversal logic must include a depth limit. Notification fan-out must use batching.

### 1.7.4.0.0.0 Security Requirements

All callable functions must validate the caller's authentication token to ensure they have the required role ('Admin' or 'Supervisor') and belong to the correct tenant. All data modifications across multiple documents must use atomic transactions (Batched Writes) to ensure data consistency.

## 1.8.0.0.0.0 Extraction Validation

| Property | Value |
|----------|-------|
| Mapping Completeness Check | The repository's purpose is well-defined and maps ... |
| Cross Reference Validation | High consistency found between the repository desc... |
| Implementation Readiness Assessment | The implementation readiness is high. The technolo... |
| Quality Assurance Confirmation | The extracted context has been systematically vali... |

