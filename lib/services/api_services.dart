import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/models/task_model.dart';
import 'package:task_manager/models/user_model.dart';
import 'package:task_manager/services/api_client.dart';

class ApiService {
  final ApiClient apiClient = ApiClient();
  static String? token;

  /// ----------------------------
  /// Token Management
  /// ----------------------------

  /// Ensure token is loaded before making API requests.
  Future<void> _ensureToken() async {
    if (token == null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      token = prefs.getString('token');

      if (token != null) {
        _setTokenHeaders(token!);
      }
    }
  }

  /// Set token headers in the API client.
  void _setTokenHeaders(String token) {
    apiClient.dio.options.headers['Authorization'] = 'Bearer $token';
    apiClient.dio.options.headers['token'] = token;
  }

  /// ----------------------------
  /// User Authentication
  /// ----------------------------

  /// Registers a new user.
  Future<dynamic> registerUser(Map<String, dynamic> userData) async {
    try {
      final response = await apiClient.post('Registration', userData);
      return response.data;
    } catch (e) {
      print('Error registering user: $e');
      throw Exception('Failed to register user');
    }
  }

  /// Logs in the user and saves the token.
  Future<dynamic> loginUser(Map<String, dynamic> userData) async {
    try {
      final response = await apiClient.post('Login', userData);

      // Save token in SharedPreferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      token = response.data['token'];
      await prefs.setString('token', token!);

      // Update API Client Header with new Token
      _setTokenHeaders(token!);

      return response.data;
    } catch (e) {
      print('Error logging in user: $e');
      throw Exception('Failed to log in');
    }
  }

  /// ----------------------------
  /// Task Management
  /// ----------------------------

  /// Fetches all tasks by category.
  /// Saves category-specific counts for "Completed" and "Cancelled"
  /// and always saves the total task count from the fetched response.
  Future<TaskModel> fetchTasks(String category) async {
    try {
      // Ensure token is set before request.
      await _ensureToken();
      print("Token ✅ : $token");

      // Update token headers.
      _setTokenHeaders(token!);
      print("Request Headers: ${apiClient.dio.options.headers}");

      final response = await apiClient.get('listTaskByStatus/$category');

      // Get SharedPreferences instance.
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      // Parse and return TaskModel if data exists.
      if (response.data != null) {
        return TaskModel.fromJson(response.data);
      } else {
        throw Exception('No data found');
      }
    } catch (e) {
      print('Error fetching tasks: $e');
      throw Exception('Failed to fetch tasks');
    }
  }

  /// ----------------------------
  /// User Data Management
  /// ----------------------------

  /// Fetches user details from the API and saves them in SharedPreferences.
  Future<UserDetails> fetchUserData() async {
    try {
      await _ensureToken();

      final response = await apiClient.get('ProfileDetails');

      if (response.data != null) {
        final SharedPreferences preferences =
            await SharedPreferences.getInstance();

        // Save user details as a JSON string.
        await preferences.setString('userDetails', jsonEncode(response.data));

        // Return the UserDetails object parsed from the response.
        return UserDetails.fromJson(response.data);
      } else {
        throw Exception('No data found');
      }
    } catch (e) {
      print('Error fetching details: $e');
      throw Exception('Failed to fetch details');
    }
  }
}
