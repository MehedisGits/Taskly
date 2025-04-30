import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/widgets/task_categories.dart';
import '../controllers/dashboard_controller.dart';
import '../core/themes/theme_data.dart';
import '../models/task_category.dart';

class TaskCategoryBottomNavigationBar extends StatelessWidget {
  final double buttonSize;
  final DashboardController controller = Get.find();

  TaskCategoryBottomNavigationBar({
    super.key,
    required this.buttonSize,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return BottomNavigationBar(
        elevation: 4,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        currentIndex: controller.selectedCategoryIndex.value,
        onTap: controller.fetchTasksForCategory,
        items: List.generate(taskCategories.length, (index) {
          final category = taskCategories[index];
          final isSelected = controller.selectedCategoryIndex.value == index;
          return _buildBottomNavigationBarItem(category, isSelected, index);
        }),
      );
    });
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
      TaskCategory category, bool isSelected, int index) {
    return BottomNavigationBarItem(
      icon: controller.isLoading.value && isSelected
          ? const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      )
          : _buildCategoryIcon(category, isSelected),
      label: category.name,
      tooltip: category.name,
    );
  }

  Widget _buildCategoryIcon(TaskCategory category, bool isSelected) {
    return Container(
      width: buttonSize,
      height: buttonSize,
      decoration: BoxDecoration(
        color: isSelected
            ? category.color
            : category.color.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        category.icon,
        size: buttonSize * 0.5,
        color: isSelected ? Colors.white : Colors.black,
      ),
    );
  }
}
