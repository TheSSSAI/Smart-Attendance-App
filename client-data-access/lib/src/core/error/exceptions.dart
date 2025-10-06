/// Represents exceptions that occur within the data layer, typically from data sources.
/// These should be caught and converted to domain-level [Failure]s in the repository layer.
abstract class AppException implements Exception {
  final String message;
  final StackTrace? stackTrace;

  const AppException({required this.message, this.stackTrace});

  @override
  String toString() => 'AppException: $message';
}

/// Exception thrown when a server-side error occurs during an API call.
/// This could be due to a 5xx HTTP status code, a Firebase error, or other backend issues.
class ServerException extends AppException {
  const ServerException({
    String message = 'A server error occurred.',
    StackTrace? stackTrace,
  }) : super(message: message, stackTrace: stackTrace);
}

/// Exception thrown when there is an issue with caching data locally.
/// This could be a failure to read from or write to the local database or cache.
class CacheException extends AppException {
  const CacheException({
    String message = 'A cache error occurred.',
    StackTrace? stackTrace,
  }) : super(message: message, stackTrace: stackTrace);
}

/// Exception thrown when the user is not authenticated for a protected operation.
class UnauthenticatedException extends AppException {
  const UnauthenticatedException({
    String message = 'User is not authenticated.',
    StackTrace? stackTrace,
  }) : super(message: message, stackTrace: stackTrace);
}

/// Exception thrown when the user is authenticated but not authorized for a specific action.
/// This typically corresponds to a 'permission-denied' error from the backend.
class UnauthorizedException extends AppException {
  const UnauthorizedException({
    String message = 'User is not authorized to perform this action.',
    StackTrace? stackTrace,
  }) : super(message: message, stackTrace: stackTrace);
}

/// Exception thrown for input validation errors from the server.
class InvalidInputException extends AppException {
  const InvalidInputException({
    required String message,
    StackTrace? stackTrace,
  }) : super(message: message, stackTrace: stackTrace);
}