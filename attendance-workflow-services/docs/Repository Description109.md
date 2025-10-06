# 1 Id

REPO-SVC-ATTENDANCE-004

# 2 Name

attendance-workflow-services

# 3 Description

This microservice encapsulates the core business logic of the application: the 'Attendance Management' bounded context. It was decomposed from the 'attendance-app-backend' to isolate all functionality related to the attendance lifecycle. This includes the server-side logic for processing check-in and check-out events, flagging clock discrepancies, handling the supervisor approval workflow, managing the auditable attendance correction process, and executing the daily auto-checkout scheduled job. By containing this critical and complex domain logic in a single, focused service, it simplifies maintenance and allows the core feature of the product to evolve independently of other concerns like user management or reporting.

# 4 Type

🔹 Application Services

# 5 Namespace

com.attendance-app.services.attendance

# 6 Output Path

services/attendance-workflow

# 7 Framework

Firebase Cloud Functions

# 8 Language

TypeScript

# 9 Technology

Firestore, Cloud Functions, Cloud Scheduler

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

REQ-FUN-004

## 13.2.0 Requirement Id

### 13.2.1 Requirement Id

REQ-FUN-005

## 13.3.0 Requirement Id

### 13.3.1 Requirement Id

REQ-FUN-014

# 14.0.0 Generate Tests

✅ Yes

# 15.0.0 Generate Documentation

✅ Yes

# 16.0.0 Architecture Style

Serverless

# 17.0.0 Architecture Map

- event-triggered-functions-006
- scheduled-task-functions-009

# 18.0.0 Components Map

*No items available*

# 19.0.0 Requirements Map

- REQ-FUN-004
- REQ-FUN-005
- REQ-FUN-007
- REQ-FUN-008
- REQ-FUN-014

# 20.0.0 Decomposition Rationale

## 20.1.0 Operation Type

NEW_DECOMPOSED

## 20.2.0 Source Repository

REPO-BACKEND-002

## 20.3.0 Decomposition Reasoning

Isolates the most critical and complex business domain—the attendance lifecycle. This allows the core value proposition of the product to be developed, tested, and deployed independently, increasing agility and reducing the risk of regressions in other areas.

## 20.4.0 Extracted Responsibilities

- Attendance record validation (e.g., clock discrepancy).
- Supervisor approval/rejection logic.
- Attendance correction workflow.
- Scheduled auto-checkout jobs.
- Approval escalation logic.

## 20.5.0 Reusability Scope

- This is a domain-specific service for this application.

## 20.6.0 Development Benefits

- Allows developers to focus on the core business logic without distraction.
- Simplifies testing of complex workflows.
- Independent deployment cycle for core features.

# 21.0.0 Dependency Contracts

*No data available*

# 22.0.0 Exposed Contracts

## 22.1.0 Public Interfaces

### 22.1.1 Interface

#### 22.1.1.1 Interface

Event Handlers

#### 22.1.1.2 Methods

- onAttendanceRecordWrite(change, context)

#### 22.1.1.3 Events

*No items available*

#### 22.1.1.4 Properties

*No items available*

#### 22.1.1.5 Consumers

- Firestore

### 22.1.2.0 Interface

#### 22.1.2.1 Interface

Scheduled Handlers

#### 22.1.2.2 Methods

- runAutoCheckout()
- runApprovalEscalation()

#### 22.1.2.3 Events

*No items available*

#### 22.1.2.4 Properties

*No items available*

#### 22.1.2.5 Consumers

- Google Cloud Scheduler

# 23.0.0.0 Integration Patterns

| Property | Value |
|----------|-------|
| Dependency Injection | N/A |
| Event Communication | Listens to Firestore `onWrite` events for the atte... |
| Data Flow | Reads and writes AttendanceRecord and AuditLog doc... |
| Error Handling | Uses shared error handler. |
| Async Patterns | Extensive use of event-driven and scheduled functi... |

# 24.0.0.0 Technology Guidance

| Property | Value |
|----------|-------|
| Framework Specific | Firestore Triggers are the primary mechanism for i... |
| Performance Considerations | Queries for batch jobs must be efficient and use a... |
| Security Considerations | All state changes must be logged to the immutable ... |
| Testing Approach | Heavy reliance on integration tests with the Fires... |

# 25.0.0.0 Scope Boundaries

## 25.1.0.0 Must Implement

- All business logic for creating, validating, and managing the state of attendance records.

## 25.2.0.0 Must Not Implement

- User profile management.
- Data export or reporting aggregation.

## 25.3.0.0 Extension Points

- New validation rules or workflow steps can be added.

## 25.4.0.0 Validation Rules

- A check-in and check-out must be on the same calendar day.

