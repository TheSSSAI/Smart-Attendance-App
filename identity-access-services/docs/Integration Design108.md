# 1 Integration Specifications

## 1.1 Extraction Metadata

| Property | Value |
|----------|-------|
| Repository Id | identity-access-services |
| Extraction Timestamp | 2024-05-24T18:00:00Z |
| Mapping Validation Score | 100% |
| Context Completeness Score | 99% |
| Implementation Readiness Level | High |

## 1.2 Relevant Requirements

### 1.2.1 Requirement Id

#### 1.2.1.1 Requirement Id

REQ-1-032

#### 1.2.1.2 Requirement Text

The system shall provide a public-facing registration page for a new organization's first Admin user. This process must capture necessary information, including an organization name. Before creating the new tenant, the system must perform a global validation to ensure the chosen organization name is unique across all existing tenants.

#### 1.2.1.3 Validation Criteria

- Register a new organization with the name 'Test Corp'.
- Attempt to register a second organization with the name 'Test Corp' and verify the system displays a 'name already taken' error.

#### 1.2.1.4 Implementation Implications

- Requires a publicly accessible callable Cloud Function to handle the registration logic.
- A performant mechanism for checking organization name uniqueness is needed, potentially a separate collection for normalized names.
- The function must be secured against abuse using rate limiting or Firebase App Check.

#### 1.2.1.5 Extraction Reasoning

This requirement defines the primary entry point for new tenant creation, a core responsibility of the identity-access-services repository as per its description.

### 1.2.2.0 Requirement Id

#### 1.2.2.1 Requirement Id

REQ-1-033

#### 1.2.2.2 Requirement Text

Upon successful registration of a new organization, the system must perform the following atomic operations: 1) Create a new document in the /tenants collection in Firestore, representing the new tenant. 2) Create a new user document in the /users collection for the registering Admin, assigning them the 'Admin' role and linking them to the new tenant. 3) Set two custom claims on the Admin's Firebase Authentication user object: tenantId (with the new tenant's ID) and role (with the value 'Admin').

#### 1.2.2.3 Validation Criteria

- After a successful registration, query the /tenants collection and verify a new document exists.
- Inspect the ID token of the newly logged-in Admin and verify the tenantId and role custom claims are present and correct.

#### 1.2.2.4 Implementation Implications

- The logic must be implemented in a server-side Cloud Function to ensure atomicity and security.
- Requires using the Firebase Admin SDK to create the Auth user and set custom claims.
- A Firestore transaction is necessary to guarantee that either all documents are created or none are, preventing orphaned data.

#### 1.2.2.5 Extraction Reasoning

This requirement details the specific backend operations for new tenant and admin creation, which is a central function of this identity-focused microservice.

### 1.2.3.0 Requirement Id

#### 1.2.3.1 Requirement Id

REQ-1-036

#### 1.2.3.2 Requirement Text

The Admin dashboard shall provide an interface for Admins to invite new users by providing their email address and assigning a role. Upon invitation, the system must: 1) Create a new user document in Firestore with a status of 'invited'. 2) Trigger the sending of an invitation email to the specified address using the SendGrid service. 3) The invitation email must contain a unique registration link that is valid for only 24 hours.

#### 1.2.3.3 Validation Criteria

- As an Admin, invite a new user and verify a user document is created with 'invited' status.
- Verify the invited user receives an email from the system.
- Attempt to use the link after 24 hours and verify it has expired and is no longer valid.

#### 1.2.3.4 Implementation Implications

- Requires a callable Cloud Function accessible only by authenticated Admins.
- The function must generate a secure, unique, and time-limited token.
- Integration with the SendGrid API client library is required for sending the email.

#### 1.2.3.5 Extraction Reasoning

This requirement defines the user invitation workflow, which is explicitly listed as a responsibility of the identity-access-services repository.

### 1.2.4.0 Requirement Id

#### 1.2.4.1 Requirement Id

REQ-1-037

#### 1.2.4.2 Requirement Text

When an invited user follows the registration link and successfully sets their password, the system must update their user document status from 'invited' to 'active'. Once active, the user shall be able to log in. Admins must have the ability to change a user's status to 'deactivated'. The system's authentication logic must prevent any user with a 'deactivated' status from successfully logging in.

#### 1.2.4.3 Validation Criteria

- Complete the registration flow for an invited user and verify their status changes to 'active'.
- As an Admin, deactivate the user's account.
- Attempt to log in with the deactivated account and verify that access is denied with an appropriate message.

#### 1.2.4.4 Implementation Implications

- A Cloud Function is needed to process the registration token and update the user's status.
- A separate callable Cloud Function is required for Admins to manage user status (e.g., 'deactivateUser').
- Authentication logic, likely using Firebase Auth Blocking Functions, must check the user's status in Firestore before issuing a session token.

#### 1.2.4.5 Extraction Reasoning

This requirement covers the full user activation and deactivation lifecycle, which are core security and identity management functions belonging to this service.

### 1.2.5.0 Requirement Id

#### 1.2.5.1 Requirement Id

REQ-1-026

#### 1.2.5.2 Requirement Text

The system must implement a business rule to prevent the creation of circular reporting hierarchies. When an Admin or Supervisor attempts to assign a supervisor to a user, the system must validate that this assignment does not result in a loop (e.g., A reports to B, and B reports to A). The operation must be blocked if a circular dependency is detected.

#### 1.2.5.3 Validation Criteria

- Attempt to set a user's supervisor to themselves and verify the system returns an error.
- Create a scenario where User A reports to User B. Attempt to set User B's supervisor to User A and verify the system returns an error.

#### 1.2.5.4 Implementation Implications

- A callable Cloud Function is required to handle supervisor updates.
- This function must contain logic to traverse the user hierarchy upwards from the proposed new supervisor to check if the original user exists in the chain.

#### 1.2.5.5 Extraction Reasoning

This data integrity rule concerns the core User entity hierarchy, which is owned by the identity-access-services repository. This service must provide the server-side validation logic for any action that modifies the `supervisorId` field.

### 1.2.6.0 Requirement Id

#### 1.2.6.1 Requirement Id

REQ-1-074

#### 1.2.6.2 Requirement Text

The system must implement a data retention policy for deactivated users. A scheduled Cloud Function shall run daily to find users who have been in a 'deactivated' state for more than 90 days. For each such user, the function must perform an anonymization process.

#### 1.2.6.3 Validation Criteria

- Deactivate a user.
- After 90 days (or by manually triggering the function for the test user), verify their name and email have been removed from their user document.

#### 1.2.6.4 Implementation Implications

- Requires a scheduled Cloud Function triggered by Cloud Scheduler.
- The function must be robust enough to query and process users across all tenants.
- The anonymization process must perform writes to the user collection to replace PII, requiring careful transaction management.

#### 1.2.6.5 Extraction Reasoning

This requirement for user data anonymization is an advanced user lifecycle feature that falls squarely within the identity and access management bounded context.

## 1.3.0.0 Relevant Components

### 1.3.1.0 Component Name

#### 1.3.1.1 Component Name

Tenant Registration Function

#### 1.3.1.2 Component Specification

A publicly accessible callable Cloud Function that handles the creation of a new tenant and its initial Admin user. It performs uniqueness checks, creates user and tenant records atomically, and sets initial security claims.

#### 1.3.1.3 Implementation Requirements

- Must validate that the organization name is globally unique (case-insensitive).
- Must use a Firestore transaction to create the Auth user, Firestore user, and Tenant documents.
- Must implement rollback logic (e.g., delete Auth user) if any step of the transaction fails.
- Must use the Firebase Admin SDK to set tenantId and role: 'Admin' custom claims on the new user's token.

#### 1.3.1.4 Architectural Context

Part of the application-services-layer, serves as the primary public API endpoint for new customer onboarding.

#### 1.3.1.5 Extraction Reasoning

This component is the direct implementation of the tenant creation responsibilities (REQ-1-032, REQ-1-033) assigned to this repository.

### 1.3.2.0 Component Name

#### 1.3.2.1 Component Name

User Invitation Function

#### 1.3.2.2 Component Specification

A callable Cloud Function restricted to Admins. It creates a new user document with an 'invited' status, generates a secure time-limited registration token, and integrates with SendGrid to dispatch an invitation email.

#### 1.3.2.3 Implementation Requirements

- Must validate that the caller has an 'Admin' role via their auth token custom claims.
- Must generate a cryptographically secure, unique token and store it with a 24-hour expiry timestamp.
- Must call the SendGrid API using a securely stored API key to send a templated email.

#### 1.3.2.4 Architectural Context

Part of the application-services-layer, serving as a secure endpoint for the Admin web application.

#### 1.3.2.5 Extraction Reasoning

This component implements the user invitation workflow (REQ-1-036), a core feature of the identity management service.

### 1.3.3.0 Component Name

#### 1.3.3.1 Component Name

User Lifecycle Functions

#### 1.3.3.2 Component Specification

A set of callable and triggered Cloud Functions that manage the state of a user account, including activation (completing registration), deactivation, and checks for preventing orphaned subordinates.

#### 1.3.3.3 Implementation Requirements

- A callable function to process registration tokens, activate users, and set final custom claims.
- A callable function for Admins to deactivate users, which must include logic to prevent deactivating a supervisor with active subordinates (REQ-1-029).
- A Firebase Auth beforeSignIn blocking function to check a user's 'status' field in Firestore and prevent login for 'deactivated' or 'invited' users.

#### 1.3.3.4 Architectural Context

Part of the application-services-layer, providing the core business logic and security enforcement for user account status.

#### 1.3.3.5 Extraction Reasoning

This group of functions fulfills the user status management responsibilities (REQ-1-037, REQ-1-029) of the repository.

### 1.3.4.0 Component Name

#### 1.3.4.1 Component Name

Scheduled Maintenance Functions

#### 1.3.4.2 Component Specification

A scheduled Cloud Function, triggered daily, responsible for tenant and user data lifecycle tasks. This includes processing tenant deletions after the grace period and anonymizing old, deactivated user data.

#### 1.3.4.3 Implementation Requirements

- Must query for all tenants with status 'pending_deletion' where the deletion timestamp is in the past.
- Must perform a cascading delete of all data associated with an expired tenant.
- Must query for all deactivated users whose deactivation timestamp is older than the configured retention period and perform anonymization.
- Must be idempotent and handle large volumes of data using batching and cursors.

#### 1.3.4.4 Architectural Context

Part of the application-services-layer, operates as a background batch process triggered by Google Cloud Scheduler.

#### 1.3.4.5 Extraction Reasoning

This component implements the automated, server-side logic for tenant offboarding (REQ-1-035) and user data anonymization (REQ-1-074).

## 1.4.0.0 Architectural Layers

- {'layer_name': 'Application Services (Firebase Cloud Functions)', 'layer_responsibilities': 'Executes complex, trusted business logic that cannot be handled by declarative rules or on the client. This includes performing scheduled tasks, integrating with third-party services like SendGrid, and setting security-critical custom claims on Firebase Auth users.', 'layer_constraints': ['All functions must be written in TypeScript.', 'Functions must be stateless.', 'All third-party secrets (e.g., SendGrid API key) must be managed via Google Secret Manager, not hardcoded.'], 'implementation_patterns': ['Callable Functions for client-invoked RPC-style calls.', 'Event-Triggered Functions for reacting to platform events (e.g., new user creation in Firebase Auth).', 'Scheduled Functions for time-based batch jobs (e.g., daily cleanup).'], 'extraction_reasoning': 'This is the primary architectural layer this repository implements. Its responsibilities directly align with the functions this identity service must provide.'}

## 1.5.0.0 Dependency Interfaces

### 1.5.1.0 Interface Name

#### 1.5.1.1 Interface Name

Data Model Interfaces & Schemas

#### 1.5.1.2 Source Repository

REPO-LIB-CORE-001

#### 1.5.1.3 Method Contracts

- {'method_name': 'N/A (Data Contracts)', 'method_signature': "export interface User { userId: string; tenantId: string; role: 'Admin' | 'Supervisor' | 'Subordinate'; status: 'active' | 'invited' | 'deactivated'; ... }", 'method_purpose': 'Provides standardized, type-safe data structures for all core domain entities like User, Tenant, and AuditLog.', 'integration_context': 'Consumed at build-time via TypeScript imports in all service files that handle domain objects, ensuring data consistency across the backend.'}

#### 1.5.1.4 Integration Pattern

Library Import

#### 1.5.1.5 Communication Protocol

TypeScript Module Import

#### 1.5.1.6 Extraction Reasoning

This service is the primary owner of the User and Tenant lifecycles. It has a critical build-time dependency on `core-domain-models` to ensure all data it creates and manages conforms to the system's single source of truth for data contracts.

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

(message: string, error: Error, context?: object): void

###### 1.5.2.3.1.3 Method Purpose

Provides a standardized mechanism for structured error logging, compliant with Google Cloud's Operations Suite.

###### 1.5.2.3.1.4 Integration Context

Used in all `catch` blocks within the service's Cloud Functions to ensure uniform error reporting for monitoring and alerting (REQ-1-076).

##### 1.5.2.3.2.0 Method Name

###### 1.5.2.3.2.1 Method Name

ISecretManagerClient.getSecret

###### 1.5.2.3.2.2 Method Signature

(secretName: string): Promise<string>

###### 1.5.2.3.2.3 Method Purpose

Provides a secure and cached method for retrieving secrets, such as the SendGrid API key, from Google Secret Manager.

###### 1.5.2.3.2.4 Integration Context

Called during initialization of the SendGrid client to fetch the required API key, fulfilling REQ-1-065.

##### 1.5.2.3.3.0 Method Name

###### 1.5.2.3.3.1 Method Name

IContextUtils.getContext

###### 1.5.2.3.3.2 Method Signature

(context: CallableContext): { userId: string, tenantId: string, role: string }

###### 1.5.2.3.3.3 Method Purpose

Provides a standardized way to parse and validate the authentication context from a callable function request, ensuring the caller's identity and permissions are reliably extracted.

###### 1.5.2.3.3.4 Integration Context

Called at the beginning of every secure callable function to authorize the request based on the user's role and tenant.

#### 1.5.2.4.0.0 Integration Pattern

Library Import

#### 1.5.2.5.0.0 Communication Protocol

TypeScript Module Import

#### 1.5.2.6.0.0 Extraction Reasoning

As a backend service, this repository must depend on the shared utilities library for cross-cutting concerns like logging, secret management, and security context handling to maintain consistency and adhere to architectural standards.

### 1.5.3.0.0.0 Interface Name

#### 1.5.3.1.0.0 Interface Name

SendGrid API

#### 1.5.3.2.0.0 Source Repository

SendGrid

#### 1.5.3.3.0.0 Method Contracts

- {'method_name': 'sgMail.send', 'method_signature': '(msg: MailDataRequired): Promise<[ClientResponse, {}]>', 'method_purpose': 'Sends a transactional email, such as a user invitation.', 'integration_context': "Called by the User Invitation Function (REQ-1-036) after creating an 'invited' user record in Firestore."}

#### 1.5.3.4.0.0 Integration Pattern

Third-Party API Integration

#### 1.5.3.5.0.0 Communication Protocol

HTTPS/REST API

#### 1.5.3.6.0.0 Extraction Reasoning

The service is explicitly required (REQ-1-011, REQ-1-036) to send user invitation emails, and SendGrid is the specified third-party provider for this functionality.

## 1.6.0.0.0.0 Exposed Interfaces

### 1.6.1.0.0.0 Interface Name

#### 1.6.1.1.0.0 Interface Name

IdentityCallableAPI

#### 1.6.1.2.0.0 Consumer Repositories

- REPO-APP-ADMIN-011
- REPO-APP-MOBILE-010

#### 1.6.1.3.0.0 Method Contracts

##### 1.6.1.3.1.0 Method Name

###### 1.6.1.3.1.1 Method Name

registerOrganization

###### 1.6.1.3.1.2 Method Signature

(data: { orgName: string; adminName: string; email: string; password: string; region: string }) => Promise<{ success: boolean }>

###### 1.6.1.3.1.3 Method Purpose

Handles the creation of a new tenant and its initial Admin user. This is a public, unauthenticated endpoint.

###### 1.6.1.3.1.4 Implementation Requirements

- Must perform atomic creation of Auth user, Firestore user, and Tenant document.
- Must set custom claims on the new Admin user.
- Must be protected by Firebase App Check to prevent abuse.

##### 1.6.1.3.2.0 Method Name

###### 1.6.1.3.2.1 Method Name

inviteUser

###### 1.6.1.3.2.2 Method Signature

(data: { email: string; role: 'Supervisor' | 'Subordinate' }, context: CallableContext) => Promise<{ success: boolean }>

###### 1.6.1.3.2.3 Method Purpose

Allows an authenticated Admin to invite a new user to their tenant by sending an email with a registration link.

###### 1.6.1.3.2.4 Implementation Requirements

- Must validate the caller is an Admin of the correct tenant before executing.
- Must generate a secure, time-limited registration token.

##### 1.6.1.3.3.0 Method Name

###### 1.6.1.3.3.1 Method Name

completeRegistration

###### 1.6.1.3.3.2 Method Signature

(data: { token: string; password: string } ) => Promise<{ success: boolean }>

###### 1.6.1.3.3.3 Method Purpose

Allows an invited user to activate their account by providing a valid token and setting their password.

###### 1.6.1.3.3.4 Implementation Requirements

- Must validate the token is valid, unexpired, and single-use.
- Must set the user's password and update their status from 'invited' to 'active'.
- Must set final custom claims for the user.

##### 1.6.1.3.4.0 Method Name

###### 1.6.1.3.4.1 Method Name

deactivateUser

###### 1.6.1.3.4.2 Method Signature

(data: { userId: string }, context: CallableContext) => Promise<{ success: boolean; error?: string }>

###### 1.6.1.3.4.3 Method Purpose

Allows an Admin to deactivate a user's account. Includes logic to prevent deactivating supervisors with active subordinates (REQ-1-029).

###### 1.6.1.3.4.4 Implementation Requirements

- Must check for active subordinates before changing the user's status.
- Must revoke the user's refresh tokens for immediate session invalidation.

##### 1.6.1.3.5.0 Method Name

###### 1.6.1.3.5.1 Method Name

updateUserSupervisor

###### 1.6.1.3.5.2 Method Signature

(data: { userId: string, newSupervisorId: string | null }, context: CallableContext) => Promise<{ success: boolean }>

###### 1.6.1.3.5.3 Method Purpose

Allows an Admin to change a user's supervisor, enforcing the circular dependency check (REQ-1-026).

###### 1.6.1.3.5.4 Implementation Requirements

- Must validate the caller is an Admin.
- Must traverse the user hierarchy to detect and prevent loops before committing the change.

##### 1.6.1.3.6.0 Method Name

###### 1.6.1.3.6.1 Method Name

requestTenantDeletion

###### 1.6.1.3.6.2 Method Signature

(data: { passwordConfirmation: string }, context: CallableContext) => Promise<{ success: boolean }>

###### 1.6.1.3.6.3 Method Purpose

Allows a tenant Admin to initiate the 30-day grace period for permanent tenant data deletion after re-authenticating.

###### 1.6.1.3.6.4 Implementation Requirements

- Must validate the caller is an Admin and has re-authenticated.
- Must update the tenant's status to 'pending_deletion'.

#### 1.6.1.4.0.0 Service Level Requirements

- p95 latency < 500ms for all functions (REQ-1-067)
- Availability > 99.9% (REQ-1-070)

#### 1.6.1.5.0.0 Implementation Constraints

- All functions must validate the caller's authentication context and custom claims (role, tenantId), except for public endpoints like `registerOrganization`.
- All functions must use the shared error handler from REPO-LIB-BACKEND-002 for consistent error responses.

#### 1.6.1.6.0.0 Extraction Reasoning

This interface represents the primary API surface for the client applications (web and mobile) to interact with the identity service for managing users and tenants, as defined in the repository's responsibilities and derived from multiple user stories and requirements.

### 1.6.2.0.0.0 Interface Name

#### 1.6.2.1.0.0 Interface Name

FirebaseAuthTriggers

#### 1.6.2.2.0.0 Consumer Repositories

- Firebase Authentication

#### 1.6.2.3.0.0 Method Contracts

##### 1.6.2.3.1.0 Method Name

###### 1.6.2.3.1.1 Method Name

beforeCreate

###### 1.6.2.3.1.2 Method Signature

(user: UserRecord, context: EventContext) => Promise<void>

###### 1.6.2.3.1.3 Method Purpose

A blocking function that runs before a new user is saved to Firebase Auth. It enforces the tenant-specific or default password policy (REQ-1-031).

###### 1.6.2.3.1.4 Implementation Requirements

- Must fetch the tenant's configuration to get the password policy.
- Must throw an error if the provided password does not meet the policy, which blocks user creation.

##### 1.6.2.3.2.0 Method Name

###### 1.6.2.3.2.1 Method Name

beforeSignIn

###### 1.6.2.3.2.2 Method Signature

(user: UserRecord, context: EventContext) => Promise<void>

###### 1.6.2.3.2.3 Method Purpose

A blocking function that runs before a user is issued an ID token. It checks the user's status in Firestore and throws an error if the status is 'deactivated' or 'invited', preventing them from logging in (REQ-1-037).

###### 1.6.2.3.2.4 Implementation Requirements

- Must perform a fast lookup to the user's document in Firestore to check the `status` field.
- Throws an error to block sign-in for inactive users.

#### 1.6.2.4.0.0 Service Level Requirements

- Execution must be very fast (<200ms) to avoid adding noticeable latency to the login and registration process.

#### 1.6.2.5.0.0 Implementation Constraints

*No items available*

#### 1.6.2.6.0.0 Extraction Reasoning

This interface represents the event-driven integration with the underlying Firebase platform, which is critical for implementing the security model (enforcing password policy) and access control (blocking deactivated users).

### 1.6.3.0.0.0 Interface Name

#### 1.6.3.1.0.0 Interface Name

ScheduledMaintenanceAPI

#### 1.6.3.2.0.0 Consumer Repositories

- Google Cloud Scheduler

#### 1.6.3.3.0.0 Method Contracts

##### 1.6.3.3.1.0 Method Name

###### 1.6.3.3.1.1 Method Name

processTenantDeletions

###### 1.6.3.3.1.2 Method Signature

(context: EventContext) => Promise<void>

###### 1.6.3.3.1.3 Method Purpose

Executes daily to find and permanently delete all data for tenants whose 30-day grace period has expired (REQ-1-035).

###### 1.6.3.3.1.4 Implementation Requirements

- Must be idempotent.
- Must perform a cascading delete of all tenant data across all collections.
- Must use batching to handle large tenants without timing out.

##### 1.6.3.3.2.0 Method Name

###### 1.6.3.3.2.1 Method Name

anonymizeDeactivatedUsers

###### 1.6.3.3.2.2 Method Signature

(context: EventContext) => Promise<void>

###### 1.6.3.3.2.3 Method Purpose

Executes daily to find deactivated users past their retention period and anonymize their PII (REQ-1-074).

###### 1.6.3.3.2.4 Implementation Requirements

- Must be idempotent.
- Must query across all tenants to find eligible users.
- Must remove PII from the user document while preserving historical record integrity, resolving the conflict with REQ-1-028.

#### 1.6.3.4.0.0 Service Level Requirements

- Functions must complete execution within the maximum Cloud Function timeout (e.g., 540 seconds).

#### 1.6.3.5.0.0 Implementation Constraints

- Functions must be triggered via Pub/Sub messages from Cloud Scheduler.

#### 1.6.3.6.0.0 Extraction Reasoning

This interface defines the asynchronous, time-based jobs owned by this service, which are essential for data lifecycle management and compliance.

## 1.7.0.0.0.0 Technology Context

### 1.7.1.0.0.0 Framework Requirements

The service must be implemented as a set of serverless functions using Firebase Cloud Functions with TypeScript.

### 1.7.2.0.0.0 Integration Technologies

- Firebase Authentication
- Firestore
- SendGrid
- Google Cloud Scheduler

### 1.7.3.0.0.0 Performance Constraints

Functions involved in the user login/registration flow must have low latency to ensure a good user experience. Batch jobs must be designed to handle large datasets without timing out.

### 1.7.4.0.0.0 Security Requirements

This is a high-security service. All callable functions must perform rigorous validation of the caller's identity and role via custom claims. Input sanitization is mandatory. All secrets must be stored in Google Secret Manager.

## 1.8.0.0.0.0 Extraction Validation

| Property | Value |
|----------|-------|
| Mapping Completeness Check | The extracted context covers all explicitly mentio... |
| Cross Reference Validation | All extracted requirements are correctly mapped to... |
| Implementation Readiness Assessment | The context is highly implementation-ready. It spe... |
| Quality Assurance Confirmation | The analysis was performed systematically, cross-r... |

