import 'package:flutter/material.dart';
import 'package:taskly/screens/widgets/tm_appBar.dart';

class TaskCreateScreen extends StatefulWidget {
  const TaskCreateScreen({super.key});

  @override
  State<TaskCreateScreen> createState() => _TaskCreateScreenState();
}

class _TaskCreateScreenState extends State<TaskCreateScreen> {
  bool isTitleExpanded = false; // Track expansion for the title field

  @override
  Widget build(BuildContext context) {
    // Get screen width and height
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: TmAppBar(),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        // Adjust padding based on screen size
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.05), // Dynamic spacing
            Text(
              'Add New Task Here:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.06, // Responsive font size
                color: Colors.black87,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),

            // Title TextFormField with Custom Style
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              child: TextFormField(
                maxLines: isTitleExpanded ? null : 1,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  hintText: "Enter Task Title",
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.green, width: 2),
                  ),
                ),
                onTap: () {
                  setState(() {
                    isTitleExpanded = true;
                  });
                },
                onFieldSubmitted: (value) {
                  setState(() {
                    isTitleExpanded = false;
                  });
                },
              ),
            ),
            SizedBox(height: screenHeight * 0.02),

            // Description TextFormField with Custom Style
            TextFormField(
              minLines: 3,
              maxLines: null,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                hintText: "Enter Task Description",
                hintStyle: TextStyle(color: Colors.grey[600]),
                filled: true,
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.green, width: 2),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.04),

            // Custom 'Continue' Button
            Center(
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green),
                  padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                      vertical: screenHeight * 0.02,
                      horizontal: screenWidth * 0.1)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
                ),
                onPressed: () {},
                child: Text(
                  'Continue',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.05, // Responsive font size
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
