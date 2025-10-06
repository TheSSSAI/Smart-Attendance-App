# 1 System Overview

## 1.1 Analysis Date

2025-06-13

## 1.2 Architecture Type

Serverless Event-Triggered Architecture

## 1.3 Technology Stack

- Firebase Cloud Functions
- Firestore
- Firebase Authentication
- Google Cloud Scheduler

## 1.4 Bounded Contexts

- Identity and Access Management
- Attendance Management
- Team and Schedule Management
- Reporting and Analytics

# 2.0 Project Specific Events

## 2.1 Event Id

### 2.1.1 Event Id

EVT-AUTH-001

### 2.1.2 Event Name

UserCreated

### 2.1.3 Event Type

system

### 2.1.4 Category

🔹 Identity and Access Management

### 2.1.5 Description

Triggered after a new user is created in Firebase Authentication. Used to set up the corresponding user document in Firestore and assign custom claims for multi-tenancy and RBAC.

### 2.1.6 Trigger Condition

Firebase Authentication onUserCreate() trigger fires.

### 2.1.7 Source Context

Firebase Authentication

### 2.1.8 Target Contexts

- Identity and Access Management

### 2.1.9 Payload

#### 2.1.9.1 Schema

##### 2.1.9.1.1 Uid

string

##### 2.1.9.1.2 Email

string

##### 2.1.9.1.3 Display Name

string

##### 2.1.9.1.4 Metadata

###### 2.1.9.1.4.1 Creation Time

string

#### 2.1.9.2.0.0 Required Fields

- uid
- email

#### 2.1.9.3.0.0 Optional Fields

- displayName

### 2.1.10.0.0.0 Frequency

medium

### 2.1.11.0.0.0 Business Criticality

critical

### 2.1.12.0.0.0 Data Source

| Property | Value |
|----------|-------|
| Database | Firebase Authentication |
| Table | N/A |
| Operation | create |
| Reference Requirement | REQ-1-033 |

### 2.1.13.0.0.0 Routing

| Property | Value |
|----------|-------|
| Routing Key | N/A |
| Exchange | N/A |
| Queue | N/A (Direct invocation by Firebase Auth) |

### 2.1.14.0.0.0 Consumers

- {'service': 'Application Services (Cloud Function)', 'handler': 'setupNewUser', 'processingType': 'async'}

### 2.1.15.0.0.0 Dependencies

- REQ-1-033

### 2.1.16.0.0.0 Error Handling

| Property | Value |
|----------|-------|
| Retry Strategy | Platform-default exponential backoff |
| Dead Letter Queue | Yes (via 2nd gen Cloud Functions config) |
| Timeout Ms | 60000 |

## 2.2.0.0.0.0 Event Id

### 2.2.1.0.0.0 Event Id

EVT-ATTENDANCE-001

### 2.2.2.0.0.0 Event Name

AttendanceRecordWritten

### 2.2.3.0.0.0 Event Type

domain

### 2.2.4.0.0.0 Category

🔹 Attendance Management

### 2.2.5.0.0.0 Description

Fires whenever an attendance record is created or updated. Used to perform server-side validation like checking for clock discrepancies.

### 2.2.6.0.0.0 Trigger Condition

A document is written to the `/attendance/{recordId}` collection in Firestore.

### 2.2.7.0.0.0 Source Context

Data & Persistence Layer (Firestore)

### 2.2.8.0.0.0 Target Contexts

- Attendance Management

### 2.2.9.0.0.0 Payload

#### 2.2.9.1.0.0 Schema

##### 2.2.9.1.1.0 Before

DocumentSnapshot

##### 2.2.9.1.2.0 After

DocumentSnapshot

#### 2.2.9.2.0.0 Required Fields

- after.data().clientTimestamp
- after.data().serverTimestamp

#### 2.2.9.3.0.0 Optional Fields

*No items available*

### 2.2.10.0.0.0 Frequency

high

### 2.2.11.0.0.0 Business Criticality

important

### 2.2.12.0.0.0 Data Source

| Property | Value |
|----------|-------|
| Database | Firestore |
| Table | AttendanceRecord |
| Operation | update |
| Reference Requirement | REQ-1-044 |

### 2.2.13.0.0.0 Routing

| Property | Value |
|----------|-------|
| Routing Key | N/A |
| Exchange | N/A |
| Queue | N/A (Direct invocation by Firestore) |

### 2.2.14.0.0.0 Consumers

- {'service': 'Application Services (Cloud Function)', 'handler': 'validateAttendanceRecord', 'processingType': 'async'}

### 2.2.15.0.0.0 Dependencies

- REQ-1-044

### 2.2.16.0.0.0 Error Handling

| Property | Value |
|----------|-------|
| Retry Strategy | Platform-default exponential backoff |
| Dead Letter Queue | Yes (via 2nd gen Cloud Functions config) |
| Timeout Ms | 60000 |

## 2.3.0.0.0.0 Event Id

### 2.3.1.0.0.0 Event Id

EVT-EVENT-001

### 2.3.2.0.0.0 Event Name

UserAssignedToEvent

### 2.3.3.0.0.0 Event Type

domain

### 2.3.4.0.0.0 Category

🔹 Team and Schedule Management

### 2.3.5.0.0.0 Description

Triggered when a new assignment is created linking a user to an event. Its purpose is to send a push notification to the user.

### 2.3.6.0.0.0 Trigger Condition

A new document is created in the `/eventAssignments/{assignmentId}` collection where assigneeType is 'USER'.

### 2.3.7.0.0.0 Source Context

Data & Persistence Layer (Firestore)

### 2.3.8.0.0.0 Target Contexts

- Presentation Layer (Flutter Clients)

### 2.3.9.0.0.0 Payload

#### 2.3.9.1.0.0 Schema

| Property | Value |
|----------|-------|
| Event Id | string |
| Assignee Id | string (userId) |
| Assignee Type | string ('USER') |

#### 2.3.9.2.0.0 Required Fields

- eventId
- assigneeId

#### 2.3.9.3.0.0 Optional Fields

*No items available*

### 2.3.10.0.0.0 Frequency

medium

### 2.3.11.0.0.0 Business Criticality

normal

### 2.3.12.0.0.0 Data Source

| Property | Value |
|----------|-------|
| Database | Firestore |
| Table | EventAssignment |
| Operation | create |
| Reference Requirement | REQ-1-056 |

### 2.3.13.0.0.0 Routing

| Property | Value |
|----------|-------|
| Routing Key | N/A |
| Exchange | N/A |
| Queue | N/A (Direct invocation by Firestore) |

### 2.3.14.0.0.0 Consumers

- {'service': 'Application Services (Cloud Function)', 'handler': 'sendNewEventNotification', 'processingType': 'async'}

### 2.3.15.0.0.0 Dependencies

- REQ-1-056

### 2.3.16.0.0.0 Error Handling

| Property | Value |
|----------|-------|
| Retry Strategy | Platform-default exponential backoff |
| Dead Letter Queue | Yes (via 2nd gen Cloud Functions config) |
| Timeout Ms | 60000 |

## 2.4.0.0.0.0 Event Id

### 2.4.1.0.0.0 Event Id

EVT-SYSTEM-001

### 2.4.2.0.0.0 Event Name

DailyScheduledTrigger

### 2.4.3.0.0.0 Event Type

system

### 2.4.4.0.0.0 Category

🔹 System Operations

### 2.4.5.0.0.0 Description

A time-based event triggered daily by Cloud Scheduler. It invokes functions for recurring tasks like auto-checkout, approval escalation, and data retention checks.

### 2.4.6.0.0.0 Trigger Condition

Google Cloud Scheduler job runs at a configured daily interval.

### 2.4.7.0.0.0 Source Context

Operations & Monitoring Layer (Cloud Scheduler)

### 2.4.8.0.0.0 Target Contexts

- Attendance Management
- Identity and Access Management

### 2.4.9.0.0.0 Payload

#### 2.4.9.1.0.0 Schema

##### 2.4.9.1.1.0 Timestamp

string

##### 2.4.9.1.2.0 Timezone

string

#### 2.4.9.2.0.0 Required Fields

- timestamp

#### 2.4.9.3.0.0 Optional Fields

- timezone

### 2.4.10.0.0.0 Frequency

low

### 2.4.11.0.0.0 Business Criticality

important

### 2.4.12.0.0.0 Data Source

| Property | Value |
|----------|-------|
| Database | N/A |
| Table | N/A |
| Operation | read |
| Reference Requirement | REQ-1-045, REQ-1-051, REQ-1-074 |

### 2.4.13.0.0.0 Routing

| Property | Value |
|----------|-------|
| Routing Key | N/A |
| Exchange | N/A |
| Queue | N/A (Pub/Sub topic triggered by Scheduler) |

### 2.4.14.0.0.0 Consumers

- {'service': 'Application Services (Cloud Function)', 'handler': 'handleDailyTasks', 'processingType': 'async'}

### 2.4.15.0.0.0 Dependencies

- REQ-1-045
- REQ-1-051
- REQ-1-074

### 2.4.16.0.0.0 Error Handling

| Property | Value |
|----------|-------|
| Retry Strategy | Platform-default exponential backoff |
| Dead Letter Queue | Yes (via 2nd gen Cloud Functions config) |
| Timeout Ms | 300000 |

# 3.0.0.0.0.0 Event Types And Schema Design

## 3.1.0.0.0.0 Essential Event Types

### 3.1.1.0.0.0 Event Name

#### 3.1.1.1.0.0 Event Name

UserCreated

#### 3.1.1.2.0.0 Category

🔹 system

#### 3.1.1.3.0.0 Description

Handles post-registration logic like creating user profiles and setting claims.

#### 3.1.1.4.0.0 Priority

🔴 high

### 3.1.2.0.0.0 Event Name

#### 3.1.2.1.0.0 Event Name

AttendanceRecordWritten

#### 3.1.2.2.0.0 Category

🔹 domain

#### 3.1.2.3.0.0 Description

Allows for server-side validation of attendance data upon submission.

#### 3.1.2.4.0.0 Priority

🔴 high

### 3.1.3.0.0.0 Event Name

#### 3.1.3.1.0.0 Event Name

UserAssignedToEvent

#### 3.1.3.2.0.0 Category

🔹 domain

#### 3.1.3.3.0.0 Description

Triggers notifications to users about new schedule assignments.

#### 3.1.3.4.0.0 Priority

🟡 medium

### 3.1.4.0.0.0 Event Name

#### 3.1.4.1.0.0 Event Name

DailyScheduledTrigger

#### 3.1.4.2.0.0 Category

🔹 system

#### 3.1.4.3.0.0 Description

Initiates all time-based batch processing for the system.

#### 3.1.4.4.0.0 Priority

🔴 high

## 3.2.0.0.0.0 Schema Design

| Property | Value |
|----------|-------|
| Format | JSON |
| Reasoning | JSON is the native format for Firebase Cloud Funct... |
| Consistency Approach | A standard event envelope will be used, containing... |

## 3.3.0.0.0.0 Schema Evolution

| Property | Value |
|----------|-------|
| Backward Compatibility | ✅ |
| Forward Compatibility | ❌ |
| Strategy | Additive changes only. Consumers must be tolerant ... |

## 3.4.0.0.0.0 Event Structure

### 3.4.1.0.0.0 Standard Fields

- eventId
- eventType
- eventTimestamp
- eventVersion
- sourceService

### 3.4.2.0.0.0 Metadata Requirements

- tenantId for multi-tenancy context
- actingUserId for audit purposes
- traceId for observability

# 4.0.0.0.0.0 Event Routing And Processing

## 4.1.0.0.0.0 Routing Mechanisms

- {'type': 'Firebase Native Triggers', 'description': 'Direct, configuration-based invocation of Cloud Functions from Firebase services (Firestore, Auth, Storage, Pub/Sub). This is the primary mechanism.', 'useCase': 'All event handling for changes within the Firebase ecosystem (e.g., database writes, new user creation).'}

## 4.2.0.0.0.0 Processing Patterns

- {'pattern': 'parallel', 'applicableScenarios': ['All event-triggered functions. The serverless platform automatically scales instances to handle concurrent event processing.'], 'implementation': 'Native behavior of Firebase Cloud Functions. Each event triggers a separate, isolated function invocation.'}

## 4.3.0.0.0.0 Filtering And Subscription

### 4.3.1.0.0.0 Filtering Mechanism

Document Path Wildcards (Firestore) and Event Type (Auth)

### 4.3.2.0.0.0 Subscription Model

Implicit Subscription

### 4.3.3.0.0.0 Routing Keys

- N/A - Routing is based on the source resource path and event type, not explicit keys.

## 4.4.0.0.0.0 Handler Isolation

| Property | Value |
|----------|-------|
| Required | ✅ |
| Approach | Serverless Function Invocation |
| Reasoning | The Firebase Cloud Functions platform provides com... |

## 4.5.0.0.0.0 Delivery Guarantees

| Property | Value |
|----------|-------|
| Level | at-least-once |
| Justification | Firebase background triggers (Firestore, Auth) gua... |
| Implementation | Handlers must be designed to be idempotent to safe... |

# 5.0.0.0.0.0 Event Storage And Replay

## 5.1.0.0.0.0 Persistence Requirements

| Property | Value |
|----------|-------|
| Required | ✅ |
| Duration | Varies by data type |
| Reasoning | Event *state changes* are persisted in Firestore, ... |

## 5.2.0.0.0.0 Event Sourcing

### 5.2.1.0.0.0 Necessary

❌ No

### 5.2.2.0.0.0 Justification

The system's requirements are met by state-stored persistence. The complexity of implementing event sourcing is not justified. The `AuditLog` provides sufficient history for critical actions.

### 5.2.3.0.0.0 Scope

*No items available*

## 5.3.0.0.0.0 Technology Options

- {'technology': 'Firestore', 'suitability': 'high', 'reasoning': 'Used to store the resulting state of events. The `AuditLog` collection acts as a log for specific, high-value domain events.'}

## 5.4.0.0.0.0 Replay Capabilities

### 5.4.1.0.0.0 Required

❌ No

### 5.4.2.0.0.0 Scenarios

- System recovery will be handled via database backups as per REQ-1-071, not by replaying events.

### 5.4.3.0.0.0 Implementation

N/A

## 5.5.0.0.0.0 Retention Policy

| Property | Value |
|----------|-------|
| Strategy | State-based retention defined in Tenant Configurat... |
| Duration | Configurable per tenant (REQ-1-061, REQ-1-074). |
| Archiving Approach | Data is anonymized or deleted from the primary Fir... |

# 6.0.0.0.0.0 Dead Letter Queue And Error Handling

## 6.1.0.0.0.0 Dead Letter Strategy

| Property | Value |
|----------|-------|
| Approach | Utilize built-in support in 2nd gen Firebase Cloud... |
| Queue Configuration | A single Pub/Sub topic configured as the Dead Lett... |
| Processing Logic | Alerting on message count in the DLQ for manual in... |

## 6.2.0.0.0.0 Retry Policies

- {'errorType': 'All transient errors', 'maxRetries': 5, 'backoffStrategy': 'exponential', 'delayConfiguration': 'Handled automatically by the Cloud Functions platform.'}

## 6.3.0.0.0.0 Poison Message Handling

| Property | Value |
|----------|-------|
| Detection Mechanism | Exhaustion of the platform's retry policy. |
| Handling Strategy | Move the event to the configured Dead Letter Queue... |
| Alerting Required | ✅ |

## 6.4.0.0.0.0 Error Notification

### 6.4.1.0.0.0 Channels

- Email
- Google Cloud Monitoring

### 6.4.2.0.0.0 Severity

critical

### 6.4.3.0.0.0 Recipients

- Development/Operations Team

## 6.5.0.0.0.0 Recovery Procedures

### 6.5.1.0.0.0 Scenario

#### 6.5.1.1.0.0 Scenario

A non-idempotent function causes data corruption on retry.

#### 6.5.1.2.0.0 Procedure

Disable the function, manually correct the corrupted data from a backup or logs, fix the handler code to be idempotent, and redeploy.

#### 6.5.1.3.0.0 Automation Level

manual

### 6.5.2.0.0.0 Scenario

#### 6.5.2.1.0.0 Scenario

Poison message in DLQ due to a persistent bug.

#### 6.5.2.2.0.0 Procedure

Inspect the message in the DLQ, identify the bug from logs, deploy a fix, and then manually decide whether to re-inject or discard the message.

#### 6.5.2.3.0.0 Automation Level

semi-automated

# 7.0.0.0.0.0 Event Versioning Strategy

## 7.1.0.0.0.0 Schema Evolution Approach

| Property | Value |
|----------|-------|
| Strategy | Tolerant Reader pattern for consumers. Event produ... |
| Versioning Scheme | Semantic versioning (e.g., 1.0, 1.1) or a simple i... |
| Migration Strategy | For breaking changes, deploy a new function versio... |

## 7.2.0.0.0.0 Compatibility Requirements

| Property | Value |
|----------|-------|
| Backward Compatible | ✅ |
| Forward Compatible | ❌ |
| Reasoning | Consumers must be able to process older versions o... |

## 7.3.0.0.0.0 Version Identification

| Property | Value |
|----------|-------|
| Mechanism | Version property in the event payload. |
| Location | payload |
| Format | string (e.g., "v1.1") |

## 7.4.0.0.0.0 Consumer Upgrade Strategy

| Property | Value |
|----------|-------|
| Approach | Deploy new function versions alongside old ones. S... |
| Rollout Strategy | Blue/Green or Canary deployments if using Cloud Ru... |
| Rollback Procedure | Redeploy the previous working version of the Cloud... |

## 7.5.0.0.0.0 Schema Registry

| Property | Value |
|----------|-------|
| Required | ❌ |
| Technology | N/A |
| Governance | The schema is implicitly defined and managed withi... |

# 8.0.0.0.0.0 Event Monitoring And Observability

## 8.1.0.0.0.0 Monitoring Capabilities

### 8.1.1.0.0.0 Capability

#### 8.1.1.1.0.0 Capability

Function execution count, duration, and error rates.

#### 8.1.1.2.0.0 Justification

Essential for understanding system load, performance, and reliability.

#### 8.1.1.3.0.0 Implementation

Google Cloud Monitoring (provided by default for Cloud Functions).

### 8.1.2.0.0.0 Capability

#### 8.1.2.1.0.0 Capability

Log aggregation and search.

#### 8.1.2.2.0.0 Justification

Crucial for debugging and auditing event processing logic.

#### 8.1.2.3.0.0 Implementation

Google Cloud Logging (provided by default).

### 8.1.3.0.0.0 Capability

#### 8.1.3.1.0.0 Capability

Dead Letter Queue size monitoring.

#### 8.1.3.2.0.0 Justification

To detect and alert on poison messages and persistent failures.

#### 8.1.3.3.0.0 Implementation

Google Cloud Monitoring alert on Pub/Sub topic message count.

## 8.2.0.0.0.0 Tracing And Correlation

| Property | Value |
|----------|-------|
| Tracing Required | ✅ |
| Correlation Strategy | Use the `trace` context provided by the Firebase F... |
| Trace Id Propagation | Handled automatically by the GCP platform for call... |

## 8.3.0.0.0.0 Performance Metrics

### 8.3.1.0.0.0 Metric

#### 8.3.1.1.0.0 Metric

p95 function execution latency

#### 8.3.1.2.0.0 Threshold

< 500ms (as per REQ-1-067)

#### 8.3.1.3.0.0 Alerting

✅ Yes

### 8.3.2.0.0.0 Metric

#### 8.3.2.1.0.0 Metric

Function error rate

#### 8.3.2.2.0.0 Threshold

> 1% (as per REQ-1-076)

#### 8.3.2.3.0.0 Alerting

✅ Yes

## 8.4.0.0.0.0 Event Flow Visualization

| Property | Value |
|----------|-------|
| Required | ✅ |
| Tooling | Google Cloud Trace |
| Scope | Visualizing the trace from the initial trigger (e.... |

## 8.5.0.0.0.0 Alerting Requirements

### 8.5.1.0.0.0 Condition

#### 8.5.1.1.0.0 Condition

Cloud Function error rate > 1% over 5 minutes.

#### 8.5.1.2.0.0 Severity

critical

#### 8.5.1.3.0.0 Response Time

15 minutes

#### 8.5.1.4.0.0 Escalation Path

- On-call developer

### 8.5.2.0.0.0 Condition

#### 8.5.2.1.0.0 Condition

Messages present in Dead Letter Queue for > 10 minutes.

#### 8.5.2.2.0.0 Severity

warning

#### 8.5.2.3.0.0 Response Time

1 hour

#### 8.5.2.4.0.0 Escalation Path

- On-call developer

# 9.0.0.0.0.0 Implementation Priority

## 9.1.0.0.0.0 Component

### 9.1.1.0.0.0 Component

Core Firebase Triggers (Auth, Firestore)

### 9.1.2.0.0.0 Priority

🔴 high

### 9.1.3.0.0.0 Dependencies

*No items available*

### 9.1.4.0.0.0 Estimated Effort

Low (Configuration)

## 9.2.0.0.0.0 Component

### 9.2.1.0.0.0 Component

Idempotent Event Handlers

### 9.2.2.0.0.0 Priority

🔴 high

### 9.2.3.0.0.0 Dependencies

- Core Firebase Triggers

### 9.2.4.0.0.0 Estimated Effort

Medium (Requires careful coding)

## 9.3.0.0.0.0 Component

### 9.3.1.0.0.0 Component

Dead Letter Queue Configuration and Alerting

### 9.3.2.0.0.0 Priority

🟡 medium

### 9.3.3.0.0.0 Dependencies

- Core Firebase Triggers

### 9.3.4.0.0.0 Estimated Effort

Low (Configuration)

## 9.4.0.0.0.0 Component

### 9.4.1.0.0.0 Component

Scheduled (Cron) Job Functions

### 9.4.2.0.0.0 Priority

🟡 medium

### 9.4.3.0.0.0 Dependencies

*No items available*

### 9.4.4.0.0.0 Estimated Effort

Low (Configuration)

# 10.0.0.0.0.0 Risk Assessment

## 10.1.0.0.0.0 Risk

### 10.1.1.0.0.0 Risk

Non-idempotent function handlers causing data corruption on retries.

### 10.1.2.0.0.0 Impact

high

### 10.1.3.0.0.0 Probability

medium

### 10.1.4.0.0.0 Mitigation

Enforce code reviews and testing standards that specifically validate idempotency for all background event handlers.

## 10.2.0.0.0.0 Risk

### 10.2.1.0.0.0 Risk

Uncontrolled function execution due to a recursive trigger loop (e.g., a function that writes to a document that triggers itself).

### 10.2.2.0.0.0 Impact

high

### 10.2.3.0.0.0 Probability

low

### 10.2.4.0.0.0 Mitigation

Careful design of Firestore triggers to ensure a function's output does not re-trigger its own input condition. Implement budget alerts as a fail-safe (REQ-1-076).

## 10.3.0.0.0.0 Risk

### 10.3.1.0.0.0 Risk

Increased latency due to Cloud Function cold starts.

### 10.3.2.0.0.0 Impact

medium

### 10.3.3.0.0.0 Probability

high

### 10.3.4.0.0.0 Mitigation

Set minimum instances for critical functions to keep them warm. Accept that some latency is inherent in the serverless model for non-critical, infrequently used functions.

# 11.0.0.0.0.0 Recommendations

## 11.1.0.0.0.0 Category

### 11.1.1.0.0.0 Category

🔹 Design

### 11.1.2.0.0.0 Recommendation

Strictly enforce idempotency in all background event handlers from day one.

### 11.1.3.0.0.0 Justification

The at-least-once delivery guarantee of Firebase triggers makes idempotency non-negotiable to prevent data duplication and corruption.

### 11.1.4.0.0.0 Priority

🔴 high

## 11.2.0.0.0.0 Category

### 11.2.1.0.0.0 Category

🔹 Operations

### 11.2.2.0.0.0 Recommendation

Configure Dead Letter Queues and associated monitoring alerts for all critical background-triggered functions before deploying to production.

### 11.2.3.0.0.0 Justification

This is the primary mechanism for preventing data loss from transient or persistent processing failures.

### 11.2.4.0.0.0 Priority

🔴 high

## 11.3.0.0.0.0 Category

### 11.3.1.0.0.0 Category

🔹 Simplicity

### 11.3.2.0.0.0 Recommendation

Avoid introducing a dedicated message bus (like Pub/Sub for inter-service communication) until a clear requirement emerges. Rely on the native Firebase triggers.

### 11.3.3.0.0.0 Justification

The current architecture's needs are fully met by the direct trigger mechanisms, and adding a message bus would introduce unnecessary complexity and cost.

### 11.3.4.0.0.0 Priority

🔴 high

