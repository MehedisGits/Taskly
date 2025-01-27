import '../api_client.dart';

class ApiServices {
  final ApiClient _apiClient = ApiClient();

  // POST Request for Authentication
  Future<Map<String, dynamic>> authPost(
      String endpoint, Map<String, dynamic> data) async {
    try {
      // Making the POST request using ApiClient's Dio client
      final response = await _apiClient.client.post(endpoint, data: data);

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusMessage == 'success') {
        return response.data;
      } else {
        // Handle unexpected status codes
        throw Exception('Unexpected status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

// GET Request for getting tasks data
}
