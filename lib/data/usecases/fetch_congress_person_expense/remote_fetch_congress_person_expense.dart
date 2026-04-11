import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/usecases.dart';
import '../../http/http.dart';
import '../../models/models.dart';

class RemoteFetchCongressPersonExpense
    implements FetchCongressPersonExpenseUseCase {
  final String url;
  final HttpClient client;

  RemoteFetchCongressPersonExpense({required this.url, required this.client});
  @override
  Future<List<CongressPersonExpenseEntity>> call({required String id}) async {
    try {
      final String requestUrl = '$url/$id/despesas?ordem=DESC&ordenarPor=ano';
      final response = await client.request(
        url: requestUrl,
        method: RequestMethod.get,
      );
      return (response['dados'] as List)
          .map(
            (json) => CongressPersonExpenseModel.fromMap(json: json).toEntity(),
          )
          .toList();
    } catch (e) {
      throw Exception();
    }
  }
}
