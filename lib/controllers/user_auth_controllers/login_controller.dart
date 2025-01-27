import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/routes/routes.dart';
import '../../services/api_services.dart';

class LoginController extends GetxController {
  RxBool isPasswordVisible = false.obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Text editing controllers for the email and password fields
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // API client instance for handling API calls
  final ApiServices apiServices = ApiServices();

  // Email validation
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    } else if (!GetUtils.isEmail(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  // Password validation
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  // Login function to handle user authentication
  Future<void> login() async {
    // Validate form fields
    if (formKey.currentState!.validate()) {
      // Prepare the user data for the API request
      Map<String, dynamic> userData = {
        'email': emailController.text.trim(),
        'password': passwordController.text,
      };

      // Show a loading dialog
      Get.dialog(
        Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false, // Prevent dismissing the dialog when tapped outside
      );

      try {
        // API call to authenticate the user
        final response = await apiServices.authPost('Login', userData);

        // Handle API response
        if (response['status'] == 'success' ||
            response['statusCode'] == 200 ||
            response['statusCode'] == 201) {
          // Store the JWT token securely
          SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
          await sharedPreferences.setString('token', response['token']);

          // Clear form fields after successful login
          clearFormFields();

          // Show success message
          Get.snackbar('Login', 'Login successful');

          // Navigate to the home screen
          Get.offAllNamed(Routes.home); // Replace with the actual home route
        } else {
          // Show error message from the server, if available
          Get.snackbar('Error', response['message'] ?? 'Invalid credentials');
        }
      } catch (e) {
        // Handle API call errors
        Get.snackbar('Error', 'Login failed. Please try again later.');
      } finally {
        // Close the loading dialog
        Get.back();
      }
    } else {
      // If the form is invalid, show a snackbar
      Get.snackbar('Error', 'Please correct the errors in the form.');
    }
  }

  // Clear the email and password fields
  void clearFormFields() {
    emailController.clear();
    passwordController.clear();
  }

  // Toggle visibility of the password field
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
}
