import '../../../domain/entities/entities.dart';
import '../../../domain/errors/failure.dart';

sealed class HomeViewState {
  const HomeViewState();
}

final class HomeLoading extends HomeViewState {
  const HomeLoading();
}

final class HomeSuccess extends HomeViewState {
  const HomeSuccess(this.items);
  final List<CongressPersonEntity> items;
}

final class HomeError extends HomeViewState {
  const HomeError(this.failure);
  final Failure failure;
}
