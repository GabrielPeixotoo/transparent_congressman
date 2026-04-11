import 'congress_expense_view_state.dart';

abstract class CongressPersonExpensePresenter {
  Stream<CongressExpenseViewState> get congressPersonExpenseStream;
  Future<void> fetchCongressPersonExpense({
    required String id,
  });
}
