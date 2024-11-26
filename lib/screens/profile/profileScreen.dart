import 'package:flutter/material.dart';
import 'package:taskly/api/controller.dart';
import 'package:taskly/screens/onboarding/loginScreen.dart';
import 'package:taskly/screens/profile/profileUpdateScreen.dart';
import 'package:taskly/screens/widgets/tm_appBar.dart';
import 'package:taskly/style/style.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen width and height to make the UI responsive
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: TmAppBar(
        isProfileScreenOpen: true,
      ),
      body: Stack(
        children: [
          screenBackground(context),
          SingleChildScrollView(
            padding: EdgeInsets.all(screenWidth * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Picture Section
                _buildProfilePictureSection(screenWidth, screenHeight),
                SizedBox(height: screenHeight * 0.02),

                // User Name Section
                _buildUserInfo('Rakibul Islam Mehedi',
                    'rakibulislammehedi4@gmail.com', screenWidth),

                SizedBox(height: screenHeight * 0.04),

                // Account Information Section
                _buildSectionTitle('Account Information', screenWidth),
                _buildAccountInfoRow(
                    'Username:', 'johndoe123', screenWidth, screenHeight),
                _buildAccountInfoRow(
                    'Phone:', '+1 234 567 890', screenWidth, screenHeight),
                _buildAccountInfoRow('Address:', '123 Main Street, City',
                    screenWidth, screenHeight),

                // Task Manager App Information Section
                SizedBox(height: screenHeight * 0.04),
                _buildSectionTitle('Task Manager App Information', screenWidth),
                _buildAccountInfoRow(
                    'App Version:', '1.0.0', screenWidth, screenHeight),
                _buildAccountInfoRow(
                    'Tasks Created:', '120', screenWidth, screenHeight),
                _buildAccountInfoRow(
                    'Pending Tasks:', '45', screenWidth, screenHeight),
                _buildAccountInfoRow(
                    'Completed Tasks:', '75', screenWidth, screenHeight),
                _buildAccountInfoRow(
                    'Last Sync:', 'Today, 2:00 PM', screenWidth, screenHeight),

                SizedBox(height: screenHeight * 0.03),

                // Edit Profile and Logout Buttons
                _buildActionButtons(screenWidth, screenHeight, context),
                SizedBox(height: screenHeight * 0.03),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Profile Picture Section
  Widget _buildProfilePictureSection(double screenWidth, double screenHeight) {
    return Center(
      child: CircleAvatar(
        radius: screenWidth * 0.15, // Dynamic size
        backgroundImage: NetworkImage(
            'https://avatars.githubusercontent.com/u/125388734?v=4'), // Placeholder image
      ),
    );
  }

  // User Information Section
  Widget _buildUserInfo(String name, String email, double screenWidth) {
    return Center(
      child: Column(
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: screenWidth * 0.06, // Responsive font size
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            email,
            style: TextStyle(
              fontSize: screenWidth * 0.04,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  // Section Title
  Widget _buildSectionTitle(String title, double screenWidth) {
    return Text(
      title,
      style: TextStyle(
        fontSize: screenWidth * 0.05,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  // Custom widget for account information rows
  Widget _buildAccountInfoRow(
      String title, String info, double screenWidth, double screenHeight) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: screenWidth * 0.045,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            info,
            style: TextStyle(
              fontSize: screenWidth * 0.045,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  // Action Buttons (Edit Profile and Logout)
  Widget _buildActionButtons(
      double screenWidth, double screenHeight, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Edit Profile Button
        _buildActionButton(
          label: 'Edit Profile',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileUpdateScreen(),
              ),
            );
          },
          color: Colors.green,
          screenWidth: screenWidth,
          screenHeight: screenHeight,
        ),

        // Logout Button
        _buildActionButton(
          label: 'Logout',
          onPressed: () {
            AuthController.clearUserData();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => LoginScreen(),
              ),
              (route) => false,
            );
          },
          color: Colors.red,
          screenWidth: screenWidth,
          screenHeight: screenHeight,
        ),
      ],
    );
  }

  // Custom Action Button
  Widget _buildActionButton({
    required String label,
    required VoidCallback onPressed,
    required Color color,
    required double screenWidth,
    required double screenHeight,
  }) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(
          vertical: screenHeight * 0.02,
          horizontal: screenWidth * 0.1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: screenWidth * 0.045,
        ),
      ),
    );
  }
}
