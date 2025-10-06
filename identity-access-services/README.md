# Identity & Access Service

This repository contains the source code for the **Identity & Access Management** microservice for the Attendance Tracking application. It is a serverless application built using Firebase Cloud Functions and TypeScript.

## Bounded Context

This service is responsible for the "Identity and Access Management" bounded context. Its primary responsibilities are:

-   **Tenant Lifecycle Management**: Handles the creation of new organization tenants and the secure, multi-step offboarding process.
-   **User Lifecycle Management**: Manages the complete user journey from invitation, registration, activation, deactivation, and eventual data anonymization for compliance.
-   **Role-Based Access Control (RBAC)**: Acts as the sole authority for setting Firebase Authentication custom claims (`tenantId`, `role`), which form the cornerstone of the system's security model.
-   **External Integrations**: Integrates with third-party services like SendGrid for transactional emails related to the user lifecycle.

This service is explicitly excluded from handling business logic related to attendance tracking, reporting, or payroll.

## Architecture

The service is built following **Clean Architecture** principles, adapted for a serverless TypeScript environment. This ensures a clear separation of concerns, high testability, and independence from the underlying framework.

The codebase is structured into four distinct layers:

1.  **Domain**: Contains core business entities (as interfaces) and business rules. It has no dependencies on other layers.
2.  **Application**: Contains application-specific business logic and use cases (e.g., `TenantService`, `UserService`). It orchestrates the flow of data between the domain and infrastructure layers.
3.  **Infrastructure**: Contains concrete implementations of the interfaces defined in the domain layer. This includes all external concerns like database access (Firestore), authentication services (Firebase Auth), and email services (SendGrid).
4.  **Presentation**: This is the entry point layer, containing the Firebase Function trigger definitions (HTTP callable, scheduled, auth triggers). It parses incoming requests and calls the appropriate application services.

## API Endpoints / Functions

This service exposes the following functions:

-   **Callable Functions**:
    -   `identity-registerOrganization`: Public endpoint for new tenant creation.
    -   `identity-inviteUser`: Admin-only endpoint to invite new users.
    -   `identity-completeRegistration`: Public endpoint for invited users to set their password.
    -   `identity-deactivateUser`: Admin-only endpoint to deactivate a user.
    -   `identity-updateUserSupervisor`: Admin-only endpoint to change a user's supervisor, with circular dependency checks.
    -   `identity-requestTenantDeletion`: Admin-only endpoint to initiate tenant offboarding.
-   **Auth Triggers**:
    -   `auth-beforeCreate`: Enforces password policies before a user is created.
    -   `auth-beforeSignIn`: Blocks login for inactive users.
-   **Scheduled Functions**:
    -   `maintenance-processTenantDeletions`: Daily job to permanently delete tenant data after the grace period.
    -   `maintenance-anonymizeDeactivatedUsers`: Daily job to anonymize PII for long-deactivated users.

## Project Setup

### Prerequisites

-   Node.js (version specified in `.nvmrc`)
-   `nvm` (Node Version Manager) is recommended.
-   Firebase CLI (`npm install -g firebase-tools`)

### Installation

1.  Switch to the correct Node.js version:
    ```bash
    nvm use
    ```
2.  Navigate to the `functions` directory:
    ```bash
    cd functions
    ```
3.  Install dependencies:
    ```bash
    npm install
    ```

## Local Development

This project is configured to run with the Firebase Local Emulator Suite, which allows for local development and testing of all functions, Firestore, and Auth triggers.

1.  From the root directory of the repository, start the emulators:
    ```bash
    firebase emulators:start --import=./.firebase/emulators.export --only functions,firestore,auth,pubsub
    ```
    -   The `--import` flag loads seed data if available.
    -   The Firebase Emulator UI will be available at `http://localhost:4000`.

2.  To run the TypeScript compiler in watch mode for live reloading:
    ```bash
    npm run build:watch
    ```

## Testing

The project uses **Jest** for unit and integration testing. Tests are located in the `src` directory alongside the code they are testing, with a `.test.ts` extension.

To run all tests:

```bash
npm test
```

To run tests with coverage:

```bash
npm test -- --coverage
```

## Deployment

Deployment is managed via the Firebase CLI and is configured for multiple environments (dev, staging, prod).

1.  **Select Firebase Project**:
    Use the Firebase CLI to switch to the desired project alias.
    ```bash
    firebase use <alias>  # e.g., firebase use dev
    ```

2.  **Deploy Functions**:
    The `package.json` contains scripts for deploying to each environment.
    ```bash
    # Deploy to development
    npm run deploy:dev

    # Deploy to staging
    npm run deploy:staging

    # Deploy to production
    npm run deploy:prod
    ```
    The `predeploy` hooks in `firebase.json` will automatically run `lint` and `build` before deployment.