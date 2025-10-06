# 1 Style

Serverless

# 2 Patterns

## 2.1 Multi-Tenancy

### 2.1.1 Name

Multi-Tenancy

### 2.1.2 Description

A single instance of the application serves multiple customer organizations (tenants) while ensuring logical data isolation. Data segregation is enforced at the database level using tenant-specific identifiers and security rules. (REQ-1-002, REQ-1-021, REQ-1-064)

### 2.1.3 Benefits

- Cost-effective infrastructure by sharing resources among tenants.
- Simplified maintenance and centralized updates for all tenants.
- Rapid onboarding of new customer organizations.

### 2.1.4 Tradeoffs

- Increased complexity in data access logic and security rules to ensure strict tenant isolation.
- Potential for 'noisy neighbor' performance issues if not properly architected.
- Customizations per tenant are more difficult to implement.

### 2.1.5 Applicability

#### 2.1.5.1 Scenarios

- SaaS applications serving multiple distinct organizations.
- Systems where cost efficiency through shared resources is a primary goal.

#### 2.1.5.2 Constraints

- Requires a database and security model that can enforce strict data boundaries, like Firestore Security Rules with custom claims.

## 2.2.0.0 Clean Architecture

### 2.2.1.0 Name

Clean Architecture

### 2.2.2.0 Description

A client-side architecture for the Flutter application that separates concerns into distinct layers (Presentation, Domain, Data) with a strict dependency rule: inner layers are independent of outer layers. (REQ-1-072)

### 2.2.3.0 Benefits

- High testability of business logic, independent of UI and frameworks.
- Improved maintainability and flexibility to change external components like databases or UI frameworks.
- Clear separation of concerns, making the codebase easier to understand and navigate.

### 2.2.4.0 Tradeoffs

- Can introduce boilerplate code for data mapping between layers.
- May have a steeper learning curve for developers unfamiliar with the pattern.

### 2.2.5.0 Applicability

#### 2.2.5.1 Scenarios

- Complex mobile or web applications with significant business logic.
- Long-term projects where maintainability and testability are high priorities.

#### 2.2.5.2 Constraints

- Requires disciplined adherence to the dependency rule throughout the development process.

## 2.3.0.0 Infrastructure as Code (IaC)

### 2.3.1.0 Name

Infrastructure as Code (IaC)

### 2.3.2.0 Description

Managing and provisioning all backend configurations (Firestore rules, indexes, Cloud Functions) through declarative code files stored in a version control repository. (REQ-1-072)

### 2.3.3.0 Benefits

- Automated, repeatable, and consistent environment deployments.
- Version control for all infrastructure, enabling audit trails and rollbacks.
- Reduced risk of manual configuration errors.

### 2.3.4.0 Tradeoffs

- Requires initial investment in setting up tooling and pipelines (e.g., Firebase CLI, GitHub Actions).
- Can add complexity for simple projects.

### 2.3.5.0 Applicability

#### 2.3.5.1 Scenarios

- Managing multiple environments (Dev, Staging, Prod) as required by REQ-1-020.
- Projects requiring auditable and reproducible infrastructure changes.

#### 2.3.5.2 Constraints

- Dependent on the capabilities of the platform's command-line tools and deployment APIs.

## 2.4.0.0 Repository Pattern

### 2.4.1.0 Name

Repository Pattern

### 2.4.2.0 Description

A data access pattern used within the client's Data layer to abstract the data source. It mediates between the domain and data mapping layers, acting like an in-memory collection of domain objects.

### 2.4.3.0 Benefits

- Decouples business logic from data access technology (e.g., Firestore, local cache).
- Centralizes data access logic, making it easier to manage and test.
- Supports offline capabilities by allowing the repository to switch between remote and local data sources.

### 2.4.4.0 Tradeoffs

- Can add a layer of abstraction that may not be necessary for very simple CRUD applications.

### 2.4.5.0 Applicability

#### 2.4.5.1 Scenarios

- Applications that need to support both online (Firestore) and offline (local cache) data access (REQ-1-009).
- Implementing the Data Layer within a Clean Architecture structure.

#### 2.4.5.2 Constraints

*No items available*

# 3.0.0.0 Layers

## 3.1.0.0 Presentation Layer (Flutter Clients)

### 3.1.1.0 Id

presentation-layer

### 3.1.2.0 Name

Presentation Layer (Flutter Clients)

### 3.1.3.0 Description

The user-facing part of the system, comprising a cross-platform mobile app and a web-based admin dashboard. It is responsible for rendering the UI and capturing user input.

### 3.1.4.0 Technologystack

Flutter 3.x, Flutter for Web, Riverpod 2.x (State Management), Google Maps SDK, Material Design 3 / Cupertino

### 3.1.5.0 Language

Dart

### 3.1.6.0 Type

🔹 Presentation

### 3.1.7.0 Responsibilities

- Render user interfaces for Mobile (iOS/Android) and Web platforms (REQ-1-001, REQ-1-010).
- Manage UI state and user interactions.
- Handle user authentication flows (Login, Forgot Password) (REQ-1-039, REQ-1-040).
- Capture user input for attendance (Check-in/Check-out), correction requests, event creation, etc. (REQ-1-004, REQ-1-006).
- Display data such as attendance history, events, and reports. (REQ-1-015, REQ-1-017, REQ-1-019).
- Handle device-specific features like GPS location capture and push notifications (FCM) (REQ-1-004, REQ-1-056).
- Implement offline data caching and synchronization UI notifications (REQ-1-009, REQ-1-043).

### 3.1.8.0 Components

- Mobile Application (iOS & Android)
- Web Administrative Dashboard

### 3.1.9.0 Interfaces

*No items available*

### 3.1.10.0 Dependencies

#### 3.1.10.1 Required

##### 3.1.10.1.1 Layer Id

application-services-layer

##### 3.1.10.1.2 Type

🔹 Required

#### 3.1.10.2.0 Required

##### 3.1.10.2.1 Layer Id

data-persistence-layer

##### 3.1.10.2.2 Type

🔹 Required

### 3.1.11.0.0 Constraints

*No items available*

## 3.2.0.0.0 Application Services (Firebase Cloud Functions)

### 3.2.1.0.0 Id

application-services-layer

### 3.2.2.0.0 Name

Application Services (Firebase Cloud Functions)

### 3.2.3.0.0 Description

The serverless backend logic that executes in response to events or direct HTTP calls. This layer contains all custom business logic that cannot be handled by declarative rules or on the client.

### 3.2.4.0.0 Technologystack

Firebase Cloud Functions, Google Cloud Scheduler

### 3.2.5.0.0 Language

TypeScript

### 3.2.6.0.0 Type

🔹 ApplicationServices

### 3.2.7.0.0 Responsibilities

- Execute complex, trusted business logic (e.g., validating and preventing circular reporting hierarchies - REQ-1-022).
- Perform scheduled tasks like automated check-outs, approval escalations, data retention/anonymization, and automated Google Sheets exports (REQ-1-045, REQ-1-051, REQ-1-074, REQ-1-059).
- Integrate with third-party services like SendGrid for sending invitation emails and Google Sheets API for data export (REQ-1-036, REQ-1-008).
- Set custom claims (tenantId, role) on Firebase Auth users upon creation or role change (REQ-1-029).
- Handle data aggregation for complex reports (REQ-1-057).
- Trigger push notifications via FCM for events like new event assignments (REQ-1-056).
- Process data migration from uploaded CSV files (REQ-1-077).

### 3.2.8.0.0 Components

- Auth Triggers (onUserCreate)
- Firestore Triggers (onWrite, onCreate)
- Scheduled Functions (Pub/Sub)
- Callable Functions (HTTP endpoint)

### 3.2.9.0.0 Interfaces

*No items available*

### 3.2.10.0.0 Dependencies

#### 3.2.10.1.0 Required

##### 3.2.10.1.1 Layer Id

data-persistence-layer

##### 3.2.10.1.2 Type

🔹 Required

#### 3.2.10.2.0 Required

##### 3.2.10.2.1 Layer Id

security-layer

##### 3.2.10.2.2 Type

🔹 Required

#### 3.2.10.3.0 Required

##### 3.2.10.3.1 Layer Id

integration-layer

##### 3.2.10.3.2 Type

🔹 Required

### 3.2.11.0.0 Constraints

*No items available*

## 3.3.0.0.0 Data & Persistence Layer (Firebase/GCP)

### 3.3.1.0.0 Id

data-persistence-layer

### 3.3.2.0.0 Name

Data & Persistence Layer (Firebase/GCP)

### 3.3.3.0.0 Description

The managed backend services responsible for data storage, user identity, and file storage. This forms the foundation of the serverless architecture.

### 3.3.4.0.0 Technologystack

Firestore, Firebase Authentication, Google Cloud Storage (for backups)

### 3.3.5.0.0 Language

N/A

### 3.3.6.0.0 Type

🔹 DataAccess

### 3.3.7.0.0 Responsibilities

- Provide a scalable, multi-tenant NoSQL database for all application data (REQ-1-013, REQ-1-069).
- Manage user identities, authentication providers (Email/Password, OTP), and sessions (REQ-1-039).
- Store data in specific geographic regions to meet data residency requirements (REQ-1-024).
- Store backups of the Firestore database (REQ-1-071).

### 3.3.8.0.0 Components

- Firestore Database
- Firebase Authentication Service
- Google Cloud Storage

### 3.3.9.0.0 Interfaces

*No items available*

### 3.3.10.0.0 Dependencies

*No items available*

### 3.3.11.0.0 Constraints

*No items available*

## 3.4.0.0.0 Security Layer

### 3.4.1.0.0 Id

security-layer

### 3.4.2.0.0 Name

Security Layer

### 3.4.3.0.0 Description

A conceptual layer that enforces security policies across the entire system, from client authentication to fine-grained data access control.

### 3.4.4.0.0 Technologystack

Firestore Security Rules, Firebase Auth Custom Claims, Google Secret Manager, IAM

### 3.4.5.0.0 Language

N/A

### 3.4.6.0.0 Type

🔹 Security

### 3.4.7.0.0 Responsibilities

- Enforce strict multi-tenant data isolation using `tenantId` custom claims in Firestore Security Rules (REQ-1-021, REQ-1-064).
- Implement Role-Based Access Control (RBAC) to restrict data access based on user roles ('Admin', 'Supervisor', 'Subordinate') (REQ-1-003, REQ-1-068).
- Ensure immutability of the audit log collection via restrictive Firestore Security Rules (REQ-1-028).
- Securely store and manage all third-party API keys and secrets (REQ-1-065).
- Encrypt all data in transit using HTTPS/TLS (REQ-1-062).
- Manage permissions for Cloud Functions to access other GCP services.

### 3.4.8.0.0 Components

- Firestore Security Ruleset (`firestore.rules`)
- Firebase Auth JWTs with Custom Claims
- Google Secret Manager
- GCP IAM Policies

### 3.4.9.0.0 Interfaces

*No items available*

### 3.4.10.0.0 Dependencies

#### 3.4.10.1.0 Required

##### 3.4.10.1.1 Layer Id

data-persistence-layer

##### 3.4.10.1.2 Type

🔹 Required

#### 3.4.10.2.0 Required

##### 3.4.10.2.1 Layer Id

application-services-layer

##### 3.4.10.2.2 Type

🔹 Required

### 3.4.11.0.0 Constraints

*No items available*

## 3.5.0.0.0 External Services Integration Layer

### 3.5.1.0.0 Id

integration-layer

### 3.5.2.0.0 Name

External Services Integration Layer

### 3.5.3.0.0 Description

Provides connectivity to all specified third-party APIs, abstracting their specific implementations from the core application logic.

### 3.5.4.0.0 Technologystack

Google Maps API, Google Sheets API, SendGrid API, Payment Gateway API

### 3.5.5.0.0 Language

TypeScript, Dart

### 3.5.6.0.0 Type

🔹 Integration

### 3.5.7.0.0 Responsibilities

- Integrate with Google Maps API for location visualization on the client (REQ-1-014).
- Integrate with Google Sheets API for programmatic, automated data export from the backend (REQ-1-014).
- Integrate with SendGrid for sending transactional emails (e.g., user invitations) from the backend (REQ-1-011).
- Integrate with a payment gateway to manage subscriptions for paid tiers (REQ-1-001).

### 3.5.8.0.0 Components

- Google Sheets API Client (in Cloud Functions)
- SendGrid API Client (in Cloud Functions)
- Google Maps SDK (in Flutter Client)
- Payment Gateway Client/SDK

### 3.5.9.0.0 Interfaces

*No items available*

### 3.5.10.0.0 Dependencies

*No items available*

### 3.5.11.0.0 Constraints

*No items available*

## 3.6.0.0.0 Operations & Monitoring Layer

### 3.6.1.0.0 Id

operations-layer

### 3.6.2.0.0 Name

Operations & Monitoring Layer

### 3.6.3.0.0 Description

A cross-cutting layer responsible for the operational health of the application, including deployment, monitoring, logging, and disaster recovery.

### 3.6.4.0.0 Technologystack

GitHub Actions (CI/CD), Google Cloud's Operations Suite (Logging, Monitoring), Firebase Crashlytics, GCP Managed Export Service

### 3.6.5.0.0 Language

YAML, N/A

### 3.6.6.0.0 Type

🔹 CrossCutting

### 3.6.7.0.0 Responsibilities

- Automate building, testing, and deploying the Flutter clients and Firebase backend (REQ-1-072).
- Provide centralized logging and monitoring for all Cloud Functions (REQ-1-076).
- Implement automated crash reporting for the mobile client (REQ-1-076).
- Configure alerts for error rates and budget thresholds (REQ-1-076).
- Perform daily automated backups of the Firestore database to meet RPO/RTO targets (REQ-1-071).

### 3.6.8.0.0 Components

- CI/CD Pipelines (GitHub Actions)
- Firebase Crashlytics SDK
- Google Cloud Logging & Monitoring
- Automated Backup Configuration

### 3.6.9.0.0 Interfaces

*No items available*

### 3.6.10.0.0 Dependencies

*No items available*

### 3.6.11.0.0 Constraints

*No items available*

