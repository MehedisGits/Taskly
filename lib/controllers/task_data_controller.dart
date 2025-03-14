import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskly/services/api_services.dart';

class TaskDataController extends GetxController {
  // Observable for task data
  final Rx<Map<String, dynamic>?> taskData = Rx<Map<String, dynamic>?>(null);
  final RxBool isEmpty = false.obs; // To track if the task list is empty
  final RxBool isLoading = false.obs; // To track loading state

  final ApiServices _apiServices = ApiServices();
  final SharedPreferences _sharedPreferences = Get.find();

  /// Fetches task data based on the provided endpoint
  Future<void> fetchData(String endpoint) async {
    try {
      _startLoading();

      final String? token = _getToken();
      if (token == null) {
        print('Token is missing'); // Log the token issue
        throw Exception('Token is missing');
      }

      print('Fetching tasks for category: $endpoint with token: $token'); // Log API request

      final response = await _apiServices.fetchTaskByStatus(status: endpoint, token: token);

      print('API Response: $response'); // Log API response

      _updateTaskData(response);
    } catch (e) {
      _handleError(e);
    } finally {
      _stopLoading();
    }
  }

  /// Starts the loading state
  void _startLoading() {
    isLoading.value = true;
    print('Loading started'); // Log loading start
  }

  /// Stops the loading state
  void _stopLoading() {
    isLoading.value = false;
    print('Loading stopped'); // Log loading stop
  }

  /// Retrieves the token from SharedPreferences
  String? _getToken() {
    final token = _sharedPreferences.getString('token');
    print('Retrieved token: $token'); // Log token retrieval
    return token;
  }

  /// Updates task data and empty state based on the API response
  void _updateTaskData(Map<String, dynamic> response) {
    if (response['data'] == null || response['data'].isEmpty) {
      isEmpty.value = true; // Mark as empty if no tasks are found
      taskData.value = null;
      print('No tasks found in response'); // Log empty task list
    } else {
      isEmpty.value = false; // Mark as not empty if tasks are found
      taskData.value = response;
      print('Tasks successfully fetched and updated'); // Log task update
    }
  }

  /// Handles errors during data fetching
  void _handleError(dynamic error) {
    taskData.value = null;
    isEmpty.value = true; // Mark as empty in case of error
    print('Error occurred while fetching tasks: $error'); // Log error
    Get.snackbar(
      'Error',
      'Failed to fetch task data: $error',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}
