import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:task_manager/widgets/bottom_sheet_form.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String description;
  final bool isMobile;
  final String createdDate;
  final String category;
  final bool isLoading;
  final VoidCallback? onDelete;
  final VoidCallback? onComplete;

  TaskCard({
    required this.title,
    required this.description,
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
    DateTime parsedDate = DateTime.tryParse(createdDate) ?? DateTime.now();
    String formattedDate = DateFormat('MMM dd, yyyy').format(parsedDate);

    if (isLoading) {
      return Shimmer.fromColors(
        baseColor: Colors.grey.shade200,
        highlightColor: Colors.grey.shade100,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: SizedBox(height: 150, width: double.infinity),
        ),
      );
    }

    return Dismissible(
      key: UniqueKey(),
      background: _slideRightBackground(),
      secondaryBackground: _slideLeftBackground(),
      onDismissed: (direction) {
        // Call the appropriate callback based on the swipe direction
        if (direction == DismissDirection.startToEnd) {
          onComplete?.call();  // Called when swiped from left to right (Complete Task)
        }
        if (direction == DismissDirection.endToStart) {
          onDelete?.call();  // Called when swiped from right to left (Delete Task)
        }
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: EdgeInsets.symmetric(
          vertical: isMobile ? 8 : 12,
          horizontal: isMobile ? 12 : 20,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _isExpanded.toggle(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
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
                            onPressed: () => Get.bottomSheet(BottomSheetForm(heading: 'Update task',)),
                            icon: const Icon(Icons.edit, color: Colors.blue),
                          ),
                          IconButton(
                            onPressed: onDelete,
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      )
                          : const SizedBox();
                    }),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      formattedDate,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      category,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Obx(() {
                  return AnimatedCrossFade(
                    firstChild: Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    secondChild: Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    crossFadeState: _isExpanded.value
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 300),
                  );
                }),
                const SizedBox(height: 8),
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
      ),
    );
  }

  Widget _slideRightBackground() {
    return Container(
      color: Colors.green,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.centerLeft,
      child: const Icon(Icons.check, color: Colors.white, size: 32),
    );
  }

  Widget _slideLeftBackground() {
    return Container(
      color: Colors.red,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.centerRight,
      child: const Icon(Icons.delete, color: Colors.white, size: 32),
    );
  }
}
