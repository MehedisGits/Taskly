import 'package:flutter/material.dart';
import 'package:taskly/api/models/task_model.dart';

class BuildTaskCard extends StatefulWidget {
  const BuildTaskCard({
    super.key,
    required this.index,
    required this.taskModel,
  });

  final int index;
  final TaskModel taskModel;

  @override
  State<BuildTaskCard> createState() => _BuildTaskCardState();
}

class _BuildTaskCardState extends State<BuildTaskCard> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Card(
      elevation: 1,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Rounded corners
      ),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.02),
        // Dynamic padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.taskModel.title ?? '',
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
              widget.taskModel.description ?? '',
              style:
                  TextStyle(fontSize: screenWidth * 0.035, color: Colors.grey),
            ),
            SizedBox(height: screenHeight * 0.02),
            // Dynamic space

            // Bottom Row with label and icon buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left side: label with green circle background
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(screenWidth * 0.02),
                      // Responsive size
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: screenWidth * 0.03, // Responsive icon size
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
                        size: screenWidth * 0.05, // Responsive icon size
                      ),
                      onPressed: () {
                        _onTapEditButton();
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: screenWidth * 0.05, // Responsive icon size
                      ),
                      onPressed: () {
                        // Handle Delete action
                        print('Delete Task $widget.index');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
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
