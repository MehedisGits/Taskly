import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/utils/get_device_type.dart';
import 'package:task_manager/widgets/bottom_sheet_form.dart';
import 'package:task_manager/widgets/task_summury_card.dart';
import '../controllers/dashboard_controller.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/task_category_buttons.dart';
import '../widgets/task_card.dart';
import '../widgets/shimmer_task_card.dart';
import '../utils/responsive_size.dart';
import 'controllers/task_form_controller.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final DashboardController controller = Get.put(DashboardController());

  static const double _padding = 8.0;
  static const double _fabIconSize = 32.0;
  static const int _shimmerItemCount = 5;

  @override
  Widget build(BuildContext context) {
    final double taskCategoryButtonSize = responsiveSize(
      context,
      mobileSize: 28,
      tabletSize: 36,
      desktopSize: 42,
    );

    return Scaffold(
      floatingActionButton: _buildFloatingActionButton(context),
      bottomNavigationBar:
          TaskCategoryBottomNavigationBar(buttonSize: taskCategoryButtonSize),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: Padding(
            padding: const EdgeInsets.all(_padding),
            child: _buildBody(),
          ),
        ),
      ),
    );
  }

  // Floating Action Button
  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      elevation: 12,
      onPressed: () => Get.bottomSheet(
        BottomSheetForm(heading: 'Add Task', status: 'New',),
        isScrollControlled: true,
      ).whenComplete(() {
        // 🧹 Clear form controller state after bottom sheet closes
        final tag = 'taskForm';
        if (Get.isRegistered<TaskFormController>(tag: tag)) {
          Get.find<TaskFormController>(tag: tag).clearForm();
          Get.delete<TaskFormController>(tag: tag); // optional but clean
        }
      }),
      backgroundColor: Theme.of(context).colorScheme.primary,
      isExtended: true,
      tooltip: 'Add Task',
      child: const Icon(
        Icons.add,
        size: _fabIconSize,
        color: Colors.white,
      ),
    );
  }

  // Main Body
  Widget _buildBody() {
    return Column(
      children: [
        CustomAppBar(),
        const SizedBox(height: 12),
        Obx(() => TaskSummaryCard(
              totalTasks: _calculateTotalTasks(),
              completed: controller.taskCounts['Completed'] ?? 0,
              cancelled: controller.taskCounts['Cancelled'] ?? 0,
              inProgress: controller.taskCounts['InProgress'] ?? 0,
            )),
        const SizedBox(height: 12),
        Expanded(child: Obx(_buildTaskList)),
      ],
    );
  }

  // Task List (Shimmer or Tasks)
  Widget _buildTaskList() {
    final TaskFormController taskFormController = TaskFormController();
    if (taskFormController.isAddingOrUpdating.value) {
      controller.controller.isLoading == true.obs;
    }
    if (controller.isLoading.value) {
      return ListView.builder(
        itemCount: _shimmerItemCount,
        itemBuilder: (context, index) => const ShimmerTaskCard(isMobile: true),
      );
    }

    if (controller.visibleTasks.isEmpty) {
      return const Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "🌱",
            style: TextStyle(fontSize: 32),
          ),
          Text("No tasks found"),
        ],
      ));
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
          taskId: task.sId ?? 'Don\'t have an Id',
          taskStatus: task.status ?? 'New',
          onDelete: () => controller.deleteTask(task.sId ?? ''),
          onComplete: () => controller.taskMarkCompleted(task.sId ?? ''),
        );
      },
    );
  }

  // Handle Pull-to-Refresh
  Future<void> _onRefresh() async {
    controller.isLoading.value = true;
    await controller
        .fetchTasksForCategory(controller.selectedCategoryIndex.value);
    controller.isLoading.value = false;
  }

  // Calculate Total Tasks
  int _calculateTotalTasks() {
    return (controller.taskCounts['New'] ?? 0) +
        (controller.taskCounts['Cancelled'] ?? 0) +
        (controller.taskCounts['InProgress'] ?? 0) +
        (controller.taskCounts['Completed'] ?? 0);
  }
}
