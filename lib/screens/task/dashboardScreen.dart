import 'package:flutter/material.dart';
import 'package:taskly/screens/task/newTaskListScreen.dart';
import 'package:taskly/screens/task/taskCreateScreen.dart';
import 'package:taskly/style/style.dart';

class NewTaskListScreen extends StatefulWidget {
  const NewTaskListScreen({super.key});

  @override
  State<NewTaskListScreen> createState() => _NewTaskListScreenState();
}

class _NewTaskListScreenState extends State<NewTaskListScreen> {
  int _selectedIndex = 0;
  String userName = "Mehedi";

  static const List<Widget> _pages = <Widget>[
    Center(child: Newtasklistscreen()),
    Center(child: Text('Cancelled Task List Screen')),
    Center(child: Text('Progress Task List Screen')),
    Center(child: Text('Completed Task List Screen')),
    Center(child: Text('Profile Screen')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Expanded(
              child: _buildGreetingRow(),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.notification_important),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TaskCreateScreen()),
          );
        },
        shape: CircleBorder(),
        backgroundColor: Colors.white,
        child: Icon(Icons.add_task, color: colorGreen),
      ),
      bottomNavigationBar: NavigationBar(
        indicatorColor: colorLight,
        backgroundColor: Colors.white,
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.new_label_outlined),
            selectedIcon: Icon(Icons.new_label),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.cancel_outlined),
            selectedIcon: Icon(Icons.cancel),
            label: 'Cancelled',
          ),
          NavigationDestination(
            icon: Icon(Icons.timelapse_outlined),
            selectedIcon: Icon(Icons.timelapse),
            label: 'Progress',
          ),
          NavigationDestination(
            icon: Icon(Icons.check_circle_outline),
            selectedIcon: Icon(Icons.check_circle),
            label: 'Completed',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_2_outlined),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: _pages,
            ),
          ),
        ],
      ),
    );
  }
}
