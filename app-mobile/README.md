# Attendance Tracking Mobile Application (`app_mobile`)

This repository contains the cross-platform mobile application for the Attendance Tracking System, built with Flutter. It is designed for both Android and iOS and serves the 'Subordinate' and 'Supervisor' user roles.

## 🚀 Overview

This application is the primary user-facing client for daily attendance operations. It allows employees (Subordinates) to mark their attendance with GPS verification and provides managers (Supervisors) with the tools to review, approve, and manage their team's attendance records.

### Key Features
-   **GPS-Enabled Attendance**: Securely check-in and check-out with precise location and timestamp data.
-   **Offline First**: Core functions, like attendance marking, work seamlessly without an internet connection, syncing automatically when connectivity is restored.
-   **Role-Based Dashboards**: Tailored user experiences for Subordinates (self-service) and Supervisors (team management).
-   **Approval Workflows**: Supervisors can review, approve, or reject pending attendance records and correction requests from their team.
-   **Event Scheduling**: Supervisors can create and assign events to individuals or entire teams, which appear on the user's in-app calendar.
-   **Real-time Updates**: The UI is built to be reactive, reflecting data changes from the backend in real-time.

## 🛠️ Tech Stack & Architecture

This project is built following enterprise-grade software development standards.

-   **Framework**: [Flutter](https://flutter.dev/) 3.x
-   **Language**: [Dart](https://dart.dev/)
-   **Architecture**: Clean Architecture
-   **State Management**: [Riverpod 2.x](https://riverpod.dev/)
-   **Backend**: Google Firebase (Authentication, Firestore, Cloud Messaging)
-   **Routing**: [GoRouter](https://pub.dev/packages/go_router)
-   **Device APIs**:
    -   Location: [geolocator](https://pub.dev/packages/geolocator)
    -   Push Notifications: [firebase_messaging](https://pub.dev/packages/firebase_messaging)
    -   Maps: [google_maps_flutter](https://pub.dev/packages/google_maps_flutter)

### Project Structure
The codebase is organized using a feature-first approach, aligned with Clean Architecture principles:
```
lib
├── src
│   ├── core/           # Shared services, routing, themes, constants
│   ├── features/       # Feature-specific modules (e.g., auth, attendance, events)
│   │   ├── auth/
│   │   ├── attendance/
│   │   └── ...
│   ├── app.dart        # Root application widget
│   └── main.dart       # Application entry point
...
```

## 📋 Prerequisites

-   Flutter SDK (version >= 3.16.0)
-   An editor like VS Code or Android Studio
-   Firebase project configured for iOS and Android
-   Access to Google Cloud Platform for API keys (Google Maps)

## ⚙️ Getting Started

### 1. Clone the Repository
```bash
git clone <repository-url>
cd app-mobile
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Environment Configuration
This project uses environment variables for sensitive keys.

1.  Create a `.env` file in the root of the project:
    ```bash
    cp .env.example .env
    ```
2.  Open the `.env` file and add your Google Maps API keys for iOS and Android. You can get these from your [Google Cloud Console](https://console.cloud.google.com/).

### 4. Firebase Setup
1.  Ensure you have the Firebase CLI installed and you are logged in.
2.  Run `flutterfire configure` to generate the `lib/firebase_options.dart` file with your project-specific credentials. You may need separate configurations for different environments (dev, staging, prod).

### 5. Run the Application
```bash
flutter run
```
To run a specific flavor (environment):
```bash
flutter run --flavor development
```

## ✅ Testing

This project maintains a high standard of code quality and test coverage.

-   **Run unit and widget tests**:
    ```bash
    flutter test
    ```
-   **Run tests with coverage**:
    ```bash
    flutter test --coverage
    ```
-   **Run integration tests**:
    ```bash
    flutter test integration_test/
    ```

## 📦 CI/CD

A Continuous Integration workflow is configured using GitHub Actions (`.github/workflows/ci.yml`). This workflow automatically triggers on pushes and pull requests to the `main` and `develop` branches. It performs the following checks:
1.  **Static Analysis**: `flutter analyze`
2.  **Testing**: `flutter test --coverage`
3.  **Coverage Check**: Ensures test coverage meets the project threshold (>= 80%).