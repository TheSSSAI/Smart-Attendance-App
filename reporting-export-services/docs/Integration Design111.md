# 1 Integration Specifications

## 1.1 Extraction Metadata

| Property | Value |
|----------|-------|
| Repository Id | reporting-export-services |
| Extraction Timestamp | 2024-05-24T10:00:00Z |
| Mapping Validation Score | 100% |
| Context Completeness Score | 100% |
| Implementation Readiness Level | High |

## 1.2 Relevant Requirements

### 1.2.1 Requirement Id

#### 1.2.1.1 Requirement Id

REQ-1-008

#### 1.2.1.2 Requirement Text

The system shall provide a feature for Admins to configure an automated, scheduled export of attendance data to a specified Google Sheet. This process must be authenticated via OAuth 2.0 and run without manual intervention after initial setup.

#### 1.2.1.3 Validation Criteria

- Verify an Admin can authenticate with their Google account and link a Google Sheet to their tenant.
- Verify that a scheduled function runs at a configured interval (e.g., daily).
- Verify that new, approved attendance records are appended as rows to the linked Google Sheet.

#### 1.2.1.4 Implementation Implications

- A scheduled Cloud Function must be created to execute the export logic.
- The service must manage OAuth 2.0 refresh tokens securely, using Google Secret Manager.
- The service needs to maintain state to track the last successful export timestamp to avoid duplicate entries.

#### 1.2.1.5 Extraction Reasoning

This requirement is the primary business driver for the existence of the reporting-export-services repository. The repository's core responsibility is to implement this automated, scheduled export.

### 1.2.2.0 Requirement Id

#### 1.2.2.1 Requirement Id

REQ-1-058

#### 1.2.2.2 Requirement Text

The Admin web dashboard must provide an interface for an Admin to set up the Google Sheets export. This interface shall initiate a standard OAuth 2.0 consent flow, prompting the Admin to authorize the application to access their Google Drive and Google Sheets. Upon successful authorization, the system must securely store the obtained refresh token and the unique ID of the Google Sheet selected by the Admin for the export.

#### 1.2.2.3 Validation Criteria

- Verify that an encrypted refresh token and the sheet ID are stored in the system's configuration.

#### 1.2.2.4 Implementation Implications

- The repository must expose a secure (callable) Cloud Function to handle the server-side OAuth code-for-token exchange.
- The service must have a secure mechanism, like Google Secret Manager, for storing sensitive refresh tokens.

#### 1.2.2.5 Extraction Reasoning

While the UI is in another repository, this service is responsible for the backend logic of 'managing the OAuth credentials' as stated in its description, which is the technical implementation of this requirement.

### 1.2.3.0 Requirement Id

#### 1.2.3.1 Requirement Id

REQ-1-059

#### 1.2.3.2 Requirement Text

A scheduled Cloud Function must execute at a tenant-configurable interval (daily or weekly) to handle the Google Sheets export. The function must query for all 'approved' attendance records since the last successful export. It shall then append this data as new rows to the linked Google Sheet, adhering strictly to the predefined column format.

#### 1.2.3.3 Validation Criteria

- Configure the export to run daily.
- Verify that new rows have been added for the approved records and that the data in each column is correct and in the proper format.

#### 1.2.3.4 Implementation Implications

- The core logic of the primary scheduled Cloud Function is defined by this requirement.
- The function must be designed to query records based on a timestamp cursor to prevent data duplication.
- Data transformation logic is needed to map Firestore documents to the specified Google Sheet column format.

#### 1.2.3.5 Extraction Reasoning

This requirement is a direct, detailed specification for the main function of the reporting-export-services repository.

### 1.2.4.0 Requirement Id

#### 1.2.4.1 Requirement Id

REQ-1-060

#### 1.2.4.2 Requirement Text

The Google Sheets export function must include robust error handling. If an API error occurs (e.g., permissions revoked, sheet deleted), the function must update the status of the integration to 'error' in Firestore and log the specific error message. The Admin dashboard must display a prominent alert notifying the Admin of the sync failure. The system must ensure that any attendance records that failed to export are automatically included in the next successful export run, preventing data loss.

#### 1.2.4.3 Validation Criteria

- After linking a sheet, manually revoke the application's permissions from the Google account settings.
- Trigger the export function.
- Verify the integration status in Firestore is set to 'error'.

#### 1.2.4.4 Implementation Implications

- The service must implement comprehensive try/catch blocks for all external API calls.
- The service must have write access to the Firestore linkedSheets collection to update the integration status.
- The export logic must not update the 'last successful export' timestamp until the API call to Google Sheets is confirmed successful, ensuring data is retried on the next run.

#### 1.2.4.5 Extraction Reasoning

This requirement directly maps to the repository's stated responsibility of 'managing the OAuth credentials and error states for that integration.'

### 1.2.5.0 Requirement Id

#### 1.2.5.1 Requirement Id

REQ-1-057

#### 1.2.5.2 Requirement Text

The system must provide a comprehensive reporting module accessible to Admins via the web dashboard. All reports must be filterable by date range, specific user(s), team(s), and attendance status.

#### 1.2.5.3 Validation Criteria

- As an Admin, generate an Attendance Summary report for the last month for a specific team.
- Verify the data in the report is accurate.

#### 1.2.5.4 Implementation Implications

- The repository may be responsible for running data aggregation jobs (e.g., nightly Cloud Functions) to pre-calculate summary data (e.g., DailyUserSummary), optimizing dashboard load times.
- If not pre-aggregating, the repository may expose callable functions that perform complex queries on behalf of the admin dashboard.

#### 1.2.5.5 Extraction Reasoning

The repository description explicitly mentions it may be responsible for 'providing aggregated data for the Admin reporting dashboard,' which directly supports this requirement.

## 1.3.0.0 Relevant Components

### 1.3.1.0 Component Name

#### 1.3.1.1 Component Name

Scheduled Export Function

#### 1.3.1.2 Component Specification

A time-triggered Cloud Function that serves as the main entry point for the export process. It queries for all tenants with active integrations, and for each, it fetches new data and writes it to the designated Google Sheet. This is the primary workload orchestrator.

#### 1.3.1.3 Implementation Requirements

- Must be triggered by Google Cloud Scheduler on a configurable interval.
- Must have a long timeout configured to handle large data volumes.
- Must query for tenants with active integrations and loop through them, handling each tenant's failure independently.
- Must be idempotent and use timestamp cursors to avoid duplicate exports.
- Must implement robust error handling and update integration status on failure.

#### 1.3.1.4 Architectural Context

Belongs to the 'application-services-layer'. Implements the Scheduled Task pattern.

#### 1.3.1.5 Extraction Reasoning

This is the core functional component described in the repository's purpose and is explicitly required by REQ-1-059.

### 1.3.2.0 Component Name

#### 1.3.2.1 Component Name

OAuth Management Function

#### 1.3.2.2 Component Specification

A callable Cloud Function that securely handles the server-side part of the OAuth 2.0 flow. It receives an authorization code from the client, exchanges it for an access and refresh token with Google, and securely stores the refresh token in Google Secret Manager.

#### 1.3.2.3 Implementation Requirements

- Must be a Callable Cloud Function to be invoked securely by the admin dashboard.
- Must use the 'googleapis' library to perform the token exchange.
- Must use the Google Secret Manager client library to store the refresh token.
- Must store the non-sensitive integration metadata (sheet ID, status, user ID) in Firestore.

#### 1.3.2.4 Architectural Context

Belongs to the 'application-services-layer'. Acts as a secure backend-for-frontend (BFF) for the OAuth setup process.

#### 1.3.2.5 Extraction Reasoning

This component is necessary to fulfill REQ-1-058 and the repository's responsibility for 'managing OAuth credentials' in a secure manner, as the client cannot be trusted with the OAuth client secret.

### 1.3.3.0 Component Name

#### 1.3.3.1 Component Name

Google Sheets API Client

#### 1.3.3.2 Component Specification

An internal client or wrapper module within the service that abstracts all direct interactions with the Google Sheets API. It handles authentication with the stored tokens, formatting data for the API, and parsing responses and errors.

#### 1.3.3.3 Implementation Requirements

- Must be initialized with authenticated OAuth2 credentials for each tenant.
- Must expose a method like appendData(sheetId, data).
- Must handle API-specific errors and translate them into application-specific errors (e.g., 'Token Revoked', 'Sheet Not Found').

#### 1.3.3.4 Architectural Context

Belongs to the 'application-services-layer'. Implements the Integration Client pattern.

#### 1.3.3.5 Extraction Reasoning

This component is required to implement REQ-1-014 and encapsulates the third-party integration, separating the specifics of the Google Sheets API from the core business logic of the export function.

## 1.4.0.0 Architectural Layers

- {'layer_name': 'application-services-layer', 'layer_responsibilities': 'The serverless backend logic that executes in response to events or direct HTTP calls. This layer contains all custom business logic that cannot be handled by declarative rules or on the client, such as scheduled tasks, third-party integrations, and complex data aggregations.', 'layer_constraints': ['Must be implemented as serverless Firebase Cloud Functions.', 'All functions must be written in TypeScript.', 'Logic must be stateless where possible.'], 'implementation_patterns': ['Scheduled Task', 'Third-Party API Integration', 'Backend for Frontend (for OAuth)'], 'extraction_reasoning': "The repository definition explicitly maps this repository to the 'application-services-layer'. Its description and responsibilities (scheduled jobs, third-party integration) are a perfect match for this layer's definition in the architecture."}

## 1.5.0.0 Dependency Interfaces

### 1.5.1.0 Interface Name

#### 1.5.1.1 Interface Name

IDataContracts

#### 1.5.1.2 Source Repository

REPO-LIB-CORE-001

#### 1.5.1.3 Method Contracts

*No items available*

#### 1.5.1.4 Integration Pattern

Library Import

#### 1.5.1.5 Communication Protocol

N/A (TypeScript Interface)

#### 1.5.1.6 Extraction Reasoning

This service must consume the standardized TypeScript data contracts (e.g., for AttendanceRecord, User, GoogleSheetIntegration) to ensure data consistency across the backend ecosystem.

### 1.5.2.0 Interface Name

#### 1.5.2.1 Interface Name

IBackendUtilities

#### 1.5.2.2 Source Repository

REPO-LIB-BACKEND-002

#### 1.5.2.3 Method Contracts

##### 1.5.2.3.1 Method Name

###### 1.5.2.3.1.1 Method Name

logger.error

###### 1.5.2.3.1.2 Method Signature

error(message: string, error: Error, context?: object): void

###### 1.5.2.3.1.3 Method Purpose

To provide structured, centralized logging for all errors, enabling monitoring and alerting as per REQ-1-076.

###### 1.5.2.3.1.4 Integration Context

Called within catch blocks for all failed operations, such as API calls or database writes.

##### 1.5.2.3.2.0 Method Name

###### 1.5.2.3.2.1 Method Name

secretManager.getSecret

###### 1.5.2.3.2.2 Method Signature

getSecret(secretName: string): Promise<string>

###### 1.5.2.3.2.3 Method Purpose

To securely retrieve sensitive credentials like the OAuth Client Secret and tenant-specific refresh tokens at runtime.

###### 1.5.2.3.2.4 Integration Context

Called during the OAuth callback handling and at the start of each tenant's export job.

##### 1.5.2.3.3.0 Method Name

###### 1.5.2.3.3.1 Method Name

secretManager.setSecret

###### 1.5.2.3.3.2 Method Signature

setSecret(secretName: string, value: string): Promise<void>

###### 1.5.2.3.3.3 Method Purpose

To securely store the OAuth refresh token for a tenant after a successful authorization.

###### 1.5.2.3.3.4 Integration Context

Called by the OAuth Management Function after successfully exchanging an authorization code for a refresh token.

#### 1.5.2.4.0.0 Integration Pattern

Library Import

#### 1.5.2.5.0.0 Communication Protocol

In-process Function Call

#### 1.5.2.6.0.0 Extraction Reasoning

This service depends on shared utilities for cross-cutting concerns like logging and secure secret management, as mandated by REQ-1-076 and REQ-1-065.

### 1.5.3.0.0.0 Interface Name

#### 1.5.3.1.0.0 Interface Name

IDataPersistence

#### 1.5.3.2.0.0 Source Repository

Data & Persistence Layer (Firestore)

#### 1.5.3.3.0.0 Method Contracts

##### 1.5.3.3.1.0 Method Name

###### 1.5.3.3.1.1 Method Name

getIntegrationConfigurations

###### 1.5.3.3.1.2 Method Signature

() => Promise<IntegrationConfig[]>

###### 1.5.3.3.1.3 Method Purpose

Fetches all active Google Sheets integration configurations from the /linkedSheets collection to determine which tenants to process.

###### 1.5.3.3.1.4 Integration Context

Called at the beginning of the scheduled export function run.

##### 1.5.3.3.2.0 Method Name

###### 1.5.3.3.2.1 Method Name

getNewApprovedRecords

###### 1.5.3.3.2.2 Method Signature

(tenantId: string, lastExportTimestamp: Timestamp) => Promise<AttendanceRecord[]>

###### 1.5.3.3.2.3 Method Purpose

Queries the /attendance collection for a specific tenant to find all 'approved' records created or updated since the last successful export.

###### 1.5.3.3.2.4 Integration Context

Called for each tenant within the main export function loop.

##### 1.5.3.3.3.0 Method Name

###### 1.5.3.3.3.1 Method Name

updateIntegrationStatus

###### 1.5.3.3.3.2 Method Signature

(tenantId: string, status: 'active' | 'error', errorDetails?: object) => Promise<void>

###### 1.5.3.3.3.3 Method Purpose

Updates the status of a tenant's integration in the /linkedSheets collection, typically to mark an error state.

###### 1.5.3.3.3.4 Integration Context

Called when the Google Sheets API returns a permanent error.

##### 1.5.3.3.4.0 Method Name

###### 1.5.3.3.4.1 Method Name

updateLastSyncTimestamp

###### 1.5.3.3.4.2 Method Signature

(tenantId: string, timestamp: Timestamp) => Promise<void>

###### 1.5.3.3.4.3 Method Purpose

Updates the timestamp of the last successfully exported record to use as a cursor for the next run.

###### 1.5.3.3.4.4 Integration Context

Called at the end of a successful export batch for a tenant.

#### 1.5.3.4.0.0 Integration Pattern

Data Access Layer (Repository Pattern)

#### 1.5.3.5.0.0 Communication Protocol

Firebase Admin SDK (gRPC/HTTPS)

#### 1.5.3.6.0.0 Extraction Reasoning

The repository's primary function is to export data. Therefore, it has a critical dependency on the data persistence layer to read the attendance records that need to be exported and to manage the state of the integration itself.

## 1.6.0.0.0.0 Exposed Interfaces

### 1.6.1.0.0.0 Interface Name

#### 1.6.1.1.0.0 Interface Name

ScheduledExportHandler

#### 1.6.1.2.0.0 Consumer Repositories

- Google Cloud Scheduler

#### 1.6.1.3.0.0 Method Contracts

- {'method_name': 'runGoogleSheetsExport', 'method_signature': '(message: PubSubMessage, context: EventContext) => Promise<void>', 'method_purpose': 'Acts as the entry point for the scheduled job. It orchestrates the entire process of fetching configurations, querying data for all relevant tenants, and exporting it to Google Sheets.', 'implementation_requirements': 'The function must be idempotent to handle potential duplicate triggers from the scheduler. It must also have a long timeout (e.g., 540 seconds) and be configured with sufficient memory to handle batch processing.'}

#### 1.6.1.4.0.0 Service Level Requirements

- The function must complete its run within the configured timeout.
- The function must not lose data; records that fail to export must be retried on the next successful run.

#### 1.6.1.5.0.0 Implementation Constraints

- Must be deployed as a Pub/Sub-triggered Cloud Function.
- Must be named and configured according to the project's Infrastructure as Code standards.

#### 1.6.1.6.0.0 Extraction Reasoning

The repository's exposed_contracts section explicitly defines this interface and its consumer. This is the primary mechanism by which the service is invoked for its main batch processing task.

### 1.6.2.0.0.0 Interface Name

#### 1.6.2.1.0.0 Interface Name

GoogleOAuthHandler

#### 1.6.2.2.0.0 Consumer Repositories

- REPO-APP-ADMIN-011

#### 1.6.2.3.0.0 Method Contracts

- {'method_name': 'handleOAuthCallback', 'method_signature': '(data: { authCode: string, sheetId: string }, context: CallableContext) => Promise<{ success: boolean }>', 'method_purpose': 'Securely exchanges a one-time authorization code from the client for an access token and a refresh token, then securely stores the refresh token and registers the integration.', 'implementation_requirements': 'This function must validate that the caller is an authenticated Admin for their tenant. It is responsible for the server-side part of the OAuth 2.0 Authorization Code Flow.'}

#### 1.6.2.4.0.0 Service Level Requirements

- p95 latency < 500ms

#### 1.6.2.5.0.0 Implementation Constraints

- Must be implemented as a Firebase Callable Function (`onCall`).
- Must return a structured `HttpsError` on failure for the client to handle.

#### 1.6.2.6.0.0 Extraction Reasoning

This interface is required by REQ-1-058 and is the secure endpoint consumed by the Admin Web Dashboard to set up the integration. It was identified as a gap in the initial analysis and is added for completeness and security.

## 1.7.0.0.0.0 Technology Context

### 1.7.1.0.0.0 Framework Requirements

The service must be implemented as a set of Firebase Cloud Functions using TypeScript, as specified in the repository definition and aligned with the system's serverless architecture.

### 1.7.2.0.0.0 Integration Technologies

- Firebase Admin SDK (for Firestore access)
- Google Cloud Scheduler (for triggering)
- Google Sheets API (via 'googleapis' library)
- Google Secret Manager (for token storage)

### 1.7.3.0.0.0 Performance Constraints

The main export function must be optimized to process new data only, using timestamp cursors to avoid full collection scans. It must handle batching for tenants with large data volumes to stay within function execution time limits.

### 1.7.4.0.0.0 Security Requirements

OAuth refresh tokens and client secrets must be stored in Google Secret Manager, not in Firestore. The Cloud Functions must be deployed with IAM service accounts that have the minimum necessary permissions (e.g., Firestore reader, Secret Manager accessor).

## 1.8.0.0.0.0 Extraction Validation

| Property | Value |
|----------|-------|
| Mapping Completeness Check | The repository's purpose is well-defined and maps ... |
| Cross Reference Validation | High consistency was found between the repository ... |
| Implementation Readiness Assessment | The implementation readiness is high. The technolo... |
| Quality Assurance Confirmation | The extracted context has been systematically vali... |

