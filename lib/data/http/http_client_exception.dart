import '../../domain/errors/failure.dart';

final class HttpClientException implements Exception {
  HttpClientException(this.failure);
  final Failure failure;
}
