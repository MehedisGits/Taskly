import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/controllers/task_data_controller.dart';
import 'package:task_manager/services/api_services.dart';

import '../models/task_model.dart';
import '../services/task_storage_service.dart';
import '../utils/check_internet_connection.dart';
import '../utils/date_utils.dart';
import '../utils/error_utils.dart';

class DashboardController extends GetxController {
  final TaskController controller = Get.put(TaskController());
  late TaskStorageService storage;

  final RxInt selectedCategoryIndex =
      2.obs; // 0=Cancelled,1=New,2=All,3=InProgress,4=Completed
  final RxBool isLoading = false.obs;
  final RxMap<String, int> taskCounts = {
    'New': 0,
    'Cancelled': 0,
    'InProgress': 0,
    'Completed': 0,
    'All': 0,
  }.obs;
  final RxList<Data> visibleTasks = <Data>[].obs;

  /// Flags to force refetch from API for each category
  final RxMap<String, bool> refetchFlags = {
    'New': false,
    'Cancelled': false,
    'InProgress': false,
    'Completed': false,
    'All': false,
  }.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    final prefs = await SharedPreferences.getInstance();
    storage = TaskStorageService(prefs);
    await _initializeDashboard();
  }

  Future<void> _initializeDashboard() async {
    isLoading.value = true;
    try {
      await _updateTaskCounts();
      await fetchTasksForCategory(selectedCategoryIndex.value);
    } catch (e) {
      print("💥 Init Error: $e");
      showError('Error', 'Failed to load initial tasks.');
    } finally {
      isLoading.value = false;
    }
  }

  /// Public: fetch tasks by category index
  Future<void> fetchTasksForCategory(int idx) async {
    selectedCategoryIndex.value = idx;
    isLoading.value = true;
    try {
      final cat = _getCategoryByIndex(idx);
      final tasks = await _loadTasksForCategory(cat);
      visibleTasks.assignAll(tasks);
      visibleTasks.refresh();
    } catch (e) {
      print("❌ Category Load Error: $e");
      showError('Error', 'Failed to load tasks.');
      visibleTasks.clear();
    } finally {
      isLoading.value = false;
    }
  }

  /// Core loading logic, respects refetchFlags and handles 'All' specially
  Future<List<Data>> _loadTasksForCategory(String category) async {
    if (category == 'All') {
// Always combine all subcategories; if flag, force API for each
      final force = refetchFlags['All'] == true;
      refetchFlags['All'] = false;
      return _loadAllTasks(forceApi: force);
    }

// For individual category, if flagged, fetch fresh
    if (refetchFlags[category] == true) {
      refetchFlags[category] = false;
      return _fetchAndSaveCategory(category);
    }

// Otherwise load local, then fallback to API if empty
    var tasks = await storage.loadTasks(category);
    if (tasks.isEmpty && await checkInternetConnection()) {
      tasks = await _fetchAndSaveCategory(category);
    }
    taskCounts[category] = tasks.length;
    return tasks;
  }

  /// Load all categories, optionally forcing API fetch for each
  Future<List<Data>> _loadAllTasks({bool forceApi = false}) async {
    final cats = ['New', 'Cancelled', 'InProgress', 'Completed'];
    List<Data> all = [];
    for (var c in cats) {
      List<Data> part;
      if (forceApi) {
        part = await _fetchAndSaveCategory(c);
      } else {
        part = await _loadTasksForCategory(c);
      }
      all.addAll(part);
    }
    all.sort((a, b) =>
        safeParseDate(b.createdDate).compareTo(safeParseDate(a.createdDate)));
    taskCounts['All'] = all.length;
    return all;
  }

  Future<List<Data>> _fetchAndSaveCategory(String category) async {
    try {
      final model = await controller.fetchTasks(category);
      if (model.data != null) {
        await storage.saveTasks(category, model.data!);
        taskCounts[category] = model.data!.length;
        return model.data!;
      }
    } catch (e) {
      print("❌ API Fetch Error: $e");
      showError('API Error', 'Could not fetch $category tasks.');
    }
    return [];
  }
  Future<void> deleteTask(String taskId) async{
    try{
      ApiService apiService = ApiService();
      await apiService.deleteTask(taskId);
      onTaskSaved();
    } catch(e){
      print("❌ Task Delete Error: $e");
      showError('API Error', 'Could not delete $selectedCategoryIndex tasks.');
    }
  }

  Future<void> taskMarkCompleted(String taskId) async {
    try {
      ApiService apiService = ApiService();
      await apiService.updateTaskStatus(taskId, 'Completed');

      // 🔁 Identify current category
      final currentCategory = _getCategoryByIndex(selectedCategoryIndex.value);

      // 🧹 Remove from current list if present (for instant UI feedback)
      visibleTasks.removeWhere((task) => task.sId == taskId);
      visibleTasks.refresh();

      // ✅ Mark 'Completed' and 'All' to be refetched
      refetchFlags['Completed'] = true;
      refetchFlags['All'] = true;

      // ✅ If the current tab is not 'Completed', also mark current category for update
      if (currentCategory != 'Completed') {
        refetchFlags[currentCategory] = true;
      }

      // 🧭 Switch to 'Completed' tab (index 4)
      selectedCategoryIndex.value = 4;

      // 🔄 Fetch completed tasks and update counts
      await fetchTasksForCategory(4);
      await _updateTaskCounts();

      // ✅ Confirm to user
      Get.snackbar('Task Completed', 'Task marked as completed ✅',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      print("❌ Task Mark Completed Error: $e");
      showError('API Error', 'Could not update task status.');
    }
  }



  Future<void> _updateTaskCounts() async {
    final cats = ['New', 'Cancelled', 'InProgress', 'Completed'];
    for (var c in cats) {
      taskCounts[c] = storage.loadTaskCount(c);
    }
    taskCounts['All'] = taskCounts.values.fold(0, (sum, v) => sum + v);
  }

  /// Call after creating/updating a task
  Future<void> onTaskSaved() async {
    final cat = _getCategoryByIndex(selectedCategoryIndex.value);
// mark this category and 'All' to refetch from API next time
    refetchFlags[cat] = true;
    refetchFlags['All'] = true;

    await fetchTasksForCategory(selectedCategoryIndex.value);
    await _updateTaskCounts();
  }

  String _getCategoryByIndex(int i) {
    switch (i) {
      case 0:
        return 'Cancelled';
      case 1:
        return 'New';
      case 2:
        return 'All';
      case 3:
        return 'InProgress';
      case 4:
        return 'Completed';
      default:
        return 'All';
    }
  }
}
