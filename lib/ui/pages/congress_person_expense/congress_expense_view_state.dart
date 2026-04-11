import '../../../domain/entities/entities.dart';
import '../../../domain/errors/failure.dart';

sealed class CongressExpenseViewState {
  const CongressExpenseViewState();
}

final class CongressExpenseLoading extends CongressExpenseViewState {
  const CongressExpenseLoading();
}

final class CongressExpenseSuccess extends CongressExpenseViewState {
  const CongressExpenseSuccess(this.items);
  final List<CongressPersonExpenseEntity> items;
}

final class CongressExpenseError extends CongressExpenseViewState {
  const CongressExpenseError(this.failure);
  final Failure failure;
}
