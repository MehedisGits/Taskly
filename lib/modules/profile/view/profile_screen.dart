import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/controllers/user_controller.dart';
import 'package:task_manager/services/auth_service.dart';
import 'package:task_manager/utils/responsive_size.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final UserController _userController = Get.find<UserController>();
  final AuthService _authService = Get.find<AuthService>();

  RxInt cancelledTasks = 0.obs;
  RxInt completedTasks = 0.obs;
  RxInt totalTasksCount = 0.obs;

  @override
  Widget build(BuildContext context) {
    // Fetch the task counts after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getTaskCounts();
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(responsiveSize(context,
            mobileSize: 16, tabletSize: 24, desktopSize: 32)),
        child: Column(
          children: [
            _buildProfileHeader(context),
            SizedBox(
                height: responsiveSize(context,
                    mobileSize: 16, tabletSize: 24, desktopSize: 32)),
            _buildStatsCard(context),
            SizedBox(
                height: responsiveSize(context,
                    mobileSize: 16, tabletSize: 24, desktopSize: 32)),
            _buildSettingsList(context),
            SizedBox(
                height: responsiveSize(context,
                    mobileSize: 16, tabletSize: 24, desktopSize: 32)),
            _buildLogoutButton(context, _authService),
          ],
        ),
      ),
    );
  }

  /// 🔹 **Profile Header (Name, Email, Mobile)**
  Widget _buildProfileHeader(BuildContext context) {
    return Obx(() {
      final userDetails = _userController.user.value;

      if (userDetails == null ||
          userDetails.data == null ||
          userDetails.data!.isEmpty) {
        return const Center(child: Text('No user data available'));
      }

      final user = userDetails.data!.first;

      return Column(
        children: [
          SizedBox(
              width: screenScale(context) * 120,
              height: screenScale(context) * 120,
              child: CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://avatars.githubusercontent.com/u/125388734?v=4"),
                  radius: 24)),
          SizedBox(
              height: responsiveSize(context,
                  mobileSize: 16, tabletSize: 20, desktopSize: 24)),
          Text(
            "${user.firstName ?? ''} ${user.lastName ?? ''}".trim().isEmpty
                ? 'No Name'
                : "${user.firstName} ${user.lastName}",
            style: TextStyle(
              fontSize: responsiveSize(context,
                  mobileSize: 24, tabletSize: 28, desktopSize: 32),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
              height: responsiveSize(context,
                  mobileSize: 4, tabletSize: 6, desktopSize: 8)),
          Text(
            user.email ?? 'No Email',
            style: TextStyle(
              fontSize: responsiveSize(context,
                  mobileSize: 16, tabletSize: 18, desktopSize: 20),
              color: Colors.grey[600],
            ),
          ),
          SizedBox(
              height: responsiveSize(context,
                  mobileSize: 4, tabletSize: 6, desktopSize: 8)),
          Text(
            user.mobile ?? 'No Mobile',
            style: TextStyle(
              fontSize: responsiveSize(context,
                  mobileSize: 16, tabletSize: 18, desktopSize: 20),
              color: Colors.grey[600],
            ),
          ),
        ],
      );
    });
  }

  /// 🔹 **Stats Card (Total Tasks, Completed Tasks)**
  Widget _buildStatsCard(BuildContext context) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: responsiveSize(context,
                mobileSize: 20, tabletSize: 24, desktopSize: 28),
            horizontal: responsiveSize(context,
                mobileSize: 16, tabletSize: 20, desktopSize: 24),
          ),
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                    context, 'Total Tasks', totalTasksCount.value.toString()),
                _buildStatItem(
                    context, 'Total Tasks', cancelledTasks.value.toString()),
                _buildStatItem(
                    context, 'Completed', completedTasks.value.toString()),
              ],
            ),
          )),
    );
  }

  Future<void> getTaskCounts() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      completedTasks.value = prefs.getInt('CompletedTaskCount') ?? 0;
      totalTasksCount.value = prefs.getInt('TotalTaskCount') ?? 0;
      cancelledTasks.value = prefs.getInt('CancelledTaskCount') ?? 0;
    } catch (e) {
      print("Error fetching task counts: $e");
    }
  }

  /// 🔹 **Single Stat Item**
  Widget _buildStatItem(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: responsiveSize(context,
                mobileSize: 20, tabletSize: 24, desktopSize: 28),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
            height: responsiveSize(context,
                mobileSize: 4, tabletSize: 6, desktopSize: 8)),
        Text(
          label,
          style: TextStyle(
            fontSize: responsiveSize(context,
                mobileSize: 14, tabletSize: 16, desktopSize: 18),
            color: Colors.grey[600],
          ),
        ),
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
          style: TextStyle(
              fontSize: responsiveSize(context,
                  mobileSize: 16, tabletSize: 18, desktopSize: 20)),
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

  /// 🔹 **Logout Button**
  Widget _buildLogoutButton(BuildContext context, AuthService authService) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
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
                await authService.logout();
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
            },
            onCancel: () => Get.back(),
          );
        },
        icon: const Icon(Icons.logout),
        label: Text(
          'Logout',
          style: TextStyle(
              fontSize: responsiveSize(context,
                  mobileSize: 16, tabletSize: 18, desktopSize: 20)),
        ),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(
            vertical: responsiveSize(context,
                mobileSize: 12, tabletSize: 14, desktopSize: 16),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
