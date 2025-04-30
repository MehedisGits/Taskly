// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../controllers/date_time_controller.dart';
// import '../../../controllers/task_data_controller.dart';
//
//
// // ignore: must_be_immutable
// class AddNewTasksScreen extends StatelessWidget {
//   AddNewTasksScreen({super.key, this.taskData});
//
//   // Get instance of TaskController
//   final TaskController controller = Get.put(TaskController());
//   final DateTimeController dateTimeController = Get.put(DateTimeController());
//   final TaskData? taskData;
//   bool _initialized = false;
//
//   @override
//   Widget build(BuildContext context) {
//     // Initialize with taskData only once
//     if (!_initialized && taskData != null) {
//       controller.initializeWithTask(taskData!);
//       _initialized = true;
//     }
//
//     return Scaffold(
//       backgroundColor: context.theme.scaffoldBackgroundColor,
//       appBar: _buildAppBar(context),
//       body: GestureDetector(
//         // Dismiss the keyboard when tapping outside
//         onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildTitleField(context),
//               const SizedBox(height: 14),
//               _buildDescriptionField(context),
//               const SizedBox(height: 24),
//               _buildDateTimeOption(context),
//               const SizedBox(height: 10),
//               _buildPriorityOption(context),
//               const Spacer(),
//               _buildSubmitButton(context),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   AppBar _buildAppBar(BuildContext context) {
//     return AppBar(
//       elevation: 0,
//       backgroundColor: context.theme.appBarTheme.backgroundColor,
//       title: Text(
//         taskData == null ? AppStrings.newTask : AppStrings.editTask,
//         style: context.textTheme.titleMedium
//             ?.copyWith(fontWeight: FontWeight.w600, color: Colors.white),
//       ),
//       actions: [
//         _buildImportanceButton(context),
//         _buildMoreOptionsButton(context),
//       ],
//     );
//   }
//
//   Widget _buildImportanceButton(BuildContext context) {
//     return Obx(
//       () => IconButton(
//         icon: Icon(
//           controller.isImportant.value
//               ? Icons.star_rounded
//               : Icons.star_outline_rounded,
//           color: controller.isImportant.value
//               ? AppColors.importantStar
//               : context.theme.iconTheme.color,
//           size: 28,
//         ),
//         tooltip: AppStrings.markImportant,
//         onPressed: controller.toggleImportance,
//       ),
//     );
//   }
//
//   Widget _buildMoreOptionsButton(BuildContext context) {
//     return PopupMenuButton<String>(
//       icon: const Icon(Icons.more_vert_rounded),
//       onSelected: (value) => _handleMoreOptionsSelection(value, context),
//       itemBuilder: (context) => [
//         PopupMenuItem(
//           value: 'attachment',
//           child: Row(
//             children: [
//               const Icon(Icons.attach_file, size: 20),
//               const SizedBox(width: 12),
//               Text(AppStrings.addAttachment),
//             ],
//           ),
//         ),
//         if (taskData != null)
//           PopupMenuItem(
//             value: 'delete',
//             child: Row(
//               children: [
//                 const Icon(Icons.delete_outline, size: 20, color: Colors.red),
//                 const SizedBox(width: 12),
//                 Text(AppStrings.deleteTask,
//                     style: const TextStyle(color: Colors.red)),
//               ],
//             ),
//           ),
//       ],
//     );
//   }
//
//   Widget _buildTitleField(BuildContext context) {
//     return Obx(
//       () => TextField(
//         controller: controller.titleController,
//         autofocus: true,
//         style: context.textTheme.titleMedium
//             ?.copyWith(fontWeight: FontWeight.w500),
//         decoration: InputDecoration(
//           hintText: AppStrings.taskTitleHint,
//           border: InputBorder.none,
//           hintStyle: context.textTheme.bodyLarge
//               ?.copyWith(color: context.theme.hintColor),
//           errorText: controller.titleError.value.isNotEmpty
//               ? controller.titleError.value
//               : null,
//           errorStyle: const TextStyle(color: AppColors.errorRed),
//           focusedErrorBorder: UnderlineInputBorder(
//             borderSide: BorderSide(color: AppColors.errorRed, width: 1.5),
//           ),
//           suffixIcon: controller.titleError.value.isNotEmpty
//               ? const Icon(Icons.error_outline, color: AppColors.errorRed)
//               : null,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDescriptionField(BuildContext context) {
//     return Obx(
//       () => TextField(
//         controller: controller.descriptionController,
//         maxLines: 3,
//         style: context.textTheme.bodyLarge,
//         decoration: InputDecoration(
//           hintText: AppStrings.taskDetailsHint,
//           border: InputBorder.none,
//           hintStyle: context.textTheme.bodyLarge
//               ?.copyWith(color: context.theme.hintColor),
//           errorText: controller.descriptionError.value.isNotEmpty
//               ? controller.descriptionError.value
//               : null,
//           errorStyle: const TextStyle(color: AppColors.errorRed),
//           focusedErrorBorder: UnderlineInputBorder(
//             borderSide: BorderSide(color: AppColors.errorRed, width: 1.5),
//           ),
//           suffixIcon: controller.descriptionError.value.isNotEmpty
//               ? const Icon(Icons.error_outline, color: AppColors.errorRed)
//               : null,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDateTimeOption(BuildContext context) {
//     return Obx(() => _TaskOptionRow(
//           icon: Icons.access_time_rounded,
//           label: controller.selectedDate.value != null
//               ? "${controller.formattedDate} • ${controller.formattedTime}"
//               : AppStrings.addDateTime,
//           onTap: () => _selectDateTime(context),
//           showClear: controller.selectedDate.value != null,
//           onClear: () => controller.clearDateTime(),
//         ));
//   }
//
//   Widget _buildPriorityOption(BuildContext context) {
//     return Obx(() => _TaskOptionRow(
//           icon: Icons.flag_rounded,
//           label: "${AppStrings.priority}: ${controller.selectedPriority.value}",
//           onTap: () => _showPriorityBottomSheet(context),
//         ));
//   }
//
//   Widget _buildSubmitButton(BuildContext context) {
//     return Obx(() => SizedBox(
//           width: double.infinity,
//           child: ElevatedButton.icon(
//             icon: controller.isLoading.value
//                 ? const SizedBox(
//                     width: 24,
//                     height: 24,
//                     child: CircularProgressIndicator(
//                       strokeWidth: 2,
//                       color: Colors.white,
//                     ),
//                   )
//                 : const Icon(Icons.check_rounded, size: 24),
//             label: Text(
//               controller.isLoading.value
//                   ? AppStrings.saving
//                   : AppStrings.saveTask,
//               style:
//                   context.textTheme.labelLarge?.copyWith(color: Colors.white),
//             ),
//             onPressed: controller.isLoading.value
//                 ? null
//                 : () => controller.submitForm(context),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.primaryColor,
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//           ),
//         ));
//   }
//
//   Future<void> _selectDateTime(BuildContext context) async {
//     final result = await showModalBottomSheet<DateTimePair>(
//       context: context,
//       isScrollControlled: true,
//       builder: (context) => DateTimePicker(
//         initialDate: dateTimeController.selectedDate.value,
//         initialTime: dateTimeController.selectedTime.value,
//       ),
//     );
//     if (result != null) {
//       controller.setDateTime(result.date, result.time);
//     }
//   }
//
//   void _showPriorityBottomSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) => Padding(
//         padding:
//             EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
//         child: PrioritySelector(
//           selectedPriority: controller.selectedPriority.value,
//           onPrioritySelected: (priority) {
//             controller.selectedPriority.value = priority;
//             Navigator.pop(context);
//           },
//         ),
//       ),
//     );
//   }
//
//   void _handleMoreOptionsSelection(String value, BuildContext context) {
//     switch (value) {
//       case 'attachment':
//         _handleAttachment();
//         break;
//       case 'delete':
//         _confirmDelete(context);
//         break;
//     }
//   }
//
//   void _handleAttachment() async {
//     // Implement file attachment logic here
//   }
//
//   void _confirmDelete(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(AppStrings.deleteTask),
//         content: Text(AppStrings.deleteTaskConfirm),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               controller.deleteTask();
//               Navigator.pop(context);
//             },
//             child: Text(
//               'Delete',
//               style: TextStyle(color: Theme.of(context).colorScheme.error),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _TaskOptionRow extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final VoidCallback onTap;
//   final bool showClear;
//   final VoidCallback? onClear;
//
//   const _TaskOptionRow({
//     required this.icon,
//     required this.label,
//     required this.onTap,
//     this.showClear = false,
//     this.onClear,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         borderRadius: BorderRadius.circular(8),
//         onTap: onTap,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
//           child: Row(
//             children: [
//               Icon(icon, size: 24, color: context.theme.iconTheme.color),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Text(
//                   label,
//                   style: context.textTheme.bodyLarge?.copyWith(
//                     color: context.theme.textTheme.bodyLarge?.color,
//                   ),
//                 ),
//               ),
//               if (showClear)
//                 IconButton(
//                   icon: const Icon(Icons.clear_rounded, size: 20),
//                   color: context.theme.iconTheme.color,
//                   onPressed: onClear,
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
