import 'dart:async';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:repo_lib_client_008/repo_lib_client_008.dart';

import 'package:app_mobile/src/core/routing/app_router.dart';
import 'package:app_mobile/src/core/routing/routes.dart';
import 'package:app_mobile/src/features/auth/application/providers/auth_providers.dart';

/// Defines the contract for a service that manages push notifications.
abstract class INotificationHandlerService {
  /// Initializes the service, setting up listeners and permissions.
  Future<void> initialize(GoRouter router, ProviderContainer container);
}

/// A service that handles all Firebase Cloud Messaging (FCM) logic.
///
/// This includes requesting permissions, managing the FCM token, and handling
/// incoming notifications for all application states (foreground, background, terminated).
class NotificationHandlerService implements INotificationHandlerService {
  final FirebaseMessaging _fcm;
  late final GoRouter _router;
  late final ProviderContainer _container;

  /// Used to display notifications when the app is in the foreground.
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  NotificationHandlerService(this._fcm);

  @override
  Future<void> initialize(GoRouter router, ProviderContainer container) async {
    _router = router;
    _container = container;

    await _requestPermissions();
    await _setupLocalNotifications();
    _setupListeners();
    await _setupToken();
    await _handleInitialMessage();
  }

  /// Requests notification permissions from the user.
  Future<void> _requestPermissions() async {
    try {
      final settings = await _fcm.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (kDebugMode) {
        log('Notification permission granted: ${settings.authorizationStatus}');
      }
    } catch (e, st) {
      log('Error requesting notification permissions', error: e, stackTrace: st);
    }
  }

  /// Sets up listeners for incoming FCM messages.
  void _setupListeners() {
    // For handling notifications when the app is in the foreground.
    FirebaseMessaging.onMessage.listen(_showLocalNotification);

    // For handling notifications that are tapped when the app is in the background.
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      log('Message opened from background: ${message.data}');
      _handleMessageNavigation(message.data);
    });

    // For handling notifications when the app is terminated.
    // This is handled by `_handleInitialMessage`.
  }

  /// Sets up the FCM token and handles its refresh.
  Future<void> _setupToken() async {
    try {
      final token = await _fcm.getToken();
      if (token != null) {
        await _updateFcmToken(token);
      }

      _fcm.onTokenRefresh.listen(_updateFcmToken);
    } catch (e, st) {
      log('Error setting up FCM token', error: e, stackTrace: st);
    }
  }

  /// Updates the user's FCM token in the backend.
  Future<void> _updateFcmToken(String token) async {
    final user = _container.read(authRepositoryProvider).getCurrentUser();
    if (user != null) {
      try {
        final userRepository = _container.read(userRepositoryProvider);
        await userRepository.updateFcmToken(user.uid, token);
        log('FCM Token updated successfully.');
      } catch (e, st) {
        log('Failed to update FCM token on server', error: e, stackTrace: st);
      }
    }
  }

  /// Handles the initial message if the app was launched from a terminated state
  /// by a user tapping on a notification.
  Future<void> _handleInitialMessage() async {
    final initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      log('App launched from terminated state by notification: ${initialMessage.data}');
      // A slight delay to ensure the router is ready
      Future.delayed(const Duration(milliseconds: 500), () {
        _handleMessageNavigation(initialMessage.data);
      });
    }
  }

  /// Navigates to the appropriate screen based on the notification payload.
  void _handleMessageNavigation(Map<String, dynamic> data) {
    final type = data['type'] as String?;
    final targetId = data['targetId'] as String?;

    if (type == null) {
      log('Notification received without a "type" field.');
      return;
    }

    switch (type) {
      case 'NEW_EVENT_ASSIGNMENT':
      case 'EVENT_UPDATED':
        // As per US-058, tapping notification opens the event calendar
        _router.go(EventCalendarRoute.path);
        break;
      case 'CORRECTION_APPROVED':
      case 'CORRECTION_REJECTED':
        // As per US-049, tapping notification deep-links to the record
        if (targetId != null) {
          _router.goNamed(
            Routes.attendanceDetail.name,
            pathParameters: {'id': targetId},
          );
        } else {
          log('Correction notification received without a "targetId".');
        }
        break;
      default:
        log('Unhandled notification type: $type');
        _router.go(SubordinateDashboardRoute.path);
    }
  }

  /// Configures the local notifications plugin.
  Future<void> _setupLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await _localNotifications.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (response) {
      // This is for local notifications shown in foreground.
      // We assume the payload is a simple string for now.
      if (response.payload != null) {
        // Here we would ideally parse the payload and navigate.
        // For simplicity, we assume the main _handleMessageNavigation
        // covers most cases, as the user is already in the app.
        log('Local notification tapped with payload: ${response.payload}');
      }
    });
  }

  /// Displays a local notification, typically for foreground messages.
  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    final android = message.notification?.android;

    if (notification != null && android != null) {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            // This channel ID should be created in AndroidManifest.xml
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription: 'This channel is used for important notifications.',
            importance: Importance.max,
            priority: Priority.high,
            icon: android.smallIcon,
          ),
          iOS: const DarwinNotificationDetails(),
        ),
      );
    }
  }
}

/// Top-level function for handling background messages, as required by firebase_messaging.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log("Handling a background message: ${message.messageId}");
  // Business logic for background messages (e.g., data pre-fetching) can go here.
  // This handler cannot interact with UI.
}


final notificationHandlerServiceProvider =
    Provider<INotificationHandlerService>((ref) {
  return NotificationHandlerService(FirebaseMessaging.instance);
});