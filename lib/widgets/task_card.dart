import 'package:Taskly/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String description;
  final bool isMobile;
  final String taskStatus; // Task status as a string
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  TaskCard({
    required this.title,
    required this.description,
    required this.isMobile,
    required this.taskStatus, // Accept task status as a string
    this.onEdit,
    this.onDelete,
    super.key,
  });

  // Status color map as a function
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
        return Colors.grey; // Default color for unknown status
    }
  }

  @override
  Widget build(BuildContext context) {
    final RxBool isExpanded = false.obs; // Observable for expansion state
    final theme = Theme.of(context);

    // Responsive styles
    final titleStyle = theme.textTheme.bodyLarge?.copyWith(
      fontSize: isMobile ? 16 : 18,
    );
    final descriptionStyle = theme.textTheme.bodyMedium?.copyWith(
      fontSize: isMobile ? 14 : 16,
    );

    return GestureDetector(
      onTap: () {
        isExpanded.value = !isExpanded.value; // Toggle expansion
      },
      child: Card(
        shadowColor: Colors.green[100],
        elevation: 1.5,
        margin: EdgeInsets.symmetric(
          vertical: isMobile ? 8 : 12,
          horizontal: isMobile ? 5 : 12,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Task Header (Title + Status Indicator)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Task Title
                  Expanded(
                    child: Text(
                      title,
                      style: titleStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Status Indicator
                  Container(
                    width: responsiveSize(context, mobileSize: 16, desktopSize: 24, tabletSize: 20),
                    height: responsiveSize(context, mobileSize: 16, desktopSize: 24, tabletSize: 20),
                    decoration: BoxDecoration(
                      color: _getStatusColor(taskStatus), // Status color based on string
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Task Description with Expand/Collapse
              Obx(() {
                return AnimatedCrossFade(
                  firstChild: Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: descriptionStyle,
                  ),
                  secondChild: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          description,
                          style: descriptionStyle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: onEdit ??
                                    () {
                                  Get.snackbar('Edit Task', 'Edit task clicked');
                                },
                            icon: Icon(Icons.edit_note_outlined, color: Colors.green),
                          ),
                          IconButton(
                            onPressed: onDelete ??
                                    () {
                                  Get.snackbar('Delete Task', 'Delete task clicked');
                                },
                            icon: Icon(Icons.delete_sweep_outlined, color: Colors.red),
                          ),
                        ],
                      ),
                    ],
                  ),
                  crossFadeState: isExpanded.value
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 300),
                );
              }),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
