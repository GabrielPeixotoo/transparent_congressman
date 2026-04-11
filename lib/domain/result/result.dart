import '../errors/failure.dart';

sealed class Result<T> {
  const Result._();

  const factory Result.ok(T value) = Ok;
  const factory Result.err(Failure failure) = Err;
}

final class Ok<T> extends Result<T> {
  const Ok(this.value) : super._();
  final T value;
}

final class Err<T> extends Result<T> {
  const Err(this.failure) : super._();
  final Failure failure;
}

extension ResultX<T> on Result<T> {
  R fold<R>({
    required R Function(T value) ok,
    required R Function(Failure failure) err,
  }) {
    return switch (this) {
      Ok(:final value) => ok(value),
      Err(:final failure) => err(failure),
    };
  }
}
