import 'package:transaction_app/app/core/result/result.dart';

extension ResultExtensions<T> on Result<T> {
  R fold<R>({
    required R Function(T) onSuccess,
    required R Function(Exception) onFailure,
  }) {
    if (this is Success<T>) {
      return onSuccess((this as Success<T>).value);
    } else {
      return onFailure((this as Failure<T>).error);
    }
  }

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;
}