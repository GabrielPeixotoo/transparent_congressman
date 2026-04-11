import 'package:Deputado_Transparente/domain/errors/failure.dart';
import 'package:Deputado_Transparente/domain/result/result.dart';
import 'package:Deputado_Transparente/domain/usecases/usecases.dart';
import 'package:Deputado_Transparente/presentation/getx_home_presenter.dart';
import 'package:Deputado_Transparente/ui/helpers/brazilian_states.dart';
import 'package:Deputado_Transparente/ui/pages/home/home_view_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/congress_person_fixtures.dart';
import '../mocks/mock_fetch_congress_people_use_case.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(FetchCongressPeopleParams.all());
  });

  tearDown(Get.reset);

  group('GetXHomePresenter', () {
    late MockFetchCongressPeopleUseCase mock;

    setUp(() {
      mock = MockFetchCongressPeopleUseCase();
    });

    test('fetchCongressPersons emits success with list from use case', () async {
      when(() => mock.call(params: any(named: 'params'))).thenAnswer((_) async => const Ok([kTestCongressPerson]));

      final presenter = GetXHomePresenter(fetchCongressPersonsUseCase: mock);

      HomeViewState? last;
      final sub = presenter.congressPersonStream.listen((s) => last = s);
      await presenter.fetchCongressPersons();
      await Future<void>.delayed(Duration.zero);

      expect(last, isA<HomeSuccess>());
      expect((last as HomeSuccess).items, [kTestCongressPerson]);

      final captured =
          verify(() => mock.call(params: captureAny(named: 'params'))).captured.single as FetchCongressPeopleParams;
      expect(captured.nome, isNull);
      expect(captured.siglaUf, '');
      await sub.cancel();
    });

    test('fetchCongressPersons emits error when use case fails', () async {
      when(() => mock.call(params: any(named: 'params'))).thenAnswer((_) async => const Err(ServerFailure(503)));

      final presenter = GetXHomePresenter(fetchCongressPersonsUseCase: mock);

      HomeViewState? last;
      final sub = presenter.congressPersonStream.listen((s) => last = s);
      await presenter.fetchCongressPersons();
      await Future<void>.delayed(Duration.zero);

      expect(last, isA<HomeError>());
      expect((last as HomeError).failure, isA<ServerFailure>());
      verify(() => mock.call(params: any(named: 'params'))).called(1);
      await sub.cancel();
    });

    test('searchCongressPersonByName with empty name does not call use case', () async {
      when(() => mock.call(params: any(named: 'params'))).thenAnswer((_) async => const Ok([kTestCongressPerson]));

      final presenter = GetXHomePresenter(fetchCongressPersonsUseCase: mock);
      await presenter.fetchCongressPersons();
      await Future<void>.delayed(Duration.zero);

      clearInteractions(mock);

      await presenter.searchCongressPersonByName(name: '');
      await Future<void>.delayed(Duration.zero);

      verifyNever(() => mock.call(params: any(named: 'params')));
    });

    test('searchCongressPersonByName passes nome in params', () async {
      when(() => mock.call(params: any(named: 'params'))).thenAnswer((_) async => const Ok([kTestCongressPerson]));

      final presenter = GetXHomePresenter(fetchCongressPersonsUseCase: mock);

      await presenter.searchCongressPersonByName(name: 'Silva');
      await Future<void>.delayed(Duration.zero);

      final captured =
          verify(() => mock.call(params: captureAny(named: 'params'))).captured.single as FetchCongressPeopleParams;
      expect(captured.nome, 'Silva');
      expect(captured.siglaUf, isNull);
    });

    test('searchCongressPersonByState skips when state is _all sentinel', () async {
      when(() => mock.call(params: any(named: 'params'))).thenAnswer((_) async => const Ok([kTestCongressPerson]));

      final presenter = GetXHomePresenter(fetchCongressPersonsUseCase: mock);
      await presenter.fetchCongressPersons();
      await Future<void>.delayed(Duration.zero);

      clearInteractions(mock);

      await presenter.searchCongressPersonByState(
        state: BrazilianState.allStatesValue,
      );

      verifyNever(() => mock.call(params: any(named: 'params')));
    });

    test('searchCongressPersonByState skips when state is empty', () async {
      when(() => mock.call(params: any(named: 'params'))).thenAnswer((_) async => const Ok([kTestCongressPerson]));

      final presenter = GetXHomePresenter(fetchCongressPersonsUseCase: mock);
      await presenter.fetchCongressPersons();
      await Future<void>.delayed(Duration.zero);

      clearInteractions(mock);

      await presenter.searchCongressPersonByState(state: '');

      verifyNever(() => mock.call(params: any(named: 'params')));
    });

    test('searchCongressPersonByState passes siglaUf', () async {
      when(() => mock.call(params: any(named: 'params'))).thenAnswer((_) async => const Ok([kTestCongressPerson]));

      final presenter = GetXHomePresenter(fetchCongressPersonsUseCase: mock);

      await presenter.searchCongressPersonByState(state: 'RJ');
      await Future<void>.delayed(Duration.zero);

      final captured =
          verify(() => mock.call(params: captureAny(named: 'params'))).captured.single as FetchCongressPeopleParams;
      expect(captured.siglaUf, 'RJ');
    });
  });
}
