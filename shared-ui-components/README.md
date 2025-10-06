# Shared UI Components (`shared_ui_components`)

A reusable Flutter library containing the application's design system and common UI widgets. This repository provides foundational UI elements for the Attendance App ecosystem.

## Overview

This package is a critical foundational component that enforces the Design System across all Flutter-based clients (mobile and web) for the Attendance App. Its primary purpose is to ensure a consistent look and feel, reduce UI code duplication, and accelerate feature development.

The library implements the application's branding, color palette, and typography, strictly adhering to **Material Design 3** principles as required by `REQ-1-062`.

## Core Principles

-   **State-Management Agnostic**: Components are purely presentational (stateless where possible) and receive all data and callbacks via their constructors. This ensures independence from the main application's state management solution (Riverpod).
-   **Theme-Aware**: All components derive their styling (colors, fonts, etc.) from the provided `ThemeData`. Hardcoded styles are forbidden.
-   **Accessible**: All components are developed to meet **WCAG 2.1 Level AA** conformance (`REQ-1-063`). This includes semantic labels, minimum touch target sizes, color contrast ratios, and support for dynamic text scaling.
-   **Localization-Ready**: Components do not contain hardcoded user-facing strings. All labels and text must be passed in as parameters, ensuring compliance with `REQ-1-064`.
-   **Performant**: Widgets are optimized to maintain a smooth 60fps rendering performance, with a preference for `const` constructors and efficient build methods, as per `REQ-1-067`.

## Getting Started

To use this package in your Flutter project, add it to your `pubspec.yaml` file.

```yaml
dependencies:
  shared_ui_components:
    # Add path or git dependency here
```

### Integration

1.  **Apply the Theme**: In the root of your application, use the provided `AppTheme` to style your entire app.

    ```dart
    import 'package:flutter/material.dart';
    import 'package:shared_ui_components/shared_ui_components.dart';

    void main() {
      runApp(const MyApp());
    }

    class MyApp extends StatelessWidget {
      const MyApp({super.key});

      @override
      Widget build(BuildContext context) {
        return MaterialApp(
          title: 'Attendance App',
          theme: AppTheme.lightTheme(),
          darkTheme: AppTheme.darkTheme(),
          themeMode: ThemeMode.system, // Or your preferred mode
          home: const MyHomePage(),
        );
      }
    }
    ```

2.  **Use Components**: Import the main library file and use the widgets in your screens.

    ```dart
    import 'package:flutter/material.dart';
    import 'package:shared_ui_components/shared_ui_components.dart';

    class LoginScreen extends StatelessWidget {
      const LoginScreen({super.key});

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: const CustomAppBar(title: 'Login'),
          body: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                const TextInputField(
                  labelText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: AppSpacing.md),
                const TextInputField(
                  labelText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: AppSpacing.lg),
                PrimaryButton(
                  onPressed: () {
                    // Handle login logic
                  },
                  label: 'Log In',
                  isLoading: false,
                ),
              ],
            ),
          ),
        );
      }
    }
    ```

## Development

This package includes an `example` directory with a runnable Flutter application that serves as a living style guide, demonstrating all available components and their states. To run it:

```bash
cd example
flutter pub get
flutter run
```

### Running Tests

To run the widget tests for this library:

```bash
flutter test --coverage
```

This will execute all tests and generate a coverage report in the `coverage/` directory.

---
This library is a core component of the Attendance App project.
REPO-ID: `REPO-LIB-UI-009`