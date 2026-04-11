import 'package:Deputado_Transparente/domain/errors/failure.dart';
import 'package:Deputado_Transparente/domain/result/result.dart';
import 'package:Deputado_Transparente/presentation/getx_congress_person_expense_presenter.dart';
import 'package:Deputado_Transparente/ui/pages/congress_person_expense/congress_expense_view_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/congress_person_expense_fixtures.dart';
import '../mocks/mock_fetch_congress_person_expense_use_case.dart';

void main() {
  setUpAll(() {
    registerFallbackValue('');
  });

  tearDown(Get.reset);

  group('GetXCongressPersonExpensePresenter', () {
    late MockFetchCongressPersonExpenseUseCase mock;

    setUp(() {
      mock = MockFetchCongressPersonExpenseUseCase();
    });

    test('fetchCongressPersonExpense emits success with list from use case', () async {
      when(() => mock.call(id: any(named: 'id'))).thenAnswer(
        (_) async => const Ok([kTestCongressPersonExpense]),
      );

      final presenter = GetXCongressPersonExpensePresenter(
        fetchCongressPersonExpenseUseCase: mock,
      );

      CongressExpenseViewState? last;
      final sub = presenter.congressPersonExpenseStream.listen((s) => last = s);
      await presenter.fetchCongressPersonExpense(id: '42');
      await Future<void>.delayed(Duration.zero);

      expect(last, isA<CongressExpenseSuccess>());
      expect(
        (last as CongressExpenseSuccess).items,
        [kTestCongressPersonExpense],
      );

      final captured = verify(() => mock.call(id: captureAny(named: 'id'))).captured.single as String;
      expect(captured, '42');
      await sub.cancel();
    });

    test('fetchCongressPersonExpense emits error when use case fails', () async {
      when(() => mock.call(id: any(named: 'id'))).thenAnswer(
        (_) async => const Err(ServerFailure(502)),
      );

      final presenter = GetXCongressPersonExpensePresenter(
        fetchCongressPersonExpenseUseCase: mock,
      );

      CongressExpenseViewState? last;
      final sub = presenter.congressPersonExpenseStream.listen((s) => last = s);
      await presenter.fetchCongressPersonExpense(id: '7');
      await Future<void>.delayed(Duration.zero);

      expect(last, isA<CongressExpenseError>());
      expect((last as CongressExpenseError).failure, isA<ServerFailure>());
      verify(() => mock.call(id: any(named: 'id'))).called(1);
      await sub.cancel();
    });
  });
}
