import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/models/task_model.dart';
import '../services/api_services.dart';

class TaskController extends GetxController {
  final ApiService _apiService = ApiService();

  // Observables
  final Rx<TaskModel?> taskData = Rx<TaskModel?>(null);
  final RxBool isEmpty = false.obs;
  final RxBool isLoading = false.obs;

  final SharedPreferences _sharedPreferences = Get.find();

  /// Fetches tasks by category (endpoint)
  Future<void> fetchTasks(String category) async {
    try {
      _startLoading();
      final String? token = _getToken();

      if (token == null) {
        throw Exception('Token is missing');
      }

      print('Fetching tasks for: $category with token: $token');

      TaskModel response = await _apiService.fetchTasks(category);
      print('API Response: $response');

      _updateTaskData(response);
    } catch (e) {
      _handleError(e);
    } finally {
      _stopLoading();
    }
  }

  /// Retrieves the token from SharedPreferences
  String? _getToken() {
    final token = _sharedPreferences.getString('token');
    print('Retrieved token: $token');
    return token;
  }

  /// Updates the task data state
  void _updateTaskData(TaskModel response) {
    if (response.data == null || response.data!.isEmpty) {
      isEmpty.value = true;
      taskData.value = null;
      print('No tasks found');
    } else {
      isEmpty.value = false;
      taskData.value = response;
      print('Tasks successfully updated');
    }
  }

  /// Handles errors and updates UI
  void _handleError(dynamic error) {
    isEmpty.value = true;
    taskData.value = null;
    print('Error fetching tasks: $error');

    Get.snackbar(
      'Error',
      'Failed to fetch tasks: $error',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  /// Starts loading
  void _startLoading() {
    isLoading.value = true;
    print('Loading started');
  }

  /// Stops loading
  void _stopLoading() {
    isLoading.value = false;
    print('Loading stopped');
  }
}
