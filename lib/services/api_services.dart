import 'package:task_manager/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/models/task_model.dart';

class ApiService {
  final ApiClient apiClient = ApiClient();
  static String? token;

  // Ensure token is loaded before making API requests
  Future<void> _ensureToken() async {
    if (token == null) {
      final prefs = await SharedPreferences.getInstance();
      token = prefs.getString('token');

      if (token != null) {
        apiClient.dio.options.headers['token'] = token!;
      }
    }
  }

  // Register a new user
  Future<dynamic> registerUser(Map<String, dynamic> userData) async {
    try {
      final response = await apiClient.post('Registration', userData);
      return response.data;
    } catch (e) {
      print('Error registering user: $e');
      throw Exception('Failed to register user');
    }
  }

  // Login user
  Future<dynamic> loginUser(Map<String, dynamic> userData) async {
    try {
      final response = await apiClient.post('Login', userData);

      // Save token in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      token = response.data['token'];
      await prefs.setString('token', token!);

      // Update API Client Header with new Token
      apiClient.dio.options.headers['token'] = token!;

      return response.data;
    } catch (e) {
      print('Error logging in user: $e');
      throw Exception('Failed to log in');
    }
  }

  // Fetch all tasks by category
  // Fetch all tasks by category
  Future<TaskModel> fetchTasks(String category) async {
    try {
      await _ensureToken(); // ✅ Ensure token is set before request
      print("Token ✅ : $token");

      final response = await apiClient.get('listTaskByStatus/$category');

      // Ensure that the response contains data and parse it
      if (response.data != null) {
        return TaskModel.fromJson(response.data); // Convert JSON response to TaskModel
      } else {
        throw Exception('No data found');
      }
    } catch (e) {
      print('Error fetching tasks: $e');
      throw Exception('Failed to fetch tasks');
    }
  }

}
