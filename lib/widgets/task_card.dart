import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';  // For date formatting

class TaskCard extends StatelessWidget {
  final String title;
  final String description;
  final bool isMobile;
  final String createdDate;
  final String category;

  TaskCard({
    required this.title,
    required this.description,
    required this.isMobile,
    required this.createdDate,
    required this.category,
    super.key,
  });

  // Use GetX to manage the expanded state
  final RxBool _isExpanded = false.obs;

  @override
  Widget build(BuildContext context) {
    // Format created date using intl package
    DateTime parsedDate = DateTime.parse(createdDate);
    String formattedDate = DateFormat('MMM dd, yyyy').format(parsedDate);

    return Card(
      elevation: 4, // Increased elevation for better shadow effect
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: EdgeInsets.symmetric(
        vertical: isMobile ? 8 : 12,
        horizontal: isMobile ? 12 : 20,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          _isExpanded.value = !_isExpanded.value;
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Task Title Row with conditional Edit/Delete buttons
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: isMobile ? 18 : 20,
                      ),
                    ),
                  ),
                  Obx(() {
                    return _isExpanded.value
                        ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            Get.snackbar('Edit Task', 'Edit task functionality');
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Colors.blueAccent,
                            size: isMobile ? 18 : 22,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Get.snackbar('Delete Task', 'Delete task functionality');
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.redAccent,
                            size: isMobile ? 18 : 22,
                          ),
                        ),
                      ],
                    )
                        : const SizedBox();
                  }),
                ],
              ),
              const SizedBox(height: 12),

              // Created Date and Category Row
              Row(
                children: [
                  Text(
                    formattedDate,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: isMobile ? 12 : 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    category,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: isMobile ? 12 : 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Task Description with Expand/Collapse functionality
              Obx(() {
                return AnimatedCrossFade(
                  firstChild: Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: isMobile ? 14 : 16,
                    ),
                  ),
                  secondChild: AnimatedSize(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    child: Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: isMobile ? 14 : 16,
                      ),
                    ),
                  ),
                  crossFadeState: _isExpanded.value
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 300),
                );
              }),
              const SizedBox(height: 8),

              // Expand/Collapse Indicator
              Align(
                alignment: Alignment.centerRight,
                child: Obx(
                      () => Icon(
                    _isExpanded.value
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
