import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/api_services.dart';

class UserController extends GetxController {
  // User profile data
  final Rx<UserDetails?> user = Rx<UserDetails?>(null);
  final RxBool isLoading = false.obs;

  // Theme settings
  final RxBool isDarkMode = false.obs;

  final ApiService _apiService = ApiService(); // API Service instance

  @override
  void onInit() {
    super.onInit();
    _loadTheme(); // Load theme settings
    loadUserProfile(); // Load user profile data
  }

  /// Load user profile data from API or SharedPreferences
  Future<void> loadUserProfile() async {
    isLoading.value = true;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userData = prefs.getString('userDetails');

      if (userData != null) {
        // যদি লোকাল ডাটা থাকে, সেটি প্রথমে ব্যবহার করবো
        user.value = UserDetails.fromJson(jsonDecode(userData));
      }

      // **API Call to fetch updated user data**
      UserDetails fetchedUser = await _apiService.fetchUserData();
      user.value = fetchedUser;

      // **Update SharedPreferences with new data**
      await prefs.setString('userDetails', jsonEncode(fetchedUser.toJson()));
    } catch (e) {
      Get.snackbar("Error", "Failed to load user profile");
      print("Error fetching user profile: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Update user profile in memory and storage
  Future<void> updateProfile(UserDetails updatedProfile) async {
    user.value = updatedProfile;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("userDetails", jsonEncode(updatedProfile.toJson()));
  }

  /// Toggle dark mode and save preference
  Future<void> toggleDarkMode(bool value) async {
    isDarkMode.value = value;
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
  }

  /// Load the saved theme preference
  Future<void> _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDarkMode.value = prefs.getBool('isDarkMode') ?? false;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }
}
