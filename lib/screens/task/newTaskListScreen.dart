import 'package:flutter/material.dart';

class Newtasklistscreen extends StatefulWidget {
  const Newtasklistscreen({super.key});

  @override
  State<Newtasklistscreen> createState() => _NewtasklistscreenState();
}

class _NewtasklistscreenState extends State<Newtasklistscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Row
            Row(
              children: [
                Expanded(
                  child: Card(
                    elevation: 0,
                    color: Colors.black12,
                    child: Column(
                      children: const [
                        Text(
                          '09',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w600),
                        ),
                        Text('Cancelled'),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 4),
                Expanded(
                  child: Card(
                    elevation: 0,
                    color: Colors.black12,
                    child: Column(
                      children: const [
                        Text(
                          '12',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w600),
                        ),
                        Text('Completed'),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 4),
                Expanded(
                  child: Card(
                    elevation: 0,
                    color: Colors.black12,
                    child: Column(
                      children: const [
                        Text(
                          '70',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w600),
                        ),
                        Text('In Progress'),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 4),
                Expanded(
                  child: Card(
                    color: Colors.black12,
                    elevation: 0,
                    child: Column(
                      children: const [
                        Text(
                          '32',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w600),
                        ),
                        Text('New Task'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),

            // Task List
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) => Card(
                  elevation: 0.8,
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Heading',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Description',
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
