# Attendance Workflow Services

This repository contains the Firebase Cloud Functions for the **Attendance Workflow Services** microservice. It encapsulates the core business logic of the 'Attendance Management' bounded context for the multi-tenant attendance tracking application.

## 🚀 Overview

This service is responsible for all server-side logic related to the lifecycle of an attendance record. It's designed as a stateless, event-driven, serverless application running on the Google Cloud Platform via Firebase.

### Core Responsibilities

-   **Attendance Lifecycle Management**: Processing check-in and check-out events.
-   **Business Rule Enforcement**:
    -   Flagging clock discrepancies between client and server timestamps (REQ-1-044).
    -   Handling the supervisor approval workflow for pending records.
    -   Processing auditable attendance correction requests (REQ-1-053).
-   **Scheduled Jobs**:
    -   Executing a daily, timezone-aware auto-checkout for users who forget to check out (REQ-1-045).
    -   Running a daily approval escalation job for overdue pending records (REQ-1-051).
-   **Auditing**: Creating immutable audit log entries for all significant state changes within its domain.

## 🛠️ Technology Stack

-   **Framework**: Firebase Cloud Functions (v2)
-   **Language**: TypeScript
-   **Runtime**: Node.js 20
-   **Database**: Google Firestore
-   **Scheduling**: Google Cloud Scheduler & Pub/Sub
-   **Authentication**: Firebase Authentication (for validating JWTs)
-   **Testing**: Jest, Firebase Emulator Suite

## 🏛️ Architecture

This service adheres to Clean Architecture principles, adapted for a serverless environment, to ensure high testability and maintainability.

-   **Domain**: Contains core entities and repository interfaces.
-   **Application**: Contains use cases that orchestrate business logic.
-   **Infrastructure**: Implements repository interfaces with Firestore-specific logic.
-   **Presentation**: Defines the function triggers (Callable, Scheduled, Firestore) that act as entry points to the application.

All Infrastructure as Code, including Firestore indexes, is managed within this repository.

## 📦 Prerequisites

-   Node.js (v20 or higher)
-   NPM
-   Firebase CLI (`npm install -g firebase-tools`)

## ⚙️ Setup & Installation

1.  **Clone the repository:**
    ```bash
    git clone <repository_url>
    cd attendance-workflow-services/functions
    ```

2.  **Install dependencies:**
    ```bash
    npm install
    ```

3.  **Set up environment variables:**
    Create a `.env` file inside the `functions` directory by copying the template.
    ```bash
    cp .env.template .env
    ```
    Populate `.env` with the necessary configuration for your local environment. Note: Production secrets are managed via Google Secret Manager (REQ-1-069) and are not stored in `.env` files.

4.  **Connect to a Firebase Project:**
    Use the Firebase CLI to select your project alias.
    ```bash
    firebase use development
    ```

## 📜 Available Scripts

Inside the `functions` directory, you can run the following scripts:

-   `npm run lint`: Lints the TypeScript source code.
-   `npm run build`: Compiles TypeScript to JavaScript.
-   `npm run test`: Runs all unit and integration tests using Jest.
-   `npm run test:watch`: Runs tests in interactive watch mode.
-   `npm run test:cov`: Runs tests and generates a code coverage report.
-   `npm run serve`: Starts the local Firebase Emulator Suite for local development and testing.

## 🧪 Testing

This project adheres to a minimum of 80% code coverage (REQ-1-072). Tests are written with Jest and leverage the Firebase Emulator Suite for a realistic testing environment.

To run tests:
```bash
npm test
```

## 🚀 Deployment

Deployment is managed via the Firebase CLI and is typically handled by a CI/CD pipeline (e.g., GitHub Actions).

To deploy manually:
```bash
firebase deploy --only functions
```
Make sure you have selected the correct project alias (`development`, `staging`, or `production`) before deploying. The predeploy script will automatically lint and build the project.