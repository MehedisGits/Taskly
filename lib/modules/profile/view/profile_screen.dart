import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/controllers/user_controller.dart';
import 'package:task_manager/services/auth_service.dart';
import 'package:task_manager/utils/responsive_size.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  // Retrieve the existing instance of UserController
  final UserController _userController = Get.find<UserController>();

  // Create an instance of AuthService
  final AuthService _authService = Get.find<AuthService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(responsiveSize(context, mobileSize: 16, tabletSize: 24, desktopSize: 32)),
        child: Column(
          children: [
            _buildProfileHeader(context),
            SizedBox(height: responsiveSize(context, mobileSize: 16, tabletSize: 24, desktopSize: 32)),
            _buildStatsCard(context),
            SizedBox(height: responsiveSize(context, mobileSize: 16, tabletSize: 24, desktopSize: 32)),
            _buildSettingsList(context),
            SizedBox(height: responsiveSize(context, mobileSize: 16, tabletSize: 24, desktopSize: 32)),
            _buildLogoutButton(context, _authService),
          ],
        ),
      ),
    );
  }

  /// Builds the profile header with avatar and name
  Widget _buildProfileHeader(BuildContext context) {
    return Obx(() {
      final user = _userController.user.value;
      return Column(
        children: [
          CircleAvatar(
            radius: responsiveSize(context, mobileSize: 50, tabletSize: 70, desktopSize: 90),
            backgroundImage: user.profileImage.isNotEmpty
                ? NetworkImage(user.profileImage)
                : const AssetImage('assets/images/flutter.png') as ImageProvider,
            onBackgroundImageError: (_, __) {
              // Handle image loading errors
              print('Failed to load profile image');
            },
          ),
          SizedBox(height: responsiveSize(context, mobileSize: 16, tabletSize: 20, desktopSize: 24)),
          Text(
            user.name.isNotEmpty ? user.name : 'No Name',
            style: TextStyle(
              fontSize: responsiveSize(context, mobileSize: 24, tabletSize: 28, desktopSize: 32),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: responsiveSize(context, mobileSize: 4, tabletSize: 6, desktopSize: 8)),
          Text(
            user.email,
            style: TextStyle(
              fontSize: responsiveSize(context, mobileSize: 16, tabletSize: 18, desktopSize: 20),
              color: Colors.grey[600],
            ),
          ),
        ],
      );
    });
  }

  /// Builds the stats card with total and completed tasks
  Widget _buildStatsCard(BuildContext context) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: responsiveSize(context, mobileSize: 20, tabletSize: 24, desktopSize: 28),
          horizontal: responsiveSize(context, mobileSize: 16, tabletSize: 20, desktopSize: 24),
        ),
        child: Obx(() {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(context, 'Total Tasks', '${_userController.totalTasks.value}'),
              _buildStatItem(context, 'Completed', '${_userController.completedTasks.value}'),
            ],
          );
        }),
      ),
    );
  }

  /// Builds a single stat item (e.g., "Total Tasks: 10")
  Widget _buildStatItem(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: responsiveSize(context, mobileSize: 20, tabletSize: 24, desktopSize: 28),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: responsiveSize(context, mobileSize: 4, tabletSize: 6, desktopSize: 8)),
        Text(
          label,
          style: TextStyle(
            fontSize: responsiveSize(context, mobileSize: 14, tabletSize: 16, desktopSize: 18),
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  /// Builds the settings list (e.g., Dark Mode toggle)
  Widget _buildSettingsList(BuildContext context) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: const Icon(Icons.dark_mode),
        title: Text(
          'Dark Mode',
          style: TextStyle(fontSize: responsiveSize(context, mobileSize: 16, tabletSize: 18, desktopSize: 20)),
        ),
        trailing: Obx(() {
          return Switch(
            value: _userController.isDarkMode.value,
            onChanged: (value) {
              _userController.toggleDarkMode(value);
            },
          );
        }),
      ),
    );
  }

  /// Builds the logout button
  Widget _buildLogoutButton(BuildContext context, AuthService authService) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          // Show a confirmation dialog before logging out
          Get.defaultDialog(
            title: 'Logout',
            middleText: 'Are you sure you want to logout?',
            textConfirm: 'Yes',
            textCancel: 'No',
            confirmTextColor: Colors.white,
            cancelTextColor: Colors.black,
            buttonColor: Theme.of(context).primaryColor,
            onConfirm: () async {
              try {
                // Perform logout
                await authService.logout();

                // Close the dialog
                Get.back();

                // Navigate to the login screen
                Get.offAllNamed('/login');
              } catch (e) {
                // Handle logout errors
                Get.back(); // Close the dialog
                Get.snackbar(
                  'Logout Failed',
                  'An error occurred while logging out. Please try again.',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.redAccent,
                  colorText: Colors.white,
                );
              }
            },
            onCancel: () {
              // Close the dialog if the user cancels
              Get.back();
            },
          );
        },
        icon: const Icon(Icons.logout),
        label: Text(
          'Logout',
          style: TextStyle(fontSize: responsiveSize(context, mobileSize: 16, tabletSize: 18, desktopSize: 20)),
        ),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(
            vertical: responsiveSize(context, mobileSize: 12, tabletSize: 14, desktopSize: 16),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}