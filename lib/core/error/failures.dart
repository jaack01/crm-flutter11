import 'package:equatable/equatable.dart';

/// Base class for all failures
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

/// Database failure
class DatabaseFailure extends Failure {
  const DatabaseFailure([String message = 'Database error occurred']) : super(message);
}

/// Cache failure
class CacheFailure extends Failure {
  const CacheFailure([String message = 'Cache error occurred']) : super(message);
}

/// Network failure
class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'Network error occurred']) : super(message);
}

/// Server failure
class ServerFailure extends Failure {
  const ServerFailure([String message = 'Server error occurred']) : super(message);
}

/// Validation failure
class ValidationFailure extends Failure {
  const ValidationFailure([String message = 'Validation error occurred']) : super(message);
}

/// Not found failure
class NotFoundFailure extends Failure {
  const NotFoundFailure([String message = 'Item not found']) : super(message);
}

/// Permission failure
class PermissionFailure extends Failure {
  const PermissionFailure([String message = 'Permission denied']) : super(message);
}

/// General failure
class GeneralFailure extends Failure {
  const GeneralFailure([String message = 'An error occurred']) : super(message);
}
