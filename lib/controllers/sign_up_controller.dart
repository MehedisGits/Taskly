import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_services.dart';
import '../views/onboardings/login_screen.dart';

class SignUpController extends GetxController {
  final formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isPasswordHidden = true.obs;

  final ApiServices apiServices = ApiServices();

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  Future<void> signUp() async {
    if (formKey.currentState!.validate()) {
      // Prepare user data to send in the API request
      Map<String, dynamic> userData = {
        'email': emailController.text,
        'firstName': firstNameController.text,
        'lastName': lastNameController.text,
        'mobile': phoneController.text,
        'password': passwordController.text,
      };

      try {
        // Show a loading indicator
        Get.dialog(
          const Center(child: CircularProgressIndicator()),
          barrierDismissible: false,
        );

        // Call the API for registration
        final response = await apiServices.authPost('Registration', userData);

        // Close the loading dialog
        Get.back();

        // Handle API response
        if (response['status'] == 'success' ||
            response['statusCode'] == 201 ||
            response['statusCode'] == 200) {
          Get.snackbar(
            'Sign Up',
            'Account created successfully!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          clearFormFields();

          // Navigate to the login screen
          Get.offAll(() => LoginScreen(), transition: Transition.zoom);
        } else {
          // Handle response error messages
          final String errorMessage =
              response['message'] ?? 'An error occurred';
          Get.snackbar(
            'Error',
            errorMessage,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } catch (e) {
        // Close the loading dialog in case of error
        Get.back();

        // Handle unexpected errors
        Get.snackbar(
          'Error',
          'An error occurred: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } else {
      Get.snackbar(
        'Error',
        'Please fill out the form correctly',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void clearFormFields() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
