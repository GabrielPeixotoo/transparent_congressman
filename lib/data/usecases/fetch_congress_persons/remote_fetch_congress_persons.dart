import '../../http/http.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/errors/failure.dart';
import '../../../domain/result/result.dart';
import '../../../domain/usecases/usecases.dart';
import '../../models/models.dart';

class RemoteFetchCongressPersons implements FetchCongressPeopleUseCase {
  final String url;
  final HttpClient httpClient;

  RemoteFetchCongressPersons({required this.url, required this.httpClient});

  @override
  Future<Result<List<CongressPersonEntity>>> call({
    required FetchCongressPeopleParams params,
  }) async {
    try {
      final requestUrl = _queryFactory(params: params);
      final response = await httpClient.request(
        url: requestUrl,
        method: RequestMethod.get,
      );
      if (response is! Map) {
        return const Result.err(ParseFailure('Response is not a JSON object'));
      }
      final raw = response['dados'];
      if (raw is! List) {
        return const Result.err(ParseFailure('Missing or invalid dados list'));
      }
      final list = raw
          .map(
            (e) => CongressPersonModel.fromMap(json: e as Map).toEntity(),
          )
          .toList();
      return Result.ok(list);
    } on HttpClientException catch (e) {
      return Result.err(e.failure);
    } catch (e) {
      return Result.err(UnknownFailure(e));
    }
  }

  String _queryFactory({required FetchCongressPeopleParams params}) {
    final nome = params.nome;
    if (nome != null && nome.isNotEmpty) {
      return '$url?nome=$nome';
    }
    final uf = params.siglaUf;
    if (uf != null && uf.isNotEmpty) {
      return '$url?siglaUf=$uf';
    }
    final ordem = params.ordem ?? 'ASC';
    final ordenarPor = params.ordenarPor ?? 'nome';
    return '$url?ordem=$ordem&ordenarPor=$ordenarPor';
  }
}
