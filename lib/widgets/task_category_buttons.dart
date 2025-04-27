import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/core/themes/theme_data.dart';
import '../controllers/dashboard_controller.dart';

class TaskCategoryBottomNavigationBar extends StatelessWidget {
  final double buttonSize;
  TaskCategoryBottomNavigationBar({super.key, required this.buttonSize});

  final DashboardController controller = Get.find();

  final List<Color> categoryColors = [
    Colors.purple, // All
    Colors.blue, // New
    Colors.red, // Cancelled
    Colors.orange, // InProgress
    Colors.green, // Completed
  ];


  @override
  Widget build(BuildContext context) {
    List<String> categories = ['All', 'New', 'Cancelled', 'InProgress', 'Completed'];

    return Obx(() {
      return BottomNavigationBar(
        elevation: 4,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
        currentIndex: controller.selectedCategoryIndex.value,
        onTap: (index) async {
          // Reset loading state for the new index
          controller.isLoading.value = true;
          // Update the tasks based on the selected category
          if (index == 0) {
            controller.visibleTasks.value = await controller.getAllTasksSortedByTime();
          } else {
            await controller.fetchTasksForCategory(controller.selectedCategoryIndex.value);
          }
          controller.selectedCategoryIndex.value = index;
          controller.isLoading.value = false; // Reset loading state after the operation
        },
        selectedItemColor: AppColors.primary, // Color for selected label
        unselectedItemColor: Colors.black, // Color for unselected label
        items: List.generate(categories.length, (index) {
          bool isSelected = controller.selectedCategoryIndex.value == index;

          return BottomNavigationBarItem(
            icon: Container(
              width: buttonSize,
              height: buttonSize,
              decoration: BoxDecoration(
                color: isSelected ? categoryColors[index] : categoryColors[index].withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: index == 33 // Show progress indicator for selected index only
                  ? controller.isLoading.value && controller.selectedCategoryIndex.value == index
                  ? const CircularProgressIndicator(
                strokeWidth: 3,
                color: AppColors.primary,
              )
                  : Icon(
                Icons.timelapse, // Use 'timelapse' icon for in-progress state
                color: isSelected ? Colors.white : Colors.black,
                size: buttonSize * 0.6,
              )
                  : Icon(
                _getIconForCategory(index),
                color: isSelected ? Colors.white : Colors.black,
                size: buttonSize * 0.6,
              ),
            ),
            label: categories[index], // Pass the category name directly as a string
          );
        }),
      );
    });
  }

  IconData _getIconForCategory(int index) {
    switch (index) {
      case 0:
        return Icons.all_inclusive; // Icon for 'All'
      case 1:
        return Icons.new_releases; // Icon for 'New'
      case 2:
        return Icons.cancel; // Icon for 'Cancelled'
      case 4:
        return Icons.check_circle; // Icon for 'Completed'
      default:
        return Icons.incomplete_circle; // Default icon
    }
  }
}
