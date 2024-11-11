import 'package:flutter/material.dart';
import 'package:taskly/screens/onboarding/loginScreen.dart';
import 'package:taskly/screens/profile/profileUpdateScreen.dart';
import 'package:taskly/style/style.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen width and height to make the UI responsive
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(children: [
        ScreenBackground(context),
        SingleChildScrollView(
          // Make the body scrollable
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture Section
              Center(
                child: CircleAvatar(
                    radius: screenWidth * 0.15, // Dynamic size
                    backgroundImage: NetworkImage(
                        'https://avatars.githubusercontent.com/u/125388734?v=4') // Placeholder image
                    ),
              ),
              SizedBox(height: screenHeight * 0.02),

              // User Name Section
              Center(
                child: Text(
                  'Rakibul Islam Mehedi',
                  style: TextStyle(
                    fontSize: screenWidth * 0.06, // Responsive font size
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),

              // Email Section
              Center(
                child: Text(
                  'rakibulislammehedi4@gmail.com',
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    color: Colors.black54,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.04),

              // Account Information Section
              Text(
                'Account Information',
                style: TextStyle(
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),

              // Account Details
              _buildAccountInfoRow(
                  'Username:', 'johndoe123', screenWidth, screenHeight),
              _buildAccountInfoRow(
                  'Phone:', '+1 234 567 890', screenWidth, screenHeight),
              _buildAccountInfoRow('Address:', '123 Main Street, City',
                  screenWidth, screenHeight),

              // Task Manager App Information Section
              SizedBox(height: screenHeight * 0.04),
              Text(
                'Task Manager App Information',
                style: TextStyle(
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),

              // Task Manager Details
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

              // Spacer to push buttons to the bottom
              SizedBox(height: screenHeight * 0.03),

              // Edit Profile and Logout Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Edit Profile Button
                  TextButton(
                    onPressed: () {
                      // Navigate to edit profile screen
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileUpdateScreen(),
                          ));
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.02,
                        horizontal: screenWidth * 0.1,
                      ),
                    ),
                    child: Text(
                      'Edit Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.045,
                      ),
                    ),
                  ),

                  // Logout Button
                  ElevatedButton(
                    onPressed: () {
                      // Handle logout
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.02,
                        horizontal: screenWidth * 0.1,
                      ),
                    ),
                    child: Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.03),
            ],
          ),
        ),
      ]),
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
}
