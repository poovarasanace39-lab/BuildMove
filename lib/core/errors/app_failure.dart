/// Domain failure types for clean error handling across the app
sealed class AppFailure {
  final String message;
  final String? code;

  const AppFailure(this.message, {this.code});
}

class NetworkFailure extends AppFailure {
  const NetworkFailure([super.message = 'Network connection failed. Please check your internet.']);
}

class ServerFailure extends AppFailure {
  final int? statusCode;
  const ServerFailure(super.message, {this.statusCode, super.code});
}

class AuthFailure extends AppFailure {
  const AuthFailure(super.message, {super.code});
}

class ValidationFailure extends AppFailure {
  const ValidationFailure(super.message);
}

class StorageFailure extends AppFailure {
  const StorageFailure(super.message);
}

class UnknownFailure extends AppFailure {
  const UnknownFailure([super.message = 'An unexpected error occurred. Please try again.']);
}
