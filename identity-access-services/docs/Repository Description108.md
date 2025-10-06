# 1 Id

REPO-SVC-IDENTITY-003

# 2 Name

identity-access-services

# 3 Description

A domain-specific microservice repository responsible for the 'Identity and Access Management' bounded context. Decomposed from 'attendance-app-backend', this service handles all aspects of the user lifecycle, tenancy, and role-based access control. Its responsibilities include new tenant creation, user invitation workflows (integrating with SendGrid), user registration completion, managing user status (active/deactivated), and setting Firebase Auth custom claims which are the foundation of the system's security model. It also contains the logic for tenant offboarding and user data anonymization. This separation isolates the critical security and identity concerns of the application into a focused, independently deployable unit.

# 4 Type

🔹 Application Services

# 5 Namespace

com.attendance-app.services.identity

# 6 Output Path

services/identity-access

# 7 Framework

Firebase Cloud Functions

# 8 Language

TypeScript

# 9 Technology

Firebase Auth, Firestore, Cloud Functions

# 10 Thirdparty Libraries

- @sendgrid/mail

# 11 Layer Ids

- application-services-layer

# 12 Dependencies

- REPO-LIB-CORE-001
- REPO-LIB-BACKEND-002

# 13 Requirements

## 13.1 Requirement Id

### 13.1.1 Requirement Id

REQ-FUN-001

## 13.2.0 Requirement Id

### 13.2.1 Requirement Id

REQ-FUN-002

## 13.3.0 Requirement Id

### 13.3.1 Requirement Id

REQ-FUN-003

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

- REQ-FUN-001
- REQ-FUN-002
- REQ-FUN-003
- REQ-1-034

# 20.0.0 Decomposition Rationale

## 20.1.0 Operation Type

NEW_DECOMPOSED

## 20.2.0 Source Repository

REPO-BACKEND-002

## 20.3.0 Decomposition Reasoning

Separated based on the 'Identity & Access Management' bounded context. This isolates highly sensitive logic related to authentication, authorization, and tenancy, allowing for focused security reviews and independent deployment of identity-related features.

## 20.4.0 Extracted Responsibilities

- Tenant creation and offboarding.
- User invitation and registration workflow.
- RBAC management via Firebase Auth custom claims.
- User status management (activation/deactivation).

## 20.5.0 Reusability Scope

- This service is specific to this application's domain.

## 20.6.0 Development Benefits

- Enables a dedicated team to own and secure the identity lifecycle.
- Reduces the risk of accidentally introducing security vulnerabilities when changing other parts of the application.

# 21.0.0 Dependency Contracts

## 21.1.0 Repo-Lib-Core-001

### 21.1.1 Required Interfaces

#### 21.1.1.1 Interface

##### 21.1.1.1.1 Interface

IUser

##### 21.1.1.1.2 Methods

*No items available*

##### 21.1.1.1.3 Events

*No items available*

##### 21.1.1.1.4 Properties

*No items available*

#### 21.1.1.2.0 Interface

##### 21.1.1.2.1 Interface

ITenant

##### 21.1.1.2.2 Methods

*No items available*

##### 21.1.1.2.3 Events

*No items available*

##### 21.1.1.2.4 Properties

*No items available*

### 21.1.2.0.0 Integration Pattern

Library Import

### 21.1.3.0.0 Communication Protocol

N/A

# 22.0.0.0.0 Exposed Contracts

## 22.1.0.0.0 Public Interfaces

### 22.1.1.0.0 Interface

#### 22.1.1.1.0 Interface

Callable Functions

#### 22.1.1.2.0 Methods

- inviteUser(email, role)
- requestTenantDeletion()

#### 22.1.1.3.0 Events

*No items available*

#### 22.1.1.4.0 Properties

*No items available*

#### 22.1.1.5.0 Consumers

- REPO-APP-ADMIN-011

### 22.1.2.0.0 Interface

#### 22.1.2.1.0 Interface

Event Handlers

#### 22.1.2.2.0 Methods

- onUserCreate(userRecord)

#### 22.1.2.3.0 Events

*No items available*

#### 22.1.2.4.0 Properties

*No items available*

#### 22.1.2.5.0 Consumers

- Firebase Authentication

# 23.0.0.0.0 Integration Patterns

| Property | Value |
|----------|-------|
| Dependency Injection | N/A (Functional approach) |
| Event Communication | Listens to Firebase Auth `onCreate` events. |
| Data Flow | Writes to User and Tenant collections in Firestore... |
| Error Handling | Uses shared error handler from REPO-LIB-BACKEND-00... |
| Async Patterns | Promise-based async/await for all operations. |

# 24.0.0.0.0 Technology Guidance

| Property | Value |
|----------|-------|
| Framework Specific | Leverage Firebase Auth triggers for reacting to us... |
| Performance Considerations | User creation functions must be fast to not delay ... |
| Security Considerations | This is a high-security component. All inputs must... |
| Testing Approach | Integration testing with the Firebase Local Emulat... |

# 25.0.0.0.0 Scope Boundaries

## 25.1.0.0.0 Must Implement

- All logic related to user accounts, roles, and tenants.

## 25.2.0.0.0 Must Not Implement

- Attendance tracking logic.
- Reporting or event management.

## 25.3.0.0.0 Extension Points

- Can be extended to support new authentication providers.

## 25.4.0.0.0 Validation Rules

- Validate uniqueness of tenant names.
- Enforce password policies.

