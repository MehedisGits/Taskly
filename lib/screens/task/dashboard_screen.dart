import 'package:flutter/material.dart';
import 'package:taskly/screens/task/cancelled_task_list_screen.dart';
import 'package:taskly/screens/task/completed_task_list_screen.dart';
import 'package:taskly/screens/task/new_task_list_screen.dart';
import 'package:taskly/screens/task/progress_task_list_screen.dart';
import 'package:taskly/style/style.dart';

class NewTaskListScreen extends StatefulWidget {
  const NewTaskListScreen({super.key});

  @override
  State<NewTaskListScreen> createState() => _NewTaskListScreenState();
}

class _NewTaskListScreenState extends State<NewTaskListScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    Center(child: Newtasklistscreen()),
    Center(child: CancelledTaskListScreen()),
    Center(child: TaskProgressScreen()),
    Center(child: CompletedTaskListScreen()),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: NavigationBar(
          indicatorColor: colorLight,
          backgroundColor: Colors.white,
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onItemTapped,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.new_label_outlined),
              selectedIcon: Icon(Icons.new_label),
              label: 'New',
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
          ],
        ),
        body: Stack(
          children: [
            screenBackground(context),
            Column(
              children: [
                Expanded(
                  child: IndexedStack(
                    index: _selectedIndex,
                    children: _pages,
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
