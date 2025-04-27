import 'package:transaction_app/app/core/result/result.dart';

extension ResultExtensions<T> on Result<T> {
  R fold<R>({
    required R Function(T) onSuccess,
    required R Function(Exception) onFailure,
  }) {
    if (this is Ok<T>) {
      return onSuccess((this as Ok<T>).value);
    } else {
      return onFailure((this as Error<T>).error);
    }
  }

  bool get isOk => this is Ok<T>;
  bool get isError => this is Error<T>;
}