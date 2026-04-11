import '../../entities/entities.dart';

abstract class FetchCongressPersonExpenseUseCase {
  Future<List<CongressPersonExpenseEntity>> call({required String id});
}
