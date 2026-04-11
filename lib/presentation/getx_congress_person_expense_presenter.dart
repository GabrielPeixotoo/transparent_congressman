import '../domain/entities/entities.dart';
import 'package:get/get.dart';

import '../domain/usecases/usecases.dart';
import '../ui/pages/pages.dart';

class GetXCongressPersonExpensePresenter
    implements CongressPersonExpensePresenter {
  final FetchCongressPersonExpenseUseCase fetchCongressPersonExpenseUseCase;
  final Rx<List<CongressPersonExpenseEntity>?> _congressExpenses = Rx(null);

  GetXCongressPersonExpensePresenter(
      {required this.fetchCongressPersonExpenseUseCase});
  @override
  Stream<List<CongressPersonExpenseEntity>?> get congressPersonExpenseStream =>
      _congressExpenses.stream;

  @override
  Future<void> fetchCongressPersonExpense({required String id}) async {
    try {
      final expenses = await fetchCongressPersonExpenseUseCase.call(id: id);
      _congressExpenses.subject.add(expenses);
    } catch (e) {
      throw Exception(e);
    }
  }
}
