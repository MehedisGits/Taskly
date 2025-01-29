import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskly/services/api_services.dart';

class TaskListController extends GetxController {
  // Observable for task data
  Rx<Map<String, dynamic>?> taskData = Rx<Map<String, dynamic>?>(null);
  RxBool isEmpty = false.obs; // To track if the task list is empty
  RxBool isLoading = false.obs; // To track loading state

  ApiServices apiServices = ApiServices();

  Future<void> fetchData(String endpoint) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final String? token = sharedPreferences.getString('token');

    try {
      if (token == null) {
        throw Exception('Token is missing');
      }

      // Set isLoading to true when the data fetching begins
      isLoading.value = true;

      final response = await apiServices.fetchTaskByStatus(endpoint, token);

      // Check if the data is empty
      if (response['data'] == null || response['data'].isEmpty) {
        isEmpty.value = true; // Set isEmpty to true if the list is empty
        taskData.value = null;
      } else {
        isEmpty.value = false; // Set isEmpty to false if there are tasks
        taskData.value = response;
      }
    } catch (e) {
      // Handle errors by setting taskData to null and optionally logging the error
      taskData.value = null;
      isEmpty.value = true; // Mark as empty in case of error (optional)
      Get.snackbar("Error", "Failed to fetch task data: $e");
    } finally {
      // Set isLoading to false once the data fetching is completed
      isLoading.value = false;
    }
  }
}
