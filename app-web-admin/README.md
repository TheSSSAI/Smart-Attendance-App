# Attendance App - Admin Web Dashboard

This repository contains the Flutter for Web application that serves as the administrative dashboard for the Attendance Tracking System. It is designed exclusively for the 'Admin' user role.

## Overview

This application provides a comprehensive interface for:
- **Tenant Management**: Configure organization-wide settings like timezone, password policies, and data retention.
- **User & Team Management**: Invite, deactivate, and manage all users and teams within the organization.
- **Reporting**: View detailed, filterable reports on attendance, exceptions, and system audits.
- **Integrations**: Manage connections to third-party services like Google Sheets.

This project is part of a larger micro-frontend and microservices architecture. It consumes shared libraries for data access and UI components and communicates with a secure Firebase backend for business logic.

## Prerequisites

- **Flutter SDK**: Version 3.3.0 or higher.
- **Firebase CLI**: Version 11.0.0 or higher.
- **Node.js & npm**: For running backend functions locally via the Firebase Emulator Suite.
- **Access to Firebase Projects**: You will need access to the development, staging, and production Firebase projects.

## Getting Started

### 1. Clone the Repository

```bash
git clone <repository-url>
cd app-web-admin
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Environment Configuration

This project uses `.env` files to manage environment-specific configurations (e.g., Firebase project settings). These files are not checked into version control and must be created manually.

**a. Create Environment Files:**
Create the following files in the `env/` directory:
- `env/.env.dev`
- `env/.env.staging`
- `env/.env.prod`

**b. Populate Environment Files:**
Copy the Firebase web configuration for each respective project into the corresponding `.env` file. The format should be:

```
# Development Environment - env/.env.dev
FIREBASE_API_KEY=AIza...
FIREBASE_AUTH_DOMAIN=attendance-app-dev.firebaseapp.com
FIREBASE_PROJECT_ID=attendance-app-dev
FIREBASE_STORAGE_BUCKET=attendance-app-dev.appspot.com
FIREBASE_MESSAGING_SENDER_ID=...
FIREBASE_APP_ID=1:...:web:...
FIREBASE_MEASUREMENT_ID=G-...
```

### 4. Running the Application

This project uses VS Code's `launch.json` configurations to run the app against different environments.

1.  Open the project in Visual Studio Code.
2.  Go to the "Run and Debug" panel (Ctrl+Shift+D).
3.  Select one of the following launch configurations from the dropdown:
    - **Run Dev (Chrome)**: Runs the app against the development backend.
    - **Run Staging (Chrome)**: Runs the app against the staging backend.
    - **Run Prod (Chrome)**: Runs the app against the production backend.
4.  Press F5 or click the green "Start Debugging" arrow.

### 5. Running with Firebase Emulators

For local development without connecting to live backends:

1.  **Start the Emulators**:
    ```bash
    firebase emulators:start
    ```
2.  **Run the App**: Use the "Run Dev (Chrome)" configuration. The application is configured to automatically detect and connect to running emulators when built in debug mode.

## Building for Deployment

Flutter for Web builds a set of static files that can be deployed to any web server. We use Firebase Hosting.

### Build a Specific Environment

The build command uses `--dart-define-from-file` to inject the correct environment variables.

- **Build for Staging:**
  ```bash
  flutter build web --dart-define-from-file=env/.env.staging
  ```
- **Build for Production:**
  ```bash
  flutter build web --dart-define-from-file=env/.env.prod
  ```

The output will be in the `build/web` directory.

## Deployment

Deployment is handled automatically by the CI/CD pipeline defined in `.github/workflows/ci.yml`.

- **Staging**: A push to the `develop` branch will trigger a deployment to the staging environment.
- **Production**: A push to the `main` branch will trigger a deployment to the production environment.

### Manual Deployment

To deploy manually, use the Firebase CLI:

1.  Select the target project: `firebase use <staging|prod>`
2.  Deploy: `firebase deploy --only hosting`

## Testing

- **Run Unit and Widget Tests**:
  ```bash
  flutter test
  ```
- **Run Integration Tests**:
  ```bash
  flutter test integration_test
  ```

## Code Generation

This project uses `build_runner` for code generation (e.g., for `freezed` and `riverpod_generator`). If you make changes to models or providers that require code generation, run the following command:

```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```