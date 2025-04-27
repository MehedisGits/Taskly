import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/user_model.dart';
import '../../../services/api_services.dart';

class UserController extends GetxController {
  // 🔹 User profile and status
  final Rx<UserDetails?> user = Rx<UserDetails?>(null);
  final RxBool isLoading = false.obs;

  // 🔹 Task counters
  final RxInt cancelledTaskCount = 0.obs;
  final RxInt completedTaskCount = 0.obs;
  final RxInt totalTasksCount = 0.obs;

  // 🔹 Theme settings
  final RxBool isDarkMode = false.obs;

  // 🔹 API Service instance
  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    _loadTheme(); // Load theme settings
    loadUserProfile(); // Load user profile
    loadTaskCounts(); // Load task counts
  }

  /// 🔹 Fetch task counts from SharedPreferences
  Future<void> loadTaskCounts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      completedTaskCount.value = prefs.getInt('CompletedTaskCount') ?? 0;
      totalTasksCount.value = prefs.getInt('TotalTaskCount') ?? 0;
      cancelledTaskCount.value = prefs.getInt('CancelledTaskCount') ?? 0;
    } catch (e) {
      print("Error loading task counts: $e");
    }
  }

  /// 🔹 Load user profile from SharedPreferences or API
  Future<void> loadUserProfile() async {
    isLoading.value = true;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? storedUserData = prefs.getString('userDetails');

      if (storedUserData != null) {
        user.value = UserDetails.fromJson(jsonDecode(storedUserData));
      }

      // 🔹 Fetch latest data from API
      UserDetails fetchedUser = await _apiService.fetchUserData();
      user.value = fetchedUser;

      // 🔹 Save updated data to local storage
      await prefs.setString('userDetails', jsonEncode(fetchedUser.toJson()));
    } catch (e) {
      Get.snackbar("Error", "Failed to load user profile");
      print("Error fetching user profile: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔹 Update user profile in memory and SharedPreferences
  Future<void> updateProfile(UserDetails updatedProfile) async {
    user.value = updatedProfile;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("userDetails", jsonEncode(updatedProfile.toJson()));
  }

  /// 🔹 Toggle dark mode and persist preference
  Future<void> toggleDarkMode(bool value) async {
    isDarkMode.value = value; // Update the theme value
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light); // Change the theme

    // Save the theme preference
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
  }

  /// 🔹 Load saved theme preference from SharedPreferences
  Future<void> _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDarkMode.value = prefs.getBool('isDarkMode') ?? false; // Default to light mode if not set
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light); // Apply theme on load
  }
}
