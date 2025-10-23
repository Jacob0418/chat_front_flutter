import 'package:dio/dio.dart';
import 'env.dart';

class ApiClient {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: EnvConfig.baseUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 60),
    sendTimeout: const Duration(seconds: 15),
  ));

  Dio get dio => _dio;

  Future<Response> post(String path, Map<String, dynamic> data,
      {bool stream = false}) async {
    if (stream) {
      return _dio.post(path, data: data,
          options: Options(responseType: ResponseType.stream));
    }
    return _dio.post(path, data: data);
  }

  Future<Response> get(String path) async => _dio.get(path);
}