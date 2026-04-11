import 'dart:async';

import 'package:Deputado_Transparente/domain/errors/failure.dart';
import 'package:Deputado_Transparente/l10n/app_localizations.dart';
import 'package:Deputado_Transparente/ui/pages/congress_person_expense/congress_expense_view_state.dart';
import 'package:Deputado_Transparente/ui/pages/congress_person_expense/congress_person_expense_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/congress_person_expense_fixtures.dart';
import '../../../helpers/congress_person_fixtures.dart';
import '../../../mocks/mock_congress_person_expense_presenter.dart';

/// Avoid [WidgetTester.pumpAndSettle]: loading uses [CircularProgressIndicator]
/// (non-terminating animation) and the header loads a network image.
Future<void> _pumpExpensePageReady(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 50));
  await tester.pump(const Duration(milliseconds: 50));
}

void main() {
  setUpAll(() {
    registerFallbackValue('');
  });

  tearDown(() {
    Get.reset();
  });

  group('CongressPersonExpensePage', () {
    late MockCongressPersonExpensePresenter mockPresenter;
    late StreamController<CongressExpenseViewState> streamController;

    setUp(() {
      mockPresenter = MockCongressPersonExpensePresenter();
      streamController = StreamController<CongressExpenseViewState>.broadcast();
      when(() => mockPresenter.congressPersonExpenseStream).thenAnswer((_) => streamController.stream);
    });

    tearDown(() async {
      await streamController.close();
    });

    testWidgets('shows expense list after presenter reports success', (tester) async {
      when(() => mockPresenter.fetchCongressPersonExpense(id: any(named: 'id'))).thenAnswer((_) async {
        await Future<void>.delayed(Duration.zero);
        streamController.add(
          const CongressExpenseSuccess([kTestCongressPersonExpense]),
        );
      });

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: CongressPersonExpensePage(
            presenter: mockPresenter,
            congressPersonForTest: kTestCongressPerson,
          ),
        ),
      );
      await _pumpExpensePageReady(tester);

      expect(find.text(kTestCongressPersonExpense.tipoDespesa), findsOneWidget);
      verify(() => mockPresenter.fetchCongressPersonExpense(id: '1')).called(1);
    });

    testWidgets('shows error message and retry calls fetch again', (tester) async {
      when(() => mockPresenter.fetchCongressPersonExpense(id: any(named: 'id'))).thenAnswer((_) async {
        await Future<void>.delayed(Duration.zero);
        streamController.add(const CongressExpenseError(NetworkFailure()));
      });

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: CongressPersonExpensePage(
            presenter: mockPresenter,
            congressPersonForTest: kTestCongressPerson,
          ),
        ),
      );
      await _pumpExpensePageReady(tester);

      final l10n = AppLocalizations.of(
        tester.element(find.byType(CongressPersonExpensePage)),
      )!;
      expect(find.text(l10n.errorNetwork), findsOneWidget);

      when(() => mockPresenter.fetchCongressPersonExpense(id: any(named: 'id'))).thenAnswer((_) async {
        await Future<void>.delayed(Duration.zero);
        streamController.add(
          const CongressExpenseSuccess([kTestCongressPersonExpense]),
        );
      });

      await tester.tap(find.text(l10n.retry));
      await _pumpExpensePageReady(tester);

      expect(find.text(kTestCongressPersonExpense.tipoDespesa), findsOneWidget);
      verify(() => mockPresenter.fetchCongressPersonExpense(id: '1')).called(2);
    });

    testWidgets('shows empty state when success has no items', (tester) async {
      when(() => mockPresenter.fetchCongressPersonExpense(id: any(named: 'id'))).thenAnswer((_) async {
        await Future<void>.delayed(Duration.zero);
        streamController.add(const CongressExpenseSuccess([]));
      });

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: CongressPersonExpensePage(
            presenter: mockPresenter,
            congressPersonForTest: kTestCongressPerson,
          ),
        ),
      );
      await _pumpExpensePageReady(tester);

      final l10n = AppLocalizations.of(
        tester.element(find.byType(CongressPersonExpensePage)),
      )!;
      expect(find.text(l10n.expensesNoData), findsOneWidget);
    });
  });
}
