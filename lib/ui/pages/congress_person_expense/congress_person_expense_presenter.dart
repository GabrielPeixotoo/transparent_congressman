import '../../../domain/entities/entities.dart';

abstract class CongressPersonExpensePresenter {
  Stream<List<CongressPersonExpenseEntity>?> get congressPersonExpenseStream;
  Future<void> fetchCongressPersonExpense({
    required String id,
  });
}
