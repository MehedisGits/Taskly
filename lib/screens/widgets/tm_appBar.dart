import 'package:flutter/material.dart';
import 'package:taskly/screens/profile/profile_screen.dart';

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
              height: screenWidth * 0.12, // Adjusting the profile image size
              width: screenWidth * 0.12,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(width: screenWidth * 0.03),
        // Adjusted space for better alignment
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${greetingMessage()}, $userName',
              style: TextStyle(
                color: Colors.white,
                fontSize: screenWidth * 0.045, // More flexible font scaling
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: screenWidth * 0.015),
            // Spacing between texts for better readability
            Text(
              'rakibulislammehedi4@gmail.com',
              style: TextStyle(
                color: Colors.white70,
                fontSize: screenWidth * 0.035, // Responsive font size
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
    double screenHeight =
        MediaQuery.of(context).size.height; // Get screen height
    bool isLandscape = MediaQuery.of(context).orientation ==
        Orientation.landscape; // Check for landscape orientation
    bool canPop = Navigator.canPop(
        context); // Check if the current screen can pop (back button exists)

    return AppBar(
      backgroundColor: Colors.green,
      automaticallyImplyLeading: canPop,
      // Show back button if there's a previous screen
      leading: canPop
          ? IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context); // Navigate back
              },
            )
          : null,
      // Show back button in navigation stack
      title: isLandscape
          ? Row(
              children: [
                Expanded(
                  child: _buildGreetingRow(screenWidth, context),
                ),
                IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("No new notifications"),
                      duration: Duration(seconds: 2),
                    ));
                  },
                  icon: Icon(Icons.notification_important, color: Colors.white),
                  tooltip: 'Notifications',
                  iconSize:
                      screenWidth * 0.07, // More dynamic icon size in landscape
                ),
              ],
            )
          : _buildGreetingRow(screenWidth, context),
      iconTheme: IconThemeData(color: Colors.white),
      elevation: 0, // Flat appearance
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
