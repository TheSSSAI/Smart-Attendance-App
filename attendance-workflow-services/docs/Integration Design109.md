# 1 Integration Specifications

## 1.1 Extraction Metadata

| Property | Value |
|----------|-------|
| Repository Id | REPO-SVC-ATTENDANCE-004 |
| Extraction Timestamp | 2024-07-28T12:00:00Z |
| Mapping Validation Score | 100% |
| Context Completeness Score | 98% |
| Implementation Readiness Level | High |

## 1.2 Relevant Requirements

### 1.2.1 Requirement Id

#### 1.2.1.1 Requirement Id

REQ-1-044

#### 1.2.1.2 Requirement Text

When an attendance record is created or updated on the server, a `serverTimestamp` field must be populated using Firestore's `FieldValue.serverTimestamp()`. A Cloud Function trigger on write must then compare the `clientTimestamp` (from check-in or check-out) with this `serverTimestamp`. If the absolute difference between the two timestamps is greater than 5 minutes, the function must add a 'clock_discrepancy' flag to the attendance record.

#### 1.2.1.3 Validation Criteria

- Manually set a device's clock back by 10 minutes.
- Perform a check-in.
- Inspect the created attendance record in Firestore and verify it contains the 'clock_discrepancy' flag.

#### 1.2.1.4 Implementation Implications

- An `onWrite` or `onUpdate` Cloud Function must be triggered by changes to the `attendance` collection.
- The function will read the `clientTimestamp` from the write payload and compare it to the server-generated timestamp.
- If the condition is met, the function must perform a subsequent update to the same document to add the flag.

#### 1.2.1.5 Extraction Reasoning

This requirement explicitly defines the logic for the 'clock discrepancy' feature, which is a core responsibility of this attendance workflow service, implemented as a Firestore-triggered function.

### 1.2.2.0 Requirement Id

#### 1.2.2.1 Requirement Id

REQ-1-045

#### 1.2.2.2 Requirement Text

The system shall support an automated check-out feature, configurable by the Admin. A scheduled Cloud Function must execute daily at the configured auto-checkout time for each tenant, respecting the tenant's timezone. This function will query for all attendance records from that day that have a `checkInTime` but no `checkOutTime`. For each found record, the function must update it by setting the `checkOutTime` to the configured time and adding an 'auto-checked-out' flag.

#### 1.2.2.3 Validation Criteria

- Configure auto-checkout for a tenant at 5:00 PM.
- Create an attendance record with only a check-in at 9:00 AM.
- After 5:00 PM, verify the scheduled function has run and the record now has a `checkOutTime` of 5:00 PM and the 'auto-checked-out' flag.

#### 1.2.2.4 Implementation Implications

- A scheduled Cloud Function must be implemented, triggered daily by Google Cloud Scheduler.
- The function logic must iterate through all tenants, read their specific auto-checkout configuration and timezone.
- For each eligible tenant, it must perform an indexed query for open attendance records and update them using a Firestore Batched Write.

#### 1.2.2.5 Extraction Reasoning

This requirement details the full specification for the 'daily auto-checkout scheduled job', which is explicitly listed as a primary responsibility of this repository.

### 1.2.3.0 Requirement Id

#### 1.2.3.1 Requirement Id

REQ-1-051

#### 1.2.3.2 Requirement Text

The system shall implement an approval escalation workflow. A scheduled Cloud Function must run daily to identify pending attendance records that have remained un-actioned beyond a tenant-configurable deadline. For each such record, the function must identify the current Supervisor's own supervisor (the next level in the hierarchy) and reassign the approval request to them. Every escalation action must be recorded as an event in the `auditLog` collection.

#### 1.2.3.3 Validation Criteria

- Configure an approval deadline of 2 days.
- Wait 3 days.
- Verify the scheduled function has reassigned the record's `supervisorId` to the original supervisor's manager.
- Verify an entry was created in the audit log for the escalation event.

#### 1.2.3.4 Implementation Implications

- Another scheduled Cloud Function is required for this daily task.
- The function must perform complex logic: query for overdue records, traverse the user hierarchy by reading `supervisorId` fields from the `users` collection, and handle edge cases like top-level managers or deactivated supervisors.
- The update to the attendance record and the creation of the audit log entry must be performed in a single atomic transaction.

#### 1.2.3.5 Extraction Reasoning

This defines the 'supervisor approval workflow' escalation logic, a key automated business process that is a core responsibility of this service.

### 1.2.4.0 Requirement Id

#### 1.2.4.1 Requirement Id

REQ-1-053

#### 1.2.4.2 Requirement Text

When a Supervisor approves a correction request, a Cloud Function must be triggered. This function shall: 1) Update the attendance record with the corrected time(s). 2) Add a 'manually-corrected' flag to the record. 3) Create a new, immutable entry in the `auditLog` collection that captures the full details of the transaction, including the requester, approver, justification, original times, and the new times.

#### 1.2.4.3 Validation Criteria

- As a Supervisor, approve a pending correction request.
- Verify the attendance record's timestamp fields are updated to the corrected values.
- Inspect the `auditLog` collection and verify a new, detailed entry for the correction exists.

#### 1.2.4.4 Implementation Implications

- A callable Cloud Function is required to handle this user-initiated, privileged action.
- The function must perform a Firestore transaction to atomically update the `attendance` document and create the `auditLog` document, ensuring data consistency.
- It must validate that the caller is the authorized supervisor for the record.

#### 1.2.4.5 Extraction Reasoning

This requirement details the server-side implementation of the 'auditable attendance correction process', which is explicitly within this repository's scope.

## 1.3.0.0 Relevant Components

- {'component_name': 'Attendance Workflow Service', 'component_specification': "A serverless microservice, implemented as a collection of Firebase Cloud Functions, that encapsulates the 'Attendance Management' bounded context. It is responsible for all server-side business logic related to the lifecycle of attendance records, including state transitions (approval/rejection), data validation, and automated, time-based processes like auto-checkout and approval escalation.", 'implementation_requirements': ["All functions must be multi-tenant aware, validating the caller's `tenantId` and scoping all database queries accordingly.", 'Functions must be stateless and adhere to a Clean Architecture pattern for testability.', 'All operations that modify more than one document (e.g., updating an attendance record and creating an audit log) must use atomic Firestore transactions.', 'The service must consume shared data contracts from `REPO-LIB-CORE-001` and shared utilities from `REPO-LIB-BACKEND-002`.'], 'architectural_context': "This component is a primary microservice within the 'Application Services' layer of the system architecture.", 'extraction_reasoning': 'This component represents the entirety of the `attendance-workflow-services` repository, summarizing its scope, responsibilities, and key architectural constraints.'}

## 1.4.0.0 Architectural Layers

- {'layer_name': 'Application Services (Firebase Cloud Functions)', 'layer_responsibilities': 'Executes complex, trusted business logic that cannot be handled by declarative rules or on the client. This includes performing scheduled tasks like automated check-outs, approval escalations, data retention/anonymization, and automated Google Sheets exports. It also integrates with third-party services like SendGrid and provides secure endpoints (Callable Functions) for client applications.', 'layer_constraints': ['Must be implemented using TypeScript.', 'All logic must be stateless.', 'Must be triggered by platform events (Firestore, Scheduler) or secure client calls (Callable Functions).'], 'implementation_patterns': ['Event-Driven Functions', 'Scheduled Functions', 'Callable Functions'], 'extraction_reasoning': "The repository's description and technology stack place it squarely in this architectural layer, where it implements the 'Attendance Management' portion of the system's business logic."}

## 1.5.0.0 Dependency Interfaces

### 1.5.1.0 Interface Name

#### 1.5.1.1 Interface Name

Data Model Contracts

#### 1.5.1.2 Source Repository

REPO-LIB-CORE-001

#### 1.5.1.3 Method Contracts

- {'method_name': 'N/A (Type Definitions)', 'method_signature': 'export interface AttendanceRecord { ... }', 'method_purpose': 'Provides standardized, type-safe data contracts (TypeScript interfaces and Zod schemas) for all core domain entities, such as `AttendanceRecord`, `User`, `Tenant`, and `AuditLog`.', 'integration_context': 'Consumed at build-time via TypeScript imports in all service files to ensure consistent data structures when interacting with Firestore and defining API payloads.'}

#### 1.5.1.4 Integration Pattern

Compile-Time Library Import

#### 1.5.1.5 Communication Protocol

TypeScript Module Import

#### 1.5.1.6 Extraction Reasoning

As a core business logic service, this repository must depend on the single source of truth for data models to ensure consistency with the rest of the backend ecosystem. This is a foundational dependency for type-safe development.

### 1.5.2.0 Interface Name

#### 1.5.2.1 Interface Name

Shared Backend Utilities

#### 1.5.2.2 Source Repository

REPO-LIB-BACKEND-002

#### 1.5.2.3 Method Contracts

##### 1.5.2.3.1 Method Name

###### 1.5.2.3.1.1 Method Name

ILogger.error

###### 1.5.2.3.1.2 Method Signature

error(message: string, error: Error, context?: object): void

###### 1.5.2.3.1.3 Method Purpose

Provides a standardized utility for structured logging compatible with Google Cloud's Operations Suite.

###### 1.5.2.3.1.4 Integration Context

Used in all `catch` blocks and for general operational logging throughout the service's functions to meet REQ-1-076.

##### 1.5.2.3.2.0 Method Name

###### 1.5.2.3.2.1 Method Name

IContextUtils.getContext

###### 1.5.2.3.2.2 Method Signature

getContext(context: functions.https.CallableContext): FirebaseRequestContext

###### 1.5.2.3.2.3 Method Purpose

Provides a standardized utility for parsing and validating the caller's authentication context, including their `userId`, `tenantId`, and `role`.

###### 1.5.2.3.2.4 Integration Context

Called at the beginning of every callable function to enforce security and multi-tenancy before any business logic is executed.

#### 1.5.2.4.0.0 Integration Pattern

Compile-Time Library Import

#### 1.5.2.5.0.0 Communication Protocol

TypeScript Module Import

#### 1.5.2.6.0.0 Extraction Reasoning

This service must use shared utilities for cross-cutting concerns like logging and security context parsing to ensure consistency and maintainability across the backend microservices, as specified by the system architecture.

### 1.5.3.0.0.0 Interface Name

#### 1.5.3.1.0.0 Interface Name

Firestore Admin SDK

#### 1.5.3.2.0.0 Source Repository

Firebase/GCP

#### 1.5.3.3.0.0 Method Contracts

##### 1.5.3.3.1.0 Method Name

###### 1.5.3.3.1.1 Method Name

db.collection(...).where(...).get()

###### 1.5.3.3.1.2 Method Signature

Query(...): Promise<QuerySnapshot>

###### 1.5.3.3.1.3 Method Purpose

To read documents from Firestore collections such as `users`, `tenants/config`, and `attendance` for validation and processing.

###### 1.5.3.3.1.4 Integration Context

Used in all functions to retrieve data for business logic, e.g., finding a user's supervisor, getting a tenant's auto-checkout time, or querying for pending records.

##### 1.5.3.3.2.0 Method Name

###### 1.5.3.3.2.1 Method Name

db.runTransaction(updateFunction)

###### 1.5.3.3.2.2 Method Signature

runTransaction(updateFunction: (transaction: Transaction) => Promise<any>): Promise<any>

###### 1.5.3.3.2.3 Method Purpose

To perform atomic, multi-document writes, ensuring data consistency.

###### 1.5.3.3.2.4 Integration Context

Used whenever an attendance record must be updated AND an audit log entry must be created simultaneously, such as in the correction approval workflow, to satisfy atomicity requirements.

#### 1.5.3.4.0.0 Integration Pattern

Direct Data Access via SDK

#### 1.5.3.5.0.0 Communication Protocol

gRPC (managed by SDK)

#### 1.5.3.6.0.0 Extraction Reasoning

Firestore is the primary data persistence layer for the application. As this service runs with elevated privileges, it interacts directly with the database via the Admin SDK to perform its core functions.

## 1.6.0.0.0.0 Exposed Interfaces

### 1.6.1.0.0.0 Interface Name

#### 1.6.1.1.0.0 Interface Name

Callable Attendance API

#### 1.6.1.2.0.0 Consumer Repositories

- REPO-APP-MOBILE-010
- REPO-APP-ADMIN-011

#### 1.6.1.3.0.0 Method Contracts

##### 1.6.1.3.1.0 Method Name

###### 1.6.1.3.1.1 Method Name

approveAttendance

###### 1.6.1.3.1.2 Method Signature

onCall(data: { recordId: string }, context: CallableContext): Promise<{ success: boolean }>

###### 1.6.1.3.1.3 Method Purpose

Allows a supervisor to approve a pending attendance record. Implements the server-side logic for REQ-1-005.

###### 1.6.1.3.1.4 Implementation Requirements

Must validate that `context.auth.uid` is the designated supervisor for the given `recordId`.

##### 1.6.1.3.2.0 Method Name

###### 1.6.1.3.2.1 Method Name

rejectAttendance

###### 1.6.1.3.2.2 Method Signature

onCall(data: { recordId: string, reason: string }, context: CallableContext): Promise<{ success: boolean }>

###### 1.6.1.3.2.3 Method Purpose

Allows a supervisor to reject a pending attendance record. Implements the server-side logic for REQ-1-049.

###### 1.6.1.3.2.4 Implementation Requirements

Must validate that `context.auth.uid` is the designated supervisor and that a `reason` is provided.

##### 1.6.1.3.3.0 Method Name

###### 1.6.1.3.3.1 Method Name

approveCorrection

###### 1.6.1.3.3.2 Method Signature

onCall(data: { recordId: string }, context: CallableContext): Promise<{ success: boolean }>

###### 1.6.1.3.3.3 Method Purpose

Allows a supervisor to approve a pending attendance correction request. Implements the server-side logic for REQ-1-053.

###### 1.6.1.3.3.4 Implementation Requirements

Must be transactional, updating the attendance record and creating an audit log entry.

##### 1.6.1.3.4.0 Method Name

###### 1.6.1.3.4.1 Method Name

rejectCorrection

###### 1.6.1.3.4.2 Method Signature

onCall(data: { recordId: string, reason: string }, context: CallableContext): Promise<{ success: boolean }>

###### 1.6.1.3.4.3 Method Purpose

Allows a supervisor to reject a pending attendance correction request. This is the logical counterpart to `approveCorrection`.

###### 1.6.1.3.4.4 Implementation Requirements

Must be transactional, reverting the attendance record's status and creating an audit log entry.

#### 1.6.1.4.0.0 Service Level Requirements

- p95 latency < 500ms (as per REQ-1-067)

#### 1.6.1.5.0.0 Implementation Constraints

- All functions must be implemented as Firebase Callable Functions.
- Functions must validate the caller's role and tenantId from the `context.auth.token` claims before executing any logic.
- Must use `HttpsError` for returning structured errors to the client.

#### 1.6.1.6.0.0 Extraction Reasoning

This interface exposes the synchronous, client-initiated business logic for the attendance approval workflow. It is consumed by the mobile and web clients to allow authorized users (Supervisors, Admins) to action attendance records.

### 1.6.2.0.0.0 Interface Name

#### 1.6.2.1.0.0 Interface Name

Attendance Event Handlers

#### 1.6.2.2.0.0 Consumer Repositories

- Firestore

#### 1.6.2.3.0.0 Method Contracts

- {'method_name': 'onAttendanceRecordWrite', 'method_signature': 'onWrite(change: Change<DocumentSnapshot>, context: EventContext): Promise<void>', 'method_purpose': 'Triggered on any create or update event in the attendance collection. It performs server-side validation, such as the clock discrepancy check (REQ-1-044).', 'implementation_requirements': 'Must be idempotent and handle both create and update event types.'}

#### 1.6.2.4.0.0 Service Level Requirements

- Function execution should complete quickly to avoid delaying subsequent triggers.

#### 1.6.2.5.0.0 Implementation Constraints

- Must be deployed as a Firestore-triggered Cloud Function.

#### 1.6.2.6.0.0 Extraction Reasoning

This interface represents the reactive, event-driven integration with the Firestore database. It enables the system to enforce data integrity rules automatically as data changes.

### 1.6.3.0.0.0 Interface Name

#### 1.6.3.1.0.0 Interface Name

Scheduled Task Handlers

#### 1.6.3.2.0.0 Consumer Repositories

- Google Cloud Scheduler

#### 1.6.3.3.0.0 Method Contracts

##### 1.6.3.3.1.0 Method Name

###### 1.6.3.3.1.1 Method Name

runAutoCheckout

###### 1.6.3.3.1.2 Method Signature

onRun(context: EventContext): Promise<void>

###### 1.6.3.3.1.3 Method Purpose

Executes the daily job to find and close out any attendance records that were not manually checked out, as per REQ-1-045.

###### 1.6.3.3.1.4 Implementation Requirements

Must be idempotent. Must efficiently query and batch-update records across multiple tenants based on their individual configurations.

##### 1.6.3.3.2.0 Method Name

###### 1.6.3.3.2.1 Method Name

runApprovalEscalation

###### 1.6.3.3.2.2 Method Signature

onRun(context: EventContext): Promise<void>

###### 1.6.3.3.2.3 Method Purpose

Executes the daily job to escalate any pending approval requests that have exceeded the tenant-configured deadline, as per REQ-1-051.

###### 1.6.3.3.2.4 Implementation Requirements

Must be idempotent. Logic must correctly traverse the user hierarchy and handle various edge cases.

#### 1.6.3.4.0.0 Service Level Requirements

- Function execution must complete within the Cloud Function timeout limit (e.g., 540 seconds).

#### 1.6.3.5.0.0 Implementation Constraints

- Must be deployed as a Pub/Sub-triggered Cloud Function linked to a Cloud Scheduler job.
- Must be designed to handle processing for all tenants in a single run.

#### 1.6.3.6.0.0 Extraction Reasoning

This interface exposes the time-based, asynchronous batch processing functions of the service. It is consumed by an external trigger (Cloud Scheduler) to automate key business processes.

## 1.7.0.0.0.0 Technology Context

### 1.7.1.0.0.0 Framework Requirements

The service must be built using Firebase Cloud Functions with TypeScript and the Node.js runtime.

### 1.7.2.0.0.0 Integration Technologies

- Firestore
- Google Cloud Scheduler
- Firebase Authentication

### 1.7.3.0.0.0 Performance Constraints

Scheduled functions performing batch operations must use efficient, indexed queries and Firestore Batched Writes to stay within execution time and cost limits. Callable functions must meet the p95 latency target of <500ms.

### 1.7.4.0.0.0 Security Requirements

As this service operates with Admin SDK privileges (bypassing Firestore Security Rules), all functions must perform strict, server-side validation of the caller's role and tenantId from the Firebase Auth token before executing any logic. All data access must be explicitly scoped to the validated tenant.

## 1.8.0.0.0.0 Extraction Validation

| Property | Value |
|----------|-------|
| Mapping Completeness Check | The analysis confirmed that all primary responsibi... |
| Cross Reference Validation | All extracted requirements, components, and interf... |
| Implementation Readiness Assessment | Readiness is High. The specification provides a cl... |
| Quality Assurance Confirmation | The systematic analysis confirmed all repository m... |

