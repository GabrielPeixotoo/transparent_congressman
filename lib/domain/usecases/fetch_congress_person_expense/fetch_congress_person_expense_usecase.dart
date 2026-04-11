import '../../entities/entities.dart';
import '../../result/result.dart';

abstract class FetchCongressPersonExpenseUseCase {
  Future<Result<List<CongressPersonExpenseEntity>>> call({required String id});
}
