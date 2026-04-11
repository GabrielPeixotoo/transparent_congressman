import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/usecases.dart';
import '../factories.dart';

FetchCongressPersonExpenseUseCase makeFetchCongressPersonExpense() =>
    RemoteFetchCongressPersonExpense(
      url: makeApiUrl('/deputados'),
      client: makeDioAdapter(),
    );
