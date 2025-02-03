import 'package:dio/dio.dart';
import '../api_client.dart';

class ApiServices {
  final ApiClient _apiClient = ApiClient();

  /// Generic method to handle POST requests
  Future<Map<String, dynamic>> postRequest({
    required String endpoint,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await _apiClient.client.post(endpoint, data: data);

      // Validate response status code
      if (_isSuccessful(response.statusCode)) {
        return response.data;
      } else {
        throw _handleError(response.statusCode);
      }
    } catch (e) {
      throw _handleException(e);
    }
  }

  /// Generic method to handle GET requests
  Future<Map<String, dynamic>> getRequest({
    required String endpoint,
    required String token,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await _apiClient.client.get(
        endpoint,
        options: Options(headers: {'token': token}),
        queryParameters: queryParams,
      );

      // Validate response status code
      if (_isSuccessful(response.statusCode)) {
        return response.data;
      } else {
        throw _handleError(response.statusCode);
      }
    } catch (e) {
      throw _handleException(e);
    }
  }

  /// Fetch tasks by status using GET request
  Future<Map<String, dynamic>> fetchTaskByStatus({
    required String status,
    required String token,
  }) async {
    final endpoint = 'listTaskByStatus/$status';
    return getRequest(endpoint: endpoint, token: token);
  }

  /// create tasks by status using POST request
  Future<Map<String, dynamic>> createTask({required Map<String, dynamic> taskData}) async {
    final endpoint = 'createTask';
    return postRequest(endpoint: endpoint, data: taskData);
  }

  /// Check if the status code indicates a successful request
  bool _isSuccessful(int? statusCode) {
    return statusCode == 200 || statusCode == 201;
  }

  /// Handle API errors based on status code
  Exception _handleError(int? statusCode) {
    return Exception('Request failed with status code: $statusCode');
  }

  /// Handle exceptions during API calls
  Exception _handleException(dynamic error) {
    return Exception('An error occurred: $error');
  }
}