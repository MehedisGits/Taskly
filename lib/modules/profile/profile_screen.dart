import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskly/modules/profile/user_controller.dart';
import '../../services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  // Get instances of AuthService and UserController
  final AuthService _authService = Get.find();
  final UserController _userController = Get.find();

  static const double _spacing = 16.0;
  static const double _cardElevation = 2.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(_spacing),
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: _spacing),
            _buildStatsCard(),
            const SizedBox(height: _spacing),
            _buildSettingsList(),
            const SizedBox(height: _spacing),
            _buildLogoutButton(),
          ],
        ),
      ),
    );
  }

  /// Builds the profile header with avatar and name
  Widget _buildProfileHeader() {
    return Obx(() {
      final user = _userController.user.value;
      return Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(user.profileImage),
          ),
          const SizedBox(height: 16),
          Text(
            user.name.isNotEmpty ? user.name : 'No Name',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      );
    });
  }

  /// Builds the stats card with total and completed tasks
  Widget _buildStatsCard() {
    return Card(
      elevation: _cardElevation,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Obx(() {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Total Tasks', '${_userController.totalTasks.value}'),
              _buildStatItem('Completed', '${_userController.completedTasks.value}'),
            ],
          );
        }),
      ),
    );
  }

  /// Builds a single stat item (e.g., "Total Tasks: 10")
  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
      ],
    );
  }

  /// Builds the settings list (e.g., Dark Mode toggle)
  Widget _buildSettingsList() {
    return Card(
      elevation: _cardElevation,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: const Icon(Icons.dark_mode),
        title: const Text('Dark Mode'),
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
  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _authService.logout,
        icon: const Icon(Icons.logout),
        label: const Text('Logout'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
