import 'package:flutter/material.dart';

class NewTaskListScreen extends StatefulWidget {
  const NewTaskListScreen({super.key});

  @override
  State<NewTaskListScreen> createState() => _taskListScreenState();
}

class _taskListScreenState extends State<NewTaskListScreen> {
  int _selectedIndex = 0;

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
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Rakibul Islam Mehedi',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.white)),
              Text('rakibulislammehedi4@gmail.com',
                  style: TextStyle(fontSize: 14, color: Colors.white70)),
            ],
          ),
          leading: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://avatars.githubusercontent.com/u/125388734?v=4'),
            ),
          ),
        ),
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
                    TaskCountRow(),
                    SizedBox(height: 20),
                    Expanded(child: _pages[_selectedIndex])
                  ],
                ),
              ],
            )));
  }
}

//Top Row for Count every Task...
class TaskCountRow extends StatelessWidget {
  const TaskCountRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.white),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  children: [
                    Text(
                      '17',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    Text('Cancelled')
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 8,
        ),
        Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.white),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  children: [
                    Text(
                      '17',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    Text('Completed')
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 8,
        ),
        Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.white),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  children: [
                    Text(
                      '17',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    Text('Progress')
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 8,
        ),
        Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.white),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  children: [
                    Text(
                      '17',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    Text('New Task')
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
