import '../../../../presentation/presentation.dart';
import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

CongressPersonExpensePresenter makeCongressPersonExpensePresenter() =>
    GetXCongressPersonExpensePresenter(
      fetchCongressPersonExpenseUseCase: makeFetchCongressPersonExpense(),
    );
