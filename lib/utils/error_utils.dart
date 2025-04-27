import 'package:get/get.dart';
import 'package:flutter/material.dart';

void showError(String title, String message) {
  Get.snackbar(
    title,
    message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.redAccent,
    colorText: Colors.white,
    margin: const EdgeInsets.all(10),
  );
}
