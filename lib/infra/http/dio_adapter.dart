import 'package:dio/dio.dart';
import '../../data/http/http.dart';

class DioAdapter implements HttpClient {
  final Dio dio;
  DioAdapter({
    required this.dio,
  });

  @override
  Future<dynamic> request(
      {required String url,
      required RequestMethod method,
      Map<String, String> headers = const {},
      Map body = const {}}) async {
    try {
      final Map<String, dynamic> dioHeaders = {};

      dioHeaders
        ..addAll(headers)
        ..addAll({
          'content-type': 'application/json',
          'accept': 'application/json',
          'User-Agent': 'Deputados-App-Teste',
        });

      final response = await dio.request(url, options: Options(method: method.name.toUpperCase()));

      return _handleResponse(response);
    } on DioError catch (error) {
      print(error);
      throw Exception();
    }
  }

  dynamic _handleResponse(Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data ?? {};
    } else if (response.statusCode == 204) {
      return {};
    }
  }
}
