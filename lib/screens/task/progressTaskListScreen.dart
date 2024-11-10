import 'package:flutter/material.dart';

class TaskProgressScreen extends StatelessWidget {
  const TaskProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen width and height to make the UI responsive
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task Title
            Text(
              'Task Progress Overview',
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            // Progress bar and info
            _buildProgressCard(screenWidth, screenHeight),
            SizedBox(height: screenHeight * 0.03),
            // Task Details Section
            _buildTaskDetails(screenWidth, screenHeight),
          ],
        ),
      ),
    );
  }

  // Custom widget for the progress card with status
  Widget _buildProgressCard(double screenWidth, double screenHeight) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Rounded corners
      ),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          children: [
            // Progress Title
            Text(
              'Progress: In Progress',
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            // Progress Bar
            LinearProgressIndicator(
              value: 0.7, // 70% progress
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
            SizedBox(height: screenHeight * 0.02),
            // Progress Message
            Text(
              '70% of the task is completed, keep it going!',
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Custom widget for task details
  Widget _buildTaskDetails(double screenWidth, double screenHeight) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task Name
            Text(
              'Task: UI Development for Mobile App',
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            // Task Description
            Text(
              'This task involves the development of UI screens for the mobile application. The progress is currently at 70%, with only a few screens remaining to be implemented.',
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            // Task Deadline
            Text(
              'Deadline: 30th November 2024',
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            // Task Priority
            Text(
              'Priority: High',
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                color: Colors.redAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
