import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:task_manager/widgets/bottom_sheet_form.dart';
import 'package:task_manager/widgets/task_categories.dart'; // Update the path if needed

class TaskCard extends StatelessWidget {
  final String taskId;
  final String title;
  final String description;
  final String taskStatus;
  final bool isMobile;
  final String createdDate;
  final String category;
  final bool isLoading;
  final VoidCallback? onDelete;
  final VoidCallback? onComplete;

  TaskCard({
    required this.taskId,
    required this.title,
    required this.description,
    required this.taskStatus,
    required this.isMobile,
    required this.createdDate,
    required this.category,
    this.isLoading = false,
    this.onDelete,
    this.onComplete,
    super.key,
  });

  final RxBool _isExpanded = false.obs;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    DateTime parsedDate = DateTime.tryParse(createdDate) ?? DateTime.now();
    String formattedDate = DateFormat('MMM dd, yyyy').format(parsedDate);

    if (isLoading) {
      return Shimmer.fromColors(
        baseColor: colorScheme.surfaceVariant.withOpacity(0.3),
        highlightColor: colorScheme.surfaceVariant.withOpacity(0.1),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: SizedBox(height: 150, width: double.infinity),
        ),
      );
    }

    final matchedCategory = taskCategories.firstWhere(
          (cat) => cat.name.toLowerCase() == category.toLowerCase(),
      orElse: () => taskCategories.last,
    );

    return Dismissible(
      key: Key(taskId),
      background: _slideRightBackground(colorScheme),
      secondaryBackground: _slideLeftBackground(colorScheme),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) onComplete?.call();
        if (direction == DismissDirection.endToStart) onDelete?.call();
      },
      child: Card(
        elevation: 4,
        margin: EdgeInsets.symmetric(
          vertical: isMobile ? 10 : 14,
          horizontal: isMobile ? 16 : 24,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: colorScheme.surface,
        child: InkWell(
          onTap: () => _isExpanded.toggle(),
          borderRadius: BorderRadius.circular(20),
          splashColor: colorScheme.primary.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Title & actions
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: isMobile ? 18 : 20,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    Obx(() => _isExpanded.value
                        ? Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: colorScheme.primary),
                          onPressed: () => Get.bottomSheet(BottomSheetForm(
                            heading: 'Update task',
                            id: taskId,
                            title: title,
                            description: description,
                            status: taskStatus,
                          )),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_outline, color: colorScheme.error),
                          onPressed: onDelete,
                        ),
                      ],
                    )
                        : const SizedBox()),
                  ],
                ),

                const SizedBox(height: 10),

                // Date + Category
                Row(
                  children: [
                    Icon(Icons.access_time, color: colorScheme.outline, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      formattedDate,
                      style: textTheme.bodySmall?.copyWith(color: colorScheme.outline),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: matchedCategory.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(matchedCategory.icon, color: matchedCategory.color, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            matchedCategory.name,
                            style: TextStyle(
                              color: matchedCategory.color,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Description
                Obx(() => AnimatedCrossFade(
                  crossFadeState: _isExpanded.value
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 300),
                  firstChild: Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
                  ),
                  secondChild: Text(
                    description,
                    style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
                  ),
                )),

                const SizedBox(height: 12),

                // Expand/Collapse icon
                Align(
                  alignment: Alignment.centerRight,
                  child: Obx(() => Icon(
                    _isExpanded.value
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: colorScheme.outline,
                  )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _slideRightBackground(ColorScheme colorScheme) {
    return Container(
      color: Colors.green,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.centerLeft,
      child: const Icon(Icons.check, color: Colors.white, size: 32),
    );
  }

  Widget _slideLeftBackground(ColorScheme colorScheme) {
    return Container(
      color: colorScheme.error,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.centerRight,
      child: const Icon(Icons.delete, color: Colors.white, size: 32),
    );
  }
}
