import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String description;
  final bool isMobile;

  TaskCard({
    required this.title,
    required this.description,
    required this.isMobile,
    super.key,
  });

  // Use GetX to manage the expanded state
  final RxBool _isExpanded = false.obs;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        vertical: isMobile ? 5 : 10,
        horizontal: isMobile ? 8 : 16,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task Title
            Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: isMobile ? 16 : 18,
              ),
            ),
            const SizedBox(height: 8),
            // Task Description
            Obx(() {
              return AnimatedCrossFade(
                firstChild: Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: isMobile ? 14 : 16,
                  ),
                ),
                secondChild: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: isMobile ? 14 : 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            // Edit Task
                            Get.snackbar('Edit Task', 'Edit task functionality');
                          },
                          child: const Text('Edit'),
                        ),
                        TextButton(
                          onPressed: () {
                            // Delete Task
                            Get.snackbar('Delete Task', 'Delete task functionality');
                          },
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  ],
                ),
                crossFadeState: _isExpanded.value
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 300),
              );
            }),
            const SizedBox(height: 8),
            // Expand/Collapse Button
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  _isExpanded.value = !_isExpanded.value;
                },
                child: Text(_isExpanded.value ? 'Collapse' : 'Expand'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}