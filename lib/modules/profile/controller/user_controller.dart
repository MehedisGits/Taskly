import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/user_model.dart';
import '../../../services/api_services.dart';

class UserController extends GetxController {
  final Rx<UserDetails?> user = Rx<UserDetails?>(null);
  final isLoading = false.obs;

  final completedTaskCount = 0.obs;
  final cancelledTaskCount = 0.obs;
  final totalTasksCount = 0.obs;

  final isDarkMode = false.obs;

  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    _loadTheme();
    loadUserProfile();
    loadTaskCounts();
  }

  Future<void> loadTaskCounts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      completedTaskCount.value = prefs.getInt('CompletedTaskCount') ?? 0;
      totalTasksCount.value = prefs.getInt('TotalTaskCount') ?? 0;
      cancelledTaskCount.value = prefs.getInt('CancelledTaskCount') ?? 0;
    } catch (e) {
      debugPrint("Error loading task counts: $e");
    }
  }

  Future<void> loadUserProfile() async {
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedUserData = prefs.getString('userDetails');

      if (storedUserData != null) {
        user.value = UserDetails.fromJson(jsonDecode(storedUserData));
      }

      final fetchedUser = await _apiService.fetchUserData();
      user.value = fetchedUser;

      await prefs.setString('userDetails', jsonEncode(fetchedUser.toJson()));
    } catch (e) {
      Get.snackbar("Error", "Could not load profile", snackPosition: SnackPosition.BOTTOM);
      debugPrint("User profile load error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile(UserDetails updatedProfile) async {
    user.value = updatedProfile;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userDetails', jsonEncode(updatedProfile.toJson()));
  }

  Future<void> toggleDarkMode(bool value) async {
    isDarkMode.value = value;
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkMode.value = prefs.getBool('isDarkMode') ?? false;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }
}
