import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_model.dart';
import '../modules/tasks/controller/task_data_controller.dart';
import '../utils/check_internet_connection.dart';
import '../utils/date_utils.dart';
import '../utils/error_utils.dart';

class DashboardController extends GetxController {
  final TaskController controller = Get.put(TaskController());

  final RxInt selectedCategoryIndex = 2.obs; // Default 'All' category (index 2)
  final RxBool isLoading = false.obs;
  final RxMap<String, int> taskCounts = {
    'New': 0,
    'Cancelled': 0,
    'InProgress': 0,
    'Completed': 0,
    'All': 0,
  }.obs;
  final RxList<Data> visibleTasks = <Data>[].obs;

  // Cache invalidation flags for each category
  final RxMap<String, bool> categoryCacheInvalidationFlags = {
    'New': false,
    'Cancelled': false,
    'InProgress': false,
    'Completed': false,
    'All': false,
  }.obs;

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
  }

  // Fetch tasks for a category from the API and save to local storage
  Future<List<Data>> fetchTasksForCategoryFromApi(String category) async {
    try {
      TaskModel taskModel = await controller.fetchTasks(category);
      if (taskModel.data != null) {
        await saveTasksForCategory(category, taskModel.data!);
        return taskModel.data!;
      }
    } catch (e) {
      showError('Error', 'Failed to fetch tasks for $category from API.');
    }
    return [];
  }

  // Save tasks to SharedPreferences (Local storage)
  Future<void> saveTasksForCategory(String category, List<Data> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(tasks.map((e) => e.toJson()).toList());
    await prefs.setString(category, jsonString);
  }

  // Load tasks for a category from SharedPreferences (Local storage)
  Future<List<Data>> loadTasksForCategoryFromLocal(String category) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(category);
    if (jsonString != null) {
      final List decoded = jsonDecode(jsonString);
      return decoded.map<Data>((json) => Data.fromJson(json)).toList();
    }
    return [];
  }

  // Fetch tasks based on category, cache them, and update the UI
  Future<void> fetchTasksForCategory(int index) async {
    selectedCategoryIndex.value = index;
    isLoading.value = true;

    String category = _getCategoryByIndex(index);
    try {
      List<Data> tasks = [];

      if (category == 'All') {
        // For "All" category, combine tasks from all categories
        tasks = await _getAllCategoryTasks();

        // If data is missing for any category, load from API
        if (tasks.isEmpty) {
          await loadTasks();
          tasks = await _getAllCategoryTasks();
        }

        // Sort tasks by creation date
        tasks.sort((a, b) {
          DateTime dateA = safeParseDate(a.createdDate);
          DateTime dateB = safeParseDate(b.createdDate);
          return dateB.compareTo(dateA); // Sort by creation date
        });
      } else {
        // For other categories, load data from local storage
        tasks = await loadTasksForCategoryFromLocal(category);

        // If no data found, fetch from API
        if (tasks.isEmpty) {
          tasks = await fetchTasksForCategoryFromApi(category);
        }
      }

      // Update task counts
      taskCounts[category] = tasks.length;
      // Update the task counts for "All" category as well
      if (category == 'All') {
        taskCounts['New'] = await loadTasksForCategoryFromLocal('New').then((tasks) => tasks.length);
        taskCounts['Cancelled'] = await loadTasksForCategoryFromLocal('Cancelled').then((tasks) => tasks.length);
        taskCounts['InProgress'] = await loadTasksForCategoryFromLocal('InProgress').then((tasks) => tasks.length);
        taskCounts['Completed'] = await loadTasksForCategoryFromLocal('Completed').then((tasks) => tasks.length);
      }

      // Update visible tasks
      visibleTasks.assignAll(tasks);

    } catch (e) {
      showError('Error', 'Failed to load $category tasks.');
      visibleTasks.clear();
    } finally {
      isLoading.value = false;
    }
  }


  // Helper method to get tasks for a specific category
  Future<List<Data>> _getTasksForCategory(String category) async {
    List<Data> tasks = [];

    // Check if the cache is invalidated for this category
    if (categoryCacheInvalidationFlags[category] == true) {
      // Fetch fresh data from the API
      tasks = await fetchTasksForCategoryFromApi(category);
      categoryCacheInvalidationFlags[category] = false; // Reset flag
    } else {
      // Load from cache if data is available
      tasks = await loadTasksForCategoryFromLocal(category);
      if (tasks.isEmpty) {
        tasks = await fetchTasksForCategoryFromApi(category);
      }
    }

    return tasks;
  }

  // Handle tasks for the 'All' category
  Future<List<Data>> _getAllCategoryTasks() async {
    List<Data> allTasks = [];
    List<String> categories = ['New', 'Cancelled', 'InProgress', 'Completed'];

    for (String category in categories) {
      List<Data> categoryTasks = await loadTasksForCategoryFromLocal(category);
      if (categoryTasks.isNotEmpty) {
        allTasks.addAll(categoryTasks);
      } else {
        categoryCacheInvalidationFlags[category] = true; // Mark as needing to fetch
      }
    }

    if (allTasks.isEmpty) {
      // Load tasks from API if no data is available
      await loadTasks();
      return await _getAllCategoryTasks();
    }

    return allTasks;
  }

  // Load tasks for all categories (cached or from API)
  Future<void> loadTasks() async {
    isLoading.value = true;

    if (!(await checkInternetConnection())) {
      showError("No Internet", "Please check your internet connection.");
      isLoading.value = false;
      return;
    }

    try {
      // Fetch tasks for all categories
      await Future.wait([
        fetchTasksForCategory(0),
        fetchTasksForCategory(1),
        fetchTasksForCategory(3),
        fetchTasksForCategory(4),
      ]);
      await fetchTasksForCategory(selectedCategoryIndex.value);
    } finally {
      isLoading.value = false;
    }
  }

  // Utility to map index to category
  String _getCategoryByIndex(int index) {
    switch (index) {
      case 0: return 'Cancelled';
      case 1: return 'New';
      case 2: return 'All';
      case 3: return 'InProgress';
      case 4: return 'Completed';
      default: return '';
    }
  }
}
