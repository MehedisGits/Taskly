import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/task_model.dart';

class TaskController extends GetxController {
  // Observable Variables
  final Rx<String> selectedPriority = Rx<String>('Medium');
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final Rx<TimeOfDay?> selectedTime = Rx<TimeOfDay?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isImportant = false.obs;

  // Text Editing Controllers
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // Error Observables
  final RxString titleError = RxString('');
  final RxString descriptionError = RxString('');

  // Priority List
  final List<String> priorities = ['High', 'Medium', 'Low'];

  // Formatted Date/Time Strings
  String get formattedDate => selectedDate.value != null
      ? DateFormat('MMM dd, yyyy').format(selectedDate.value!)
      : 'No date set';

  String get formattedTime => selectedTime.value != null
      ? selectedTime.value!.format(Get.context!)
      : 'No time set';

  // Methods to Toggle Importance and Set Date/Time
  void toggleImportance() => isImportant.toggle();

  void setDateTime(DateTime date, TimeOfDay time) {
    selectedDate.value = date;
    selectedTime.value = time;
  }

  void initializeWithTask(TaskData task) {
    titleController.text = task.title;
    descriptionController.text = task.description;
    selectedPriority.value = task.priority ?? 'Medium';
    isImportant.value = task.isImportant;

    if (task.dueDate != null) {
      selectedDate.value = task.dueDate;
      selectedTime.value = TimeOfDay.fromDateTime(task.dueDate!);
    }
  }

  // Form Submission Logic with Improved UI/UX
  Future<void> submitForm(BuildContext context) async {
    try {
      // Indicate loading state
      isLoading.value = true;
      resetErrors();  // Reset error messages before submitting

      // Validate Inputs
      if (!_validateInputs()) return;

      // Simulate API Call to add task (Replace with actual API logic)
      await _addTaskToApi();

      // Success - Clear Form and Show Success Message
      _clearFormFields();
      _showSuccessMessage();
      Get.back(); // Close the screen after successful submission
    } catch (e) {
      // Handle error and show appropriate message
      _showErrorMessage(e.toString());
    } finally {
      isLoading.value = false; // Reset loading state
    }
  }

  // Reset Error Messages
  void resetErrors() {
    titleError.value = '';
    descriptionError.value = '';
  }

  // Input Validation
  bool _validateInputs() {
    bool isValid = true;

    // Check if Title is Empty
    if (titleController.text.isEmpty) {
      titleError.value = 'Please enter a task title';
      isValid = false;
    }

    // Check if Description is Empty
    if (descriptionController.text.isEmpty) {
      descriptionError.value = 'Please add task details';
      isValid = false;
    }

    return isValid;
  }

  // Simulate API Call to Add Task (Replace with actual API call)
  Future<void> _addTaskToApi() async {
    try {
      // Simulating a delay (Replace with actual API call)
      await Future.delayed(const Duration(seconds: 2));

      // Uncomment to simulate a failure:
      // throw Exception("Failed to add task");

      // Simulate success response
    } catch (error) {
      throw Exception("An error occurred while adding the task. Please try again.");
    }
  }

  // Clear form fields after successful submission
  void _clearFormFields() {
    titleController.clear();
    descriptionController.clear();
    selectedPriority.value = 'Medium';
    selectedDate.value = null;
    selectedTime.value = null;
  }

  // Show Success Snackbar
  void _showSuccessMessage() {
    Get.snackbar(
      'Success',
      'Task created successfully',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  // Show Error Snackbar
  void _showErrorMessage(String errorMessage) {
    Get.snackbar(
      'Error',
      errorMessage,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  // Task Deletion Logic
  void deleteTask() {
    // Implement delete functionality here (replace with actual delete logic)
    Get.back();
    Get.snackbar(
      'Deleted',
      'Task has been removed',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  // Dispose Controllers
  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
