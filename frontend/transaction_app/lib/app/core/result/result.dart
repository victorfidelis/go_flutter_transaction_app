abstract class Result<T> {
  factory Result.ok(T value) = Ok<T>;
  factory Result.error(Exception error) = Error<T>;
}

class Ok<T> implements Result<T> {
  final T value;
  Ok(this.value);
}

class Error<T> implements Result<T> {
  final Exception error;
  Error(this.error);
}