import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskly/modules/add_new_task_controller.dart';
import 'package:taskly/models/task_model.dart';
import 'package:taskly/widgets/custom_dropdown.dart';

class AddNewTasksScreen extends StatelessWidget {
  AddNewTasksScreen({super.key, this.taskData});

  final TaskController controller = Get.put(TaskController());
  final TaskData? taskData;

  @override
  Widget build(BuildContext context) {

    // Initialize controller with task data if provided
    if (taskData != null) {
      controller.initializeWithTask(taskData!);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitleField(),
            _buildDescriptionField(),
            const SizedBox(height: 20),
            _buildDateTimeOption(),
            _buildPriorityOption(),
            const Spacer(),
            _buildSubmitButton(context),
          ],
        ),
      ),
    );
  }

  // AppBar with dynamic icon for importance and options
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.green,
      foregroundColor: Colors.black,
      title: const Text(
        'New Task',
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      centerTitle: false,
      actions: [
        Obx(() => IconButton(
          icon: Icon(
            controller.isImportant.value ? Icons.star : Icons.star_border,
            color: controller.isImportant.value ? Colors.amber : Colors.grey,
          ),
          onPressed: controller.toggleImportance,
        )),
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () => _showMoreOptions(context),
        ),
      ],
    );
  }

  // Task Title Input
  Widget _buildTitleField() {
    return TextField(
      controller: controller.titleController,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: "Task Title",
        border: InputBorder.none,
        errorText: controller.titleError.value.isNotEmpty
            ? controller.titleError.value
            : null,
      ),
    );
  }

  // Task Description Input
  Widget _buildDescriptionField() {
    return TextField(
      controller: controller.descriptionController,
      maxLines: 3,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        hintText: "Add details",
        border: InputBorder.none,
        errorText: controller.descriptionError.value.isNotEmpty
            ? controller.descriptionError.value
            : null,
      ),
    );
  }

  // Date/Time Selection Option
  Widget _buildDateTimeOption() {
    return Obx(() => _taskOption(
      icon: Icons.access_time,
      text: controller.selectedDate.value != null
          ? "${controller.formattedDate} • ${controller.formattedTime}"
          : "Add date/time",
      onTap: _selectDateTime,
    ));
  }

  // Priority Selection Option
  Widget _buildPriorityOption() {
    return Obx(() => _taskOption(
      icon: Icons.priority_high,
      text: "Priority: ${controller.selectedPriority.value}",
      onTap: () => _showPriorityDropdown(Get.context!),
    ));
  }

  // Task Option Widget (Date/Time or Priority)
  Widget _taskOption({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey[700]),
            const SizedBox(width: 12),
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Submit Button
  Widget _buildSubmitButton(BuildContext context) {
    return Obx(() {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: controller.isLoading.value
              ? null  // Disable the button when loading
              : () => controller.submitForm(context),  // Submit the form if not loading
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: controller.isLoading.value
              ? const CircularProgressIndicator(
            color: Colors.white,  // White spinner to match button text color
          )
              : const Text(
            "Save Task",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    });
  }


  // Date/Time Picker
  Future<void> _selectDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: Get.context!,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        controller.setDateTime(pickedDate, pickedTime);
      }
    }
  }

  void _showPriorityDropdown(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Optional: for rounded corners
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 300, // Adjust as needed
              minHeight: 200, // Adjust as needed
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min, // To prevent the dialog from taking the full screen
                children: [
                  const Text(
                    "Set Priority",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 12),
                  CustomDropdown<String>(
                    label: 'Priority',
                    items: controller.priorities
                        .map((priority) => DropdownMenuItem(
                      value: priority,
                      child: Text(priority),
                    ))
                        .toList(),
                    value: controller.selectedPriority.value,
                    onChanged: (newValue) {
                      controller.selectedPriority.value = newValue!;
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("Close"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  // More Options (Attachment, Delete)
  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.attach_file),
              title: const Text('Add Attachment'),
              onTap: () {
                // Handle attachment
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete Task'),
              onTap: () {
                controller.deleteTask();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
