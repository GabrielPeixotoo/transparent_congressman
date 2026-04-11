import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/usecases.dart';
import '../factories.dart';

FetchCongressPeopleUseCase makeFetchCongressPersonUseCase() =>
    RemoteFetchCongressPersons(
      url: makeApiUrl('/deputados'),
      httpClient: makeDioAdapter(),
    );
