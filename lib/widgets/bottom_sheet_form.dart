import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/widgets/custom_button.dart';

class BottomSheetForm extends StatelessWidget {
  final String heading;

  BottomSheetForm({
    super.key,
    required this.heading,
  });

  // Controllers to manage input data
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // Make the height as small as possible
          children: [
            const SizedBox(height: 12),
            Text(
              '🌱 $heading',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
            ),
            const SizedBox(height: 20),
            // Task Title TextField
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Task Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              ),
            ),
            const SizedBox(height: 12),
            // Task Description TextField
            TextField(
              controller: descriptionController,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: 'Task Description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Task Status',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              ),
            ),

            Spacer(),
            // Save Task Button
            CustomButton(text: heading, onPressed: () {}),
            // ElevatedButton(
            //   onPressed: () {
            //     // Handle form submission and validation
            //     if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
            //       Get.snackbar(
            //         'Error',
            //         'Please fill in both title and description.',
            //         snackPosition: SnackPosition.BOTTOM,
            //         backgroundColor: Colors.redAccent,
            //         colorText: Colors.white,
            //       );
            //     } else {
            //       String taskTitle = titleController.text;
            //       String taskDescription = descriptionController.text;
            //
            //       // Add your task creation logic here
            //       // Example:
            //       // controller.addTask(taskTitle, taskDescription);
            //
            //       // Close bottom sheet
            //       Get.back();
            //
            //       // Optionally show success message
            //       Get.snackbar(
            //         'Success',
            //         'Task "$taskTitle" has been added.',
            //         snackPosition: SnackPosition.BOTTOM,
            //         backgroundColor: Colors.green,
            //         colorText: Colors.white,
            //       );
            //     }
            //   },
            //   style: ElevatedButton.styleFrom(
            //     minimumSize: Size.infinite,
            //     maximumSize: Size.infinite,
            //     backgroundColor: Colors.blueAccent,
            //     padding: const EdgeInsets.symmetric(vertical: 12),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(8),
            //     ),
            //     elevation: 5, // Adding shadow for elevation
            //   ),
            //   child: const Text(
            //     'Save Task',
            //     style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            //   ),
            // ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
