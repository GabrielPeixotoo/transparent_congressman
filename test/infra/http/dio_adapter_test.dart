import 'package:Deputado_Transparente/data/http/http.dart';
import 'package:Deputado_Transparente/data/http/http_client_exception.dart';
import 'package:Deputado_Transparente/domain/errors/failure.dart';
import 'package:Deputado_Transparente/infra/http/dio_adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

Dio _dioThatResolves(Response response) {
  final dio = Dio(BaseOptions(baseUrl: 'https://example.com'));
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        handler.resolve(
          Response(
            requestOptions: options,
            statusCode: response.statusCode,
            statusMessage: response.statusMessage,
            data: response.data,
          ),
        );
      },
    ),
  );
  return dio;
}

Dio _dioThatRejects(DioException exception) {
  final dio = Dio(BaseOptions(baseUrl: 'https://example.com'));
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        handler.reject(
          DioException(
            requestOptions: options,
            type: exception.type,
            response: exception.response,
            error: exception.error,
            message: exception.message,
          ),
        );
      },
    ),
  );
  return dio;
}

void main() {
  group('DioAdapter', () {
    test('returns response data for 200', () async {
      final dio = _dioThatResolves(
        Response(
          requestOptions: RequestOptions(path: '/'),
          statusCode: 200,
          data: <String, dynamic>{'k': 1},
        ),
      );
      final sut = DioAdapter(dio: dio);

      final out = await sut.request(
        url: 'https://example.com/x',
        method: RequestMethod.get,
      );

      expect(out, <String, dynamic>{'k': 1});
    });

    test('returns response data for 201', () async {
      final dio = _dioThatResolves(
        Response(
          requestOptions: RequestOptions(path: '/'),
          statusCode: 201,
          data: 'created',
        ),
      );
      final sut = DioAdapter(dio: dio);

      final out = await sut.request(
        url: 'https://example.com/x',
        method: RequestMethod.get,
      );

      expect(out, 'created');
    });

    test('returns empty map for 204', () async {
      final dio = _dioThatResolves(
        Response(
          requestOptions: RequestOptions(path: '/'),
          statusCode: 204,
        ),
      );
      final sut = DioAdapter(dio: dio);

      final out = await sut.request(
        url: 'https://example.com/x',
        method: RequestMethod.get,
      );

      expect(out, <String, dynamic>{});
    });

    test('throws HttpClientException with NotFoundFailure for 404 response',
        () async {
      final dio = _dioThatResolves(
        Response(
          requestOptions: RequestOptions(path: '/'),
          statusCode: 404,
          statusMessage: 'gone',
        ),
      );
      final sut = DioAdapter(dio: dio);

      expect(
        () => sut.request(
          url: 'https://example.com/x',
          method: RequestMethod.get,
        ),
        throwsA(
          isA<HttpClientException>().having(
            (e) => e.failure,
            'failure',
            isA<NotFoundFailure>(),
          ),
        ),
      );
    });

    test('throws HttpClientException with ServerFailure for 500 response',
        () async {
      final dio = _dioThatResolves(
        Response(
          requestOptions: RequestOptions(path: '/'),
          statusCode: 500,
          statusMessage: 'err',
        ),
      );
      final sut = DioAdapter(dio: dio);

      try {
        await sut.request(
          url: 'https://example.com/x',
          method: RequestMethod.get,
        );
        fail('expected exception');
      } on HttpClientException catch (e) {
        expect(e.failure, isA<ServerFailure>());
        expect((e.failure as ServerFailure).statusCode, 500);
      }
    });

    test('maps connectionError to NetworkFailure', () async {
      final dio = _dioThatRejects(
        DioException(
          requestOptions: RequestOptions(path: '/'),
          type: DioExceptionType.connectionError,
          message: 'no net',
        ),
      );
      final sut = DioAdapter(dio: dio);

      expect(
        () => sut.request(
          url: 'https://example.com/x',
          method: RequestMethod.get,
        ),
        throwsA(
          isA<HttpClientException>().having(
            (e) => e.failure,
            'failure',
            isA<NetworkFailure>(),
          ),
        ),
      );
    });

    test('maps badResponse 404 to NotFoundFailure', () async {
      final dio = _dioThatRejects(
        DioException(
          requestOptions: RequestOptions(path: '/'),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: '/'),
            statusCode: 404,
            statusMessage: 'nf',
          ),
        ),
      );
      final sut = DioAdapter(dio: dio);

      try {
        await sut.request(
          url: 'https://example.com/x',
          method: RequestMethod.get,
        );
        fail('expected exception');
      } on HttpClientException catch (e) {
        expect(e.failure, isA<NotFoundFailure>());
      }
    });

    test('maps badResponse 503 to ServerFailure', () async {
      final dio = _dioThatRejects(
        DioException(
          requestOptions: RequestOptions(path: '/'),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: '/'),
            statusCode: 503,
          ),
        ),
      );
      final sut = DioAdapter(dio: dio);

      try {
        await sut.request(
          url: 'https://example.com/x',
          method: RequestMethod.get,
        );
        fail('expected exception');
      } on HttpClientException catch (e) {
        expect(e.failure, isA<ServerFailure>());
        expect((e.failure as ServerFailure).statusCode, 503);
      }
    });

    test('maps cancel to NetworkFailure', () async {
      final dio = _dioThatRejects(
        DioException(
          requestOptions: RequestOptions(path: '/'),
          type: DioExceptionType.cancel,
        ),
      );
      final sut = DioAdapter(dio: dio);

      try {
        await sut.request(
          url: 'https://example.com/x',
          method: RequestMethod.get,
        );
        fail('expected exception');
      } on HttpClientException catch (e) {
        expect(e.failure, isA<NetworkFailure>());
      }
    });
  });
}
