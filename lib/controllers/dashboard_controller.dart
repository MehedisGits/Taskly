import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_model.dart';
import '../utils/date_utils.dart';
import '../utils/error_utils.dart';
import 'task_data_controller.dart';

class DashboardController extends GetxController {
  final TaskController controller = Get.put(TaskController());

  final RxInt selectedCategoryIndex = 0.obs;
  final RxBool isLoading = false.obs;
  final RxMap<String, int> taskCounts = {
    'New': 0,
    'Cancelled': 0,
    'InProgress': 0,
    'Completed': 0,
  }.obs;
  final RxList<Data> visibleTasks = <Data>[].obs;
  final RxList<Data> allTasks = <Data>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadTasks();
  }

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

    // print("✅ Task Counts Saved: Completed: $completed, Cancelled: $cancelled, Total: $total");
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

      combinedTasks.sort((a, b) {
        DateTime dateA = safeParseDate(a.createdDate);
        DateTime dateB = safeParseDate(b.createdDate);
        return dateB.compareTo(dateA);
      });

      allTasks.assignAll(combinedTasks);
      return combinedTasks;
    } catch (e) {
      // print("❌ Error loading all tasks: $e");
      showError("Error", "Failed to load all tasks");
      return [];
    }
  }

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
      showError('Error', 'Failed to load tasks. Please try again.');
      visibleTasks.clear();
    } finally {
      isLoading.value = false;
    }
  }

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

  Future<void> fetchTasksSilent(int index) async {
    String category = _getCategoryByIndex(index);
    try {
      TaskModel taskModel = await controller.fetchTasks(category);
      taskCounts[category] = taskModel.data?.length ?? 0;
    } catch (_) {
      taskCounts[category] = 0;
    }
  }

  String _getCategoryByIndex(int index) {
    switch (index) {
      case 0: return 'New';
      case 1: return 'Cancelled';
      case 2: return 'InProgress';
      case 3: return 'Completed';
      default: return '';
    }
  }
}
