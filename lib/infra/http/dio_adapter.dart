import 'package:dio/dio.dart';

import '../../data/http/http.dart';
import '../../domain/errors/failure.dart';

class DioAdapter implements HttpClient {
  final Dio dio;
  DioAdapter({
    required this.dio,
  });

  @override
  Future<dynamic> request(
      {required String url,
      required RequestMethod method,
      Map<String, String> headers = const {},
      Map body = const {}}) async {
    try {
      final Map<String, dynamic> dioHeaders = {};

      dioHeaders
        ..addAll(headers)
        ..addAll({
          'content-type': 'application/json',
          'accept': 'application/json',
          'User-Agent': 'Deputados-App-Teste',
        });

      final response = await dio.request(
        url,
        options: Options(
          method: method.name.toUpperCase(),
          headers: dioHeaders,
        ),
      );

      return _handleResponse(response);
    } on DioException catch (error) {
      throw HttpClientException(_mapDioException(error));
    }
  }

  Failure _mapDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return NetworkFailure(error.message);
      case DioExceptionType.badResponse:
        final code = error.response?.statusCode ?? 0;
        if (code == 404) {
          return NotFoundFailure(error.response?.statusMessage);
        }
        return ServerFailure(code, error.response?.statusMessage);
      case DioExceptionType.cancel:
        return const NetworkFailure('Request cancelled');
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return UnknownFailure(error.error ?? error.message);
    }
  }

  dynamic _handleResponse(Response response) {
    final code = response.statusCode ?? 0;
    if (code == 200 || code == 201) {
      return response.data ?? {};
    }
    if (code == 204) {
      return {};
    }
    if (code == 404) {
      throw HttpClientException(NotFoundFailure(response.statusMessage));
    }
    throw HttpClientException(ServerFailure(code, response.statusMessage));
  }
}
