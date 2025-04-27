abstract class Result<T> {
  factory Result.success(T value) = Success<T>;
  factory Result.failure(Exception error) = Failure<T>;
}

class Success<T> implements Result<T> {
  final T value;
  Success(this.value);
}

class Failure<T> implements Result<T> {
  final Exception error;
  Failure(this.error);
}