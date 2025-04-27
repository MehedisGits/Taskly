import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/utils/get_device_type.dart';
import 'package:task_manager/widgets/bottom_sheet_form.dart';
import '../controllers/dashboard_controller.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/task_category_buttons.dart';
import '../widgets/task_card.dart';
import '../widgets/shimmer_task_card.dart';
import 'utils/responsive_size.dart';
import 'widgets/task_summury_card.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final DashboardController controller = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    double taskCategoryButtonSize = responsiveSize(
      context,
      mobileSize: 28,
      tabletSize: 36,
      desktopSize: 42,
    );

    return Scaffold(
      backgroundColor: Colors.grey[150],
      floatingActionButton: FloatingActionButton(
        elevation: 15,
        onPressed: () {
          // Open bottom sheet with form
          Get.bottomSheet(BottomSheetForm(
            heading: 'Add Task',
          ));
        },
        backgroundColor: Colors.blueAccent,
        isExtended: true,
        tooltip: 'Add Task',
        child: const Icon(
          Icons.add,
          size: 32,
          color: Colors.white,
        ),
      ),
      bottomNavigationBar:
          TaskCategoryBottomNavigationBar(buttonSize: taskCategoryButtonSize),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.loadTasks,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                CustomAppBar(),
                // 👇 New Task Summary Card
                Obx(() => TaskSummaryCard(
                      totalTasks: controller.taskCounts['New']! +
                          controller.taskCounts['Cancelled']! +
                          controller.taskCounts['InProgress']! +
                          controller.taskCounts['Completed']!,
                      completed: controller.taskCounts['Completed'] ?? 0,
                      cancelled: controller.taskCounts['Cancelled'] ?? 0,
                      inProgress: controller.taskCounts['InProgress'] ?? 0,
                    )),

                const SizedBox(height: 12),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return ListView.builder(
                        itemCount: 5,
                        // Display a shimmer for 5 items while loading
                        itemBuilder: (context, index) {
                          return const ShimmerTaskCard(
                            isMobile: true,
                          );
                        },
                      );
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
                          createdDate: task.createdDate ?? '',
                          category: task.status ?? 'Uncategorized',
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
}
