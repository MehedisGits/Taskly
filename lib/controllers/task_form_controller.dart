import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class TaskFormController extends GetxController {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final taskId = RxnString();
  final selectedStatus = 'New'.obs;
  final isAddingOrUpdating = false.obs;
  final isDataLoaded = false.obs; // 👈 New

  final List<String> statuses = ['New', 'InProgress', 'Completed', 'Cancelled'];

  bool get isEdit => taskId.value != null;

  void setStatus(String status) {
    if (statuses.contains(status)) {
      selectedStatus.value = status;
    }
  }

  void loadData({
    String? id,
    String? title,
    String? description,
    String? status,
  }) {
    if (id != null) taskId.value = id;
    if (title != null) titleController.text = title;
    if (description != null) descriptionController.text = description;
    if (status != null && statuses.contains(status)) {
      selectedStatus.value = status;
    }

    isDataLoaded.value = true; // ✅ Mark as loaded
  }

  void clearForm() {
    taskId.value = null;
    titleController.clear();
    descriptionController.clear();
    selectedStatus.value = 'New';
    isDataLoaded.value = false;
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
