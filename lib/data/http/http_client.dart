enum RequestMethod { get, post }

abstract class HttpClient {
  Future<dynamic> request({
    required String url,
    required RequestMethod method,
    Map<String, String> headers = const {},
    Map body = const {},
  });
}
