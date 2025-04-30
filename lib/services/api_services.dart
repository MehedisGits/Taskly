import 'dart:convert';

import 'package:get/get_connect/http/src/response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/models/task_model.dart';
import 'package:task_manager/models/user_model.dart';
import 'package:task_manager/services/api_client.dart';

class ApiService {
  final ApiClient apiClient = ApiClient();
  static String? _token;

  /// ----------------------------
  /// Token Management
  /// ----------------------------

  Future<void> _ensureToken() async {
    if (_token == null) {
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('token');
    }

    if (_token != null) {
      apiClient.dio.options.headers['Authorization'] = 'Bearer $_token';
      apiClient.dio.options.headers['token'] = _token;
    } else {
      throw Exception("Missing token! Please login again.");
    }
  }

  /// ----------------------------
  /// Authentication
  /// ----------------------------

  Future<dynamic> registerUser(Map<String, dynamic> userData) async {
    try {
      final response = await apiClient.post('Registration', userData);
      return response.data;
    } catch (e) {
      print('❌ Error registering user: $e');
      throw Exception('Failed to register user');
    }
  }

  Future<dynamic> loginUser(Map<String, dynamic> userData) async {
    try {
      final response = await apiClient.post('Login', userData);

      final prefs = await SharedPreferences.getInstance();
      _token = response.data['token'];
      await prefs.setString('token', _token!);
      apiClient.dio.options.headers['Authorization'] = 'Bearer $_token';
      apiClient.dio.options.headers['token'] = _token;

      return response.data;
    } catch (e) {
      print('❌ Login error: $e');
      throw Exception('Login failed');
    }
  }

  /// ----------------------------
  /// Task Management
  /// ----------------------------

  Future<TaskModel> fetchTasks(String category) async {
    try {
      await _ensureToken();

      final response = await apiClient.get('listTaskByStatus/$category');
      final prefs = await SharedPreferences.getInstance();

      if (response.data != null) {
        final data = response.data;

        // Save total task count
        prefs.setInt('totalTasks', data['totalTasks'] ?? 0);

        // Optional: Save category-wise counts if available
        prefs.setInt('${category}_completedCount', data['completedCount'] ?? 0);
        prefs.setInt('${category}_cancelledCount', data['cancelledCount'] ?? 0);

        return TaskModel.fromJson(data);
      } else {
        throw Exception('No task data found for $category');
      }
    } catch (e) {
      print('❌ Error fetching tasks for $category: $e');
      throw Exception('Failed to fetch tasks');
    }
  }

  Future<void> createTask(String title, String desc, String status) async {
    try {
      await _ensureToken();

      final body = {
        'title': title,
        'description': desc,
        'status': status,
      };

      final response = await apiClient.post('createTask', body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Task added to $status');
      } else {
        print("❌ Response: ${response.data}");
        throw Exception('Failed to create task');
      }
    } catch (e) {
      print('❌ Create task error: $e');
      throw Exception('Could not create task');
    }
  }

  Future<void> updateTaskStatus(String taskId, String taskStatus) async {
    try {
      await _ensureToken();

      final String endpoint = 'updateTaskStatus/$taskId/$taskStatus';
      final response = await apiClient.get(endpoint);

      if (response.statusCode == 200) {
        print('✅ Task status updated to $taskStatus');
      } else {
        print("❌ Server response: ${response.data}");
        throw Exception('Update failed');
      }
    } catch (e) {
      print('❌ Update task error: $e');
      throw Exception('Failed to update task status');
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _ensureToken();
      final String endpoint = 'deleteTask/$taskId';

      final response = await apiClient.delete(endpoint);
      if (response.statusCode == 200) {
        print('✅ Task deleted successfully');
      } else {
        print("❌ Server response: ${response.data}");
        throw Exception('Delete failed');
      }
    } catch (e) {
      print('❌ Update task error: $e');
      throw Exception('Failed to Delete task');
    }
  }

  /// ----------------------------
  /// User Data
  /// ----------------------------

  Future<UserDetails> fetchUserData() async {
    try {
      await _ensureToken();

      final response = await apiClient.get('ProfileDetails');
      final prefs = await SharedPreferences.getInstance();

      if (response.data != null) {
        prefs.setString('userDetails', jsonEncode(response.data));
        return UserDetails.fromJson(response.data);
      } else {
        throw Exception('User data missing');
      }
    } catch (e) {
      print('❌ User fetch error: $e');
      throw Exception('Could not fetch user details');
    }
  }

  /// ----------------------------
  /// Logout
  /// ----------------------------

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clears all data
    _token = null;
    apiClient.dio.options.headers.clear();
    print("🧹 User logged out and local data cleared.");
  }
}
