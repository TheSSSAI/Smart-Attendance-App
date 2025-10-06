import 'dart:async';

import 'package:app_mobile/app.dart';
import 'package:app_mobile/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// REQ-1-056, REQ-1-013: This background handler is required by firebase_messaging
// to handle notifications when the app is not in the foreground.
// It must be a top-level function (not a class method).
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Per REQ-1-072 (Monitoring), this is where background notification processing
  // would be logged if necessary.
  // For now, the handler's existence is sufficient for receiving notifications.
  if (kDebugMode) {
    print("Handling a background message: ${message.messageId}");
    print('Message data: ${message.data}');
    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  }
}

/// The main entry point of the application.
/// Initializes essential services and runs the Flutter app.
void main() async {
  // This is a global error handler to catch uncaught exceptions,
  // making the app more robust as per enterprise standards.
  // REQ-1-072: This aligns with comprehensive monitoring requirements.
  runZonedGuarded<Future<void>>(() async {
    // Ensure that the Flutter binding is initialized before calling any Flutter APIs.
    WidgetsFlutterBinding.ensureInitialized();

    // REQ-1-012, REQ-1-013: Initialize Firebase using the platform-specific options.
    // This is a prerequisite for using any Firebase services (Auth, Firestore, etc.).
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // REQ-1-056: Set the background messaging handler for FCM.
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // The ProviderScope is the root of the Riverpod state management system.
    // It stores the state of all providers.
    runApp(
      const ProviderScope(
        child: App(),
      ),
    );
  }, (error, stack) {
    // REQ-1-072: Global error logging. In a production app, this would
    // report errors to a service like Firebase Crashlytics.
    // FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    if (kDebugMode) {
      print('Caught fatal error: $error');
      print(stack);
    }
  });
}