import 'package:get/get.dart';

import '../domain/result/result.dart';
import '../domain/usecases/usecases.dart';
import '../ui/pages/pages.dart';

class GetXCongressPersonExpensePresenter
    implements CongressPersonExpensePresenter {
  final FetchCongressPersonExpenseUseCase fetchCongressPersonExpenseUseCase;

  GetXCongressPersonExpensePresenter(
      {required this.fetchCongressPersonExpenseUseCase});

  final Rx<CongressExpenseViewState> _state =
      Rx<CongressExpenseViewState>(const CongressExpenseLoading());

  @override
  Stream<CongressExpenseViewState> get congressPersonExpenseStream =>
      _state.stream;

  @override
  Future<void> fetchCongressPersonExpense({required String id}) async {
    _state.value = const CongressExpenseLoading();
    final result = await fetchCongressPersonExpenseUseCase.call(id: id);
    result.fold(
      ok: (list) => _state.value = CongressExpenseSuccess(list),
      err: (failure) => _state.value = CongressExpenseError(failure),
    );
  }
}
