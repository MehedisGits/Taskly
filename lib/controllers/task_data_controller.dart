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


  // Fetch tasks by category
  Future<TaskModel> fetchTasks(String category) async {
    try {
      _startLoading();

      // Get the token from SharedPreferences
      final token = _getToken();
      if (token == null) {
        throw Exception('Token is missing');
      }

      print('Fetching tasks for: $category');

      // Call the API to fetch tasks
      TaskModel response = await _apiService.fetchTasks(category);

      // Update the task data with the API response
      _updateTaskData(response);
      return response;

    } catch (e) {
      // Log the error and show the snackbar with the error message
      _handleError(e, category);

      // Return an empty TaskModel to handle the error gracefully
      return TaskModel();  // Return an empty task model to prevent app crashes
    } finally {
      _stopLoading();
    }
  }

  // Retrieves the token from SharedPreferences
  String? _getToken() {
    final token = _sharedPreferences.getString('token');
    print('Retrieved token: $token');
    return token;
  }

  // Update task data state
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

  // Handle errors and show an appropriate snackbar
  void _handleError(dynamic error, String category) {
    isEmpty.value = true;
    taskData.value = null;
    print('Error fetching tasks for $category: $error');

    Get.snackbar(
      'Error',
      'Failed to fetch tasks for category: $category. Error: $error',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  // Start loading state
  void _startLoading() {
    isLoading.value = true;
    print('Loading started');
  }

  // Stop loading state
  void _stopLoading() {
    isLoading.value = false;
    print('Loading stopped');
  }
}
