import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskly/services/api_services.dart';

class TaskListController extends GetxController {
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
        throw Exception('Token is missing');
      }

      final response = await _apiServices.fetchTaskByStatus(status: endpoint, token: token);
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
  }

  /// Stops the loading state
  void _stopLoading() {
    isLoading.value = false;
  }

  /// Retrieves the token from SharedPreferences
  String? _getToken() {
    return _sharedPreferences.getString('token');
  }

  /// Updates task data and empty state based on the API response
  void _updateTaskData(Map<String, dynamic> response) {
    if (response['data'] == null || response['data'].isEmpty) {
      isEmpty.value = true; // Mark as empty if no tasks are found
      taskData.value = null;
    } else {
      isEmpty.value = false; // Mark as not empty if tasks are found
      taskData.value = response;
    }
  }

  /// Handles errors during data fetching
  void _handleError(dynamic error) {
    taskData.value = null;
    isEmpty.value = true; // Mark as empty in case of error
    Get.snackbar(
      'Error',
      'Failed to fetch task data: $error',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}