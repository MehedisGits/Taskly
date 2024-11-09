import 'package:flutter/material.dart';
import 'package:taskly/style/style.dart';

class TmAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TmAppBar({super.key});

  final String userName = "Mehedi";

  String greetingMessage() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  Widget _buildGreetingRow() {
    return Row(
      children: [
        ClipOval(
          child: Image.network(
            "https://avatars.githubusercontent.com/u/125388734?v=4",
            height: 48,
            width: 48,
          ),
        ),
        SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${greetingMessage()}, $userName',
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
            Text(
              'rakibulislammehedi4@gmail.com',
              style: TextStyle(color: colorLightGrey, fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Row(
        children: [
          Expanded(
            child: _buildGreetingRow(),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notification_important, color: Colors.black),
            tooltip: 'Notifications',
          ),
        ],
      ),
      iconTheme: IconThemeData(color: Colors.black), // Consistent icon color
      elevation: 0, // Flat appearance
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
