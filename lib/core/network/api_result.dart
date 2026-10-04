import '../errors/app_failure.dart';

/// Generic Result type representing either a successful outcome [T]
/// or a failure [AppFailure].
sealed class ApiResult<T> {
  const ApiResult();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;

  T? get dataOrNull => this is Success<T> ? (this as Success<T>).data : null;
  AppFailure? get failureOrNull => this is Failure<T> ? (this as Failure<T>).failure : null;

  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(AppFailure failure) onFailure,
  }) {
    if (this is Success<T>) {
      return onSuccess((this as Success<T>).data);
    } else {
      return onFailure((this as Failure<T>).failure);
    }
  }
}

class Success<T> extends ApiResult<T> {
  final T data;
  const Success(this.data);
}

class Failure<T> extends ApiResult<T> {
  final AppFailure failure;
  const Failure(this.failure);
}
