// ignore_for_file: constant_identifier_names

/// A configuration class to hold environment-specific variables.
///
/// This class provides a centralized way to access configuration loaded from
/// `--dart-define` compile-time variables. It ensures that environment-specific
/// settings, such as Firebase project keys, are not hardcoded into the source code.
///
/// To use this, you must run the Flutter application with the appropriate
/// `--dart-define` flags. For example:
///
/// flutter run --dart-define=FIREBASE_API_KEY=your_key \
///             --dart-define=FIREBASE_AUTH_DOMAIN=your_domain \
///             ...
///
/// The class uses a singleton pattern to ensure a single, immutable instance
/// of the configuration is available throughout the application's lifecycle.
class EnvConfig {
  /// The Firebase API key for the web application.
  final String firebaseApiKey;

  /// The Firebase Authentication domain.
  final String firebaseAuthDomain;

  /// The Google Cloud Platform Project ID.
  final String firebaseProjectId;

  /// The Firebase Storage bucket.
  final String firebaseStorageBucket;

  /// The Firebase Cloud Messaging sender ID.
  final String firebaseMessagingSenderId;

  /// The Firebase application ID.
  final String firebaseAppId;

  /// The Google Analytics measurement ID.
  final String firebaseMeasurementId;

  /// The name of the environment (e.g., 'dev', 'staging', 'prod').
  final String environment;

  /// Private constructor to prevent direct instantiation.
  const EnvConfig._({
    required this.firebaseApiKey,
    required this.firebaseAuthDomain,
    required this.firebaseProjectId,
    required this.firebaseStorageBucket,
    required this.firebaseMessagingSenderId,
    required this.firebaseAppId,
    required this.firebaseMeasurementId,
    required this.environment,
  });

  /// The singleton instance of the environment configuration.
  ///
  /// This instance is initialized once at startup by reading the compile-time
  /// environment variables.
  static final EnvConfig instance = EnvConfig._init();

  /// Factory constructor that initializes the configuration from environment variables.
  ///
  /// This is called internally to create the singleton instance. It reads
  /// values using `String.fromEnvironment` and provides default empty strings
  /// if a variable is not defined, which will cause a clear failure during
  /// Firebase initialization if configuration is missing.
  factory EnvConfig._init() {
    return EnvConfig._(
      firebaseApiKey: const String.fromEnvironment('FIREBASE_API_KEY', defaultValue: ''),
      firebaseAuthDomain: const String.fromEnvironment('FIREBASE_AUTH_DOMAIN', defaultValue: ''),
      firebaseProjectId: const String.fromEnvironment('FIREBASE_PROJECT_ID', defaultValue: ''),
      firebaseStorageBucket: const String.fromEnvironment('FIREBASE_STORAGE_BUCKET', defaultValue: ''),
      firebaseMessagingSenderId: const String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID', defaultValue: ''),
      firebaseAppId: const String.fromEnvironment('FIREBASE_APP_ID', defaultValue: ''),
      firebaseMeasurementId: const String.fromEnvironment('FIREBASE_MEASUREMENT_ID', defaultValue: ''),
      environment: const String.fromEnvironment('ENVIRONMENT', defaultValue: 'dev'),
    );
  }

  /// A getter to easily check if the current environment is production.
  bool get isProd => environment == 'prod';

  /// A getter to easily check if the current environment is staging.
  bool get isStaging => environment == 'staging';
  
  /// A getter to easily check if the current environment is development.
  bool get isDev => environment == 'dev';
}