import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/modules/profile/controller/user_controller.dart';
import 'package:task_manager/services/auth_service.dart';
import 'package:task_manager/utils/responsive_size.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserController _userController = Get.find<UserController>();

  final AuthService _authService = Get.find<AuthService>();

  final RxBool isLoggingOut = false.obs;

  @override
  void initState() {
    super.initState();
    _userController.refreshAllTaskCounts();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Obx(() {
        if (_userController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final userDetails = _userController.user.value?.data?.first;

        if (userDetails == null) {
          return const Center(child: Text('User data not available'));
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(responsiveSize(
              context, mobileSize: 16, tabletSize: 24, desktopSize: 32)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildProfileHeader(context, userDetails),
              _buildSpacer(context),
              _buildStatsCard(context),
              _buildSpacer(context),
              _buildSettingsList(context),
              _buildSpacer(context),
              _buildLogoutButton(context),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildProfileHeader(BuildContext context, dynamic user) {
    return Column(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(
              "https://avatars.githubusercontent.com/u/125388734?v=4"),
          onBackgroundImageError: (_, __) => const Icon(Icons.error),
          radius: screenScale(context) * 60,
        ),
        _buildSpacer(context, size: 16),
        Text(
          "${user.firstName ?? ''} ${user.lastName ?? ''}"
              .trim()
              .isNotEmpty
              ? "${user.firstName} ${user.lastName}"
              : 'No Name',
          style: TextStyle(
            fontSize: responsiveSize(
                context, mobileSize: 24, tabletSize: 28, desktopSize: 32),
            fontWeight: FontWeight.bold,
          ),
        ),
        _buildSpacer(context, size: 4),
        Text(user.email ?? 'No Email', style: _infoTextStyle(context)),
        _buildSpacer(context, size: 2),
        Text(user.mobile ?? 'No Mobile', style: _infoTextStyle(context)),
      ],
    );
  }

  Widget _buildStatsCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: responsiveSize(
              context, mobileSize: 20, tabletSize: 24, desktopSize: 28),
          horizontal: responsiveSize(
              context, mobileSize: 16, tabletSize: 20, desktopSize: 24),
        ),
        child: Obx(() =>
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(context, "Total Tasks",
                    _userController.totalTasksCount.value),
                _buildStatItem(context, "Completed",
                    _userController.completedTaskCount.value),
                _buildStatItem(context, "Cancelled",
                    _userController.cancelledTaskCount.value),
              ],
            )),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, int value) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: responsiveSize(
                context, mobileSize: 20, tabletSize: 24, desktopSize: 28),
            fontWeight: FontWeight.bold,
            color: Theme
                .of(context)
                .colorScheme
                .primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: _infoTextStyle(context)),
      ],
    );
  }

  Widget _buildSettingsList(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.dark_mode),
        title: Text(
          'Dark Mode',
          style: TextStyle(fontSize: responsiveSize(
              context, mobileSize: 16, tabletSize: 18, desktopSize: 20)),
        ),
        trailing: Obx(() {
          return Switch(
            value: _userController.isDarkMode.value,
            onChanged: _userController.toggleDarkMode,
          );
        }),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Obx(() {
        return isLoggingOut.value ? CircularProgressIndicator() : ElevatedButton.icon(
          onPressed: () => _showLogoutDialog(context),
          icon: const Icon(Icons.logout),
          label: Text(
            'Logout',
            style: TextStyle(fontSize: responsiveSize(
                context, mobileSize: 16, tabletSize: 18, desktopSize: 20)),
          ),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(
              vertical: responsiveSize(
                  context, mobileSize: 12, tabletSize: 14, desktopSize: 16),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            backgroundColor: Colors.redAccent,
          ),
        );
      }),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    Get.defaultDialog(
      title: 'Logout',
      middleText: 'Are you sure you want to logout?',
      textConfirm: 'Yes',
      textCancel: 'No',
      confirmTextColor: Colors.white,
      cancelTextColor: Colors.black,
      buttonColor: Colors.redAccent,
      onConfirm: _handleLogout,
      onCancel: () => Get.back(),
    );
  }

  Future<void> _handleLogout() async {
    isLoggingOut.value = true;
    try {
      await _authService.logout();
      Get.back(); // Close dialog
      Get.offAllNamed('/login');
    } catch (e) {
      Get.back();
      Get.snackbar(
        'Logout Failed',
        'Something went wrong. Try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoggingOut.value = false;
    }
  }

  Widget _buildSpacer(BuildContext context, {double? size}) {
    return SizedBox(height: size ?? responsiveSize(
        context, mobileSize: 16, tabletSize: 24, desktopSize: 32));
  }

  TextStyle _infoTextStyle(BuildContext context) {
    return TextStyle(
      fontSize: responsiveSize(
          context, mobileSize: 14, tabletSize: 16, desktopSize: 18),
      color: Colors.grey[600],
    );
  }
}
