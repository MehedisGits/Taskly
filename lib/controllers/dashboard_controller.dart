import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/controllers/task_data_controller.dart';
import 'package:task_manager/models/task_model.dart';

class DashboardController extends GetxController {
  final TaskController controller = Get.put(TaskController());

// Maintain task counts for each category in an RxMap
  final RxMap<String, int> taskCounts = {
    'New': 0,
    'Cancelled': 0,
    'InProgress': 0,
    'Completed': 0,
  }.obs;

  /// Save Task Counts for Completed, Cancelled, and Total Task Count
  Future<void> saveTaskCounts() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // 🔹 taskCounts ম্যাপে key না থাকলে, 0 ধরে নেওয়া হবে
    int completed = taskCounts["Completed"] ?? 0;
    int cancelled = taskCounts["Cancelled"] ?? 0;
    int newTasks = taskCounts["New"] ?? 0;
    int inProgress = taskCounts["InProgress"] ?? 0;

    // 🔹 মোট টাস্ক কাউন্ট বের করা
    int total = newTasks + cancelled + inProgress + completed;

    // 🔹 SharedPreferences-এ মান সংরক্ষণ
    await prefs.setInt("CompletedTaskCount", completed);
    await prefs.setInt("CancelledTaskCount", cancelled);
    await prefs.setInt("TotalTaskCount", total);

    print(
        "✅ Task Counts Saved: Completed: $completed, Cancelled: $cancelled, Total: $total");
  }

  /// Fetch tasks for a selected category and update task counts.
  Future<List<Data>> getTasksForCategory(int selectedCategoryIndex) async {
    String category = _getCategoryByIndex(selectedCategoryIndex);
    try {
      TaskModel taskModel = await controller.fetchTasks(category);
      if (taskModel.data != null) {
        taskCounts[category] = taskModel.data!.length;
        // Save counts for specific categories if applicable.
        await saveTaskCounts();
        return taskModel.data!;
      } else {
        taskCounts[category] = 0;
        await saveTaskCounts();
        return [];
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load tasks. Please try again.',
          snackPosition: SnackPosition.BOTTOM);
      return [];
    }
  }

  /// Helper function to map category index to category name.
  String _getCategoryByIndex(int index) {
    switch (index) {
      case 0:
        return 'New';
      case 1:
        return 'Cancelled';
      case 2:
        return 'InProgress';
      case 3:
        return 'Completed';
      default:
        return '';
    }
  }

  /// Load tasks for all categories when the screen is opened.
  Future<void> loadTasks() async {
    await Future.wait([
      getTasksForCategory(0), // New
      getTasksForCategory(1), // Cancelled
      getTasksForCategory(2), // In Progress
      getTasksForCategory(3), // Completed
    ]);
  }
}
