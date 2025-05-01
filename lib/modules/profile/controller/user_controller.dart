import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/services/task_storage_service.dart';
import '../../../models/user_model.dart';
import '../../../services/api_services.dart';

class UserController extends GetxController {
  final Rx<UserDetails?> user = Rx<UserDetails?>(null);
  final isLoading = false.obs;

  late TaskStorageService storage;
  final isDarkMode = false.obs;

  final completedTaskCount = 0.obs;
  final cancelledTaskCount = 0.obs;
  final newTaskCount = 0.obs;
  final inProgressTaskCount = 0.obs;
  final totalTasksCount = 0.obs;

  final ApiService _apiService = ApiService();

  @override
  Future<void> onInit() async {
    super.onInit();
    final prefs = await SharedPreferences.getInstance();
    storage = TaskStorageService(prefs);
    _loadTheme();
    await loadUserProfile();
    await refreshAllTaskCounts();
  }

  /// 🔄 Load all counts using TaskStorageService
  Future<void> refreshAllTaskCounts() async {
    try {
      completedTaskCount.value = storage.loadTaskCount("Completed");
      cancelledTaskCount.value = storage.loadTaskCount("Cancelled");
      newTaskCount.value = storage.loadTaskCount("New");
      inProgressTaskCount.value = storage.loadTaskCount("InProgress");

      totalTasksCount.value = completedTaskCount.value +
          cancelledTaskCount.value +
          newTaskCount.value +
          inProgressTaskCount.value;
    } catch (e) {
      debugPrint("❌ Error loading task counts: $e");
    }
  }

  /// 👤 User profile management
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
      Get.snackbar("Error", "Could not load profile",
          snackPosition: SnackPosition.BOTTOM);
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

  /// 🌙 Theme
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
