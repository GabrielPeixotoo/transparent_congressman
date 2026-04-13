import 'package:Deputado_Transparente/data/http/http.dart';
import 'package:Deputado_Transparente/data/usecases/fetch_congress_person_expense/remote_fetch_congress_person_expense.dart';
import 'package:Deputado_Transparente/domain/entities/entities.dart';
import 'package:Deputado_Transparente/domain/errors/failure.dart';
import 'package:Deputado_Transparente/domain/result/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/mock_http_client.dart';

Map<String, dynamic> validDespesaJson() => {
      'tipoDespesa': 'PASSAGEM AÉREA',
      'valorLiquido': '1500.00',
      'ano': '2024',
      'mes': '6',
      'urlDocumento': 'https://example.com/doc.pdf',
    };

void main() {
  setUpAll(() {
    registerFallbackValue(RequestMethod.get);
    registerFallbackValue(RequestMethod.post);
  });

  const baseUrl = 'https://api.example/deputados';

  late MockHttpClient http;
  late RemoteFetchCongressPersonExpense sut;

  setUp(() {
    http = MockHttpClient();
    sut = RemoteFetchCongressPersonExpense(url: baseUrl, client: http);
  });

  group('RemoteFetchCongressPersonExpense', () {
    test('returns Ok with entities when dados is a valid list', () async {
      when(() => http.request(
            url: any(named: 'url'),
            method: any(named: 'method'),
          )).thenAnswer((_) async => {
            'dados': [validDespesaJson()],
          });

      final result = await sut.call(id: '42');

      expect(result, isA<Ok<List<CongressPersonExpenseEntity>>>());
      final list = (result as Ok<List<CongressPersonExpenseEntity>>).value;
      expect(list, hasLength(1));
      expect(list.first.tipoDespesa, 'PASSAGEM AÉREA');
      expect(list.first.valorLiquido, '1500.00');
      verify(() => http.request(
            url: any(named: 'url'),
            method: RequestMethod.get,
          )).called(1);
    });

    test('requests correct URL for id', () async {
      when(() => http.request(
            url: any(named: 'url'),
            method: any(named: 'method'),
          )).thenAnswer((_) async => {'dados': <dynamic>[]});

      await sut.call(id: '99');

      final url = verify(() => http.request(
            url: captureAny(named: 'url'),
            method: any(named: 'method'),
          )).captured.single as String;
      expect(
        url,
        '$baseUrl/99/despesas?ordem=DESC&ordenarPor=ano',
      );
    });

    test('returns ParseFailure when response is not a Map', () async {
      when(() => http.request(
            url: any(named: 'url'),
            method: any(named: 'method'),
          )).thenAnswer((_) async => 'oops');

      final result = await sut.call(id: '1');

      expect(result, isA<Err<List<CongressPersonExpenseEntity>>>());
      expect(
        (result as Err<List<CongressPersonExpenseEntity>>).failure,
        isA<ParseFailure>(),
      );
    });

    test('returns ParseFailure when dados is missing', () async {
      when(() => http.request(
            url: any(named: 'url'),
            method: any(named: 'method'),
          )).thenAnswer((_) async => <String, dynamic>{});

      final result = await sut.call(id: '1');

      expect(result, isA<Err>());
      expect((result as Err).failure, isA<ParseFailure>());
    });

    test('returns ParseFailure when dados is not a List', () async {
      when(() => http.request(
            url: any(named: 'url'),
            method: any(named: 'method'),
          )).thenAnswer((_) async => {'dados': 'x'});

      final result = await sut.call(id: '1');

      expect(result, isA<Err>());
      expect((result as Err).failure, isA<ParseFailure>());
    });

    test('maps HttpClientException to Err', () async {
      when(() => http.request(
            url: any(named: 'url'),
            method: any(named: 'method'),
          )).thenThrow(HttpClientException(const ServerFailure(502)));

      final result = await sut.call(id: '1');

      expect(result, isA<Err<List<CongressPersonExpenseEntity>>>());
      final failure =
          (result as Err<List<CongressPersonExpenseEntity>>).failure;
      expect(failure, isA<ServerFailure>());
      expect((failure as ServerFailure).statusCode, 502);
    });
  });
}
