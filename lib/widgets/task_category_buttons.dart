import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/core/themes/theme_data.dart';
import '../controllers/dashboard_controller.dart';

class TaskCategoryBottomNavigationBar extends StatelessWidget {
  final double buttonSize;
  final DashboardController controller = Get.find();

  TaskCategoryBottomNavigationBar({super.key, required this.buttonSize});

  static const List<String> categories = [
    'Cancelled',
    'New',
    'All',
    'InProgress',
    'Completed',
  ];

  static const List<Color> categoryColors = [
    Colors.red, // Cancelled
    Colors.blue, // New
    Colors.purple, // All
    Colors.orange, // InProgress
    Colors.green, // Completed
  ];

  static const List<IconData> categoryIcons = [
    Icons.cancel, // Cancelled
    Icons.new_releases, // New
    Icons.all_inclusive, // All
    Icons.timelapse, // InProgress
    Icons.check_circle, // Completed
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Determine whether to show a loading indicator for the selected tab
      bool isLoading = controller.isLoading.value;

      return BottomNavigationBar(
        elevation: 4,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
        currentIndex: controller.selectedCategoryIndex.value,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        onTap: _onCategorySelected,
        items: List.generate(categories.length, (index) {
          final isSelected = controller.selectedCategoryIndex.value == index;
          return BottomNavigationBarItem(
            icon: isLoading && isSelected
                ? CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 2,
            )
                : Container(
              width: buttonSize,
              height: buttonSize,
              decoration: BoxDecoration(
                color: isSelected
                    ? categoryColors[index]
                    : categoryColors[index].withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                categoryIcons[index],
                color: isSelected ? Colors.white : Colors.black,
                size: buttonSize * 0.6,
              ),
            ),
            label: categories[index],
            tooltip: categories[index], // Show a tooltip when the user hovers over a tab
          );
        }),
      );
    });
  }

  Future<void> _onCategorySelected(int index) async {
    controller.isLoading.value = true;
    controller.selectedCategoryIndex.value = index;

    try {
      await controller.fetchTasksForCategory(index);
    } catch (e) {
      // Handle error (e.g., show a Snackbar or a dialog)
      Get.snackbar('Error', 'Failed to load tasks for the selected category');
    } finally {
      controller.isLoading.value = false;
    }
  }

}
