import 'package:get/get.dart';
import 'package:task_manager/models/task_model.dart';
import '../services/api_services.dart';

class TaskFetchingController extends GetxController {
  final ApiService apiService = ApiService();

  // Fetch tasks by category
  Future<TaskModel> fetchTasksByCategory(String category) async {
    try {
      // Call the API service to fetch tasks
      return await apiService.fetchTasks(category);
    } catch (e) {
      // Handle error and return a default empty TaskModel
      print('Error fetching tasks: $e');
      return TaskModel(status: 'error', data: []); // Returning an empty TaskModel in case of error
    }
  }
}
