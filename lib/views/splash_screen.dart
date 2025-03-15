import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/routes.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    _checkToken(); // Call token check function
    return Scaffold(
      body: Center(
        child: FlutterLogo(size: 100),
      ),
    );
  }

  /// Check if the token is valid and navigate to the appropriate screen
  /// based on the token validity.
  /// If the token is valid, navigate to the home screen.
  /// If the token is invalid, missing, expired, unauth navigate to the login screen.
  void _checkToken() async {
    await Future.delayed(
        Duration(seconds: 1)); // Add a small delay to show the splash screen

    bool isValid = await isTokenValid();
    if (isValid) {
      Get.offAllNamed(Routes.home); // Navigate to home if valid
    } else {
      Get.offAllNamed(Routes.login); // Navigate to login if invalid
    }
  }

  /// Validate if the token is valid by checking expiration
  Future<bool> isTokenValid() async {
    final storage = await SharedPreferences.getInstance();

    try {
      String? token = storage.getString('token'); // Ensure consistent key usage
      if (token == null) return false; // Token doesn't exist

      // Decode the token without verifying signature
      final jwt = JWT.decode(token);

      final expiration = jwt.payload['exp'] as int?;
      if (expiration == null) return false; // No expiration claim in the token

      final currentTime = DateTime.now().millisecondsSinceEpoch ~/
          1000; // Get current time in seconds

      return expiration >
          currentTime; // Token is valid if expiration is in the future
    } catch (e) {
      print("Error decoding token: $e"); // Log the error for debugging
      return false; // Invalid token or expired
    }
  }
}
