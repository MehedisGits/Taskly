import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/modules/profile/controller/user_controller.dart';
import 'package:task_manager/services/auth_service.dart';
import 'package:task_manager/utils/responsive_size.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final UserController _userController = Get.find<UserController>();
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
            _buildSpacer(context),
            _buildStatsCard(context),
            _buildSpacer(context),
            _buildSettingsList(context),
            _buildSpacer(context),
            _buildLogoutButton(context),
          ],
        ),
      ),
    );
  }

  /// 🔹 **Profile Header (Name, Email, Mobile)**
  Widget _buildProfileHeader(BuildContext context) {
    return Obx(() {
      final userDetails = _userController.user.value;

      if (userDetails?.data?.isEmpty ?? true) {
        return const Center(child: Text('No user data available'));
      }

      final user = userDetails!.data!.first;

      return Column(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage("https://avatars.githubusercontent.com/u/125388734?v=4"),
            radius: screenScale(context) * 60,
          ),
          _buildSpacer(context, size: 16),
          _buildUserName(context, user),
          _buildSpacer(context, size: 4),
          _buildUserInfo(context, user.email, user.mobile),
        ],
      );
    });
  }

  /// 🔹 **User Name** Text Widget
  Widget _buildUserName(BuildContext context, dynamic user) {
    return Text(
      "${user.firstName ?? ''} ${user.lastName ?? ''}".trim().isEmpty ? 'No Name' : "${user.firstName} ${user.lastName}",
      style: TextStyle(
        fontSize: responsiveSize(context, mobileSize: 24, tabletSize: 28, desktopSize: 32),
        fontWeight: FontWeight.w600,
      ),
    );
  }

  /// 🔹 **User Info (Email & Mobile)** Text Widgets
  Widget _buildUserInfo(BuildContext context, String? email, String? mobile) {
    return Column(
      children: [
        Text(email ?? 'No Email', style: _infoTextStyle(context)),
        _buildSpacer(context, size: 4),
        Text(mobile ?? 'No Mobile', style: _infoTextStyle(context)),
      ],
    );
  }

  /// 🔹 **Stats Card (Total Tasks, Completed Tasks, Cancelled Tasks)**
  Widget _buildStatsCard(BuildContext context) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: responsiveSize(context, mobileSize: 20, tabletSize: 24, desktopSize: 28),
          horizontal: responsiveSize(context, mobileSize: 16, tabletSize: 20, desktopSize: 24),
        ),
        child: Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(context, 'Total Tasks', _userController.totalTasksCount.value.toString()),
            _buildStatItem(context, 'Completed', _userController.completedTaskCount.value.toString()),
            _buildStatItem(context, 'Cancelled', _userController.cancelledTaskCount.value.toString()),
          ],
        )),
      ),
    );
  }

  /// 🔹 **Single Stat Item**
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
        _buildSpacer(context, size: 4),
        Text(label, style: _infoTextStyle(context)),
      ],
    );
  }

  /// 🔹 **Settings List (Dark Mode)**
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
            onChanged: (bool value) {
              _userController.toggleDarkMode(value); // Toggle theme on change
            },
          );
        }),
      ),
    );
  }

  /// 🔹 **Logout Button**
  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _showLogoutDialog(context),
        icon: const Icon(Icons.logout),
        label: Text('Logout', style: TextStyle(fontSize: responsiveSize(context, mobileSize: 16, tabletSize: 18, desktopSize: 20))),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: responsiveSize(context, mobileSize: 12, tabletSize: 14, desktopSize: 16)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  /// 🔹 **Logout Dialog**
  void _showLogoutDialog(BuildContext context) {
    Get.defaultDialog(
      title: 'Logout',
      middleText: 'Are you sure you want to logout?',
      textConfirm: 'Yes',
      textCancel: 'No',
      confirmTextColor: Colors.white,
      cancelTextColor: Colors.black,
      buttonColor: Theme.of(context).primaryColor,
      onConfirm: _handleLogout,
      onCancel: () => Get.back(),
    );
  }

  /// 🔹 **Handle Logout**
  Future<void> _handleLogout() async {
    try {
      await _authService.logout();
      Get.back();
      Get.offAllNamed('/login');
    } catch (e) {
      Get.back();
      Get.snackbar(
        'Logout Failed',
        'An error occurred while logging out. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  /// 🔹 **Helper Functions**
  /// Adds space between widgets dynamically
  Widget _buildSpacer(BuildContext context, {double? size}) {
    return SizedBox(height: size ?? responsiveSize(context, mobileSize: 16, tabletSize: 24, desktopSize: 32));
  }

  /// Style for profile info text
  TextStyle _infoTextStyle(BuildContext context) {
    return TextStyle(
      fontSize: responsiveSize(context, mobileSize: 16, tabletSize: 18, desktopSize: 20),
      color: Colors.grey[600],
    );
  }
}
