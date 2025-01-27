import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/routes/routes.dart';
import '../services/api_services.dart'; // Import your API services

class LoginController extends GetxController {
  RxBool isPasswordVisible = false.obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // API client
  final ApiServices apiServices =
      ApiServices(); // Instance of ApiServices for API calls

  // Validate email
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    } else if (!GetUtils.isEmail(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  // Validate password
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  // Handle login
  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      Map<String, dynamic> userData = {
        'email': emailController.text.trim(),
        'password': passwordController.text
      };
      // Show loading dialog
      Get.dialog(Center(child: CircularProgressIndicator()),
          barrierDismissible: false);

      try {
        // API call for login (replace with your API endpoint and data structure)
        final response = await apiServices.authPost('Login', userData);

        // Check if login was successful based on API response
        if (response['status'] == 'success' ||
            response['statusCode'] == 201 ||
            response['statusCode'] == 200) {
          clearFormFields();
          Get.snackbar('Login', 'Login successful');
          // Navigate to the next screen or main app page
          Get.offAllNamed(Routes.home); // Replace with actual route
        } else {
          // If login failed, show an error message
          Get.snackbar('Error', 'Invalid credentials');
        }
      } catch (e) {
        // Show error if the API call fails
        Get.snackbar('Error', 'Login failed. Please try again');
      } finally {
        // Close the loading dialog
        Get.back();
      }
    } else {
      // If the form is not valid, show a snackbar with error message
      Get.snackbar('Error', 'Please fix the errors in the form');
    }
  }

  void clearFormFields() {
    emailController.clear();
    passwordController.clear();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
}
