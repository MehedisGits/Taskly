import 'dart:convert';

import 'package:http/http.dart';
import 'package:taskly/api/models/networkResponse.dart';
import 'package:taskly/api/urls.dart';

class NetworkCaller {
  /// Handles GET requests
  static Future<NetworkResponse> getRequest({required String url}) async {
    try {
      Uri uri = Uri.parse(url);
      final Response response = await get(uri);

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
    required Map<String, dynamic> body,
  }) async {
    try {
      Uri uri = Uri.parse(url);
      final Response response = await post(
        uri,
        headers: reqHeader,
        body: jsonEncode(body),
      );

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
      return NetworkResponse(
        isSuccess: false,
        statusCode: 404,
        errorMessage: e.toString(),
      );
    }
  }
}
