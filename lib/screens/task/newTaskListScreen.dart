import 'package:flutter/material.dart';
import 'package:taskly/screens/widgets/tm_appBar.dart';
import 'package:taskly/style/style.dart';

class NewTaskListScreen extends StatefulWidget {
  const NewTaskListScreen({super.key});

  @override
  State<NewTaskListScreen> createState() => _NewTaskListScreenState();
}

class _NewTaskListScreenState extends State<NewTaskListScreen> {
  @override
  Widget build(BuildContext context) {
    // Get screen width and height to make the UI responsive
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: TmAppBar(),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Stack(
            children: [
              screenBackground(context),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Summary Row (Status Cards)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatusCard('09', 'Cancelled', screenWidth),
                      _buildStatusCard('12', 'Completed', screenWidth),
                      _buildStatusCard('70', 'In Progress', screenWidth),
                      _buildStatusCard('32', 'New Task', screenWidth),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  // Dynamic space based on screen height

                  // Task List Header
                  Text(
                    'Tasks Overview',
                    style: TextStyle(
                      fontSize: screenWidth * 0.05, // Responsive font size
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  // Dynamic space based on screen height

                  // Task List
                  Expanded(
                    child: ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () {
                          // Handle task item tap, maybe navigate to a task detail screen
                          print('Task $index clicked');
                        },
                        child: Card(
                          elevation: 1,
                          color: Colors.white,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12), // Rounded corners
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(screenWidth * 0.02),
                            // Dynamic padding
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Task Heading Here',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.045,
                                    // Responsive font size
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.01),
                                // Dynamic space
                                Text(
                                  'Brief description of the task goes here. Tap for more details.',
                                  style: TextStyle(
                                      fontSize: screenWidth * 0.035,
                                      color: Colors.grey),
                                ),
                                SizedBox(height: screenHeight * 0.02),
                                // Dynamic space

                                // Bottom Row with label and icon buttons
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Left side: label with green circle background
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(
                                              screenWidth * 0.02),
                                          // Responsive size
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: screenWidth *
                                                0.03, // Responsive icon size
                                          ),
                                        ),
                                        SizedBox(width: screenWidth * 0.01),
                                        // Dynamic space
                                        Text(
                                          'In Progress',
                                          // Label for task status
                                          style: TextStyle(
                                            fontSize: screenWidth * 0.035,
                                            // Responsive font size
                                            color: Colors.green,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),

                                    // Right side: Edit and Delete icons
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.edit,
                                            color: Colors.blue,
                                            size: screenWidth *
                                                0.05, // Responsive icon size
                                          ),
                                          onPressed: () {
                                            _onTapEditButton();
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                            size: screenWidth *
                                                0.05, // Responsive icon size
                                          ),
                                          onPressed: () {
                                            // Handle Delete action
                                            print('Delete Task $index');
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }

  // Custom widget for the status cards with gradient water box effect
  Widget _buildStatusCard(String count, String status, double screenWidth) {
    return Expanded(
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Rounded corners
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [Colors.green.shade300, Colors.blue.shade400],
              // Blue gradient
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: EdgeInsets.all(screenWidth * 0.01), // Dynamic padding
          child: Column(
            children: [
              Text(
                count,
                style: TextStyle(
                    fontSize: screenWidth * 0.07, // Responsive font size
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: screenWidth * 0.01), // Responsive space
              Text(
                status,
                style: TextStyle(
                    fontSize: screenWidth * 0.03, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTapEditButton() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Edit task status',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            elevation: 2,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: ['New', 'Completed', 'Progress', 'Cancelled'].map((e) {
                return ListTile(
                  onTap: () {},
                  title: Text(e),
                );
              }).toList(),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
              TextButton(onPressed: () {}, child: Text('Okay')),
            ],
          );
        });
  }
}
