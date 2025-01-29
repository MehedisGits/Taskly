import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskly/views/add_new_tasks_screen.dart';

import '../utils/responsive_size.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String description;
  final bool isMobile;
  final String taskStatus;
  final ValueChanged<String>? onTaskStatusChanged;

  // Initialize currentStatus with the passed taskStatus
  final RxString currentStatus;

  TaskCard({
    required this.title,
    required this.description,
    required this.isMobile,
    required this.taskStatus,
    this.onTaskStatusChanged,
    super.key,
  }) : currentStatus = taskStatus.obs;

  // Handle task completion status update
  void _handleTaskCompletion(bool value) {
    if (value) {
      // Only update if not already completed
      if (currentStatus.value != 'Completed') {
        currentStatus.value = 'Completed';
        onTaskStatusChanged?.call(currentStatus.value);
        // Show Snackbar on completion
        Get.snackbar(
          'Task Completed',
          'You have marked the task as completed.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.7),
          colorText: Colors.white,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleStyle =
    theme.textTheme.bodyLarge?.copyWith(fontSize: isMobile ? 16 : 18);
    final descriptionStyle =
    theme.textTheme.bodyMedium?.copyWith(fontSize: isMobile ? 14 : 16);

    return GestureDetector(
      onTap: () => Get.to(
            () => AddNewTasksScreen(),
        transition: Transition.zoom,
        duration: const Duration(milliseconds: 300),
      ),
      child: Card(
        elevation: 0.5,
        margin: EdgeInsets.symmetric(
          vertical: isMobile ? 8 : 12,
          horizontal: isMobile ? 5 : 12,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTaskHeader(titleStyle, context),
              const SizedBox(height: 8),
              _buildTaskDescription(descriptionStyle),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the task header with title, status indicator, and radio button
  Widget _buildTaskHeader(TextStyle? titleStyle, BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: titleStyle,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        _buildStatusIndicator(context),
        const SizedBox(width: 8),
        // Show radio button only if status is not "Cancelled"
        _buildRadioButton(),
      ],
    );
  }

  /// Builds the colored status indicator circle
  Widget _buildStatusIndicator(BuildContext context) {
    return Obx(() => Container(
      width: responsiveSize(context,
          mobileSize: 16, desktopSize: 24, tabletSize: 20),
      height: responsiveSize(context,
          mobileSize: 16, desktopSize: 24, tabletSize: 20),
      decoration: BoxDecoration(
        color: _getStatusColor(currentStatus.value),
        shape: BoxShape.circle,
      ),
    ));
  }

  /// Builds the radio button (hidden if status is "Cancelled")
  Widget _buildRadioButton() {
    return Obx(() {
      if (currentStatus.value == 'Cancelled') {
        return const SizedBox.shrink(); // Hide if cancelled
      }

      return Transform.scale(
        scale: 0.9,
        child: Radio<String>(
          value: 'Completed',
          groupValue: currentStatus.value,
          onChanged: (value) {
            if (value != null) {
              // Convert value to boolean (true if 'Completed')
              _handleTaskCompletion(value == 'Completed');
            }
          },
        ),
      );
    });
  }

  /// Builds the task description with conditional styling
  Widget _buildTaskDescription(TextStyle? descriptionStyle) {
    return Obx(() => Text(
      description,
      style: descriptionStyle?.copyWith(
        decoration: currentStatus.value == 'Completed'
            ? TextDecoration.lineThrough
            : null,
        color: currentStatus.value == 'Cancelled' ? Colors.red : null,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    ));
  }

  /// Returns color based on task status
  Color _getStatusColor(String status) {
    switch (status) {
      case 'New':
        return Colors.blue;
      case 'InProgress':
        return Colors.orange;
      case 'Completed':
        return Colors.green;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}