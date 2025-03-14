import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/routes.dart';

class CustomAppBarController extends GetxController {
  // Observable to track if the search bar is active
  var isSearchActive = false.obs;

  // Observable to track dark mode state
  var isDarkMode = false.obs;

  // TextEditingController for the search bar
  final TextEditingController searchController = TextEditingController();

  // Observable to track the search query
  final RxString searchQuery = ''.obs;

  // Observable to track the number of notifications
  final RxInt notificationCount = 0.obs;

  // Method to activate the search bar
  void activateSearch() {
    isSearchActive.value = true;
  }

  // Method to deactivate the search bar
  void deactivateSearch() {
    isSearchActive.value = false;
    searchController.clear(); // Clear the search field
    searchQuery.value = ''; // Reset the search query
  }

  // Method to toggle dark mode
  void toggleDarkMode(bool value) {
    isDarkMode.value = value;
    Get.changeTheme(value ? ThemeData.dark() : ThemeData.light());
  }

  // Method to handle search input changes
  void onSearchChanged(String value) {
    searchQuery.value = value;
    // You can add search logic here (e.g., filter tasks or fetch data from an API)
  }

  // Method to simulate fetching notifications
  void fetchNotifications() async {
    // Simulate an API call or local storage fetch
    await Future.delayed(const Duration(seconds: 2));
    notificationCount.value = 3; // Example: 3 new notifications
  }

  // Method to navigate to the profile screen
  void navigateToProfile() {
    Get.toNamed(Routes.profile);
  }

  // Method to show more options
  void showMoreOptions() {
    Get.snackbar(
      'More Options',
      'More options selected',
      margin: const EdgeInsets.all(10),
    );
  }

  @override
  void onClose() {
    // Dispose the TextEditingController when the controller is closed
    // searchController.dispose();
    super.onClose();
  }
}