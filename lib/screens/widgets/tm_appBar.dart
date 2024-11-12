import 'package:flutter/material.dart';
import 'package:taskly/screens/profile/profileScreen.dart';

class TmAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TmAppBar({super.key, this.isProfileScreenOpen = false});

  final String userName = "Mehedi";

  final bool isProfileScreenOpen;

  String greetingMessage() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  Widget _buildGreetingRow(double screenWidth, context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            if (isProfileScreenOpen) {
              return;
            }
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(),
                ));
          },
          child: ClipOval(
            child: Image.network(
              "https://avatars.githubusercontent.com/u/125388734?v=4",
              height: screenWidth * 0.1,
              // Responsive size based on screen width
              width: screenWidth * 0.1,
              // Responsive size based on screen width
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(width: screenWidth * 0.02),
        // Increased space for better alignment
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${greetingMessage()}, $userName',
              style: TextStyle(
                color: Colors.white,
                fontSize: screenWidth * 0.040, // Responsive font size
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: screenWidth * 0.01), // Added spacing between texts
            Text(
              'rakibulislammehedi4@gmail.com',
              style: TextStyle(
                color: Colors.white70,
                fontSize: screenWidth * 0.030, // Responsive font size
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; // Get screen width

    return AppBar(
      backgroundColor: Colors.green,
      title: Row(
        children: [
          Expanded(
            child: _buildGreetingRow(screenWidth, context),
          ),
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("No new notification"),
                duration: Duration(seconds: 2),
              ));
            },
            icon: Icon(Icons.notification_important, color: Colors.white),
            tooltip: 'Notifications',
            iconSize: screenWidth * 0.05, // Responsive icon size
          ),
        ],
      ),
      iconTheme: IconThemeData(color: Colors.white), // Consistent icon color
      elevation: 0, // Flat appearance
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
