import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/controllers/task_fetching_controller.dart';
import '../models/task_model.dart'; // Contains TaskModel and Data classes.
import '../utils/get_device_type.dart';
import '../utils/responsive_size.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/task_card.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final TaskFetchingController controller = Get.put(TaskFetchingController());
  final RxInt selectedCategoryIndex = 0.obs;
  final RxBool isLoading = false.obs;
  final RxMap<String, int> taskCounts = {
    'New': 0,
    'Cancelled': 0,
    'InProgress': 0,
    'Completed': 0,
  }.obs;

  @override
  Widget build(BuildContext context) {
    double taskCategoryButtonSize = responsiveSize(
      context,
      mobileSize: 12,
      tabletSize: 16,
      desktopSize: 20,
    );

    // Load tasks when screen opens
    loadTasks();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.snackbar('Add a new task', 'Click here to add a new task.',
              margin: const EdgeInsets.all(12));
        },
        backgroundColor: Colors.grey,
        focusColor: Colors.green,
        hoverColor: Colors.green,
        focusElevation: 5,
        child: Icon(
          Icons.add,
          size: screenScale(context) * 40,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Custom App Bar
              CustomAppBar(),
              const SizedBox(height: 10),
              // Task Category Buttons with Badge showing task count
              buildTaskCategoryButtons(taskCategoryButtonSize),
              const SizedBox(height: 12),
              // Task List
              Expanded(
                child: Obx(() {
                  if (isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return FutureBuilder<List<Data>>(
                    future: _getTasksForCategory(
                        selectedCategoryIndex.value), // Fetch tasks
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(
                            child: Text('Error: ${snapshot.error}'));
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text("No tasks found"));
                      }

                      final tasks = snapshot.data!;
                      return ListView.builder(
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          return TaskCard(
                            title: tasks[index].title ?? 'No Title',
                            description: tasks[index].description ??
                                'No Description',
                            isMobile: DeviceType.isMobile(context),
                          );
                        },
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fetch tasks for a selected category and update task counts
  Future<List<Data>> _getTasksForCategory(int selectedCategoryIndex) async {
    String category = _getCategoryByIndex(selectedCategoryIndex);
    try {
      TaskModel taskModel = await controller.fetchTasksByCategory(category);

      if (taskModel.data != null) {
        taskCounts[category] = taskModel.data!.length;
        return taskModel.data!;
      } else {
        taskCounts[category] = 0;
        return [];
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load tasks. Please try again.',
          snackPosition: SnackPosition.BOTTOM);
      return [];
    }
  }

  // Helper function to map category index to category name
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

  // Load tasks for all categories when the screen is opened
  Future<void> loadTasks() async {
    await Future.wait([
      _getTasksForCategory(0), // New
      _getTasksForCategory(1), // Cancelled
      _getTasksForCategory(2), // In Progress
      _getTasksForCategory(3), // Completed
    ]);
  }

  // Category Colors
  final List<Color> categoryColors = [
    Colors.blue,   // New
    Colors.red,    // Cancelled
    Colors.orange, // In Progress
    Colors.green,  // Completed
  ];

  /// Builds Task Category Buttons with Badge for Task Count
  Widget buildTaskCategoryButtons(double buttonSize) {
    List<String> categories = ['New', 'Cancelled', 'InProgress', 'Completed'];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(categories.length, (index) {
        return buildCategoryButton(categories[index], index, buttonSize);
      }),
    );
  }

  /// Builds Individual Category Button with Floating Badge
  Widget buildCategoryButton(String text, int index, double buttonSize) {
    return Obx(() {
      return Stack(
        clipBehavior: Clip.none, // Ensure badge overflows properly
        children: [
          TextButton(
            onPressed: () async {
              selectedCategoryIndex.value = index;
              isLoading.value = true;
              try {
                await _getTasksForCategory(index);
              } catch (e) {
                print("Error fetching tasks: $e");
                Get.snackbar('Error', 'Failed to load tasks. Please try again.',
                    snackPosition: SnackPosition.BOTTOM);
              } finally {
                isLoading.value = false;
              }
            },
            style: TextButton.styleFrom(
              backgroundColor: selectedCategoryIndex.value != index
                  ? categoryColors[index].withOpacity(0.3)
                  : categoryColors[index],
              padding: EdgeInsets.symmetric(
                horizontal: buttonSize,
                vertical: buttonSize,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: Colors.black,
                fontSize: buttonSize,
              ),
            ),
          ),
          // Floating Badge
          Positioned(
            right: -8, // Slightly outside button
            top: -8,  // Slightly outside button
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                taskCounts[text].toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: buttonSize * 0.8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

}
