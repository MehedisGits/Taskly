import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/routes.dart';
import '../../services/api_services.dart';

class LoginController extends GetxController {
  RxBool isPasswordVisible = false.obs;
  RxBool isLoading = false.obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Text editing controllers for the email and password fields
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // API client instance for handling API calls
  final ApiService apiServices = ApiService();

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
    isLoading = true.obs;
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
        barrierDismissible:
            false, // Prevent dismissing the dialog when tapped outside
      );

      try {
        final response = await apiServices.loginUser(userData);

        print("🟢 API Response: $response"); // ✅ Debugging line

        if (response.containsKey("token")) {
          String token = response["token"];
          print("✅ Token received: $token");
          isLoading = false.obs;
          // Store in SharedPreferences
          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          await sharedPreferences.setString('token', token);
          print("🔐 Token saved in SharedPreferences");

          // Clear form fields
          clearFormFields();

          // Show success message
          Get.snackbar('Login', 'Login successful');

          // Navigate to the home screen
          Get.offAllNamed(Routes.home);
        } else {
          print("⚠️ Token not found in response: $response");
          Get.snackbar('Error', response['message'] ?? 'Invalid credentials');
        }
      } catch (e) {
        print("❌ Exception during login: $e");
        Get.snackbar('Error', 'Login failed. Please try again later.');
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
