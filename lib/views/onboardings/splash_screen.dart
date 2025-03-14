
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/routes/routes.dart';

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

  void _checkToken() async {
    bool isValid = await isTokenValid();
    if (isValid) {
      Get.offAllNamed(Routes.home); // Navigate to home if valid
    } else {
      Get.offAllNamed(Routes.login); // Navigate to login if invalid
    }
  }

  Future<bool> isTokenValid() async {
    final storage = await SharedPreferences.getInstance();

    try {
      String? token = storage.getString('token');
      if (token == null) return false;

      // Decode the token without verifying signature
      final jwt = JWT.decode(token);

      final expiration = jwt.payload['exp'] as int?;
      if (expiration == null) return false;

      final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      return expiration > currentTime; // True if token is valid
    } catch (e) {
      return false; // Invalid token or expired
    }
  }
}
