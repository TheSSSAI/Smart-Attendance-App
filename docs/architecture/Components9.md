# 1 Components

## 1.1 Components

### 1.1.1 Cross-Platform Client Application

#### 1.1.1.1 Id

flutter-mobile-web-client-001

#### 1.1.1.2 Name

Cross-Platform Client Application

#### 1.1.1.3 Description

A single Flutter codebase for the iOS/Android mobile application and the web-based administrative dashboard. It implements the Presentation layer of the Clean Architecture, managing UI, state, and user interaction.

#### 1.1.1.4 Type

🔹 Client Application

#### 1.1.1.5 Dependencies

- callable-functions-api-002
- data-repository-abstractions-003
- firebase-client-sdks-004

#### 1.1.1.6 Properties

| Property | Value |
|----------|-------|
| Architecture | Clean Architecture |
| State Management | Riverpod 2.x |

#### 1.1.1.7 Interfaces

*No items available*

#### 1.1.1.8 Technology

Flutter 3.x, Dart

#### 1.1.1.9 Resources

| Property | Value |
|----------|-------|
| Cpu | N/A (Client Device) |
| Memory | N/A (Client Device) |
| Storage | Local Cache for Offline Mode |

#### 1.1.1.10 Configuration

*No data available*

#### 1.1.1.11 Health Check

*No data available*

#### 1.1.1.12 Responsible Features

- REQ-1-001
- REQ-1-004
- REQ-1-009
- REQ-1-010
- REQ-1-019
- REQ-1-041
- REQ-1-052
- REQ-1-056
- REQ-1-061
- REQ-1-062
- REQ-1-063

#### 1.1.1.13 Security

##### 1.1.1.13.1 Requires Authentication

✅ Yes

##### 1.1.1.13.2 Requires Authorization

❌ No

##### 1.1.1.13.3 Allowed Roles

- Admin
- Supervisor
- Subordinate

### 1.1.2.0.0 Callable Functions API

#### 1.1.2.1.0 Id

callable-functions-api-002

#### 1.1.2.2.0 Name

Callable Functions API

#### 1.1.2.3.0 Description

A set of HTTPS-callable Firebase Cloud Functions that serve as the primary API endpoint for the client application. They handle complex business logic and actions that require elevated privileges or server-side validation.

#### 1.1.2.4.0 Type

🔹 Cloud Function (Callable)

#### 1.1.2.5.0 Dependencies

- secret-manager-client-007
- integration-clients-008
- firestore-service-005

#### 1.1.2.6.0 Properties

*No data available*

#### 1.1.2.7.0 Interfaces

- RESTful-like API for client

#### 1.1.2.8.0 Technology

TypeScript, Firebase Cloud Functions

#### 1.1.2.9.0 Resources

| Property | Value |
|----------|-------|
| Cpu | Dynamic (Serverless) |
| Memory | 512MB |
| Network | Dynamic (Serverless) |

#### 1.1.2.10.0 Configuration

##### 1.1.2.10.1 Timeout

60s

#### 1.1.2.11.0 Health Check

*No data available*

#### 1.1.2.12.0 Responsible Features

- REQ-1-022
- REQ-1-029
- REQ-1-032
- REQ-1-034
- REQ-1-036
- REQ-1-077

#### 1.1.2.13.0 Security

##### 1.1.2.13.1 Requires Authentication

✅ Yes

##### 1.1.2.13.2 Requires Authorization

✅ Yes

##### 1.1.2.13.3 Allowed Roles

*No items available*

### 1.1.3.0.0 Client Data Repositories

#### 1.1.3.1.0 Id

data-repository-abstractions-003

#### 1.1.3.2.0 Name

Client Data Repositories

#### 1.1.3.3.0 Description

A set of abstract data access components within the Flutter client's Data layer. They implement the Repository Pattern, decoupling the application's domain logic from the underlying data source (Firestore or local cache).

#### 1.1.3.4.0 Type

🔹 Repository

#### 1.1.3.5.0 Dependencies

- firebase-client-sdks-004

#### 1.1.3.6.0 Properties

| Property | Value |
|----------|-------|
| Pattern | Repository Pattern |

#### 1.1.3.7.0 Interfaces

- IUserRepository
- IAttendanceRepository
- ITeamRepository

#### 1.1.3.8.0 Technology

Dart

#### 1.1.3.9.0 Resources

*No data available*

#### 1.1.3.10.0 Configuration

*No data available*

#### 1.1.3.11.0 Security

##### 1.1.3.11.1 Requires Authentication

❌ No

##### 1.1.3.11.2 Requires Authorization

❌ No

### 1.1.4.0.0 Firebase Client SDKs

#### 1.1.4.1.0 Id

firebase-client-sdks-004

#### 1.1.4.2.0 Name

Firebase Client SDKs

#### 1.1.4.3.0 Description

The official Firebase SDKs integrated into the Flutter client. This component handles real-time data synchronization with Firestore, user authentication, offline persistence, and receiving push notifications.

#### 1.1.4.4.0 Type

🔹 SDK

#### 1.1.4.5.0 Dependencies

*No items available*

#### 1.1.4.6.0 Properties

*No data available*

#### 1.1.4.7.0 Interfaces

*No items available*

#### 1.1.4.8.0 Technology

Firebase SDK for Flutter

#### 1.1.4.9.0 Resources

*No data available*

#### 1.1.4.10.0 Configuration

*No data available*

#### 1.1.4.11.0 Security

##### 1.1.4.11.1 Requires Authentication

✅ Yes

### 1.1.5.0.0 Firestore Database & Security Rules

#### 1.1.5.1.0 Id

firestore-service-005

#### 1.1.5.2.0 Name

Firestore Database & Security Rules

#### 1.1.5.3.0 Description

The core data persistence component, including the NoSQL database schema and the critical Firestore Security Ruleset. The ruleset is a key component that enforces all multi-tenancy, RBAC, and data validation logic at the database level.

#### 1.1.5.4.0 Type

🔹 Database

#### 1.1.5.5.0 Dependencies

*No items available*

#### 1.1.5.6.0 Properties

| Property | Value |
|----------|-------|
| Ia Cmanaged | ✅ |

#### 1.1.5.7.0 Interfaces

*No items available*

#### 1.1.5.8.0 Technology

Firestore, Firestore Security Rules Language

#### 1.1.5.9.0 Resources

##### 1.1.5.9.1 Storage

Dynamic (Serverless)

#### 1.1.5.10.0 Configuration

##### 1.1.5.10.1 Indexes

firestore.indexes.json

##### 1.1.5.10.2 Rules

firestore.rules

#### 1.1.5.11.0 Security

##### 1.1.5.11.1 Requires Authentication

✅ Yes

##### 1.1.5.11.2 Requires Authorization

✅ Yes

### 1.1.6.0.0 Event-Triggered Logic Functions

#### 1.1.6.1.0 Id

event-triggered-functions-006

#### 1.1.6.2.0 Name

Event-Triggered Logic Functions

#### 1.1.6.3.0 Description

A collection of background Cloud Functions triggered by events in Firestore (e.g., onWrite) or Firebase Auth (e.g., onCreateUser). They perform reactive logic, such as data validation, logging, and triggering notifications.

#### 1.1.6.4.0 Type

🔹 Cloud Function (Event Triggered)

#### 1.1.6.5.0 Dependencies

- firestore-service-005
- integration-clients-008

#### 1.1.6.6.0 Properties

*No data available*

#### 1.1.6.7.0 Interfaces

*No items available*

#### 1.1.6.8.0 Technology

TypeScript, Firebase Cloud Functions

#### 1.1.6.9.0 Resources

##### 1.1.6.9.1 Cpu

Dynamic (Serverless)

##### 1.1.6.9.2 Memory

256MB

#### 1.1.6.10.0 Configuration

*No data available*

#### 1.1.6.11.0 Health Check

*No data available*

#### 1.1.6.12.0 Responsible Features

- REQ-1-029
- REQ-1-044
- REQ-1-049
- REQ-1-053
- REQ-1-056

#### 1.1.6.13.0 Security

##### 1.1.6.13.1 Requires Authentication

❌ No

##### 1.1.6.13.2 Requires Authorization

❌ No

### 1.1.7.0.0 Secret Management Component

#### 1.1.7.1.0 Id

secret-manager-client-007

#### 1.1.7.2.0 Name

Secret Management Component

#### 1.1.7.3.0 Description

A server-side component responsible for securely accessing secrets (e.g., API keys for SendGrid, Google APIs) from Google Secret Manager at runtime. This prevents secrets from being hardcoded in source code.

#### 1.1.7.4.0 Type

🔹 Security Service

#### 1.1.7.5.0 Dependencies

*No items available*

#### 1.1.7.6.0 Properties

*No data available*

#### 1.1.7.7.0 Interfaces

*No items available*

#### 1.1.7.8.0 Technology

Google Secret Manager API Client

#### 1.1.7.9.0 Resources

*No data available*

#### 1.1.7.10.0 Configuration

*No data available*

#### 1.1.7.11.0 Security

##### 1.1.7.11.1 Requires Authentication

✅ Yes

### 1.1.8.0.0 Third-Party Integration Clients

#### 1.1.8.1.0 Id

integration-clients-008

#### 1.1.8.2.0 Name

Third-Party Integration Clients

#### 1.1.8.3.0 Description

Server-side clients and SDKs for interacting with external services. This includes sending emails via SendGrid and writing data to Google Sheets.

#### 1.1.8.4.0 Type

🔹 Integration Client

#### 1.1.8.5.0 Dependencies

- secret-manager-client-007

#### 1.1.8.6.0 Properties

*No data available*

#### 1.1.8.7.0 Interfaces

*No items available*

#### 1.1.8.8.0 Technology

Google APIs Node.js Client, SendGrid Mail SDK

#### 1.1.8.9.0 Resources

*No data available*

#### 1.1.8.10.0 Configuration

*No data available*

#### 1.1.8.11.0 Security

##### 1.1.8.11.1 Requires Authentication

❌ No

##### 1.1.8.11.2 Requires Authorization

❌ No

### 1.1.9.0.0 Scheduled Task Functions

#### 1.1.9.1.0 Id

scheduled-task-functions-009

#### 1.1.9.2.0 Name

Scheduled Task Functions

#### 1.1.9.3.0 Description

A set of Cloud Functions triggered by Google Cloud Scheduler on a recurring basis. They handle all time-based batch jobs for the system.

#### 1.1.9.4.0 Type

🔹 Cloud Function (Scheduled)

#### 1.1.9.5.0 Dependencies

- firestore-service-005
- integration-clients-008

#### 1.1.9.6.0 Properties

*No data available*

#### 1.1.9.7.0 Interfaces

*No items available*

#### 1.1.9.8.0 Technology

TypeScript, Firebase Cloud Functions, Google Cloud Scheduler

#### 1.1.9.9.0 Resources

##### 1.1.9.9.1 Cpu

Dynamic (Serverless)

##### 1.1.9.9.2 Memory

512MB

#### 1.1.9.10.0 Configuration

*No data available*

#### 1.1.9.11.0 Health Check

*No data available*

#### 1.1.9.12.0 Responsible Features

- REQ-1-031
- REQ-1-045
- REQ-1-051
- REQ-1-059
- REQ-1-070
- REQ-1-074

#### 1.1.9.13.0 Security

##### 1.1.9.13.1 Requires Authentication

❌ No

##### 1.1.9.13.2 Requires Authorization

❌ No

### 1.1.10.0.0 CI/CD Pipeline

#### 1.1.10.1.0 Id

cicd-pipeline-010

#### 1.1.10.2.0 Name

CI/CD Pipeline

#### 1.1.10.3.0 Description

Automated workflows for building, testing, and deploying all parts of the system, including the Flutter client and Firebase backend resources (Functions, Rules, Indexes). Managed as code.

#### 1.1.10.4.0 Type

🔹 CI/CD

#### 1.1.10.5.0 Dependencies

*No items available*

#### 1.1.10.6.0 Properties

| Property | Value |
|----------|-------|
| Ia Cmanaged | ✅ |

#### 1.1.10.7.0 Interfaces

*No items available*

#### 1.1.10.8.0 Technology

GitHub Actions, Firebase CLI

#### 1.1.10.9.0 Resources

*No data available*

#### 1.1.10.10.0 Configuration

##### 1.1.10.10.1 Workflow Files

.github/workflows/*.yml

#### 1.1.10.11.0 Security

##### 1.1.10.11.1 Requires Authentication

✅ Yes

### 1.1.11.0.0 Monitoring, Logging, and Alerting

#### 1.1.11.1.0 Id

monitoring-and-logging-011

#### 1.1.11.2.0 Name

Monitoring, Logging, and Alerting

#### 1.1.11.3.0 Description

A cross-cutting component that provides operational visibility. It includes client-side crash reporting and server-side performance monitoring, logging, and alerting for errors and budgets.

#### 1.1.11.4.0 Type

🔹 Monitoring

#### 1.1.11.5.0 Dependencies

*No items available*

#### 1.1.11.6.0 Properties

*No data available*

#### 1.1.11.7.0 Interfaces

*No items available*

#### 1.1.11.8.0 Technology

Google Cloud's Operations Suite, Firebase Crashlytics

#### 1.1.11.9.0 Resources

*No data available*

#### 1.1.11.10.0 Configuration

##### 1.1.11.10.1 Alert Policies

Managed in GCP Console/Terraform

##### 1.1.11.10.2 Budget Alerts

Managed in GCP Billing

#### 1.1.11.11.0 Security

##### 1.1.11.11.1 Requires Authentication

❌ No

##### 1.1.11.11.2 Requires Authorization

❌ No

### 1.1.12.0.0 Backup and Recovery Component

#### 1.1.12.1.0 Id

backup-and-recovery-012

#### 1.1.12.2.0 Name

Backup and Recovery Component

#### 1.1.12.3.0 Description

The configuration and process for performing automated daily backups of the Firestore database to Google Cloud Storage to meet RPO/RTO requirements for disaster recovery.

#### 1.1.12.4.0 Type

🔹 Operations

#### 1.1.12.5.0 Dependencies

*No items available*

#### 1.1.12.6.0 Properties

| Property | Value |
|----------|-------|
| Rpo | 24 hours |
| Rto | 4 hours |

#### 1.1.12.7.0 Interfaces

*No items available*

#### 1.1.12.8.0 Technology

GCP Managed Export Service, Google Cloud Storage

#### 1.1.12.9.0 Resources

*No data available*

#### 1.1.12.10.0 Configuration

##### 1.1.12.10.1 Backup Schedule

Daily

##### 1.1.12.10.2 Storage Bucket Policy

Cross-region

#### 1.1.12.11.0 Security

##### 1.1.12.11.1 Requires Authentication

❌ No

##### 1.1.12.11.2 Requires Authorization

❌ No

## 1.2.0.0.0 Configuration

| Property | Value |
|----------|-------|
| Environment | production |
| Logging Level | INFO |
| Database Url | N/A (Firestore) |
| Cache Ttl | N/A |
| Max Threads | N/A (Serverless) |

# 2.0.0.0.0 Component Relations

## 2.1.0.0.0 Architecture

### 2.1.1.0.0 Components

#### 2.1.1.1.0 Flutter Mobile & Web Client

##### 2.1.1.1.1 Id

client-flutter-app-001

##### 2.1.1.1.2 Name

Flutter Mobile & Web Client

##### 2.1.1.1.3 Description

A single codebase cross-platform application for iOS, Android, and Web, built using the Flutter framework. It implements the Presentation, Domain, and Data layers according to Clean Architecture principles.

##### 2.1.1.1.4 Type

🔹 ClientApplication

##### 2.1.1.1.5 Dependencies

- infra-firebase-auth-001
- infra-firestore-db-002
- infra-fcm-service-003
- integration-google-maps-001

##### 2.1.1.1.6 Properties

| Property | Value |
|----------|-------|
| Architecture | Clean Architecture |
| State Management | Riverpod 2.x |

##### 2.1.1.1.7 Interfaces

*No items available*

##### 2.1.1.1.8 Technology

Flutter 3.x

##### 2.1.1.1.9 Resources

| Property | Value |
|----------|-------|
| Cpu | Device Dependant |
| Memory | Device Dependant |
| Storage | Device Dependant (for offline cache) |

##### 2.1.1.1.10 Configuration

###### 2.1.1.1.10.1 Min Android Sdk

23

###### 2.1.1.1.10.2 Min Iosversion

12.0

##### 2.1.1.1.11.0 Health Check

*Not specified*

##### 2.1.1.1.12.0 Responsible Features

- REQ-1-001
- REQ-1-004
- REQ-1-009
- REQ-1-010
- REQ-1-062
- REQ-1-063

##### 2.1.1.1.13.0 Security

###### 2.1.1.1.13.1 Requires Authentication

✅ Yes

###### 2.1.1.1.13.2 Requires Authorization

❌ No

#### 2.1.1.2.0.0 Data Repositories

##### 2.1.1.2.1.0 Id

client-data-repository-002

##### 2.1.1.2.2.0 Name

Data Repositories

##### 2.1.1.2.3.0 Description

A set of classes within the Flutter client's Data Layer that abstract data sources. They implement the Repository Pattern to mediate between domain logic and data persistence (Firestore and local cache), supporting offline functionality.

##### 2.1.1.2.4.0 Type

🔹 Repository

##### 2.1.1.2.5.0 Dependencies

- infra-firestore-db-002
- client-data-localcache-003

##### 2.1.1.2.6.0 Properties

*No data available*

##### 2.1.1.2.7.0 Interfaces

- IAuthRepository
- IUserRepository
- IAttendanceRepository
- ITeamRepository
- IEventRepository

##### 2.1.1.2.8.0 Technology

Dart

##### 2.1.1.2.9.0 Resources

*No data available*

##### 2.1.1.2.10.0 Configuration

*No data available*

##### 2.1.1.2.11.0 Health Check

*Not specified*

##### 2.1.1.2.12.0 Responsible Features

- REQ-1-009
- REQ-1-042
- REQ-1-046

##### 2.1.1.2.13.0 Security

###### 2.1.1.2.13.1 Requires Authentication

❌ No

###### 2.1.1.2.13.2 Requires Authorization

❌ No

#### 2.1.1.3.0.0 Offline Data Cache & Sync Manager

##### 2.1.1.3.1.0 Id

client-data-localcache-003

##### 2.1.1.3.2.0 Name

Offline Data Cache & Sync Manager

##### 2.1.1.3.3.0 Description

Manages the local persistence of data for offline use, primarily for attendance marking. It is responsible for queuing offline writes and syncing them with Firestore upon network restoration, and for notifying the user of persistent sync failures.

##### 2.1.1.3.4.0 Type

🔹 Service

##### 2.1.1.3.5.0 Dependencies

*No items available*

##### 2.1.1.3.6.0 Properties

| Property | Value |
|----------|-------|
| Sync Retry Period | 24 hours |

##### 2.1.1.3.7.0 Interfaces

- IOfflineSyncService

##### 2.1.1.3.8.0 Technology

Firestore Offline Persistence SDK

##### 2.1.1.3.9.0 Resources

###### 2.1.1.3.9.1 Storage

Device Dependant

##### 2.1.1.3.10.0 Configuration

###### 2.1.1.3.10.1 Cache Size Bytes

104857600

##### 2.1.1.3.11.0 Health Check

*Not specified*

##### 2.1.1.3.12.0 Responsible Features

- REQ-1-009
- REQ-1-043
- REQ-1-046

##### 2.1.1.3.13.0 Security

###### 2.1.1.3.13.1 Requires Authentication

❌ No

###### 2.1.1.3.13.2 Requires Authorization

❌ No

#### 2.1.1.4.0.0 Authentication Trigger Functions

##### 2.1.1.4.1.0 Id

backend-function-auth-triggers-004

##### 2.1.1.4.2.0 Name

Authentication Trigger Functions

##### 2.1.1.4.3.0 Description

A set of Firebase Cloud Functions triggered by events from Firebase Authentication. Primarily used to provision new user data in Firestore and set initial custom claims (`tenantId`, `role`) upon user creation or registration completion.

##### 2.1.1.4.4.0 Type

🔹 Function (Auth Trigger)

##### 2.1.1.4.5.0 Dependencies

- infra-firebase-auth-001
- infra-firestore-db-002

##### 2.1.1.4.6.0 Properties

| Property | Value |
|----------|-------|
| Trigger | onUserCreate |

##### 2.1.1.4.7.0 Interfaces

*No items available*

##### 2.1.1.4.8.0 Technology

TypeScript

##### 2.1.1.4.9.0 Resources

###### 2.1.1.4.9.1 Memory

256MB

##### 2.1.1.4.10.0 Configuration

###### 2.1.1.4.10.1 Timeout

60s

##### 2.1.1.4.11.0 Health Check

*Not specified*

##### 2.1.1.4.12.0 Responsible Features

- REQ-1-029
- REQ-1-033

##### 2.1.1.4.13.0 Security

###### 2.1.1.4.13.1 Requires Authentication

❌ No

###### 2.1.1.4.13.2 Requires Authorization

❌ No

###### 2.1.1.4.13.3 Allowed Roles

- SYSTEM

#### 2.1.1.5.0.0 Callable Business Logic Functions

##### 2.1.1.5.1.0 Id

backend-function-callable-005

##### 2.1.1.5.2.0 Name

Callable Business Logic Functions

##### 2.1.1.5.3.0 Description

A group of HTTPS-callable Cloud Functions that encapsulate trusted, server-side business logic invoked directly by the client. Examples include validating supervisor assignments to prevent circular hierarchies and processing user invitations.

##### 2.1.1.5.4.0 Type

🔹 Function (Callable)

##### 2.1.1.5.5.0 Dependencies

- infra-firestore-db-002
- integration-sendgrid-002

##### 2.1.1.5.6.0 Properties

*No data available*

##### 2.1.1.5.7.0 Interfaces

- validateHierarchy(userId, newSupervisorId)
- inviteUser(email, role)
- requestTenantDeletion()

##### 2.1.1.5.8.0 Technology

TypeScript

##### 2.1.1.5.9.0 Resources

###### 2.1.1.5.9.1 Memory

512MB

##### 2.1.1.5.10.0 Configuration

###### 2.1.1.5.10.1 Timeout

60s

##### 2.1.1.5.11.0 Health Check

*Not specified*

##### 2.1.1.5.12.0 Responsible Features

- REQ-1-022
- REQ-1-025
- REQ-1-029
- REQ-1-032
- REQ-1-034

##### 2.1.1.5.13.0 Security

###### 2.1.1.5.13.1 Requires Authentication

✅ Yes

###### 2.1.1.5.13.2 Requires Authorization

✅ Yes

###### 2.1.1.5.13.3 Allowed Roles

- Admin
- Supervisor

#### 2.1.1.6.0.0 Scheduled Task Functions

##### 2.1.1.6.1.0 Id

backend-function-scheduled-006

##### 2.1.1.6.2.0 Name

Scheduled Task Functions

##### 2.1.1.6.3.0 Description

A suite of Cloud Functions triggered by Google Cloud Scheduler on a recurring basis. They perform background maintenance and workflow tasks such as data exports, auto-checkouts, approval escalations, data anonymization, and final tenant data deletion.

##### 2.1.1.6.4.0 Type

🔹 Function (Scheduled)

##### 2.1.1.6.5.0 Dependencies

- infra-firestore-db-002
- integration-google-sheets-003

##### 2.1.1.6.6.0 Properties

| Property | Value |
|----------|-------|
| Trigger | Pub/Sub (via Cloud Scheduler) |

##### 2.1.1.6.7.0 Interfaces

*No items available*

##### 2.1.1.6.8.0 Technology

TypeScript

##### 2.1.1.6.9.0 Resources

###### 2.1.1.6.9.1 Memory

1GB

##### 2.1.1.6.10.0 Configuration

###### 2.1.1.6.10.1 Timeout

540s

###### 2.1.1.6.10.2 Schedule

Varies per function (e.g., 'every day 01:00')

##### 2.1.1.6.11.0 Health Check

*Not specified*

##### 2.1.1.6.12.0 Responsible Features

- REQ-1-031
- REQ-1-041
- REQ-1-045
- REQ-1-047
- REQ-1-051
- REQ-1-055
- REQ-1-059
- REQ-1-070
- REQ-1-074

##### 2.1.1.6.13.0 Security

###### 2.1.1.6.13.1 Requires Authentication

❌ No

###### 2.1.1.6.13.2 Requires Authorization

❌ No

###### 2.1.1.6.13.3 Allowed Roles

- SYSTEM

#### 2.1.1.7.0.0 Firestore Trigger Functions

##### 2.1.1.7.1.0 Id

backend-function-firestore-triggers-007

##### 2.1.1.7.2.0 Name

Firestore Trigger Functions

##### 2.1.1.7.3.0 Description

Cloud Functions that execute in response to data changes (create, update, delete) in the Firestore database. Used for reactive logic, such as checking for clock discrepancies on new attendance records or creating audit log entries upon correction approval.

##### 2.1.1.7.4.0 Type

🔹 Function (Firestore Trigger)

##### 2.1.1.7.5.0 Dependencies

- infra-firestore-db-002

##### 2.1.1.7.6.0 Properties

| Property | Value |
|----------|-------|
| Trigger | onWrite, onCreate |

##### 2.1.1.7.7.0 Interfaces

*No items available*

##### 2.1.1.7.8.0 Technology

TypeScript

##### 2.1.1.7.9.0 Resources

###### 2.1.1.7.9.1 Memory

256MB

##### 2.1.1.7.10.0 Configuration

###### 2.1.1.7.10.1 Timeout

60s

##### 2.1.1.7.11.0 Health Check

*Not specified*

##### 2.1.1.7.12.0 Responsible Features

- REQ-1-040
- REQ-1-044
- REQ-1-049
- REQ-1-053

##### 2.1.1.7.13.0 Security

###### 2.1.1.7.13.1 Requires Authentication

❌ No

###### 2.1.1.7.13.2 Requires Authorization

❌ No

###### 2.1.1.7.13.3 Allowed Roles

- SYSTEM

#### 2.1.1.8.0.0 Firestore Security Ruleset

##### 2.1.1.8.1.0 Id

security-firestore-rules-008

##### 2.1.1.8.2.0 Name

Firestore Security Ruleset

##### 2.1.1.8.3.0 Description

The primary declarative security mechanism for the database. This ruleset enforces multi-tenancy and Role-Based Access Control (RBAC) by inspecting the `tenantId` and `role` from the user's JWT custom claims on every database request.

##### 2.1.1.8.4.0 Type

🔹 SecurityPolicy

##### 2.1.1.8.5.0 Dependencies

- infra-firebase-auth-001

##### 2.1.1.8.6.0 Properties

| Property | Value |
|----------|-------|
| Managed As Code | ✅ |

##### 2.1.1.8.7.0 Interfaces

*No items available*

##### 2.1.1.8.8.0 Technology

Firestore Security Rules Language

##### 2.1.1.8.9.0 Resources

*No data available*

##### 2.1.1.8.10.0 Configuration

###### 2.1.1.8.10.1 File Path

firestore.rules

##### 2.1.1.8.11.0 Health Check

*Not specified*

##### 2.1.1.8.12.0 Responsible Features

- REQ-1-002
- REQ-1-021
- REQ-1-024
- REQ-1-025
- REQ-1-028
- REQ-1-064
- REQ-1-068

##### 2.1.1.8.13.0 Security

###### 2.1.1.8.13.1 Requires Authentication

✅ Yes

###### 2.1.1.8.13.2 Requires Authorization

✅ Yes

#### 2.1.1.9.0.0 Firebase Authentication Service

##### 2.1.1.9.1.0 Id

infra-firebase-auth-001

##### 2.1.1.9.2.0 Name

Firebase Authentication Service

##### 2.1.1.9.3.0 Description

A managed service providing user identity, authentication (Email/Pass, OTP), session management via JWTs, and secure storage of user credentials. It is the source of truth for user identity and provides custom claims for RBAC.

##### 2.1.1.9.4.0 Type

🔹 AuthenticationService

##### 2.1.1.9.5.0 Dependencies

*No items available*

##### 2.1.1.9.6.0 Properties

*No data available*

##### 2.1.1.9.7.0 Interfaces

- Firebase Auth SDK

##### 2.1.1.9.8.0 Technology

Firebase

##### 2.1.1.9.9.0 Resources

*No data available*

##### 2.1.1.9.10.0 Configuration

*No data available*

##### 2.1.1.9.11.0 Health Check

*Not specified*

##### 2.1.1.9.12.0 Responsible Features

- REQ-1-013
- REQ-1-035
- REQ-1-039
- REQ-1-040
- REQ-1-062

##### 2.1.1.9.13.0 Security

*No data available*

#### 2.1.1.10.0.0 Firestore Database Service

##### 2.1.1.10.1.0 Id

infra-firestore-db-002

##### 2.1.1.10.2.0 Name

Firestore Database Service

##### 2.1.1.10.3.0 Description

A managed, serverless NoSQL document database that serves as the primary data store for all application data, including tenants, users, attendance, and logs. It supports data residency and is secured by the Firestore Security Ruleset.

##### 2.1.1.10.4.0 Type

🔹 Database

##### 2.1.1.10.5.0 Dependencies

*No items available*

##### 2.1.1.10.6.0 Properties

| Property | Value |
|----------|-------|
| Mode | Native |

##### 2.1.1.10.7.0 Interfaces

- Firebase SDK

##### 2.1.1.10.8.0 Technology

Firestore

##### 2.1.1.10.9.0 Resources

*No data available*

##### 2.1.1.10.10.0 Configuration

###### 2.1.1.10.10.1 Data Residency

Configurable per tenant (REQ-1-024)

##### 2.1.1.10.11.0 Health Check

*Not specified*

##### 2.1.1.10.12.0 Responsible Features

- REQ-1-013
- REQ-1-069
- REQ-1-073

##### 2.1.1.10.13.0 Security

###### 2.1.1.10.13.1 Access Control

Firestore Security Rules

#### 2.1.1.11.0.0 Google Secret Manager

##### 2.1.1.11.1.0 Id

infra-secret-manager-009

##### 2.1.1.11.2.0 Name

Google Secret Manager

##### 2.1.1.11.3.0 Description

A secure and convenient storage system for API keys, passwords, certificates, and other sensitive data. It is used to store all third-party secrets (e.g., SendGrid API key) and provides them to Cloud Functions at runtime via IAM permissions.

##### 2.1.1.11.4.0 Type

🔹 SecurityService

##### 2.1.1.11.5.0 Dependencies

*No items available*

##### 2.1.1.11.6.0 Properties

*No data available*

##### 2.1.1.11.7.0 Interfaces

- GCP Secret Manager API/SDK

##### 2.1.1.11.8.0 Technology

Google Cloud Platform

##### 2.1.1.11.9.0 Resources

*No data available*

##### 2.1.1.11.10.0 Configuration

*No data available*

##### 2.1.1.11.11.0 Health Check

*Not specified*

##### 2.1.1.11.12.0 Responsible Features

- REQ-1-065
- REQ-1-069

##### 2.1.1.11.13.0 Security

###### 2.1.1.11.13.1 Access Control

GCP IAM

#### 2.1.1.12.0.0 CI/CD Pipeline

##### 2.1.1.12.1.0 Id

infra-cicd-pipeline-010

##### 2.1.1.12.2.0 Name

CI/CD Pipeline

##### 2.1.1.12.3.0 Description

An automated pipeline for building, testing, and deploying all system components. It manages the deployment of the Flutter application to app stores and the deployment of backend infrastructure (rules, indexes, functions) via the Firebase CLI (IaC).

##### 2.1.1.12.4.0 Type

🔹 CICD_Pipeline

##### 2.1.1.12.5.0 Dependencies

- security-firestore-rules-008

##### 2.1.1.12.6.0 Properties

*No data available*

##### 2.1.1.12.7.0 Interfaces

*No items available*

##### 2.1.1.12.8.0 Technology

GitHub Actions

##### 2.1.1.12.9.0 Resources

*No data available*

##### 2.1.1.12.10.0 Configuration

###### 2.1.1.12.10.1 Triggers

onPush (main), onPullRequest

##### 2.1.1.12.11.0 Health Check

*Not specified*

##### 2.1.1.12.12.0 Responsible Features

- REQ-1-020
- REQ-1-072

##### 2.1.1.12.13.0 Security

*No data available*

#### 2.1.1.13.0.0 Google Sheets Integration Service

##### 2.1.1.13.1.0 Id

integration-google-sheets-003

##### 2.1.1.13.2.0 Name

Google Sheets Integration Service

##### 2.1.1.13.3.0 Description

A server-side component within a Cloud Function responsible for authenticating via OAuth 2.0 and programmatically writing attendance data to a user-specified Google Sheet. It handles token management and error reporting.

##### 2.1.1.13.4.0 Type

🔹 Integration

##### 2.1.1.13.5.0 Dependencies

- infra-secret-manager-009
- infra-firestore-db-002

##### 2.1.1.13.6.0 Properties

*No data available*

##### 2.1.1.13.7.0 Interfaces

- Google Sheets API v4

##### 2.1.1.13.8.0 Technology

google-api-nodejs-client

##### 2.1.1.13.9.0 Resources

*No data available*

##### 2.1.1.13.10.0 Configuration

*No data available*

##### 2.1.1.13.11.0 Health Check

*Not specified*

##### 2.1.1.13.12.0 Responsible Features

- REQ-1-008
- REQ-1-014
- REQ-1-054
- REQ-1-055
- REQ-1-058
- REQ-1-059
- REQ-1-060

##### 2.1.1.13.13.0 Security

###### 2.1.1.13.13.1 Authentication

OAuth 2.0 (Refresh Token)

#### 2.1.1.14.0.0 SendGrid Email Integration Service

##### 2.1.1.14.1.0 Id

integration-sendgrid-002

##### 2.1.1.14.2.0 Name

SendGrid Email Integration Service

##### 2.1.1.14.3.0 Description

A server-side component, typically used within a Cloud Function, that integrates with the SendGrid API to send transactional emails, such as invitations to new users.

##### 2.1.1.14.4.0 Type

🔹 Integration

##### 2.1.1.14.5.0 Dependencies

- infra-secret-manager-009

##### 2.1.1.14.6.0 Properties

*No data available*

##### 2.1.1.14.7.0 Interfaces

- SendGrid API

##### 2.1.1.14.8.0 Technology

@sendgrid/mail

##### 2.1.1.14.9.0 Resources

*No data available*

##### 2.1.1.14.10.0 Configuration

*No data available*

##### 2.1.1.14.11.0 Health Check

*Not specified*

##### 2.1.1.14.12.0 Responsible Features

- REQ-1-011
- REQ-1-032
- REQ-1-036

##### 2.1.1.14.13.0 Security

###### 2.1.1.14.13.1 Authentication

API Key

#### 2.1.1.15.0.0 Payment Gateway Integration

##### 2.1.1.15.1.0 Id

integration-payment-gateway-004

##### 2.1.1.15.2.0 Name

Payment Gateway Integration

##### 2.1.1.15.3.0 Description

A component responsible for integrating with a third-party payment and subscription management service (e.g., Stripe, RevenueCat). It handles the logic for managing paid tiers, processing payments, and reflecting subscription status in the system.

##### 2.1.1.15.4.0 Type

🔹 Integration

##### 2.1.1.15.5.0 Dependencies

- infra-firestore-db-002

##### 2.1.1.15.6.0 Properties

*No data available*

##### 2.1.1.15.7.0 Interfaces

- Payment Provider SDK/API

##### 2.1.1.15.8.0 Technology

TBD (e.g., Stripe SDK)

##### 2.1.1.15.9.0 Resources

*No data available*

##### 2.1.1.15.10.0 Configuration

*No data available*

##### 2.1.1.15.11.0 Health Check

*Not specified*

##### 2.1.1.15.12.0 Responsible Features

- REQ-1-001

##### 2.1.1.15.13.0 Security

###### 2.1.1.15.13.1 Authentication

API Key

### 2.1.2.0.0.0 Configuration

| Property | Value |
|----------|-------|
| Environment | Production |
| Logging Level | INFO |
| Deployment Strategy | CI/CD via GitHub Actions |
| Monitoring | Google Cloud's Operations Suite |

