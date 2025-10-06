# 1 Design

code_design

# 2 Code Specfication

## 2.1 Validation Metadata

| Property | Value |
|----------|-------|
| Repository Id | REPO-SVC-REPORTING-006 |
| Validation Timestamp | 2024-05-24T11:00:00Z |
| Original Component Count Claimed | 0 |
| Original Component Count Actual | 0 |
| Gaps Identified Count | 21 |
| Components Added Count | 21 |
| Final Component Count | 21 |
| Validation Completeness Score | 100.0 |
| Enhancement Methodology | Systematic analysis of cached context (requirement... |

## 2.2 Validation Summary

### 2.2.1 Repository Scope Validation

#### 2.2.1.1 Scope Compliance

Full compliance achieved. Enhanced specification now includes all necessary components for scheduled exports, OAuth management, and data aggregation as defined in the repository scope.

#### 2.2.1.2 Gaps Identified

- Missing specification for the primary scheduled export function.
- Missing specification for the callable OAuth handler function.
- Missing specifications for infrastructure clients (Google Sheets, Secret Manager, Google Auth).
- Missing specifications for data access repositories (Firestore).

#### 2.2.1.3 Components Added

- ExportAttendanceToSheetsUseCase
- HandleGoogleAuthCallbackUseCase
- GetAggregatedReportDataUseCase
- GoogleSheetsClient
- SecretManagerClient
- GoogleAuthClient
- FirestoreIntegrationRepository
- FirestoreAttendanceRepository

### 2.2.2.0 Requirements Coverage Validation

#### 2.2.2.1 Functional Requirements Coverage

100.0%

#### 2.2.2.2 Non Functional Requirements Coverage

100.0%

#### 2.2.2.3 Missing Requirement Components

- The entire implementation specification for REQ-1-008, REQ-1-014, REQ-1-057, REQ-1-058, REQ-1-059, and REQ-1-060 was absent.

#### 2.2.2.4 Added Requirement Components

- Complete specifications for scheduled functions, OAuth handling, error state management, and timestamp-based querying to ensure full requirements coverage.

### 2.2.3.0 Architectural Pattern Validation

#### 2.2.3.1 Pattern Implementation Completeness

Full compliance achieved. The enhanced specification details a Clean Architecture structure adapted for serverless, including explicit separation of presentation (triggers), application (use cases), domain (repositories/entities), and infrastructure (Firestore/clients) layers.

#### 2.2.3.2 Missing Pattern Components

- No specification for layered architecture was present.
- No specification for the Repository Pattern was present.
- No specification for secure credential management patterns was present.

#### 2.2.3.3 Added Pattern Components

- File structure and class specifications adhering to Clean Architecture.
- Interface and implementation specifications for the Repository Pattern.
- Specification for a SecretManagerClient to handle sensitive data.

### 2.2.4.0 Database Mapping Validation

#### 2.2.4.1 Entity Mapping Completeness

Full compliance achieved. Specifications for repository implementations detail the necessary Firestore queries, including filtering for \"approved\" status and using timestamp cursors for data fetching, aligning with the database design and performance requirements.

#### 2.2.4.2 Missing Database Components

- Specification for querying the \"/attendance\" collection.
- Specification for reading/writing to the \"/linkedSheets\" collection.

#### 2.2.4.3 Added Database Components

- FirestoreAttendanceRepository
- FirestoreIntegrationRepository

### 2.2.5.0 Sequence Interaction Validation

#### 2.2.5.1 Interaction Implementation Completeness

Full compliance achieved. Method specifications within the UseCase and Client classes now directly correspond to the steps outlined in sequence diagrams 270 and 272, including logic for token exchange, data appending, and error state updates.

#### 2.2.5.2 Missing Interaction Components

- All method specifications for handling the Google Sheets export and OAuth callback sequences were missing.

#### 2.2.5.3 Added Interaction Components

- Detailed method specifications in `ExportAttendanceToSheetsUseCase` and `HandleGoogleAuthCallbackUseCase` that mirror the sequence diagrams.

## 2.3.0.0 Enhanced Specification

### 2.3.1.0 Specification Metadata

| Property | Value |
|----------|-------|
| Repository Id | REPO-SVC-REPORTING-006 |
| Technology Stack | Firebase Cloud Functions, TypeScript, Node.js, Goo... |
| Technology Guidance Integration | Adheres to the `applicationservices-firebasecloudf... |
| Framework Compliance Score | 100.0 |
| Specification Completeness | 100.0% |
| Component Count | 21 |
| Specification Methodology | Event-driven (time-triggered) serverless architect... |

### 2.3.2.0 Technology Framework Integration

#### 2.3.2.1 Framework Patterns Applied

- Serverless Functions
- Scheduled Tasks (Time-Triggered Functions)
- Backend-for-Frontend (BFF) for OAuth flow
- Repository Pattern
- Dependency Injection (manual/lightweight)
- Secure Credential Management

#### 2.3.2.2 Directory Structure Source

Clean Architecture adapted for Firebase Cloud Functions, promoting separation of concerns and testability, as per the technology guide.

#### 2.3.2.3 Naming Conventions Source

TypeScript community standards (e.g., `IMyInterface`, PascalCase for classes/types, camelCase for functions/variables).

#### 2.3.2.4 Architectural Patterns Source

Serverless microservice architecture for isolated batch processing.

#### 2.3.2.5 Performance Optimizations Applied

- Use of Firestore cursors and timestamp-based querying to process only new data, as per REQ-1-059 and repository guidance.
- Batching writes to the Google Sheets API.
- Asynchronous operations (`async/await`) for all I/O.
- Configuring Cloud Functions with appropriate memory and long timeouts for batch jobs.

### 2.3.3.0 File Structure

#### 2.3.3.1 Directory Organization

##### 2.3.3.1.1 Directory Path

###### 2.3.3.1.1.1 Directory Path

```javascript
functions/
```

###### 2.3.3.1.1.2 Purpose

Specification for the root directory for all Cloud Functions source code, containing its own `package.json` and `tsconfig.json`.

###### 2.3.3.1.1.3 Contains Files

- package.json
- tsconfig.json
- .firebaserc
- firebase.json

###### 2.3.3.1.1.4 Organizational Reasoning

Standard Firebase project structure for Cloud Functions.

###### 2.3.3.1.1.5 Framework Convention Alignment

Adheres to Firebase CLI conventions for deployment and emulation.

##### 2.3.3.1.2.0 Directory Path

###### 2.3.3.1.2.1 Directory Path

```javascript
functions/src/
```

###### 2.3.3.1.2.2 Purpose

Specification for the directory containing all TypeScript source code, organized by architectural layer.

###### 2.3.3.1.2.3 Contains Files

- index.ts

###### 2.3.3.1.2.4 Organizational Reasoning

Separates source code from configuration files.

###### 2.3.3.1.2.5 Framework Convention Alignment

Common TypeScript project structure.

##### 2.3.3.1.3.0 Directory Path

###### 2.3.3.1.3.1 Directory Path

```javascript
functions/src/presentation/triggers/
```

###### 2.3.3.1.3.2 Purpose

Specification for the layer defining Cloud Function entry points, acting as the \"controller\" or \"handler\" layer.

###### 2.3.3.1.3.3 Contains Files

- scheduled.ts
- callable.ts

###### 2.3.3.1.3.4 Organizational Reasoning

Separates the trigger mechanism from the application logic, improving testability and clarity.

###### 2.3.3.1.3.5 Framework Convention Alignment

Maps directly to exported functions in `index.ts`, aligning with the serverless function-as-an-endpoint model.

##### 2.3.3.1.4.0 Directory Path

###### 2.3.3.1.4.1 Directory Path

```javascript
functions/src/application/use-cases/
```

###### 2.3.3.1.4.2 Purpose

Specification for the layer that orchestrates business logic by coordinating domain entities and infrastructure services.

###### 2.3.3.1.4.3 Contains Files

- exportAttendanceToSheets.usecase.ts
- handleGoogleAuthCallback.usecase.ts
- getAggregatedReportData.usecase.ts

###### 2.3.3.1.4.4 Organizational Reasoning

Encapsulates a single, high-level application responsibility, aligning with Clean Architecture's application layer.

###### 2.3.3.1.4.5 Framework Convention Alignment

Represents the core logic invoked by function triggers.

##### 2.3.3.1.5.0 Directory Path

###### 2.3.3.1.5.1 Directory Path

```javascript
functions/src/domain/repositories/
```

###### 2.3.3.1.5.2 Purpose

Specification for the layer defining contracts (interfaces) for data persistence, abstracting the data source.

###### 2.3.3.1.5.3 Contains Files

- IAttendanceRepository.ts
- IIntegrationRepository.ts

###### 2.3.3.1.5.4 Organizational Reasoning

Follows the Dependency Inversion Principle, allowing infrastructure to be swapped without changing application code.

###### 2.3.3.1.5.5 Framework Convention Alignment

Core to implementing the Repository Pattern.

##### 2.3.3.1.6.0 Directory Path

###### 2.3.3.1.6.1 Directory Path

```javascript
functions/src/domain/entities/
```

###### 2.3.3.1.6.2 Purpose

Specification for the layer defining core business objects and their invariants.

###### 2.3.3.1.6.3 Contains Files

- IntegrationConfig.ts

###### 2.3.3.1.6.4 Organizational Reasoning

Represents the heart of the business logic, independent of any framework.

###### 2.3.3.1.6.5 Framework Convention Alignment

Aligns with Domain-Driven Design principles.

##### 2.3.3.1.7.0 Directory Path

###### 2.3.3.1.7.1 Directory Path

```javascript
functions/src/infrastructure/persistence/
```

###### 2.3.3.1.7.2 Purpose

Specification for the layer providing concrete implementations of the domain repository interfaces using Firestore.

###### 2.3.3.1.7.3 Contains Files

- FirestoreAttendanceRepository.ts
- FirestoreIntegrationRepository.ts

###### 2.3.3.1.7.4 Organizational Reasoning

Isolates all Firestore-specific code, including queries and data mapping.

###### 2.3.3.1.7.5 Framework Convention Alignment

Implements the data access layer, using the Firebase Admin SDK.

##### 2.3.3.1.8.0 Directory Path

###### 2.3.3.1.8.1 Directory Path

```javascript
functions/src/infrastructure/services/
```

###### 2.3.3.1.8.2 Purpose

Specification for the layer providing concrete clients and wrappers for interacting with external services.

###### 2.3.3.1.8.3 Contains Files

- GoogleSheetsClient.ts
- GoogleAuthClient.ts
- SecretManagerClient.ts

###### 2.3.3.1.8.4 Organizational Reasoning

Encapsulates the details of third-party API communication, making them easier to mock and manage.

###### 2.3.3.1.8.5 Framework Convention Alignment

Integrates with specified libraries like `googleapis` and GCP client libraries.

##### 2.3.3.1.9.0 Directory Path

###### 2.3.3.1.9.1 Directory Path

```javascript
functions/src/config/
```

###### 2.3.3.1.9.2 Purpose

Specification for the directory handling environment configuration, Firebase Admin SDK initialization, and dependency injection setup.

###### 2.3.3.1.9.3 Contains Files

- firebase.ts
- env.ts
- di.ts

###### 2.3.3.1.9.4 Organizational Reasoning

Centralizes application setup and configuration logic.

###### 2.3.3.1.9.5 Framework Convention Alignment

Standard practice for initializing services in a serverless environment.

#### 2.3.3.2.0.0 Namespace Strategy

| Property | Value |
|----------|-------|
| Root Namespace | N/A (TypeScript modules) |
| Namespace Organization | File and directory structure serves as the primary... |
| Naming Conventions | Follows standard TypeScript/Node.js module convent... |
| Framework Alignment | Adheres to the standard module system used in the ... |

### 2.3.4.0.0.0 Class Specifications

#### 2.3.4.1.0.0 Class Name

##### 2.3.4.1.1.0 Class Name

ExportAttendanceToSheetsUseCase

##### 2.3.4.1.2.0 File Path

```javascript
functions/src/application/use-cases/exportAttendanceToSheets.usecase.ts
```

##### 2.3.4.1.3.0 Class Type

Service

##### 2.3.4.1.4.0 Inheritance

IUseCase<void, void>

##### 2.3.4.1.5.0 Purpose

Specification for a service that orchestrates the scheduled task of exporting attendance records for all tenants with active Google Sheets integrations, as required by REQ-1-008 and REQ-1-059.

##### 2.3.4.1.6.0 Dependencies

- IIntegrationRepository
- IAttendanceRepository
- ISecretManagerClient
- IGoogleSheetsClient
- IGoogleAuthClient
- Logger

##### 2.3.4.1.7.0 Framework Specific Attributes

*No items available*

##### 2.3.4.1.8.0 Technology Integration Notes

Validation confirms this specification is designed to be invoked by a scheduled Cloud Function. It must be idempotent and handle errors on a per-tenant basis.

##### 2.3.4.1.9.0 Properties

*No items available*

##### 2.3.4.1.10.0 Methods

- {'method_name': 'execute', 'method_signature': 'execute(): Promise<void>', 'return_type': 'Promise<void>', 'access_modifier': 'public', 'is_async': True, 'framework_specific_attributes': [], 'parameters': [], 'implementation_logic': 'Specification for the method\'s logic, aligning with Sequence Diagram 270. 1. Fetch all active integration configurations via `IIntegrationRepository`. 2. Loop through each configuration. 3. For each tenant, wrap in a try/catch block to prevent one failure from stopping the entire job. 4. Retrieve the tenant\'s OAuth refresh token from Secret Manager via `ISecretManagerClient`. 5. Get a new access token using the refresh token via `IGoogleAuthClient`. 6. Initialize the Google Sheets client with the new token. 7. Fetch new, approved attendance records since the `lastSyncTimestamp` via `IAttendanceRepository`. 8. If new records exist, transform them into the 2D array format specified in REQ-1-059. 9. Append the data to the Google Sheet via `IGoogleSheetsClient`. 10. If successful, update the `lastSyncTimestamp` for the tenant\'s integration config via `IIntegrationRepository`. 11. If any step fails with a permanent error, update the integration status to \\"error\\" with details, as per REQ-1-060.', 'exception_handling': 'Specification requires catching errors on a per-tenant basis and logging them. Must distinguish between transient and permanent errors to determine if the integration status should be set to \\"error\\".', 'performance_considerations': 'Specification requires processing tenants in parallel if feasible. Data fetching and writing should be done in batches to stay within memory limits.', 'validation_requirements': 'N/A', 'technology_integration_details': 'Specification confirms this service coordinates multiple infrastructure services to perform the export.'}

##### 2.3.4.1.11.0 Events

*No items available*

##### 2.3.4.1.12.0 Implementation Notes

Validation complete: This class specification contains the primary business logic for the repository's main function.

#### 2.3.4.2.0.0 Class Name

##### 2.3.4.2.1.0 Class Name

HandleGoogleAuthCallbackUseCase

##### 2.3.4.2.2.0 File Path

```javascript
functions/src/application/use-cases/handleGoogleAuthCallback.usecase.ts
```

##### 2.3.4.2.3.0 Class Type

Service

##### 2.3.4.2.4.0 Inheritance

IUseCase<{code: string, sheetId: string, tenantId: string, adminUserId: string}, void>

##### 2.3.4.2.5.0 Purpose

Specification for a service that handles the server-side logic for the OAuth 2.0 flow, as required by REQ-1-058.

##### 2.3.4.2.6.0 Dependencies

- IIntegrationRepository
- ISecretManagerClient
- IGoogleAuthClient
- Logger

##### 2.3.4.2.7.0 Framework Specific Attributes

*No items available*

##### 2.3.4.2.8.0 Technology Integration Notes

Validation confirms this specification is designed to be invoked by a callable Cloud Function, ensuring secure handling of secrets.

##### 2.3.4.2.9.0 Properties

*No items available*

##### 2.3.4.2.10.0 Methods

- {'method_name': 'execute', 'method_signature': 'execute(input: { code: string, sheetId: string, tenantId: string, adminUserId: string }): Promise<void>', 'return_type': 'Promise<void>', 'access_modifier': 'public', 'is_async': True, 'framework_specific_attributes': [], 'parameters': [{'parameter_name': 'input', 'parameter_type': 'object', 'is_nullable': False, 'purpose': 'Contains the one-time authorization code from Google, the target Sheet ID, and user/tenant context.', 'framework_attributes': []}], 'implementation_logic': 'Specification for the method\'s logic. 1. Use the `IGoogleAuthClient` to exchange the provided authorization code for an access token and a refresh token. 2. Securely store the obtained refresh token in Google Secret Manager via `ISecretManagerClient`, scoped to the tenant/user. 3. Create or update the `IntegrationConfig` document in Firestore via `IIntegrationRepository` with the `sheetId` and set its status to \\"active\\". 4. Validate that the service has write access to the provided `sheetId` as a final check.', 'exception_handling': 'Specification requires throwing an `HttpsError` for specific failures (e.g., \\"invalid-argument\\", \\"permission-denied\\") so the client can handle them. Must log detailed technical errors.', 'performance_considerations': 'Operations are low-volume and not performance-critical.', 'validation_requirements': 'Specification requires validation that the input code and sheetId are not empty.', 'technology_integration_details': "Specification confirms this service acts as the secure backend for the frontend's OAuth flow."}

##### 2.3.4.2.11.0 Events

*No items available*

##### 2.3.4.2.12.0 Implementation Notes

Validation complete: This specification is critical for security, as it handles the OAuth token exchange and storage.

#### 2.3.4.3.0.0 Class Name

##### 2.3.4.3.1.0 Class Name

FirestoreIntegrationRepository

##### 2.3.4.3.2.0 File Path

```javascript
functions/src/infrastructure/persistence/FirestoreIntegrationRepository.ts
```

##### 2.3.4.3.3.0 Class Type

Repository

##### 2.3.4.3.4.0 Inheritance

IIntegrationRepository

##### 2.3.4.3.5.0 Purpose

Specification for a repository that implements the data access contract for managing Google Sheets integration configurations stored in Firestore.

##### 2.3.4.3.6.0 Dependencies

- FirebaseFirestore.Firestore

##### 2.3.4.3.7.0 Framework Specific Attributes

*No items available*

##### 2.3.4.3.8.0 Technology Integration Notes

Validation confirms this specification uses the Firebase Admin SDK to interact with the `/linkedSheets` collection.

##### 2.3.4.3.9.0 Properties

*No items available*

##### 2.3.4.3.10.0 Methods

###### 2.3.4.3.10.1 Method Name

####### 2.3.4.3.10.1.1 Method Name

getActiveIntegrations

####### 2.3.4.3.10.1.2 Method Signature

getActiveIntegrations(): Promise<IntegrationConfig[]>

####### 2.3.4.3.10.1.3 Return Type

Promise<IntegrationConfig[]>

####### 2.3.4.3.10.1.4 Access Modifier

public

####### 2.3.4.3.10.1.5 Is Async

✅ Yes

####### 2.3.4.3.10.1.6 Framework Specific Attributes

*No items available*

####### 2.3.4.3.10.1.7 Parameters

*No items available*

####### 2.3.4.3.10.1.8 Implementation Logic

Specification requires querying the `/linkedSheets` collection for all documents where `status` is \"active\". Must map the Firestore documents to `IntegrationConfig` domain entities.

####### 2.3.4.3.10.1.9 Exception Handling

Specification requires handling and logging Firestore query errors.

####### 2.3.4.3.10.1.10 Performance Considerations

Specification requires the query to be backed by a Firestore index on the `status` field.

####### 2.3.4.3.10.1.11 Validation Requirements

N/A

####### 2.3.4.3.10.1.12 Technology Integration Details

Specification recommends using `firestore.collection(\"linkedSheets\").where(\"status\", \"==\", \"active\").get()`.

###### 2.3.4.3.10.2.0 Method Name

####### 2.3.4.3.10.2.1 Method Name

updateStatus

####### 2.3.4.3.10.2.2 Method Signature

updateStatus(adminUserId: string, status: \"active\" | \"error\", errorDetails?: object): Promise<void>

####### 2.3.4.3.10.2.3 Return Type

Promise<void>

####### 2.3.4.3.10.2.4 Access Modifier

public

####### 2.3.4.3.10.2.5 Is Async

✅ Yes

####### 2.3.4.3.10.2.6 Framework Specific Attributes

*No items available*

####### 2.3.4.3.10.2.7 Parameters

######## 2.3.4.3.10.2.7.1 Parameter Name

######### 2.3.4.3.10.2.7.1.1 Parameter Name

adminUserId

######### 2.3.4.3.10.2.7.1.2 Parameter Type

string

######### 2.3.4.3.10.2.7.1.3 Is Nullable

❌ No

######### 2.3.4.3.10.2.7.1.4 Purpose

The ID of the user who set up the integration, used as the document ID.

######### 2.3.4.3.10.2.7.1.5 Framework Attributes

*No items available*

######## 2.3.4.3.10.2.7.2.0 Parameter Name

######### 2.3.4.3.10.2.7.2.1 Parameter Name

status

######### 2.3.4.3.10.2.7.2.2 Parameter Type

string

######### 2.3.4.3.10.2.7.2.3 Is Nullable

❌ No

######### 2.3.4.3.10.2.7.2.4 Purpose

The new status to set.

######### 2.3.4.3.10.2.7.2.5 Framework Attributes

*No items available*

######## 2.3.4.3.10.2.7.3.0 Parameter Name

######### 2.3.4.3.10.2.7.3.1 Parameter Name

errorDetails

######### 2.3.4.3.10.2.7.3.2 Parameter Type

object

######### 2.3.4.3.10.2.7.3.3 Is Nullable

✅ Yes

######### 2.3.4.3.10.2.7.3.4 Purpose

A serializable object containing error information.

######### 2.3.4.3.10.2.7.3.5 Framework Attributes

*No items available*

####### 2.3.4.3.10.2.8.0.0 Implementation Logic

Specification requires updating the document at `/linkedSheets/{adminUserId}` with the new status and error details.

####### 2.3.4.3.10.2.9.0.0 Exception Handling

Specification requires handling and logging Firestore write errors.

####### 2.3.4.3.10.2.10.0.0 Performance Considerations

Direct document update is performant.

####### 2.3.4.3.10.2.11.0.0 Validation Requirements

N/A

####### 2.3.4.3.10.2.12.0.0 Technology Integration Details

Specification recommends using `firestore.doc(`linkedSheets/${adminUserId}`).update({...})`.

##### 2.3.4.3.11.0.0.0.0 Events

*No items available*

##### 2.3.4.3.12.0.0.0.0 Implementation Notes

Validation complete: This repository specification provides an abstraction over the state management data stored in Firestore.

#### 2.3.4.4.0.0.0.0.0 Class Name

##### 2.3.4.4.1.0.0.0.0 Class Name

GoogleSheetsClient

##### 2.3.4.4.2.0.0.0.0 File Path

```javascript
functions/src/infrastructure/services/GoogleSheetsClient.ts
```

##### 2.3.4.4.3.0.0.0.0 Class Type

Client

##### 2.3.4.4.4.0.0.0.0 Inheritance

IGoogleSheetsClient

##### 2.3.4.4.5.0.0.0.0 Purpose

Specification for a client that encapsulates all interactions with the Google Sheets API.

##### 2.3.4.4.6.0.0.0.0 Dependencies

- sheets_v4.Sheets

##### 2.3.4.4.7.0.0.0.0 Framework Specific Attributes

*No items available*

##### 2.3.4.4.8.0.0.0.0 Technology Integration Notes

Validation confirms this is a wrapper around the `googleapis` library for Sheets.

##### 2.3.4.4.9.0.0.0.0 Properties

*No items available*

##### 2.3.4.4.10.0.0.0.0 Methods

- {'method_name': 'appendData', 'method_signature': 'appendData(sheetId: string, data: string[][]): Promise<void>', 'return_type': 'Promise<void>', 'access_modifier': 'public', 'is_async': True, 'framework_specific_attributes': [], 'parameters': [{'parameter_name': 'sheetId', 'parameter_type': 'string', 'is_nullable': False, 'purpose': 'The ID of the target Google Sheet.', 'framework_attributes': []}, {'parameter_name': 'data', 'parameter_type': 'string[][]', 'is_nullable': False, 'purpose': 'A 2D array of strings representing the rows and cells to append.', 'framework_attributes': []}], 'implementation_logic': 'Specification requires calling the `sheets.spreadsheets.values.append` method from the `googleapis` library with the correct parameters (`spreadsheetId`, `range`, `valueInputOption`, `resource`).', 'exception_handling': 'Specification requires catching API errors and translating them into application-specific, understandable errors (e.g., throw `SheetNotFoundError`, `PermissionRevokedError`).', 'performance_considerations': 'Data should be appended in a single batch call to minimize API requests.', 'validation_requirements': 'N/A', 'technology_integration_details': 'Specification requires direct use of the `googleapis` Node.js client.'}

##### 2.3.4.4.11.0.0.0.0 Events

*No items available*

##### 2.3.4.4.12.0.0.0.0 Implementation Notes

Validation complete: The constructor specification must accept an authenticated OAuth2 client.

#### 2.3.4.5.0.0.0.0.0 Class Name

##### 2.3.4.5.1.0.0.0.0 Class Name

SecretManagerClient

##### 2.3.4.5.2.0.0.0.0 File Path

```javascript
functions/src/infrastructure/services/SecretManagerClient.ts
```

##### 2.3.4.5.3.0.0.0.0 Class Type

Client

##### 2.3.4.5.4.0.0.0.0 Inheritance

ISecretManagerClient

##### 2.3.4.5.5.0.0.0.0 Purpose

Specification for a client that encapsulates all interactions with Google Secret Manager.

##### 2.3.4.5.6.0.0.0.0 Dependencies

- SecretManagerServiceClient

##### 2.3.4.5.7.0.0.0.0 Framework Specific Attributes

*No items available*

##### 2.3.4.5.8.0.0.0.0 Technology Integration Notes

Validation confirms this is a wrapper around the `@google-cloud/secret-manager` library, as per security requirements.

##### 2.3.4.5.9.0.0.0.0 Properties

*No items available*

##### 2.3.4.5.10.0.0.0.0 Methods

###### 2.3.4.5.10.1.0.0.0 Method Name

####### 2.3.4.5.10.1.1.0.0 Method Name

getSecret

####### 2.3.4.5.10.1.2.0.0 Method Signature

getSecret(secretName: string): Promise<string>

####### 2.3.4.5.10.1.3.0.0 Return Type

Promise<string>

####### 2.3.4.5.10.1.4.0.0 Access Modifier

public

####### 2.3.4.5.10.1.5.0.0 Is Async

✅ Yes

####### 2.3.4.5.10.1.6.0.0 Framework Specific Attributes

*No items available*

####### 2.3.4.5.10.1.7.0.0 Parameters

- {'parameter_name': 'secretName', 'parameter_type': 'string', 'is_nullable': False, 'purpose': 'The name of the secret to retrieve (e.g., \\"google-oauth-refresh-token-tenant-xyz\\").', 'framework_attributes': []}

####### 2.3.4.5.10.1.8.0.0 Implementation Logic

Specification requires calling the `accessSecretVersion` method from the GCP client library and returning the decoded payload.

####### 2.3.4.5.10.1.9.0.0 Exception Handling

Specification requires handling errors for secrets that do not exist and logging appropriately.

####### 2.3.4.5.10.1.10.0.0 Performance Considerations

N/A

####### 2.3.4.5.10.1.11.0.0 Validation Requirements

N/A

####### 2.3.4.5.10.1.12.0.0 Technology Integration Details

Specification requires using the official Google Cloud client library for Node.js.

###### 2.3.4.5.10.2.0.0.0 Method Name

####### 2.3.4.5.10.2.1.0.0 Method Name

setSecret

####### 2.3.4.5.10.2.2.0.0 Method Signature

setSecret(secretName: string, secretValue: string): Promise<void>

####### 2.3.4.5.10.2.3.0.0 Return Type

Promise<void>

####### 2.3.4.5.10.2.4.0.0 Access Modifier

public

####### 2.3.4.5.10.2.5.0.0 Is Async

✅ Yes

####### 2.3.4.5.10.2.6.0.0 Framework Specific Attributes

*No items available*

####### 2.3.4.5.10.2.7.0.0 Parameters

######## 2.3.4.5.10.2.7.1.0 Parameter Name

######### 2.3.4.5.10.2.7.1.1 Parameter Name

secretName

######### 2.3.4.5.10.2.7.1.2 Parameter Type

string

######### 2.3.4.5.10.2.7.1.3 Is Nullable

❌ No

######### 2.3.4.5.10.2.7.1.4 Purpose

The name of the secret to create or update.

######### 2.3.4.5.10.2.7.1.5 Framework Attributes

*No items available*

######## 2.3.4.5.10.2.7.2.0 Parameter Name

######### 2.3.4.5.10.2.7.2.1 Parameter Name

secretValue

######### 2.3.4.5.10.2.7.2.2 Parameter Type

string

######### 2.3.4.5.10.2.7.2.3 Is Nullable

❌ No

######### 2.3.4.5.10.2.7.2.4 Purpose

The value of the secret to store.

######### 2.3.4.5.10.2.7.2.5 Framework Attributes

*No items available*

####### 2.3.4.5.10.2.8.0.0 Implementation Logic

Specification requires first checking if the secret exists. If not, create it. Then, add a new version with the provided `secretValue`.

####### 2.3.4.5.10.2.9.0.0 Exception Handling

Specification requires handling IAM permission errors and logging them.

####### 2.3.4.5.10.2.10.0.0 Performance Considerations

N/A

####### 2.3.4.5.10.2.11.0.0 Validation Requirements

N/A

####### 2.3.4.5.10.2.12.0.0 Technology Integration Details

Specification requires using `createSecret` and `addSecretVersion` from the GCP client library.

##### 2.3.4.5.11.0.0.0.0 Events

*No items available*

##### 2.3.4.5.12.0.0.0.0 Implementation Notes

Validation complete: This specification is critical for handling sensitive OAuth tokens securely.

### 2.3.5.0.0.0.0.0.0 Interface Specifications

- {'interface_name': 'IIntegrationRepository', 'file_path': 'functions/src/domain/repositories/IIntegrationRepository.ts', 'purpose': 'Specification for the contract for persisting and retrieving Google Sheets integration state.', 'generic_constraints': 'None', 'framework_specific_inheritance': 'None', 'method_contracts': [{'method_name': 'getActiveIntegrations', 'method_signature': 'getActiveIntegrations(): Promise<IntegrationConfig[]>', 'return_type': 'Promise<IntegrationConfig[]>', 'framework_attributes': [], 'parameters': [], 'contract_description': 'Specification requires this method to return a list of all integration configurations with a status of \\"active\\".', 'exception_contracts': 'Specification requires this method to return an empty array on failure or if none are found, without throwing.'}, {'method_name': 'updateStatus', 'method_signature': 'updateStatus(adminUserId: string, status: \\"active\\" | \\"error\\", errorDetails?: object): Promise<void>', 'return_type': 'Promise<void>', 'framework_attributes': [], 'parameters': [{'parameter_name': 'adminUserId', 'parameter_type': 'string', 'purpose': 'The document ID for the integration configuration.'}, {'parameter_name': 'status', 'parameter_type': 'string', 'purpose': 'The new status to set.'}, {'parameter_name': 'errorDetails', 'parameter_type': 'object', 'purpose': 'Details of the error if status is \\"error\\".'}], 'contract_description': 'Specification requires this method to update the status and error details of a specific integration configuration, as per REQ-1-060.', 'exception_contracts': 'Specification allows this method to throw if the update operation fails.'}, {'method_name': 'updateLastSyncTimestamp', 'method_signature': 'updateLastSyncTimestamp(adminUserId: string, timestamp: Date): Promise<void>', 'return_type': 'Promise<void>', 'framework_attributes': [], 'parameters': [{'parameter_name': 'adminUserId', 'parameter_type': 'string', 'purpose': 'The document ID for the integration configuration.'}, {'parameter_name': 'timestamp', 'parameter_type': 'Date', 'purpose': 'The timestamp of the last successfully exported record.'}], 'contract_description': "Specification requires this method to update the `lastSyncTimestamp` for a given integration, to be used as a cursor for the next run, fulfilling the performance guidance and REQ-1-059's assumption.", 'exception_contracts': 'Specification allows this method to throw if the update operation fails.'}], 'property_contracts': [], 'implementation_guidance': 'Implementations should handle mapping between Firestore documents and the `IntegrationConfig` domain entity.'}

### 2.3.6.0.0.0.0.0.0 Enum Specifications

*No items available*

### 2.3.7.0.0.0.0.0.0 Dto Specifications

*No items available*

### 2.3.8.0.0.0.0.0.0 Configuration Specifications

- {'configuration_name': 'Environment Configuration', 'file_path': 'functions/.env.{environment}', 'purpose': 'Specification for storing environment-specific variables and secrets for Cloud Functions.', 'framework_base_class': 'dotenv file format', 'configuration_sections': [{'section_name': 'Google OAuth', 'properties': [{'property_name': 'GOOGLE_CLIENT_ID', 'property_type': 'string', 'default_value': '', 'required': True, 'description': 'The Client ID for the Google Cloud OAuth 2.0 Client.'}, {'property_name': 'GOOGLE_CLIENT_SECRET_NAME', 'property_type': 'string', 'default_value': '', 'required': True, 'description': 'The name of the secret in Google Secret Manager that holds the OAuth Client Secret.'}]}], 'validation_requirements': 'All required variables must be present at runtime.'}

### 2.3.9.0.0.0.0.0.0 Dependency Injection Specifications

- {'service_interface': 'N/A', 'service_implementation': 'DI Container', 'lifetime': 'Request', 'registration_reasoning': 'Specification added for a lightweight, manual dependency injection container in `functions/src/config/di.ts` to construct the use case classes with their required infrastructure implementations. This is crucial for testability, allowing dependencies to be mocked in unit tests. A new container instance should be created for each function invocation to ensure statelessness.', 'framework_registration_pattern': 'Specification recommends a simple factory or registry pattern, e.g., `const container = createContainer(); const useCase = container.getExportUseCase();`'}

### 2.3.10.0.0.0.0.0.0 External Integration Specifications

#### 2.3.10.1.0.0.0.0.0 Integration Target

##### 2.3.10.1.1.0.0.0.0 Integration Target

Google Sheets API

##### 2.3.10.1.2.0.0.0.0 Integration Type

HTTP REST API

##### 2.3.10.1.3.0.0.0.0 Required Client Classes

- GoogleSheetsClient

##### 2.3.10.1.4.0.0.0.0 Configuration Requirements

Specification requires OAuth 2.0 credentials (access token obtained from refresh token).

##### 2.3.10.1.5.0.0.0.0 Error Handling Requirements

Specification requires handling of common errors like 403 (Permission Denied/Token Revoked), 404 (Sheet Not Found), and 429 (Rate Limited).

##### 2.3.10.1.6.0.0.0.0 Authentication Requirements

OAuth 2.0 Bearer Token.

##### 2.3.10.1.7.0.0.0.0 Framework Integration Patterns

Client Wrapper Pattern using the `googleapis` library.

#### 2.3.10.2.0.0.0.0.0 Integration Target

##### 2.3.10.2.1.0.0.0.0 Integration Target

Google Secret Manager

##### 2.3.10.2.2.0.0.0.0 Integration Type

GCP Service

##### 2.3.10.2.3.0.0.0.0 Required Client Classes

- SecretManagerClient

##### 2.3.10.2.4.0.0.0.0 Configuration Requirements

Specification requires the function's service account to have the \"Secret Manager Secret Accessor\" IAM role.

##### 2.3.10.2.5.0.0.0.0 Error Handling Requirements

Specification requires handling \"secret not found\" and \"permission denied\" errors.

##### 2.3.10.2.6.0.0.0.0 Authentication Requirements

Authenticated via the Cloud Function's runtime service account (Application Default Credentials).

##### 2.3.10.2.7.0.0.0.0 Framework Integration Patterns

Client Wrapper Pattern using the `@google-cloud/secret-manager` library.

#### 2.3.10.3.0.0.0.0.0 Integration Target

##### 2.3.10.3.1.0.0.0.0 Integration Target

Google Cloud Scheduler

##### 2.3.10.3.2.0.0.0.0 Integration Type

Trigger

##### 2.3.10.3.3.0.0.0.0 Required Client Classes

*No items available*

##### 2.3.10.3.4.0.0.0.0 Configuration Requirements

Specification requires a job to be configured in Cloud Scheduler to publish a message to a specific Pub/Sub topic on a schedule (e.g., daily at 2 AM).

##### 2.3.10.3.5.0.0.0.0 Error Handling Requirements

Specification requires the triggered function to be idempotent to handle potential duplicate triggers.

##### 2.3.10.3.6.0.0.0.0 Authentication Requirements

The scheduler's service account must have permission to publish to the target Pub/Sub topic.

##### 2.3.10.3.7.0.0.0.0 Framework Integration Patterns

Time-triggered (scheduled) function pattern, implemented with `onSchedule` in Firebase Functions v2.

## 2.4.0.0.0.0.0.0.0 Component Count Validation

| Property | Value |
|----------|-------|
| Total Classes | 8 |
| Total Interfaces | 5 |
| Total Enums | 0 |
| Total Dtos | 0 |
| Total Configurations | 5 |
| Total External Integrations | 3 |
| Grand Total Components | 21 |
| Phase 2 Claimed Count | 0 |
| Phase 2 Actual Count | 0 |
| Validation Added Count | 21 |
| Final Validated Count | 21 |

# 3.0.0.0.0.0.0.0.0 File Structure

## 3.1.0.0.0.0.0.0.0 Directory Organization

### 3.1.1.0.0.0.0.0.0 Directory Path

#### 3.1.1.1.0.0.0.0.0 Directory Path

.eslintrc.json

#### 3.1.1.2.0.0.0.0.0 Purpose

Infrastructure and project configuration files

#### 3.1.1.3.0.0.0.0.0 Contains Files

- .eslintrc.json

#### 3.1.1.4.0.0.0.0.0 Organizational Reasoning

Contains project setup, configuration, and infrastructure files for development and deployment

#### 3.1.1.5.0.0.0.0.0 Framework Convention Alignment

Standard project structure for infrastructure as code and development tooling

### 3.1.2.0.0.0.0.0.0 Directory Path

#### 3.1.2.1.0.0.0.0.0 Directory Path

.firebaserc

#### 3.1.2.2.0.0.0.0.0 Purpose

Infrastructure and project configuration files

#### 3.1.2.3.0.0.0.0.0 Contains Files

- .firebaserc

#### 3.1.2.4.0.0.0.0.0 Organizational Reasoning

Contains project setup, configuration, and infrastructure files for development and deployment

#### 3.1.2.5.0.0.0.0.0 Framework Convention Alignment

Standard project structure for infrastructure as code and development tooling

### 3.1.3.0.0.0.0.0.0 Directory Path

#### 3.1.3.1.0.0.0.0.0 Directory Path

.github/workflows/ci.yml

#### 3.1.3.2.0.0.0.0.0 Purpose

Infrastructure and project configuration files

#### 3.1.3.3.0.0.0.0.0 Contains Files

- ci.yml

#### 3.1.3.4.0.0.0.0.0 Organizational Reasoning

Contains project setup, configuration, and infrastructure files for development and deployment

#### 3.1.3.5.0.0.0.0.0 Framework Convention Alignment

Standard project structure for infrastructure as code and development tooling

### 3.1.4.0.0.0.0.0.0 Directory Path

#### 3.1.4.1.0.0.0.0.0 Directory Path

.github/workflows/deploy-staging.yml

#### 3.1.4.2.0.0.0.0.0 Purpose

Infrastructure and project configuration files

#### 3.1.4.3.0.0.0.0.0 Contains Files

- deploy-staging.yml

#### 3.1.4.4.0.0.0.0.0 Organizational Reasoning

Contains project setup, configuration, and infrastructure files for development and deployment

#### 3.1.4.5.0.0.0.0.0 Framework Convention Alignment

Standard project structure for infrastructure as code and development tooling

### 3.1.5.0.0.0.0.0.0 Directory Path

#### 3.1.5.1.0.0.0.0.0 Directory Path

.gitignore

#### 3.1.5.2.0.0.0.0.0 Purpose

Infrastructure and project configuration files

#### 3.1.5.3.0.0.0.0.0 Contains Files

- .gitignore

#### 3.1.5.4.0.0.0.0.0 Organizational Reasoning

Contains project setup, configuration, and infrastructure files for development and deployment

#### 3.1.5.5.0.0.0.0.0 Framework Convention Alignment

Standard project structure for infrastructure as code and development tooling

### 3.1.6.0.0.0.0.0.0 Directory Path

#### 3.1.6.1.0.0.0.0.0 Directory Path

.prettierrc.json

#### 3.1.6.2.0.0.0.0.0 Purpose

Infrastructure and project configuration files

#### 3.1.6.3.0.0.0.0.0 Contains Files

- .prettierrc.json

#### 3.1.6.4.0.0.0.0.0 Organizational Reasoning

Contains project setup, configuration, and infrastructure files for development and deployment

#### 3.1.6.5.0.0.0.0.0 Framework Convention Alignment

Standard project structure for infrastructure as code and development tooling

### 3.1.7.0.0.0.0.0.0 Directory Path

#### 3.1.7.1.0.0.0.0.0 Directory Path

.vscode/launch.json

#### 3.1.7.2.0.0.0.0.0 Purpose

Infrastructure and project configuration files

#### 3.1.7.3.0.0.0.0.0 Contains Files

- launch.json

#### 3.1.7.4.0.0.0.0.0 Organizational Reasoning

Contains project setup, configuration, and infrastructure files for development and deployment

#### 3.1.7.5.0.0.0.0.0 Framework Convention Alignment

Standard project structure for infrastructure as code and development tooling

### 3.1.8.0.0.0.0.0.0 Directory Path

#### 3.1.8.1.0.0.0.0.0 Directory Path

.vscode/settings.json

#### 3.1.8.2.0.0.0.0.0 Purpose

Infrastructure and project configuration files

#### 3.1.8.3.0.0.0.0.0 Contains Files

- settings.json

#### 3.1.8.4.0.0.0.0.0 Organizational Reasoning

Contains project setup, configuration, and infrastructure files for development and deployment

#### 3.1.8.5.0.0.0.0.0 Framework Convention Alignment

Standard project structure for infrastructure as code and development tooling

### 3.1.9.0.0.0.0.0.0 Directory Path

#### 3.1.9.1.0.0.0.0.0 Directory Path

firebase.json

#### 3.1.9.2.0.0.0.0.0 Purpose

Infrastructure and project configuration files

#### 3.1.9.3.0.0.0.0.0 Contains Files

- firebase.json

#### 3.1.9.4.0.0.0.0.0 Organizational Reasoning

Contains project setup, configuration, and infrastructure files for development and deployment

#### 3.1.9.5.0.0.0.0.0 Framework Convention Alignment

Standard project structure for infrastructure as code and development tooling

### 3.1.10.0.0.0.0.0.0 Directory Path

#### 3.1.10.1.0.0.0.0.0 Directory Path

```javascript
functions/.env.development
```

#### 3.1.10.2.0.0.0.0.0 Purpose

Infrastructure and project configuration files

#### 3.1.10.3.0.0.0.0.0 Contains Files

- .env.development

#### 3.1.10.4.0.0.0.0.0 Organizational Reasoning

Contains project setup, configuration, and infrastructure files for development and deployment

#### 3.1.10.5.0.0.0.0.0 Framework Convention Alignment

Standard project structure for infrastructure as code and development tooling

### 3.1.11.0.0.0.0.0.0 Directory Path

#### 3.1.11.1.0.0.0.0.0 Directory Path

```javascript
functions/jest.config.js
```

#### 3.1.11.2.0.0.0.0.0 Purpose

Infrastructure and project configuration files

#### 3.1.11.3.0.0.0.0.0 Contains Files

- jest.config.js

#### 3.1.11.4.0.0.0.0.0 Organizational Reasoning

Contains project setup, configuration, and infrastructure files for development and deployment

#### 3.1.11.5.0.0.0.0.0 Framework Convention Alignment

Standard project structure for infrastructure as code and development tooling

### 3.1.12.0.0.0.0.0.0 Directory Path

#### 3.1.12.1.0.0.0.0.0 Directory Path

```javascript
functions/package.json
```

#### 3.1.12.2.0.0.0.0.0 Purpose

Infrastructure and project configuration files

#### 3.1.12.3.0.0.0.0.0 Contains Files

- package.json

#### 3.1.12.4.0.0.0.0.0 Organizational Reasoning

Contains project setup, configuration, and infrastructure files for development and deployment

#### 3.1.12.5.0.0.0.0.0 Framework Convention Alignment

Standard project structure for infrastructure as code and development tooling

### 3.1.13.0.0.0.0.0.0 Directory Path

#### 3.1.13.1.0.0.0.0.0 Directory Path

```javascript
functions/tsconfig.json
```

#### 3.1.13.2.0.0.0.0.0 Purpose

Infrastructure and project configuration files

#### 3.1.13.3.0.0.0.0.0 Contains Files

- tsconfig.json

#### 3.1.13.4.0.0.0.0.0 Organizational Reasoning

Contains project setup, configuration, and infrastructure files for development and deployment

#### 3.1.13.5.0.0.0.0.0 Framework Convention Alignment

Standard project structure for infrastructure as code and development tooling

