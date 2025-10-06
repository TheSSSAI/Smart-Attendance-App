# Attendance Management System - Enterprise Architecture Documentation

## Executive Summary

This document outlines the enterprise architecture for the Attendance Management System, a multi-tenant, cloud-native SaaS application designed for organizations with hierarchical structures. The solution is a mobile-first, cross-platform application (iOS, Android, Web) built on a fully serverless backend, providing GPS-based attendance tracking, approval workflows, and automated reporting capabilities.

**Key Architectural Decisions:**
1.  **Unified Serverless Platform:** The entire system is built upon the Google Firebase/GCP ecosystem. This strategic choice leverages a tightly integrated suite of managed services (Firestore, Cloud Functions, Authentication) to accelerate development, reduce operational overhead, and provide automatic, elastic scalability.
2.  **Microservice-Inspired Backend Decomposition:** The backend logic is decomposed into discrete, domain-aligned services (e.g., Identity, Attendance, Reporting). This strategy promotes team autonomy, enables independent deployment cycles, isolates complex business logic, and enhances system maintainability and resilience.
3.  **Single Codebase with Flutter:** A single Flutter codebase is used for the mobile applications (iOS/Android) and the web-based admin dashboard. This approach maximizes development efficiency, ensures a consistent user experience across platforms, and simplifies feature parity.
4.  **Security-First Design:** A robust security posture is established through a multi-layered approach, with multi-tenancy and Role-Based Access Control (RBAC) enforced at the database level via declarative Firestore Security Rules, which serve as the primary line of defense.

**Business Value:** The architecture delivers a scalable, reliable, and cost-effective solution that can be rapidly developed and iterated upon. It minimizes infrastructure management costs while providing a modern, feature-rich experience for end-users and administrators, catering to a wide range of organizations from small teams to larger enterprises.

## Solution Architecture Overview

The system is designed as a classic serverless, event-driven architecture tightly coupled with the Firebase platform, which acts as a Backend for Frontend (BFF) for the client applications.

*   **Technology Stack:** The frontend is built with **Flutter 3.x** and **Dart**, using **Riverpod** for state management. The backend services are implemented as **Firebase Cloud Functions** using **TypeScript** on a **Node.js 20+** runtime. The primary database is **Firestore**, with **Firebase Authentication** managing user identity.
*   **Architectural Patterns:**
    *   **Serverless:** No servers are managed; all compute and database resources scale on demand.
    *   **Multi-Tenant:** Each organization is an isolated tenant, with data segregation enforced by `tenantId` at the database layer.
    *   **Event-Driven:** Backend services are largely decoupled and react to events, such as data writes in Firestore (`onWrite`) or new user creation in Authentication (`onCreate`).
    *   **Clean Architecture:** The Flutter client applications follow Clean Architecture principles, separating UI, application logic, and data access layers.
*   **Integration Approach:** Third-party integrations are intentionally limited to maintain a streamlined architecture. The system integrates with:
    *   **Google Services:** Google Maps API for location visualization and Google Sheets API for automated data export.
    *   **SendGrid:** For delivering transactional emails (e.g., user invitations).
*   **Environments:** The system operates across three distinct, isolated Firebase projects to ensure a stable release process: **Development**, **Staging/UAT**, and **Production**.

## Repository Architecture Strategy

The project's repository structure evolved from a simple two-repository monolith (client, backend) to a granular, 11-repository structure to support scalability, team autonomy, and long-term maintainability.

*   **Decomposition Rationale:** The decomposition was driven by principles of Domain-Driven Design (DDD) and separation of concerns. The backend was broken down along key business capabilities (Identity, Attendance, Teams, Reporting) into independent microservices. Similarly, the client was split into shared libraries (Data Access, UI) and distinct application shells for mobile and web.
*   **Optimization Benefits:**
    *   **Independent Deployments:** Each backend service and client application can be tested and deployed independently, increasing development velocity and reducing deployment risk.
    *   **Team Autonomy:** Enables smaller, focused teams to take ownership of specific business domains (e.g., a team for Identity & Access).
    *   **Code Reusability:** Cross-cutting concerns (data models, shared utilities, UI components) are extracted into versioned libraries, reducing code duplication and enforcing consistency.
    *   **Improved Maintainability:** Smaller, focused codebases are easier to understand, test, and maintain.
*   **Development Workflow:** Developers can work on a single micro-repository in isolation, using the Firebase Local Emulator Suite to simulate the entire backend environment. Shared libraries are consumed as versioned packages, ensuring stable dependencies.

## System Architecture Diagrams

### Repository Dependency Architecture

This diagram illustrates the final 11-repository structure, grouped by architectural layers, and shows the dependencies between them. The flow of dependencies is unidirectional, from the outer application layers inwards to the core domain models and infrastructure.


### Component Integration Patterns

This diagram shows the runtime interaction between key components for two critical user flows: **User Attendance Check-in** and **Admin User Invitation**.


## Repository Catalog

**Client Repositories**

*   **app-mobile (REPO-APP-MOBILE-010):** The main Flutter application for iOS and Android. Contains the UI, state management, and device-specific integrations for Subordinate and Supervisor roles. Consumes `client-data-access` and `shared-ui-components`.
*   **app-web-admin (REPO-APP-ADMIN-011):** The Flutter for Web application for the Admin dashboard. Contains all UI and state management for administrative features. Consumes `client-data-access` and `shared-ui-components`.

**Shared Client Libraries**

*   **client-data-access (REPO-LIB-CLIENT-008):** Implements the Repository Pattern, abstracting all Firebase data access logic for the client apps. Manages Firestore queries, offline persistence, and data serialization.
*   **shared-ui-components (REPO-LIB-UI-009):** A reusable Flutter widget library containing the application's design system, themes, and common UI components to ensure a consistent look and feel.

**Backend Service Repositories**

*   **identity-access-services (REPO-SVC-IDENTITY-003):** Manages the Identity & Access bounded context, including tenant creation, user invitations, authentication, RBAC via custom claims, and user lifecycle management.
*   **attendance-workflow-services (REPO-SVC-ATTENDANCE-004):** Contains the core business logic for the attendance lifecycle, including validation, supervisor approvals, correction workflows, and scheduled auto-checkouts.
*   **team-event-management-services (REPO-SVC-TEAM-005):** Manages the Team & Schedule bounded context, including CRUD for teams, event creation/assignment, and sending event-related push notifications via FCM.
*   **reporting-export-services (REPO-SVC-REPORTING-006):** Handles asynchronous, data-intensive tasks. Manages the automated data export to Google Sheets and server-side aggregation for reports.

**Shared Backend Libraries**

*   **core-domain-models (REPO-LIB-CORE-001):** The single source of truth for data contracts. Contains TypeScript interfaces and Zod validation schemas for all data entities.
*   **backend-shared-utils (REPO-LIB-BACKEND-002):** A library of cross-cutting concerns for all backend services, including a standardized logger, error handlers, and a secret manager client.

**Infrastructure Repository**

*   **firebase-infrastructure (REPO-INFRA-FIREBASE-007):** Contains all Infrastructure as Code (IaC) definitions, including the critical Firestore Security Rules, database indexes, and other Firebase project configurations.

## Integration Architecture

*   **Client-to-Backend:** The primary integration is via the Firebase SDK, which provides real-time data synchronization with Firestore and handles authentication. For synchronous actions that require trusted server-side logic, the client uses **Firebase Callable Functions**, which act as secure, authenticated RPC endpoints.
*   **Inter-Service Communication:** Backend services are fully decoupled and **do not communicate directly**. They communicate asynchronously through state changes in the shared Firestore database, which trigger event-driven Cloud Functions. For example, the `attendance-workflow-services` reacts to new documents created by the client.
*   **Backend-to-External:** All integrations with third-party services (Google Sheets, SendGrid) are encapsulated within dedicated Cloud Functions, typically in the relevant microservice (e.g., `reporting-export-services`). These integrations use standard REST API calls over HTTPS, with secrets like API keys and OAuth tokens securely retrieved at runtime from **Google Secret Manager**.

## Technology Implementation Framework

*   **Client-Side (Flutter):** Adherence to **Clean Architecture** is mandatory, separating the UI (Widgets), State Management (Riverpod Providers), and Data Access (Repositories) into distinct layers. This promotes testability and separation of concerns.
*   **Backend-Side (TypeScript):**
    *   **Idempotency:** All event-driven functions must be idempotent to handle the at-least-once delivery guarantee of Firebase triggers without causing data corruption.
    *   **Validation:** **Zod** schemas defined in `core-domain-models` must be used to validate all incoming data in Callable Functions and before writing to the database.
    *   **Consistency:** A shared logging utility from `backend-shared-utils` must be used to ensure all logs are structured and include contextual information like `tenantId` and `traceId`.
*   **Infrastructure & Deployment:** All Firebase resources (security rules, indexes) are managed declaratively in the `firebase-infrastructure` repository and deployed via the **Firebase CLI**, enforcing an Infrastructure as Code (IaC) workflow.
*   **Testing:** The **Firebase Local Emulator Suite** is a required tool for all backend development, allowing developers to run a high-fidelity local version of the entire Firebase backend for rapid testing and debugging.

## Performance & Scalability Architecture

*   **Scalability:** The serverless architecture is inherently scalable. Firestore and Cloud Functions automatically scale horizontally to handle variable loads, such as mass check-ins in the morning, without manual intervention.
*   **Performance:**
    *   Client performance is achieved through Flutter's efficient rendering and by leveraging Firestore's real-time data sync and offline persistence, which provides a responsive UI even on slow networks.
    *   Backend performance is governed by NFRs (p95 latency < 500ms for Callable Functions) and is ensured by writing efficient, targeted Firestore queries supported by composite indexes defined in the IaC repository.
*   **Availability & Reliability:** The system targets **99.9% availability**, relying on the underlying SLA of Google Cloud Platform. Reliability is enhanced by automated daily backups of the Firestore database, with a **Recovery Point Objective (RPO) of 24 hours** and a **Recovery Time Objective (RTO) of 4 hours**.

## Development & Deployment Strategy

*   **Development Workflow:** The micro-repository structure allows teams to work on different parts of the system concurrently with minimal friction. Feature branches are used within each repository. Pull requests require automated checks (linting, testing) and peer review before merging.
*   **Deployment Pipeline:** A comprehensive CI/CD pipeline is implemented using **GitHub Actions**. Separate, parallel workflows exist for:
    1.  Publishing shared libraries (e.g., `core-domain-models`) as versioned NPM/Pub packages.
    2.  Deploying backend microservices (Cloud Functions) to the appropriate Firebase environment (Dev, Staging, Prod).
    3.  Deploying infrastructure changes (Firestore Rules, Indexes) from the `firebase-infrastructure` repository.
    4.  Building and deploying the web admin app to Firebase Hosting.
    5.  Building and publishing the mobile app to TestFlight/Google Play Beta and, finally, to the production app stores.

## Architecture Decision Records

*   **ADR-001: Adopt a Fully Serverless Architecture on Firebase/GCP**
    *   **Decision:** To exclusively use the managed, serverless services of the Firebase/GCP platform for all backend components.
    *   **Rationale:** This decision prioritizes development speed, minimizes operational overhead, and provides automatic scalability. The tight integration between client SDKs and backend services (Auth, Firestore) enables core features like real-time data and offline sync with minimal custom code.
*   **ADR-002: Decompose Backend into Domain-Aligned Microservices**
    *   **Decision:** To break the backend monolith into smaller, independently deployable services based on business domains (Identity, Attendance, etc.).
    *   **Rationale:** Improves long-term maintainability, allows teams to specialize and own specific domains, enables independent scaling of services, and reduces the cognitive load of working with the codebase. This aligns with modern cloud-native best practices.
*   **ADR-003: Utilize a Single Flutter Codebase for Mobile and Web**
    *   **Decision:** To use Flutter for building the iOS, Android, and Web applications from one codebase.
    *   **Rationale:** Significantly reduces development time and cost compared to building and maintaining separate native applications. It also ensures a consistent user experience and feature set across all platforms.
*   **ADR-004: Enforce Security via Declarative Firestore Rules**
    *   **Decision:** To make Firestore Security Rules the primary mechanism for enforcing multi-tenancy and role-based access control, rather than relying solely on imperative checks in backend code.
    *   **Rationale:** This declarative, server-side approach provides a powerful and robust security layer that protects data from unauthorized access, even if there is a bug in client or backend logic. Managing these rules as code in a dedicated repository (`firebase-infrastructure`) makes them auditable and version-controllable.