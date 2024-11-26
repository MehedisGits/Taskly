import 'package:flutter/material.dart';
import 'package:taskly/screens/widgets/tm_appBar.dart';

class CancelledTaskListScreen extends StatelessWidget {
  const CancelledTaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen width and height to make the UI responsive
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: TmAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Screen Title
            Text(
              'Cancelled Task Overview',
              style: _getTitleStyle(screenWidth),
            ),
            SizedBox(height: screenHeight * 0.01),

            // Cancelled Task List
            Expanded(
              child: ListView.builder(
                itemCount: 10, // Example task count, replace with dynamic count
                itemBuilder: (context, index) =>
                    _buildCancelledTaskCard(screenWidth, screenHeight, index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Custom method to get title style based on screen width
  TextStyle _getTitleStyle(double screenWidth) {
    return TextStyle(
      fontSize: screenWidth * 0.05,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    );
  }

  // Custom method to get text style for task info
  TextStyle _getTextStyle(double screenWidth, Color color, {double? fontSize}) {
    return TextStyle(
      fontSize: fontSize ?? screenWidth * 0.04,
      color: color,
    );
  }

  // Custom widget for displaying each cancelled task
  Widget _buildCancelledTaskCard(
      double screenWidth, double screenHeight, int index) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Rounded corners
      ),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task Title
            Text(
              'Cancelled Task $index',
              style: _getTextStyle(screenWidth, Colors.black87,
                  fontSize: screenWidth * 0.05),
            ),
            SizedBox(height: screenHeight * 0.02),

            // Task Description
            Text(
              'This task has been cancelled. No further actions will be taken.',
              style: _getTextStyle(screenWidth, Colors.black54),
            ),
            SizedBox(height: screenHeight * 0.02),

            // Task Cancellation Date
            Text(
              'Cancelled on: ${DateTime.now().toLocal().toString().split(' ')[0]}',
              style: _getTextStyle(screenWidth, Colors.grey),
            ),
            SizedBox(height: screenHeight * 0.02),

            // Cancelled Task Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Reschedule Button
                TextButton.icon(
                  icon: Icon(
                    Icons.schedule,
                    color: Colors.green,
                    size: screenWidth * 0.05,
                  ),
                  label: Text(
                    'Reschedule',
                    style: _getTextStyle(screenWidth, Colors.green),
                  ),
                  onPressed: () {
                    print('Reschedule Task $index');
                  },
                ),

                // Delete Button
                TextButton.icon(
                  icon: Icon(
                    Icons.delete_forever,
                    color: Colors.red,
                    size: screenWidth * 0.05,
                  ),
                  label: Text(
                    'Delete',
                    style: _getTextStyle(screenWidth, Colors.red),
                  ),
                  onPressed: () {
                    print('Delete Task $index');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
