import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';

import '../controller.dart';
import '../models/networkResponse.dart';

class NetworkCaller {
  static final Client _httpClient = Client();

  /// Handles GET requests
  static Future<NetworkResponse> getRequest({required String url}) async {
    try {
      Uri uri = Uri.parse(url);
      log("GET Request URL: $url");

      final Response response =
          await _httpClient.get(uri).timeout(const Duration(seconds: 10));

      log("GET Response: ${response.body}");

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: decodedData,
        );
      } else {
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      log("GET Request Error: $e");
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  /// Handles POST requests
  static Future<NetworkResponse> postRequest({
    required String url,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    try {
      final Map<String, String> reqHeader = {
        "Content-Type": "application/json",
        if (AuthController.accessToken != null)
          "token": AuthController.accessToken!,
        ...?headers, // Add additional headers if provided
      };

      Uri uri = Uri.parse(url);
      log("POST Request URL: $url");
      log("POST Request Headers: $reqHeader");
      log("POST Request Body: ${jsonEncode(body)}");

      final Response response = await _httpClient
          .post(
            uri,
            headers: reqHeader,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(const Duration(seconds: 10));

      log("POST Response: ${response.body}");

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: decodedData,
        );
      } else {
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      log("POST Request Error: $e");
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }
}
