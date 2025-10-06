import 'dart:async';

import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

/// Defines the contract for a service that provides device location data.
///
/// This service abstracts the implementation details of a third-party package
/// (like geolocator) and provides a clean, testable API for the application layer.
abstract class ILocationService {
  /// Checks the current location permission status for the application.
  Future<LocationPermission> checkPermission();

  /// Requests location permission from the user.
  ///
  /// This will display the OS-native permission dialog.
  Future<LocationPermission> requestPermission();

  /// Gets the current geographical position of the device.
  ///
  /// Throws a [LocationServiceException] on failure (e.g., no signal,
  /// timeout, permission denied).
  Future<Position> getCurrentPosition();

  /// Attempts to open the operating system's settings page for this specific application.
  ///
  /// This is typically used when permissions have been permanently denied (deniedForever).
  /// Returns `true` if the settings page could be opened, `false` otherwise.
  Future<bool> openAppSettings();

  /// Returns a stream that emits an event whenever the location service status changes.
  ///
  /// This can be used to monitor if the user enables/disables GPS at the OS level.
  Stream<ServiceStatus> getServiceStatusStream();
}

/// An exception thrown by the [LocationService] when an operation fails.
class LocationServiceException implements Exception {
  /// A user-friendly message describing the error.
  final String message;

  /// The specific type of failure that occurred.
  final LocationFailureType type;

  const LocationServiceException(this.message, this.type);

  @override
  String toString() => 'LocationServiceException: $message (type: $type)';
}

/// Enumerates the specific types of failures that can occur in the [LocationService].
enum LocationFailureType {
  /// The user has denied location permissions for the app.
  permissionDenied,

  /// The user has permanently denied location permissions. The app cannot
  /// request permissions again and must guide the user to settings.
  permissionDeniedForever,

  /// The device's location services are disabled.
  serviceDisabled,

  /// A timeout occurred while trying to acquire the device's location.
  timeout,

  /// An unknown or unexpected error occurred.
  unknown,
}

/// Concrete implementation of [ILocationService] using the `geolocator` package.
class LocationService implements ILocationService {
  // A reasonable timeout for acquiring a location fix.
  // Fulfills REQ-1-067 performance targets.
  static const Duration _locationTimeout = Duration(seconds: 10);

  @override
  Future<LocationPermission> checkPermission() async {
    return Geolocator.checkPermission();
  }

  @override
  Future<LocationPermission> requestPermission() async {
    return Geolocator.requestPermission();
  }

  @override
  Future<Position> getCurrentPosition() async {
    LocationPermission permission;
    try {
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw const LocationServiceException(
            'Location permissions are denied.',
            LocationFailureType.permissionDenied,
          );
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw const LocationServiceException(
          'Location permissions are permanently denied, we cannot request permissions.',
          LocationFailureType.permissionDeniedForever,
        );
      }

      // Fulfills REQ-1-004 for precise GPS coordinates.
      // Fulfills REQ-1-067 with a 10-second timeout.
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: _locationTimeout,
      );
    } on TimeoutException {
      throw const LocationServiceException(
        'Could not get location in time. Please try again with a clearer view of the sky.',
        LocationFailureType.timeout,
      );
    } on LocationServiceDisabledException {
      throw const LocationServiceException(
        'Location services are disabled on your device. Please enable them to continue.',
        LocationFailureType.serviceDisabled,
      );
    } on PlatformException catch (e) {
      // Handle other potential platform-level errors
      throw LocationServiceException(
        'An unexpected error occurred while fetching location: ${e.message}',
        LocationFailureType.unknown,
      );
    } catch (e) {
      // Catch-all for any other unexpected exceptions
      throw LocationServiceException(
        'An unknown error occurred: ${e.toString()}',
        LocationFailureType.unknown,
      );
    }
  }

  @override
  Future<bool> openAppSettings() async {
    return Geolocator.openAppSettings();
  }

  @override
  Stream<ServiceStatus> getServiceStatusStream() {
    return Geolocator.getServiceStatusStream();
  }
}