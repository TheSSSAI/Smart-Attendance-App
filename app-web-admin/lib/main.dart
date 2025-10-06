import 'dart:developer';

import 'package:app_web_admin/src/app.dart';
import 'package:app_web_admin/src/config/env/env_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The main entry point for the application.
///
/// This function is responsible for:
/// 1. Ensuring the Flutter widget binding is initialized.
/// 2. Loading the environment-specific Firebase configuration from compile-time variables.
/// 3. Initializing the Firebase app with the loaded configuration.
/// 4. Setting up the root `ProviderScope` for the Riverpod state management.
/// 5. Running the main `App` widget, which contains the application's UI and routing.
///
/// It includes robust error handling for the critical Firebase initialization step,
/// logging any failures to the developer console. This ensures that configuration
/// issues during deployment are easily discoverable.
Future<void> main() async {
  // Ensure that the Flutter binding is initialized before any Flutter APIs are used.
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Load environment configuration from `--dart-define` variables.
    // This allows for different Firebase projects for dev, staging, and prod.
    final env = EnvConfig.fromEnv();
    log('Environment loaded: ${env.env}');

    // Create FirebaseOptions from the loaded environment configuration.
    final firebaseOptions = FirebaseOptions(
      apiKey: env.firebaseApiKey,
      authDomain: env.firebaseAuthDomain,
      projectId: env.firebaseProjectId,
      storageBucket: env.firebaseStorageBucket,
      messagingSenderId: env.firebaseMessagingSenderId,
      appId: env.firebaseAppId,
      measurementId: env.firebaseMeasurementId,
    );

    // Initialize Firebase with the environment-specific options.
    // This is a critical step that must complete before any other Firebase
    // services can be used.
    await Firebase.initializeApp(
      options: firebaseOptions,
    );
    log('Firebase initialized successfully for project: ${env.firebaseProjectId}');
  } catch (e, stackTrace) {
    // Log a catastrophic error if Firebase initialization fails.
    // This typically indicates a misconfiguration in the environment variables
    // or `firebase_options.dart`. The application cannot run without Firebase.
    log(
      'FATAL: Firebase initialization failed.',
      error: e,
      stackTrace: stackTrace,
    );
    // In a production web environment, this will likely result in a blank screen,
    // which is appropriate as the app is non-functional. The error will be
    // visible in the browser's developer console.
    return;
  }

  // Run the application, wrapping the root widget (`App`) in a `ProviderScope`.
  // The `ProviderScope` is the root of the Riverpod dependency injection and
  // state management system, making all providers available to the entire
  // widget tree.
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}