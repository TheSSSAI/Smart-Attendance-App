import 'package:equatable/equatable.dart';

/// Represents a failure in the domain layer.
/// Failures are used to represent expected error states that the application
/// layer should be able to handle, as opposed to throwing exceptions for unexpected errors.
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

/// Represents a failure originating from the server during a remote API call.
class ServerFailure extends Failure {
  const ServerFailure({String message = 'An error occurred on the server.'}) : super(message);
}

/// Represents a failure related to local data caching.
class CacheFailure extends Failure {
  const CacheFailure({String message = 'An error occurred with local data storage.'}) : super(message);
}

/// Represents a failure due to lack of network connectivity.
class NetworkFailure extends Failure {
  const NetworkFailure({String message = 'No internet connection detected.'}) : super(message);
}

/// Represents a failure due to the user not being authenticated.
class UnauthenticatedFailure extends Failure {
  const UnauthenticatedFailure({String message = 'You are not logged in.'}) : super(message);
}

/// Represents a failure due to the user not having the required permissions.
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({String message = 'You do not have permission to perform this action.'}) : super(message);
}

/// Represents a failure due to invalid input being sent to the server.
class InvalidInputFailure extends Failure {
  const InvalidInputFailure({required String message}) : super(message);
}

/// A generic failure for miscellaneous errors.
class GeneralFailure extends Failure {
    const GeneralFailure({String message = 'An unexpected error occurred.'}) : super(message);
}