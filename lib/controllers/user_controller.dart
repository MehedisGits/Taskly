import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class UserController extends GetxController {
  // User profile data
  final Rx<UserProfile> user = UserProfile().obs;

  // Task statistics
  final RxInt totalTasks = 0.obs;
  final RxInt completedTasks = 0.obs;

  // Theme settings
  final RxBool isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadTheme(); // Load theme settings
    loadUserProfile(); // Load user profile data
  }

  /// Loads user profile data
  Future<void> loadUserProfile() async {
    // Simulate a network request or database query
    await Future.delayed(const Duration(seconds: 1));

    // Set user profile data
    user.value = UserProfile(
      name: 'Rakibul Islam Mehedi',
      email: 'rakibulislammehedi4@gmail.com',
      profileImage: 'https://avatars.githubusercontent.com/u/125388734?v=4',
    );
  }

  /// Updates the user's profile information
  Future<void> updateProfile(UserProfile updatedProfile) async {
    user.value = updatedProfile;
    // Optionally, save the updated profile to a database or API
  }

  /// Toggles dark mode and saves preference
  Future<void> toggleDarkMode(bool value) async {
    isDarkMode.value = value;
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);

    // Save the theme preference
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
  }

  /// Loads the saved theme preference
  Future<void> _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDarkMode.value = prefs.getBool('isDarkMode') ?? false;

    // Apply the theme
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }
}