import 'package:flutter/material.dart';

class NewTaskListScreen extends StatefulWidget {
  const NewTaskListScreen({super.key});

  @override
  State<NewTaskListScreen> createState() => _taskListScreenState();
}

class _taskListScreenState extends State<NewTaskListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Card(
                  margin: EdgeInsets.all(8),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          '17',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                        Text('Cancelled')
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Card(
                  margin: EdgeInsets.all(8),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          '17',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                        Text('Completed')
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Card(
                  margin: EdgeInsets.all(8),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          '17',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                        Text('Progress')
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Card(
                  margin: EdgeInsets.all(8),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          '17',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                        Text('New Task')
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    ));
  }
}
