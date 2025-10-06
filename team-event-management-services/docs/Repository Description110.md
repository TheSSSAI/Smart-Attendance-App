# 1 Id

REPO-SVC-TEAM-005

# 2 Name

team-event-management-services

# 3 Description

This microservice is responsible for the 'Team and Schedule Management' bounded context. Extracted from the 'attendance-app-backend', it manages the creation and lifecycle of Teams and calendar-based Events. Its functions include creating, updating, and deleting teams, managing team memberships, assigning supervisors, and the full feature set for event management: creating single or recurring events, assigning events to individuals or teams, and triggering push notifications (via FCM) to users when they are assigned to a new event. This separation allows scheduling and organizational structure features to be managed and deployed independently from the core attendance workflow.

# 4 Type

🔹 Application Services

# 5 Namespace

com.attendance-app.services.team

# 6 Output Path

services/team-event-management

# 7 Framework

Firebase Cloud Functions

# 8 Language

TypeScript

# 9 Technology

Firestore, Cloud Functions, FCM

# 10 Thirdparty Libraries

*No items available*

# 11 Layer Ids

- application-services-layer

# 12 Dependencies

- REPO-LIB-CORE-001
- REPO-LIB-BACKEND-002

# 13 Requirements

## 13.1 Requirement Id

### 13.1.1 Requirement Id

REQ-1-015

## 13.2.0 Requirement Id

### 13.2.1 Requirement Id

REQ-FUN-009

## 13.3.0 Requirement Id

### 13.3.1 Requirement Id

REQ-FUN-011

# 14.0.0 Generate Tests

✅ Yes

# 15.0.0 Generate Documentation

✅ Yes

# 16.0.0 Architecture Style

Serverless

# 17.0.0 Architecture Map

- callable-functions-api-002
- event-triggered-functions-006

# 18.0.0 Components Map

*No items available*

# 19.0.0 Requirements Map

- REQ-1-015
- REQ-FUN-009
- REQ-FUN-011
- REQ-1-056

# 20.0.0 Decomposition Rationale

## 20.1.0 Operation Type

NEW_DECOMPOSED

## 20.2.0 Source Repository

REPO-BACKEND-002

## 20.3.0 Decomposition Reasoning

Separated based on the 'Team & Schedule Management' domain. This logic is distinct from the daily attendance workflow and often has a different rate of change. Isolating it allows for independent feature development around scheduling and organization without impacting core attendance functionality.

## 20.4.0 Extracted Responsibilities

- CRUD operations for Teams.
- Team membership management.
- Event creation, including recurrence.
- Assigning events to users/teams.
- Triggering event-related push notifications.

## 20.5.0 Reusability Scope

- Domain-specific to this application.

## 20.6.0 Development Benefits

- Clear ownership for scheduling and team structure features.
- Allows for future expansion of scheduling features (e.g., leave management) without touching other services.

# 21.0.0 Dependency Contracts

*No data available*

# 22.0.0 Exposed Contracts

## 22.1.0 Public Interfaces

### 22.1.1 Interface

#### 22.1.1.1 Interface

Callable Functions

#### 22.1.1.2 Methods

- createTeam(name, supervisorId)
- createEvent(eventData)

#### 22.1.1.3 Events

*No items available*

#### 22.1.1.4 Properties

*No items available*

#### 22.1.1.5 Consumers

- REPO-APP-ADMIN-011
- REPO-APP-MOBILE-010

### 22.1.2.0 Interface

#### 22.1.2.1 Interface

Event Handlers

#### 22.1.2.2 Methods

- onEventAssignmentCreate(snapshot, context)

#### 22.1.2.3 Events

*No items available*

#### 22.1.2.4 Properties

*No items available*

#### 22.1.2.5 Consumers

- Firestore

# 23.0.0.0 Integration Patterns

| Property | Value |
|----------|-------|
| Dependency Injection | N/A |
| Event Communication | Triggers FCM push notifications based on new docum... |
| Data Flow | Manages the Team and Event collections in Firestor... |
| Error Handling | Uses shared error handler. |
| Async Patterns | Asynchronous handling for sending push notificatio... |

# 24.0.0.0 Technology Guidance

| Property | Value |
|----------|-------|
| Framework Specific | Use Callable Functions for admin/supervisor action... |
| Performance Considerations | N/A |
| Security Considerations | Ensure only authorized Admins or Supervisors can c... |
| Testing Approach | Test notification logic using the emulator suite. |

# 25.0.0.0 Scope Boundaries

## 25.1.0.0 Must Implement

- All logic for managing teams and calendar events.

## 25.2.0.0 Must Not Implement

- Attendance approval workflows.
- User account creation.

## 25.3.0.0 Extension Points

- Can be extended with more complex scheduling rules or event types.

## 25.4.0.0 Validation Rules

- Prevent circular reporting structures when assigning supervisors.

