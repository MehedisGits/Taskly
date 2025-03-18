import 'package:dio/dio.dart';

class ApiClient {
  late Dio dio;

  ApiClient() {
    dio = Dio(BaseOptions(
      baseUrl: 'http://35.73.30.144:2005/api/v1/',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Add Interceptors for logging, authentication, etc.
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('➡️ Request: ${options.method} ${options.uri}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('✅ Response: ${response.statusCode} ${response.data}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          if (e.type == DioExceptionType.connectionTimeout) {
            print('⏳ Connection Timeout');
          } else if (e.type == DioExceptionType.receiveTimeout) {
            print('⏳ Receive Timeout');
          } else if (e.response != null) {
            print('❌ Error: ${e.response?.statusCode} - ${e.response?.statusMessage}');
          } else {
            print('⚠️ Unexpected Error: ${e.message}');
          }
          return handler.next(e);
        },
      ),
    );
  }

  // GET Request
  Future<Response> get(String endpoint) async {
    return await dio.get(endpoint);
  }

  // POST Request
  Future<Response> post(String endpoint, dynamic data) async {
    return await dio.post(endpoint, data: data);
  }

  // PUT Request
  Future<Response> put(String endpoint, dynamic data) async {
    return await dio.put(endpoint, data: data);
  }

  // DELETE Request
  Future<Response> delete(String endpoint) async {
    return await dio.delete(endpoint);
  }
}
