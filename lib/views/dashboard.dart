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
  // Change reactive list type to Data (individual tasks), not TaskModel.
  final RxList<Data> tasks = <Data>[].obs;

  @override
  Widget build(BuildContext context) {
    double taskCategoryButtonSize = responsiveSize(
      context,
      mobileSize: 12,
      tabletSize: 16,
      desktopSize: 20,
    );

    // Load tasks when screen opens.
    // Note: For optimal performance, consider moving loadTasks() to initState() of a StatefulWidget.
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
              // Task Category Buttons
              buildTaskCategoryButtons(taskCategoryButtonSize),
              const SizedBox(height: 12),
              // Task List
              Expanded(
                child: Obx(() {
                  if (isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (tasks.isEmpty) {
                    return const Center(child: Text("No tasks found"));
                  }
                  return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      // Use dot notation to access properties.
                      return TaskCard(
                        title: tasks[index].title ?? 'No Title',
                        description: tasks[index].description ?? 'No Description',
                        isMobile: DeviceType.isMobile(context),
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

  Future<void> loadTasks() async {
    isLoading.value = true;
    try {
      // Fetch data from API. Controller returns a TaskModel.
      TaskModel taskModel = await controller.fetchTasksByCategory('New');

      // Check if there are tasks available and data is not null.
      if (taskModel.data != null && taskModel.data!.isNotEmpty) {
        tasks.value = taskModel.data!; // Assign the list of task data.
      } else {
        tasks.clear();
        Get.snackbar('No tasks found', 'No tasks available for this category.',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print("Error: $e");
      Get.snackbar('Error', 'Failed to load tasks. Please try again.',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  // Category Colors
  final List<Color> categoryColors = [
    Colors.blue,   // New
    Colors.red,    // Cancelled
    Colors.orange, // In Progress
    Colors.green,  // Completed
  ];

  /// Builds Task Category Buttons
  Widget buildTaskCategoryButtons(double buttonSize) {
    List<String> categories = ['New', 'Cancelled', 'In Progress', 'Completed'];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(categories.length, (index) {
        return buildCategoryButton(categories[index], index, buttonSize);
      }),
    );
  }

  /// Builds Individual Category Button
  Widget buildCategoryButton(String text, int index, double buttonSize) {
    return Obx(() => TextButton(
      onPressed: () async {
        selectedCategoryIndex.value = index;
        isLoading.value = true; // Show loading.
        try {
          TaskModel taskModel = await controller.fetchTasksByCategory(text);
          // Null check for taskModel and its data before assigning.
          if (taskModel.data != null && taskModel.data!.isNotEmpty) {
            tasks.value = taskModel.data!;
          } else {
            tasks.clear();
            Get.snackbar('Error', 'No tasks available for this category.',
                snackPosition: SnackPosition.BOTTOM);
          }
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
    ));
  }
}
