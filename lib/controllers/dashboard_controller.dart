import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/task_model.dart';
import 'task_data_controller.dart';

class DashboardController extends GetxController {
  final TaskController controller = Get.put(TaskController());

  /// State Observables
  final RxInt selectedCategoryIndex = 0.obs;
  final RxBool isLoading = false.obs;

  /// Task counts by category
  final RxMap<String, int> taskCounts = {
    'New': 0,
    'Cancelled': 0,
    'InProgress': 0,
    'Completed': 0,
  }.obs;

  /// Current visible task list
  final RxList<Data> visibleTasks = <Data>[].obs;

  /// All tasks sorted by time
  final RxList<Data> allTasks = <Data>[].obs;

  /// Save Task Counts (persisted using SharedPreferences)
  Future<void> saveTaskCounts() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    int completed = taskCounts["Completed"] ?? 0;
    int cancelled = taskCounts["Cancelled"] ?? 0;
    int newTasks = taskCounts["New"] ?? 0;
    int inProgress = taskCounts["InProgress"] ?? 0;
    int total = newTasks + cancelled + inProgress + completed;

    await prefs.setInt("CompletedTaskCount", completed);
    await prefs.setInt("CancelledTaskCount", cancelled);
    await prefs.setInt("TotalTaskCount", total);

    print("✅ Task Counts Saved: Completed: $completed, Cancelled: $cancelled, Total: $total");
  }

  Future<List<Data>> getAllTasksSortedByTime() async {
    try {
      List<String> categories = ['New', 'Cancelled', 'InProgress', 'Completed'];
      List<Data> combinedTasks = [];

      for (String category in categories) {
        TaskModel taskModel = await controller.fetchTasks(category);
        if (taskModel.data != null) {
          combinedTasks.addAll(taskModel.data!);

        }
      }

      // 🔽 Safe sort by createdAt (latest first)
      combinedTasks.sort((a, b) {
        DateTime dateA = _safeParseDate(a.createdDate);
        DateTime dateB = _safeParseDate(b.createdDate);
        return dateB.compareTo(dateA);
      });

      allTasks.assignAll(combinedTasks);
      return combinedTasks;
    } catch (e) {
      print("❌ Error loading all tasks: $e");
      Get.snackbar("Error", "Failed to load all tasks");
      return [];
    }
  }

// Helper method to safely parse date
  DateTime _safeParseDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) {
      return DateTime(1970); // fallback
    }
    try {
      return DateTime.parse(dateStr);
    } catch (_) {
      print("⚠️ Invalid date format: $dateStr");
      return DateTime(1970);
    }
  }


  /// Fetch and update tasks for a specific category
  Future<void> fetchTasksForCategory(int index) async {
    selectedCategoryIndex.value = index;
    isLoading.value = true;

    String category = _getCategoryByIndex(index);
    try {
      TaskModel taskModel = await controller.fetchTasks(category);

      if (taskModel.data != null) {
        taskCounts[category] = taskModel.data!.length;
        visibleTasks.assignAll(taskModel.data!);
      } else {
        taskCounts[category] = 0;
        visibleTasks.clear();
      }

      await saveTaskCounts();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load tasks. Please try again.',
          snackPosition: SnackPosition.BOTTOM);
      visibleTasks.clear();
    } finally {
      isLoading.value = false;
    }
  }

  /// Load all tasks and update counts
  Future<void> loadTasks() async {
    isLoading.value = true;
    try {
      await Future.wait([
        fetchTasksSilent(0),
        fetchTasksSilent(1),
        fetchTasksSilent(2),
        fetchTasksSilent(3),
      ]);
      await fetchTasksForCategory(selectedCategoryIndex.value);
      await getAllTasksSortedByTime();
    } finally {
      isLoading.value = false;
    }
  }

  /// Silent fetching for count updates only
  Future<void> fetchTasksSilent(int index) async {
    String category = _getCategoryByIndex(index);
    try {
      TaskModel taskModel = await controller.fetchTasks(category);
      taskCounts[category] = taskModel.data?.length ?? 0;
    } catch (_) {
      taskCounts[category] = 0;
    }
  }

  /// Index to category string mapper
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
}
