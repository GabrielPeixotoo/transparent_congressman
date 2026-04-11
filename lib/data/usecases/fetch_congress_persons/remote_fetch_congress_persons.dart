import '../../http/http.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/usecases.dart';
import '../../models/models.dart';

class RemoteFetchCongressPersons implements FetchCongressPeopleUseCase {
  final String url;
  final HttpClient httpClient;

  RemoteFetchCongressPersons({required this.url, required this.httpClient});

  @override
  Future<List<CongressPersonEntity>> call({required FetchCongressPeopleParams params}) async {
    try {
      final requestUrl = _queryFactory(params: params);
      final response = await httpClient.request(
        url: requestUrl,
        method: RequestMethod.get,
      );
      return (response['dados'] as List)
          .map(
            (e) => CongressPersonModel.fromMap(json: e as Map).toEntity(),
          )
          .toList();
    } catch (e) {
      return [];
    }
  }

  String _queryFactory({required FetchCongressPeopleParams params}) {
    if (params.nome != null) {
      return '$url?nome=${params.nome}';
    } else if (params.siglaUf != null) {
      return '$url?siglaUf=${params.siglaUf}';
    } else {
      return '$url?ordem=${params.ordem}&ordenarPor=${params.ordenarPor}';
    }
  }
}
