import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/routes.dart';
import '../services/api_services.dart';
import '../services/auth_service.dart';

class LoginController extends GetxController {
  final RxBool isPasswordVisible = false.obs;
  final RxBool isLoading = false.obs; // নতুন loading state
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ApiServices _apiServices = ApiServices();
  final AuthService _authService = Get.find<AuthService>();

  /// Validates the email field
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email cannot be empty';
    if (!GetUtils.isEmail(value)) return 'Enter a valid email address';
    return null;
  }

  /// Validates the password field
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password cannot be empty';
    if (value.length < 6) return 'Password must be at least 6 characters long';
    return null;
  }

  /// Handles the login process using AuthService
  Future<void> login() async {
    if (!formKey.currentState!.validate()) {
      Get.snackbar('Error', 'Please correct the errors in the form.');
      return;
    }

    final userData = {
      'email': emailController.text.trim(),
      'password': passwordController.text,
    };

    isLoading.value = true;
    print('Attempting login with: $userData');

    try {
      final response = await _apiServices.postRequest(endpoint: 'Login', data: userData);
      print('Response from API: $response');

      if (response['status'] == 'success' ||
          response['statusCode'] == 200 ||
          response['statusCode'] == 201) {
        await _authService.login(response['token']);
        clearFormFields();
        Get.offAllNamed(Routes.home);
      } else {
        // Print error message from response for debugging
        print('Login failed with message: ${response['message']}');
        _showError(response['message'] ?? 'Invalid credentials');
      }
    } catch (e, stacktrace) {
      print('Error during login: $e');
      print('Stacktrace: $stacktrace');
      _showError('Login failed. Please try again later.');
    } finally {
      isLoading.value = false;
    }
  }


  /// Logs out the user using AuthService
  void logout() {
    _authService.logout();
  }

  /// Clears the email and password fields
  void clearFormFields() {
    emailController.clear();
    passwordController.clear();
  }

  /// Toggles the visibility of the password field
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  /// Shows error message using a snackbar
  void _showError(String message) {
    Get.snackbar('Error', message, snackPosition: SnackPosition.BOTTOM);
  }
}
