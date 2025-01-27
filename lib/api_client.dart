import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://35.73.30.144:2005/api/v1/",
      // Base URL for API requests
      connectTimeout: Duration(seconds: 10),
      // Timeout for establishing a connection
      receiveTimeout: Duration(seconds: 10),
      // Timeout for receiving a response
      headers: {
        'Content-Type': 'application/json',
        // Default content type for requests
        // You can add other headers here, such as Authorization token if required
      },
    ),
  );



  // You can add interceptors to handle requests globally (for example, adding auth tokens)
  void addInterceptors() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Add authorization token if required before the request
        // For example:
        // options.headers['Authorization'] = 'Bearer yourToken';
        return handler.next(options); // Continue with the request
      },
      onResponse: (response, handler) {
        // Handle the response (e.g., logging)
        return handler.next(response); // Continue with the response
      },
      onError: (DioException e, handler) {
        // Handle errors (e.g., logging)
        return handler.next(e); // Continue with the error
      },
    ));
  }

  Dio get client => _dio; // Expose Dio client
}
