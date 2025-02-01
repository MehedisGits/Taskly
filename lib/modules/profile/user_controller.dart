import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user_model.dart';

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
    loadTheme(); // থিম সেটিংস লোড করুন
  }

  /// Loads user profile data
  Future<void> loadUserProfile() async {
    await Future.delayed(const Duration(seconds: 1));

    user.value = UserProfile(
      name: 'John Doe',
      email: 'john.doe@example.com',
      profileImage: 'https://via.placeholder.com/150',
    );
  }

  /// Updates the user's profile information
  Future<void> updateProfile(UserProfile updatedProfile) async {
    user.value = updatedProfile;
  }

  /// Toggles dark mode and saves preference
  Future<void> toggleDarkMode(bool value) async {
    isDarkMode.value = value;
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);

    // থিম সেটিংস সংরক্ষণ করুন
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
  }

  /// Loads the saved theme preference
  Future<void> loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDarkMode.value = prefs.getBool('isDarkMode') ?? false;

    // আগের থিম অ্যাপ্লাই করুন
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }
}

