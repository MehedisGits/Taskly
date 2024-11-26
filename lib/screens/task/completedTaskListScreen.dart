import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting

import '../widgets/tm_appBar.dart';

class CompletedTaskListScreen extends StatelessWidget {
  const CompletedTaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    double screenWidth = mediaQuery.size.width;
    double screenHeight = mediaQuery.size.height;

    return Scaffold(
      appBar: TmAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Screen Title
            Text(
              'Completed Task Overview',
              style: TextStyle(
                fontSize: screenWidth * 0.06,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),

            // Completed Task List
            Expanded(
              child: ListView.builder(
                itemCount: 10, // Replace with actual task count
                itemBuilder: (context, index) =>
                    _buildCompletedTaskCard(screenWidth, screenHeight, index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Custom widget for displaying each completed task
  Widget _buildCompletedTaskCard(
      double screenWidth, double screenHeight, int index) {
    final formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Rounded corners
      ),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task Title
            Text(
              'Completed Task $index',
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),

            // Task Description
            Text(
              'This task has been completed successfully.',
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),

            // Task Completion Date
            Text(
              'Completed on: $formattedDate',
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),

            // Completed Task Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Archive Button
                TextButton.icon(
                  icon: Icon(
                    Icons.archive,
                    color: Colors.orange,
                    size: screenWidth * 0.05,
                  ),
                  label: Text(
                    'Archive',
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: Colors.orange,
                    ),
                  ),
                  onPressed: () {
                    print('Archive Task $index');
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
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: Colors.red,
                    ),
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
