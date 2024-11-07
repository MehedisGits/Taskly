import 'package:flutter/material.dart';
import 'package:taskly/style/style.dart';

class NewTaskListScreen extends StatefulWidget {
  const NewTaskListScreen({super.key});

  @override
  State<NewTaskListScreen> createState() => _taskListScreenState();
}

class _taskListScreenState extends State<NewTaskListScreen> {
  int _selectedIndex = 0;
  String userName = "Mehedi";
  static const List<Widget> _pages = <Widget>[
    Center(child: Text('New Task List Screen')),
    Center(child: Text('Cancelled Task List Screen')),
    Center(child: Text('Progress Task List Screen')),
    Center(child: Text('Completed Task List Screen')),
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
          indicatorColor: Colors.green,
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
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ClipOval(
                                child: Image.network(
                                  "https://avatars.githubusercontent.com/u/125388734?v=4",
                                  height: 48,
                                  width: 48,
                                ),
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Good morning, $userName',
                                    style: TextStyle(
                                        color: colorLightGrey,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    'rakibulislammehedi4@gmail.com',
                                    style: TextStyle(color: colorLightGrey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.notification_important))
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(height: 20),
                    Expanded(child: _pages[_selectedIndex])
                  ],
                ),
              ],
            )));
  }
}

//Top Row for Count every Task...
