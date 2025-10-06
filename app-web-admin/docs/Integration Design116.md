# 1 Integration Specifications

## 1.1 Extraction Metadata

| Property | Value |
|----------|-------|
| Repository Id | REPO-APP-ADMIN-011 |
| Extraction Timestamp | 2024-07-28T11:00:00Z |
| Mapping Validation Score | 100% |
| Context Completeness Score | 100% |
| Implementation Readiness Level | High |

## 1.2 Relevant Requirements

### 1.2.1 Requirement Id

#### 1.2.1.1 Requirement Id

REQ-1-010

#### 1.2.1.2 Requirement Text

The system shall provide a web-based administrative dashboard accessible via modern web browsers...for users with the 'Admin' role to perform tenant management, user management, configuration, and reporting tasks.

#### 1.2.1.3 Validation Criteria

- Verify that a user with the 'Admin' role can log in to a web application.
- Verify the dashboard provides access to user management, team management, and reporting features.

#### 1.2.1.4 Implementation Implications

- This repository's primary output is the Flutter for Web application that fulfills this requirement.
- A routing guard must be implemented to check for an authenticated user's JWT and validate the 'Admin' role custom claim, blocking all other roles.
- The application's main layout will feature navigation to the various management sections.

#### 1.2.1.5 Extraction Reasoning

This requirement is the foundational mandate for the existence and core scope of the 'app-web-admin' repository.

### 1.2.2.0 Requirement Id

#### 1.2.2.1 Requirement Id

REQ-1-057

#### 1.2.2.2 Requirement Text

The system must provide a comprehensive reporting module accessible to Admins via the web dashboard. All reports must be filterable by date range, specific user(s), team(s), and attendance status...All generated reports must be exportable to CSV format...

#### 1.2.2.3 Validation Criteria

- As an Admin, generate an Attendance Summary report for the last month for a specific team.
- Apply a filter to show only 'approved' records and verify the report updates.
- Click the 'Export to CSV' button and verify a correctly formatted CSV file is downloaded.

#### 1.2.2.4 Implementation Implications

- The application must include a dedicated 'Reports' section with UI for multiple report types (Summary, Exception, Audit Log).
- A reusable filtering component must be built to handle date ranges and multi-select for users, teams, and statuses.
- Data must be fetched via the data access layer using server-side filtering and pagination to ensure performance.
- Client-side logic is required to generate and trigger the download of CSV files.

#### 1.2.2.5 Extraction Reasoning

This requirement defines one of the most complex functional areas of the Admin dashboard, directly influencing its integration with the data access layer and its internal UI component structure.

### 1.2.3.0 Requirement Id

#### 1.2.3.1 Requirement Id

REQ-1-061

#### 1.2.3.2 Requirement Text

The Admin web dashboard must feature a 'Tenant Settings' section where Admins can configure system behavior...Organization Timezone, Auto-checkout time, Approval escalation period, Default working hours, Password policy details, Data retention periods...

#### 1.2.3.3 Validation Criteria

- As an Admin, navigate to the settings page.
- Change the organization's timezone from EST to PST and verify the setting is saved.

#### 1.2.3.4 Implementation Implications

- A 'Settings' or 'Configuration' page must be a primary navigation destination in the dashboard.
- The page must contain various form components to manage all the specified settings.
- The application will interact with a dedicated repository interface from the data access layer (e.g., 'ITenantConfigRepository') to persist these settings.

#### 1.2.3.5 Extraction Reasoning

This requirement defines the 'tenant management' and 'configuration' responsibilities of the Admin Web Dashboard, dictating a significant portion of its UI and data integration needs.

### 1.2.4.0 Requirement Id

#### 1.2.4.1 Requirement Id

REQ-1-077

#### 1.2.4.2 Requirement Text

To support new tenant onboarding, the system shall provide a data migration tool for users and teams...The Admin web dashboard will feature a secure, Admin-only tool to upload this CSV file.

#### 1.2.4.3 Validation Criteria

- As an Admin, upload this file using the import tool in the web dashboard.
- Verify that the correct user and team documents are created in Firestore.

#### 1.2.4.4 Implementation Implications

- The application must implement a UI for file upload that is restricted to Admins.
- The upload will trigger a backend Cloud Function (from 'identity-access-services') to process the file.
- The UI needs to manage the asynchronous state of the import process, displaying progress and a final summary report.

#### 1.2.4.5 Extraction Reasoning

Defines a key onboarding feature that this repository must provide the user interface for, including the integration with the backend processing service.

## 1.3.0.0 Relevant Components

### 1.3.1.0 Component Name

#### 1.3.1.1 Component Name

Admin Dashboard Application

#### 1.3.1.2 Component Specification

The main Flutter for Web application that orchestrates all admin-facing features. It manages routing, authentication state, and the overall page layout including navigation.

#### 1.3.1.3 Implementation Requirements

- Implement a main app widget that listens to authentication state.
- Implement a router (e.g., GoRouter) with a routing guard to protect all routes and ensure only authenticated 'Admin' users can access them, fulfilling REQ-1-010.

#### 1.3.1.4 Architectural Context

This is the top-level application component within the Presentation Layer, acting as the composition root.

#### 1.3.1.5 Extraction Reasoning

Represents the application entry point and overall structure of the repository's output, responsible for enforcing Admin-only access.

### 1.3.2.0 Component Name

#### 1.3.2.1 Component Name

User, Team & Hierarchy Management UI

#### 1.3.2.2 Component Specification

A collection of screens, forms, and modals for performing CRUD operations on users and teams, and for managing the supervisor-subordinate hierarchy.

#### 1.3.2.3 Implementation Requirements

- Implement screens to list users and teams with filtering and pagination.
- Implement modal forms for inviting/editing users and creating/editing teams.
- The UI for assigning a supervisor to a user must trigger a backend validation call to prevent circular hierarchies (REQ-1-026).
- Utilize the 'IUserRepository' and 'ITeamRepository' from the data access layer and call secure functions in 'identity-access-services' and 'team-event-management-services'.

#### 1.3.2.4 Architectural Context

A major feature module within the Presentation Layer, responsible for the 'user management' tasks of the Admin role.

#### 1.3.2.5 Extraction Reasoning

This component directly fulfills primary responsibilities outlined in REQ-1-010, REQ-1-018, and REQ-1-038, requiring integration with both the data layer and multiple backend services.

### 1.3.3.0 Component Name

#### 1.3.3.1 Component Name

Reporting Module UI

#### 1.3.3.2 Component Specification

A set of screens dedicated to displaying various reports (Summary, Exception, Audit Log, etc.) as specified in REQ-1-057, including data visualization and filtering capabilities.

#### 1.3.3.3 Implementation Requirements

- Implement a screen for each required report type.
- Build reusable data table and filter components that consume data from the 'IAttendanceRepository' and 'IAuditLogRepository'.
- Implement client-side CSV export functionality for all reports.

#### 1.3.3.4 Architectural Context

A major feature module within the Presentation Layer, responsible for the 'reporting tasks' of the Admin role.

#### 1.3.3.5 Extraction Reasoning

This component directly implements the comprehensive reporting requirements for the Admin dashboard, driving the need for performant, paginated data queries from the data access layer.

### 1.3.4.0 Component Name

#### 1.3.4.1 Component Name

Tenant & Integration Configuration UI

#### 1.3.4.2 Component Specification

A settings screen that allows Admins to manage tenant-wide configurations (REQ-1-061) and third-party integrations like the Google Sheets export (REQ-1-008, REQ-1-058).

#### 1.3.4.3 Implementation Requirements

- Implement a form with various input types to manage settings like timezone, password policy, etc., using the 'ITenantConfigRepository'.
- Implement the UI to initiate the Google OAuth 2.0 flow, which calls a function in 'reporting-export-services' to securely exchange the token.
- Display the status of integrations and provide options for re-authentication or management.

#### 1.3.4.4 Architectural Context

A key feature within the Presentation Layer, responsible for 'tenant management' and 'configuration' tasks.

#### 1.3.4.5 Extraction Reasoning

This component implements multiple configuration requirements and has critical integration points with both the data access layer and backend services for secure operations like OAuth.

## 1.4.0.0 Architectural Layers

- {'layer_name': 'Presentation Layer (Web Client)', 'layer_responsibilities': "This repository is the implementation of the 'Web Administrative Dashboard' component within the Presentation Layer. Its responsibilities include rendering all user interfaces for the Admin role, managing UI state via Riverpod, capturing user input, and displaying data fetched from underlying layers.", 'layer_constraints': ['Must not contain business logic; all logic is delegated to repositories or state notifiers.', 'Must not directly interact with Firebase or any other data source; must use repository interfaces or call secure backend functions.', 'Must implement UI according to the shared UI component library (REPO-LIB-UI-009).'], 'implementation_patterns': ['Clean Architecture', 'MVVM (Model-View-ViewModel) using Riverpod State Notifiers', 'Dependency Injection using Riverpod', 'Repository Pattern (as a consumer)'], 'extraction_reasoning': 'The repository is explicitly mapped to the presentation-layer and its description aligns perfectly with the responsibilities of a web-based UI client in a Clean Architecture.'}

## 1.5.0.0 Dependency Interfaces

### 1.5.1.0 Interface Name

#### 1.5.1.1 Interface Name

Client Data Access Layer

#### 1.5.1.2 Source Repository

REPO-LIB-CLIENT-008

#### 1.5.1.3 Method Contracts

##### 1.5.1.3.1 Method Name

###### 1.5.1.3.1.1 Method Name

IUserRepository.fetchAllUsers(paginationOptions)

###### 1.5.1.3.1.2 Method Signature

Stream<List<User>> fetchAllUsers(String tenantId, {PaginationOptions options})

###### 1.5.1.3.1.3 Method Purpose

Fetches a paginated, real-time list of all users within the current tenant.

###### 1.5.1.3.1.4 Integration Context

Used to populate the main user list in the User Management section.

##### 1.5.1.3.2.0 Method Name

###### 1.5.1.3.2.1 Method Name

ITeamRepository.createTeam(name, supervisorId)

###### 1.5.1.3.2.2 Method Signature

Future<void> createTeam(String name, String supervisorId)

###### 1.5.1.3.2.3 Method Purpose

Creates a new team document in Firestore.

###### 1.5.1.3.2.4 Integration Context

Called when an Admin submits the 'Create Team' form.

##### 1.5.1.3.3.0 Method Name

###### 1.5.1.3.3.1 Method Name

IAttendanceRepository.getFilteredRecords(filters, paginationOptions)

###### 1.5.1.3.3.2 Method Signature

Future<PaginatedResult<AttendanceRecord>> getFilteredRecords(ReportFilters filters, PaginationOptions options)

###### 1.5.1.3.3.3 Method Purpose

Fetches a filtered and paginated list of attendance records for reporting.

###### 1.5.1.3.3.4 Integration Context

Called by the reporting module to display data in tables.

##### 1.5.1.3.4.0 Method Name

###### 1.5.1.3.4.1 Method Name

ITenantConfigRepository.updateConfig(config)

###### 1.5.1.3.4.2 Method Signature

Future<void> updateConfig(TenantConfiguration config)

###### 1.5.1.3.4.3 Method Purpose

Updates the tenant's configuration document in Firestore.

###### 1.5.1.3.4.4 Integration Context

Called when the Admin saves changes on the Tenant Settings page.

#### 1.5.1.4.0.0 Integration Pattern

Library Import & Dependency Injection (via Riverpod)

#### 1.5.1.5.0.0 Communication Protocol

In-process Dart method calls.

#### 1.5.1.6.0.0 Extraction Reasoning

The admin dashboard is responsible for all data management and viewing, requiring comprehensive, abstracted access to all data domains (Users, Teams, Attendance, Config, etc.) provided by the shared data access library.

### 1.5.2.0.0.0 Interface Name

#### 1.5.2.1.0.0 Interface Name

Shared UI Component Library

#### 1.5.2.2.0.0 Source Repository

REPO-LIB-UI-009

#### 1.5.2.3.0.0 Method Contracts

##### 1.5.2.3.1.0 Method Name

###### 1.5.2.3.1.1 Method Name

PrimaryButton

###### 1.5.2.3.1.2 Method Signature

Widget PrimaryButton({required VoidCallback onPressed, required Widget child})

###### 1.5.2.3.1.3 Method Purpose

Provides a consistently styled primary action button.

###### 1.5.2.3.1.4 Integration Context

Used for all 'Save', 'Create', and 'Submit' actions in forms.

##### 1.5.2.3.2.0 Method Name

###### 1.5.2.3.2.1 Method Name

DataTableWidget

###### 1.5.2.3.2.2 Method Signature

Widget DataTableWidget({required List<Column> columns, required List<Row> rows, required PaginationControls controls})

###### 1.5.2.3.2.3 Method Purpose

Provides a responsive and styled data table for displaying report data with pagination.

###### 1.5.2.3.2.4 Integration Context

Used as the core component in all screens within the Reporting Module.

##### 1.5.2.3.3.0 Method Name

###### 1.5.2.3.3.1 Method Name

ReportFilterWidget

###### 1.5.2.3.3.2 Method Signature

Widget ReportFilterWidget({required Function(Filters) onApply})

###### 1.5.2.3.3.3 Method Purpose

Provides a reusable UI component for all report filtering controls.

###### 1.5.2.3.3.4 Integration Context

Used at the top of every report screen.

#### 1.5.2.4.0.0 Integration Pattern

Library Import

#### 1.5.2.5.0.0 Communication Protocol

N/A (Widget Composition)

#### 1.5.2.6.0.0 Extraction Reasoning

To ensure a consistent look and feel (REQ-1-062) and reduce code duplication, this repository must consume the shared UI library for all common components like buttons, tables, and form fields.

### 1.5.3.0.0.0 Interface Name

#### 1.5.3.1.0.0 Interface Name

Identity & Access Callable API

#### 1.5.3.2.0.0 Source Repository

REPO-SVC-IDENTITY-003

#### 1.5.3.3.0.0 Method Contracts

##### 1.5.3.3.1.0 Method Name

###### 1.5.3.3.1.1 Method Name

registerOrganization

###### 1.5.3.3.1.2 Method Signature

(data: { orgName: string, ... }) => Promise<void>

###### 1.5.3.3.1.3 Method Purpose

Handles the public-facing registration of a new tenant and its first Admin.

###### 1.5.3.3.1.4 Integration Context

Called from the public registration page hosted by this repository.

##### 1.5.3.3.2.0 Method Name

###### 1.5.3.3.2.1 Method Name

inviteUser

###### 1.5.3.3.2.2 Method Signature

(data: { email: string, role: string }) => Promise<void>

###### 1.5.3.3.2.3 Method Purpose

Initiates the secure user invitation workflow.

###### 1.5.3.3.2.4 Integration Context

Called from the 'Invite User' modal in the User Management section.

##### 1.5.3.3.3.0 Method Name

###### 1.5.3.3.3.1 Method Name

deactivateUser

###### 1.5.3.3.3.2 Method Signature

(data: { userId: string }) => Promise<void>

###### 1.5.3.3.3.3 Method Purpose

Securely deactivates a user, including checks for reassigning subordinates.

###### 1.5.3.3.3.4 Integration Context

Called from the User Management section when an Admin deactivates a user.

#### 1.5.3.4.0.0 Integration Pattern

Secure RPC via Firebase Callable Functions

#### 1.5.3.5.0.0 Communication Protocol

HTTPS

#### 1.5.3.6.0.0 Extraction Reasoning

This repository provides the UI for critical identity and access management tasks (tenant registration, user invitations, deactivation) that require secure, transactional, server-side logic, which is provided by the 'identity-access-services' microservice.

### 1.5.4.0.0.0 Interface Name

#### 1.5.4.1.0.0 Interface Name

Reporting & Export Callable API

#### 1.5.4.2.0.0 Source Repository

REPO-SVC-REPORTING-006

#### 1.5.4.3.0.0 Method Contracts

- {'method_name': 'exchangeAuthCodeForToken', 'method_signature': '(data: { authCode: string }) => Promise<void>', 'method_purpose': 'Securely exchanges a one-time Google OAuth 2.0 authorization code for a long-lived refresh token.', 'integration_context': 'Called by the UI after the Admin is redirected back from the Google consent screen during the Google Sheets integration setup.'}

#### 1.5.4.4.0.0 Integration Pattern

Secure RPC via Firebase Callable Functions

#### 1.5.4.5.0.0 Communication Protocol

HTTPS

#### 1.5.4.6.0.0 Extraction Reasoning

The UI in this repository initiates the Google Sheets integration, which requires a secure backend endpoint to handle the sensitive OAuth token exchange, as provided by 'reporting-export-services'.

## 1.6.0.0.0.0 Exposed Interfaces

*No items available*

## 1.7.0.0.0.0 Technology Context

### 1.7.1.0.0.0 Framework Requirements

The application must be built using Flutter with the Flutter for Web target enabled. State management must be implemented using the Riverpod package.

### 1.7.2.0.0.0 Integration Technologies

- Firebase SDK for Flutter (Authentication, Firestore, Functions)
- Riverpod (for State Management and Dependency Injection)
- Google Sign-In for Web (for initiating OAuth flow)

### 1.7.3.0.0.0 Performance Constraints

Reporting screens must use server-side filtering and pagination to handle large datasets efficiently, preventing high client-side load and Firestore read costs, as per REQ-1-057.

### 1.7.4.0.0.0 Security Requirements

The application must implement a routing guard that checks the user's Firebase Auth custom claims ('role' and 'tenantId') on every navigation. Access must be denied if the role is not 'Admin'. All secure operations must be delegated to backend Callable Functions.

## 1.8.0.0.0.0 Extraction Validation

| Property | Value |
|----------|-------|
| Mapping Completeness Check | The analysis confirms all major functional areas o... |
| Cross Reference Validation | All mappings are consistent. The dependencies alig... |
| Implementation Readiness Assessment | The readiness is high. This specification provides... |
| Quality Assurance Confirmation | The analysis was performed systematically, identif... |

