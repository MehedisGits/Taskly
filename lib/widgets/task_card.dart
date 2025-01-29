import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskly/views/add_new_tasks.dart';

import '../utils/responsive_size.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String description;
  final bool isMobile;
  final String taskStatus;
  final ValueChanged<bool?>?
      onMarkCompleted; // Added callback for completed status change

  TaskCard({
    required this.title,
    required this.description,
    required this.isMobile,
    required this.taskStatus,
    this.onMarkCompleted, // Initialize callback
    super.key,
  });

  final RxBool isCompleted = false.obs; // Observing the completion status

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleStyle =
        theme.textTheme.bodyLarge?.copyWith(fontSize: isMobile ? 16 : 18);
    final descriptionStyle =
        theme.textTheme.bodyMedium?.copyWith(fontSize: isMobile ? 14 : 16);

    return GestureDetector(
      onTap: () => Get.to(AddNewTasksScreen(),
          transition: Transition.zoom, duration: Duration(milliseconds: 300)),
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

  /// **Task Header: Title + Status Indicator**
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
        // Add space between the status and the radio button
        _buildRadioButton(),
      ],
    );
  }

  /// **Status Indicator (Colored Circle)**
  Widget _buildStatusIndicator(BuildContext context) {
    return Container(
      width: responsiveSize(context,
          mobileSize: 16, desktopSize: 24, tabletSize: 20),
      height: responsiveSize(context,
          mobileSize: 16, desktopSize: 24, tabletSize: 20),
      decoration: BoxDecoration(
        color: _getStatusColor(taskStatus),
        shape: BoxShape.circle,
      ),
    );
  }

  /// **Radio Button for Marking Task as Completed**
  Widget _buildRadioButton() {
    return Obx(() => Transform.scale(
          scale: 0.9, // Optional: reduces the size of the Radio button
          child: Radio<bool>(
            value: true,
            groupValue: isCompleted.value ? true : null,
            onChanged: (value) {
              isCompleted.value = value ?? false;

              if (isCompleted.value) {
                // Show Snackbar when task is marked as completed
                Get.snackbar(
                  'Task Completed', // Title of the snackbar
                  'You have marked the task as completed.', // Message
                  snackPosition: SnackPosition.BOTTOM,
                  // Position at the bottom
                  backgroundColor: Colors.green.withValues(alpha: 0.5),
                  // Background color
                  colorText: Colors.white, // Text color
                );
              }

              if (onMarkCompleted != null) {
                onMarkCompleted!(
                    isCompleted.value); // Pass the updated completion status
              }
            },
          ),
        ));
  }

  /// **Task Description**
  Widget _buildTaskDescription(TextStyle? descriptionStyle) {
    return Text(
      description,
      style: descriptionStyle,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}
