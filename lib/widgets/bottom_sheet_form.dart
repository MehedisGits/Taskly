import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/controllers/dashboard_controller.dart';
import 'package:task_manager/services/api_services.dart';
import 'package:task_manager/widgets/custom_button.dart';
import '../controllers/task_form_controller.dart';

class BottomSheetForm extends StatelessWidget {
  final String heading;
  final String? id;
  final String? title;
  final String? description;
  final String? status;

  BottomSheetForm({
    super.key,
    required this.heading,
    this.id,
    this.title,
    this.description,
    this.status,
  });

  final ApiService _apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Initialize controller once per widget lifecycle
    final TaskFormController controller =
        Get.put(TaskFormController(), tag: 'taskForm');

    // Load data when the controller is first initialized
    controller.loadData(
      id: id,
      title: title,
      description: description,
      status: status,
    );

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: Container(
        color: theme.colorScheme.surface,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDragHandle(),
              _buildHeader(theme, controller),
              const SizedBox(height: 24),
              _buildTextField(
                controller: controller.titleController,
                label: 'Task Title',
                theme: theme,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: controller.descriptionController,
                label: 'Task Description',
                maxLines: 3,
                theme: theme,
              ),
              const SizedBox(height: 20),
              _buildStatusLabel(theme),
              const SizedBox(height: 12),
              _buildStatusSelector(theme, controller),
              const SizedBox(height: 30),
              CustomButton(
                text: controller.isEdit ? 'Update Task' : 'Save Task',
                onPressed: () => _onSavePressed(controller),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDragHandle() => Center(
        child: Container(
          width: 40,
          height: 5,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.grey[400],
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

  Widget _buildHeader(ThemeData theme, TaskFormController controller) {
    return Center(
      child: Text(
        controller.isEdit ? '✏️ Edit Task' : '🌱 Add Task',
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: theme.colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildStatusLabel(ThemeData theme) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'Task Status',
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildStatusSelector(ThemeData theme, TaskFormController controller) {
    final primaryColor = theme.colorScheme.primary;

    return Obx(() => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: controller.statuses.map((status) {
              final isSelected = controller.selectedStatus.value == status;
              return GestureDetector(
                onTap: () => controller.setStatus(status),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 12),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? _getStatusColor(status, primaryColor)
                        : theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? _getStatusColor(status, primaryColor)
                          : Colors.grey[400]!,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : theme.colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ));
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required ThemeData theme,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: theme.colorScheme.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      ),
    );
  }

  Color _getStatusColor(String status, Color fallback) {
    switch (status) {
      case 'Cancelled':
        return Colors.red;
      case 'New':
        return Colors.blue;
      case 'InProgress':
        return Colors.orange;
      case 'Completed':
        return Colors.green;
      default:
        return fallback;
    }
  }

  void _onSavePressed(TaskFormController controller) async {
    final title = controller.titleController.text.trim();
    final description = controller.descriptionController.text.trim();
    final status = controller.selectedStatus.value;

    if (title.isEmpty || description.isEmpty) {
      Get.snackbar(
        'Incomplete',
        'Please fill in all fields.',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final dashboard = Get.find<DashboardController>();
    final taskId = id ?? '';

    try {
      controller.isAddingOrUpdating.value = true;

      if (controller.isEdit) {
        await _apiService.updateTaskStatus(taskId, status);
      } else {
        await _apiService.createTask(title, description, status);
      }

      // clear form
      Future.delayed(const Duration(milliseconds: 300), controller.clearForm);

      // close sheet
      Get.back();

      // <-- NEW: refetch from API & refresh counts/UI
      await dashboard.onTaskSaved();

      Get.snackbar(
        'Success',
        'Task "$title" saved with status "$status".',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong while saving the task.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      controller.isAddingOrUpdating.value = false;
    }
  }
}
