// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:task_manager/models/user_model.dart';
//
// import '../../../services/api_services.dart';
//
// class UserProfileController extends GetxController {
//   // Observable for user profile data
//
//
//
//   // Observable for loading state
//   RxBool isLoading = false.obs;
//
//   // Instance of ApiService to call API endpoints
//   final ApiService _apiService = ApiService();
//
//   @override
//   void onInit() {
//     super.onInit();
//     // Automatically fetch user profile when the controller is initialized.
//     fetchUserProfile();
//   }
//
//   /// Fetches user profile data using ApiService
//   Future<void> fetchUserProfile() async {
//     isLoading.value = true;
//     try {
//       // Fetch the user data from the API
//       UserDetails userDetails = await _apiService.fetchUserData();
//       // Update the observable with the new user details
//       userProfile.value = userDetails;
//     } catch (e) {
//       // Show an error message if something goes wrong
//       Get.snackbar("Error", "Failed to load user profile");
//       print("Error in fetchUserProfile: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   /// Updates the user profile both in the controller and in SharedPreferences.
//   Future<void> updateUserProfile(UserDetails updatedProfile) async {
//     // Update the observable value
//     userProfile.value = updatedProfile;
//     // Optionally update the local storage (SharedPreferences) as well
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString("userDetails", jsonEncode(updatedProfile.toJson()));
//     // Notify the user about the update (optional)
//     Get.snackbar("Success", "Profile updated successfully");
//   }
// }
