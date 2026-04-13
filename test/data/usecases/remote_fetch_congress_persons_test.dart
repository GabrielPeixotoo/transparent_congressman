import 'package:Deputado_Transparente/data/http/http.dart';
import 'package:Deputado_Transparente/data/usecases/fetch_congress_persons/remote_fetch_congress_persons.dart';
import 'package:Deputado_Transparente/domain/entities/entities.dart';
import 'package:Deputado_Transparente/domain/errors/failure.dart';
import 'package:Deputado_Transparente/domain/result/result.dart';
import 'package:Deputado_Transparente/domain/usecases/usecases.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/mock_http_client.dart';

Map<String, dynamic> validDeputadoJson() => {
      'id': 123,
      'uri': 'https://dadosabertos.camara.leg.br/api/v2/deputados/123',
      'nome': 'Fulano',
      'siglaPartido': 'PT',
      'uriPartido': 'https://example.com/pt',
      'siglaUf': 'SP',
      'idLegislatura': 57,
      'urlFoto': 'https://example.com/foto.jpg',
      'email': 'a@b.c',
    };

void main() {
  setUpAll(() {
    registerFallbackValue(RequestMethod.get);
    registerFallbackValue(RequestMethod.post);
  });

  const baseUrl = 'https://api.example/deputados';

  late MockHttpClient http;
  late RemoteFetchCongressPersons sut;

  setUp(() {
    http = MockHttpClient();
    sut = RemoteFetchCongressPersons(url: baseUrl, httpClient: http);
  });

  group('RemoteFetchCongressPersons', () {
    test('returns Ok with entities when dados is a valid list', () async {
      when(() => http.request(
            url: any(named: 'url'),
            method: any(named: 'method'),
          )).thenAnswer((_) async => {
            'dados': [validDeputadoJson()],
          });

      final result = await sut.call(params: FetchCongressPeopleParams.all());

      expect(result, isA<Ok<List<CongressPersonEntity>>>());
      final list = (result as Ok<List<CongressPersonEntity>>).value;
      expect(list, hasLength(1));
      expect(list.first.name, 'Fulano');
      expect(list.first.id, 123);
      verify(() => http.request(
            url: any(named: 'url'),
            method: RequestMethod.get,
          )).called(1);
    });

    test('returns ParseFailure when response is not a Map', () async {
      when(() => http.request(
            url: any(named: 'url'),
            method: any(named: 'method'),
          )).thenAnswer((_) async => <dynamic>[]);

      final result = await sut.call(params: FetchCongressPeopleParams.all());

      expect(result, isA<Err>());
      expect((result as Err).failure, isA<ParseFailure>());
    });

    test('returns ParseFailure when dados is missing', () async {
      when(() => http.request(
            url: any(named: 'url'),
            method: any(named: 'method'),
          )).thenAnswer((_) async => <String, dynamic>{});

      final result = await sut.call(params: FetchCongressPeopleParams.all());

      expect(result, isA<Err>());
      expect((result as Err).failure, isA<ParseFailure>());
    });

    test('returns ParseFailure when dados is not a List', () async {
      when(() => http.request(
            url: any(named: 'url'),
            method: any(named: 'method'),
          )).thenAnswer((_) async => {'dados': <String, dynamic>{}});

      final result = await sut.call(params: FetchCongressPeopleParams.all());

      expect(result, isA<Err>());
      expect((result as Err).failure, isA<ParseFailure>());
    });

    test('builds URL with nome when nome is non-empty', () async {
      when(() => http.request(
            url: any(named: 'url'),
            method: any(named: 'method'),
          )).thenAnswer((_) async => {'dados': <dynamic>[]});

      await sut.call(params: FetchCongressPeopleParams(nome: 'Silva'));

      final url = verify(() => http.request(
            url: captureAny(named: 'url'),
            method: any(named: 'method'),
          )).captured.single as String;
      expect(url, '$baseUrl?nome=Silva');
    });

    test('builds URL with siglaUf when set and nome is empty', () async {
      when(() => http.request(
            url: any(named: 'url'),
            method: any(named: 'method'),
          )).thenAnswer((_) async => {'dados': <dynamic>[]});

      await sut.call(params: FetchCongressPeopleParams(siglaUf: 'RJ'));

      final url = verify(() => http.request(
            url: captureAny(named: 'url'),
            method: any(named: 'method'),
          )).captured.single as String;
      expect(url, '$baseUrl?siglaUf=RJ');
    });

    test('builds default ordem and ordenarPor for FetchCongressPeopleParams.all',
        () async {
      when(() => http.request(
            url: any(named: 'url'),
            method: any(named: 'method'),
          )).thenAnswer((_) async => {'dados': <dynamic>[]});

      await sut.call(params: FetchCongressPeopleParams.all());

      final url = verify(() => http.request(
            url: captureAny(named: 'url'),
            method: any(named: 'method'),
          )).captured.single as String;
      expect(url, '$baseUrl?ordem=ASC&ordenarPor=nome');
    });

    test('maps HttpClientException to Err', () async {
      when(() => http.request(
            url: any(named: 'url'),
            method: any(named: 'method'),
          )).thenThrow(HttpClientException(const ServerFailure(503)));

      final result = await sut.call(params: FetchCongressPeopleParams.all());

      expect(result, isA<Err>());
      expect((result as Err).failure, isA<ServerFailure>());
      expect(((result as Err<List<CongressPersonEntity>>).failure as ServerFailure)
          .statusCode, 503);
    });
  });
}
