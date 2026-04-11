sealed class Failure {
  const Failure();
}

final class NetworkFailure extends Failure {
  const NetworkFailure([this.message]);
  final String? message;
}

final class ServerFailure extends Failure {
  const ServerFailure(this.statusCode, [this.message]);
  final int statusCode;
  final String? message;
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure([this.message]);
  final String? message;
}

final class ParseFailure extends Failure {
  const ParseFailure([this.message]);
  final String? message;
}

final class UnknownFailure extends Failure {
  const UnknownFailure([this.cause]);
  final Object? cause;
}
