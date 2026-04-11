import 'package:get/get.dart';

import '../domain/entities/entities.dart';
import '../domain/result/result.dart';
import '../domain/usecases/usecases.dart';
import '../main/routes/routes.dart';
import '../ui/pages/pages.dart';

class GetXHomePresenter implements HomePresenter {
  final FetchCongressPeopleUseCase fetchCongressPersonsUseCase;
  GetXHomePresenter({
    required this.fetchCongressPersonsUseCase,
  });

  final Rx<HomeViewState> _state = Rx<HomeViewState>(const HomeLoading());

  @override
  Stream<HomeViewState> get congressPersonStream => _state.stream;

  @override
  Future<void> fetchCongressPersons() async {
    _state.value = const HomeLoading();
    final result = await fetchCongressPersonsUseCase.call(
      params: FetchCongressPeopleParams.all(),
    );
    result.fold(
      ok: (list) => _state.value = HomeSuccess(list),
      err: (failure) => _state.value = HomeError(failure),
    );
  }

  @override
  Future<void> searchCongressPersonByName({required String name}) async {
    if (name.isEmpty) return;
    _state.value = const HomeLoading();
    final result = await fetchCongressPersonsUseCase.call(
      params: FetchCongressPeopleParams(nome: name),
    );
    result.fold(
      ok: (list) => _state.value = HomeSuccess(list),
      err: (failure) => _state.value = HomeError(failure),
    );
  }

  @override
  Future<void> searchCongressPersonByState({required String state}) async {
    if (state.isEmpty || state == 'Todos') return;
    _state.value = const HomeLoading();
    final result = await fetchCongressPersonsUseCase.call(
      params: FetchCongressPeopleParams(siglaUf: state),
    );
    result.fold(
      ok: (list) => _state.value = HomeSuccess(list),
      err: (failure) => _state.value = HomeError(failure),
    );
  }

  @override
  void navigateToExpenses({required CongressPersonEntity congressPerson}) {
    Get.toNamed(
      AppRoutes.congressExpenseDetails,
      arguments: {'congressPerson': congressPerson},
    );
  }
}
