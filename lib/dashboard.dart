import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/dashboard_controller.dart';
import 'utils/get_device_type.dart';
import 'utils/responsive_size.dart';
import 'widgets/custom_app_bar.dart';
import 'widgets/task_card.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final DashboardController controller = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    double taskCategoryButtonSize = responsiveSize(
      context,
      mobileSize: 12,
      tabletSize: 16,
      desktopSize: 20,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.loadTasks();
    });

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.snackbar('Add a new task', 'Click here to add a new task.',
              margin: const EdgeInsets.all(12));
        },
        backgroundColor: Colors.grey,
        child: const Icon(Icons.add, size: 40),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.loadTasks,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                CustomAppBar(),
                const SizedBox(height: 10),
                buildTaskCategoryButtons(taskCategoryButtonSize),
                const SizedBox(height: 12),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (controller.visibleTasks.isEmpty) {
                      return const Center(child: Text("No tasks found"));
                    }

                    return ListView.builder(
                      itemCount: controller.visibleTasks.length,
                      itemBuilder: (context, index) {
                        final task = controller.visibleTasks[index];
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
      ),
    );
  }

  final List<Color> categoryColors = [
    Colors.blue,
    Colors.red,
    Colors.orange,
    Colors.green,
  ];

  Widget buildTaskCategoryButtons(double buttonSize) {
    List<String> categories = ['New', 'Cancelled', 'InProgress', 'Completed'];

    return Obx(() => Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(categories.length, (index) {
        bool isSelected = controller.selectedCategoryIndex.value == index;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            TextButton(
              onPressed: () => controller.fetchTasksForCategory(index),
              style: TextButton.styleFrom(
                backgroundColor: isSelected
                    ? categoryColors[index]
                    : categoryColors[index].withOpacity(0.3),
                padding: EdgeInsets.symmetric(
                  horizontal: buttonSize,
                  vertical: buttonSize,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                categories[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontSize: buttonSize,
                ),
              ),
            ),
            Positioned(
              right: -8,
              top: -8,
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  controller.taskCounts[categories[index]]?.toString() ??
                      '0',
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
      }),
    ));
  }
}
