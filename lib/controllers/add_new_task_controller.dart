// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../models/task_model.dart';
// import '../services/api_services.dart';
//
// class TaskController extends GetxController {
//   final ApiService apiServices = Get.put(ApiService());
//
//   // Observable Variables
//   final Rx<String> selectedPriority = 'Medium'.obs;
//   final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
//   final Rx<TimeOfDay?> selectedTime = Rx<TimeOfDay?>(null);
//   final RxBool isLoading = false.obs;
//   final RxBool isImportant = false.obs;
//
//   // Text Editing Controllers
//   final TextEditingController titleController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();
//
//   // Error Observables
//   final RxString titleError = ''.obs;
//   final RxString descriptionError = ''.obs;
//
//   // Priority List
//   final List<String> priorities = ['High', 'Medium', 'Low'];
//
//   // Formatted Date/Time Strings
//   String get formattedDate => selectedDate.value != null
//       ? DateFormat('MMM dd, yyyy').format(selectedDate.value!)
//       : 'No date set';
//
//   String get formattedTime {
//     // Using Get.context! is acceptable here if called when context is available.
//     return selectedTime.value != null
//         ? selectedTime.value!.format(Get.context!)
//         : 'No time set';
//   }
//
//   // -------------------------------
//   // Methods to Toggle & Set Values
//   // -------------------------------
//
//   /// Toggle the importance flag.
//   void toggleImportance() => isImportant.toggle();
//
//   /// Set the selected date and time.
//   void setDateTime(DateTime date, TimeOfDay time) {
//     selectedDate.value = date;
//     selectedTime.value = time;
//   }
//
//   /// Clears the selected date and time.
//   void clearDateTime() {
//     selectedDate.value = null;
//     selectedTime.value = null;
//   }
//
//   ////////////////////////////
//   //// If Task Exist
//   ////////////////////////////
//
//   /// Initialize the controller with an existing task.
//   void initializeWithTask(TaskData task) {
//     titleController.text = task.title;
//     descriptionController.text = task.description;
//     selectedPriority.value = task.priority ?? 'Medium';
//     isImportant.value = task.isImportant;
//     if (task.dueDate != null) {
//       selectedDate.value = task.dueDate;
//       selectedTime.value = TimeOfDay.fromDateTime(task.dueDate!);
//     }
//   }
//
//   // -------------------------------
//   // Form Submission & Validation
//   // -------------------------------
//
//   /// Submits the task form after validating inputs.
//   Future<void> submitForm(BuildContext context) async {
//     try {
//       isLoading.value = true;
//       resetErrors();
//
//       // Validate Inputs; if not valid, exit early.
//       if (!_validateInputs()) return;
//
//       // Simulate API call (Replace with actual API logic)
//       await _addTaskToApi();
//
//       // On success: clear fields, show success, then close screen.
//       _clearFormFields();
//       _showSuccessMessage();
//       Get.back();
//     } catch (e) {
//       _showErrorMessage(e.toString());
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   /// Resets error messages.
//   void resetErrors() {
//     titleError.value = '';
//     descriptionError.value = '';
//   }
//
//   /// Validate title and description inputs.
//   bool _validateInputs() {
//     bool isValid = true;
//
//     if (titleController.text.trim().isEmpty) {
//       titleError.value = 'Please enter a task title';
//       isValid = false;
//     }
//
//     if (descriptionController.text.trim().isEmpty) {
//       descriptionError.value = 'Please add task details';
//       isValid = false;
//     }
//
//     return isValid;
//   }
//
//   /// Simulate an API call to add the task.
//   Future<void> _addTaskToApi() async {
//     try {
//       // Simulate network delay
//       await Future.delayed(const Duration(seconds: 2));
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('token');
//       final Map<String, dynamic> taskData = {
//         'title': titleController.text.toString(),
//         'description': descriptionController.text.toString(),
//         'status': 'New'
//       };
//       await apiServices.createTask(taskData: taskData, token: token);
//       // Uncomment the following line to simulate an error:
//       // throw Exception("Failed to add task");
//     } catch (error) {
//       throw Exception(
//           "An error occurred while adding the task. Please try again.");
//     }
//   }
//
//   /// Clears form fields after a successful submission.
//   void _clearFormFields() {
//     titleController.clear();
//     descriptionController.clear();
//     selectedPriority.value = 'Medium';
//     clearDateTime();
//   }
//
//   // -------------------------------
//   // Snackbars for Feedback
//   // -------------------------------
//
//   /// Display a success message.
//   void _showSuccessMessage() {
//     Get.snackbar(
//       'Success',
//       'Task created successfully',
//       backgroundColor: Colors.green,
//       colorText: Colors.white,
//       duration: const Duration(seconds: 3),
//     );
//   }
//
//   /// Display an error message.
//   void _showErrorMessage(String errorMessage) {
//     Get.snackbar(
//       'Error',
//       errorMessage,
//       backgroundColor: Colors.red,
//       colorText: Colors.white,
//       duration: const Duration(seconds: 3),
//     );
//   }
//
//   // -------------------------------
//   // Task Deletion Logic
//   // -------------------------------
//
//   /// Delete the current task.
//   void deleteTask() {
//     // Implement deletion logic (replace with actual API call if needed)
//     Get.back();
//     Get.snackbar(
//       'Deleted',
//       'Task has been removed',
//       backgroundColor: Colors.blue,
//       colorText: Colors.white,
//       duration: const Duration(seconds: 2),
//     );
//   }
//
//   // -------------------------------
//   // Dispose Controllers
//   // -------------------------------
//
//   @override
//   void onClose() {
//     titleController.dispose();
//     descriptionController.dispose();
//     super.onClose();
//   }
// }
