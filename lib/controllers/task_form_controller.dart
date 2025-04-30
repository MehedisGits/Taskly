import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaskFormController extends GetxController {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final RxnString taskId = RxnString();
  final RxString selectedStatus = 'New'.obs;
  final RxBool isAddingOrUpdating = false.obs;

  final List<String> statuses = ['New', 'InProgress', 'Completed', 'Cancelled'];

  bool get isEdit => taskId.value != null;

  void setStatus(String status) {
    selectedStatus.value = status;
  }

  void loadData({String? id, String? title, String? description, String? status}) {
    if (id != null) taskId.value = id;
    if (title != null) titleController.text = title;
    if (description != null) descriptionController.text = description;
    if (status != null) selectedStatus.value = status;
  }

  void clearForm() {
    taskId.value = null;
    titleController.clear();
    descriptionController.clear();
    selectedStatus.value = 'New';
  }
}
