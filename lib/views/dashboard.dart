import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/task_data_controller.dart';
import '../utils/get_device_type.dart';
import '../utils/responsive_size.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/task_card.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final TaskController controller = Get.put(TaskController());
  final RxInt selectedCategoryIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    double taskCategoryButtonSize = responsiveSize(
      context,
      mobileSize: 12,
      tabletSize: 16,
      desktopSize: 20,
    );

    // Fetch tasks initially for the default category
    controller.fetchTasks("New");

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
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (controller.isEmpty.value || controller.taskData.value == null) {
                    return const Center(child: Text("No tasks found"));
                  }
                  return ListView.builder(
                    itemCount: controller.taskData.value!.data!.length,
                    itemBuilder: (context, index) {
                      final task = controller.taskData.value!.data![index];
                      return TaskCard(
                        title: task.title ?? 'No Title',
                        description: task.description ?? 'No Description',
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
      onPressed: () {
        selectedCategoryIndex.value = index;
        controller.fetchTasks(text); // Fetch tasks when category changes
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
