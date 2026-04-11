import '../../../domain/entities/entities.dart';
import '../../../domain/errors/failure.dart';
import '../../../domain/result/result.dart';
import '../../../domain/usecases/usecases.dart';
import '../../http/http.dart';
import '../../models/models.dart';

class RemoteFetchCongressPersonExpense
    implements FetchCongressPersonExpenseUseCase {
  final String url;
  final HttpClient client;

  RemoteFetchCongressPersonExpense({required this.url, required this.client});

  @override
  Future<Result<List<CongressPersonExpenseEntity>>> call(
      {required String id}) async {
    try {
      final String requestUrl = '$url/$id/despesas?ordem=DESC&ordenarPor=ano';
      final response = await client.request(
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
            (json) =>
                CongressPersonExpenseModel.fromMap(json: json).toEntity(),
          )
          .toList();
      return Result.ok(list);
    } on HttpClientException catch (e) {
      return Result.err(e.failure);
    } catch (e) {
      return Result.err(UnknownFailure(e));
    }
  }
}
