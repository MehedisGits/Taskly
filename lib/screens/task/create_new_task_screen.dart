import 'package:flutter/material.dart';
import 'package:taskly/api/models/network_response.dart';
import 'package:taskly/api/services/network_caller.dart';
import 'package:taskly/api/urls.dart';
import 'package:taskly/screens/widgets/show_snackbar.dart';
import 'package:taskly/screens/widgets/tm_appBar.dart';
import 'package:taskly/style/style.dart';

class TaskCreateScreen extends StatefulWidget {
  const TaskCreateScreen({super.key});

  @override
  State<TaskCreateScreen> createState() => _TaskCreateScreenState();
}

class _TaskCreateScreenState extends State<TaskCreateScreen> {
  bool isTitleExpanded = false; // Track expansion for the title field
  final TextEditingController _titleTEController = TextEditingController();
  final TextEditingController _descriptionTEController =
      TextEditingController();

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool _shouldRefreshPrevPage = false;

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
        child: Form(
          key: _globalKey,
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
              TextFormField(
                controller: _titleTEController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter task title";
                  }
                  return null;
                },
                maxLines: isTitleExpanded ? null : 1,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  hintText: "Enter Task Title",
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.green, width: 1),
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
              SizedBox(height: screenHeight * 0.02),

              // Description TextFormField with Custom Style
              TextFormField(
                controller: _descriptionTEController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter task description";
                  }
                  return null;
                },
                minLines: 3,
                maxLines: null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  hintText: "Enter Task Description",
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.green, width: 1),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.04),

              // Custom 'Continue' Button
              ElevatedButton(
                onPressed: isLoading ? null : _onTapSubmitButton,
                style: appButtonStyle(),
                child: isLoading
                    ? SizedBox(
                        width: double.infinity,
                        child: Center(
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                      )
                    : successButtonChild('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTapSubmitButton() {
    if (_globalKey.currentState!.validate()) {
      _addNewTask();
    }
  }

  Future<void> _addNewTask() async {
    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> postData = {
      "title": _titleTEController.text.trim(),
      "description": _descriptionTEController.text.trim(),
      "status": "New"
    };

    NetworkResponse response =
        await NetworkCaller.postRequest(url: addNewTaskUrl, body: postData);

    setState(() {
      isLoading = false;
    });

    if (response.isSuccess) {
      _shouldRefreshPrevPage = true;
      showSnackBar(context, "New task added");
      _titleTEController.clear();
      _descriptionTEController.clear();
    } else if (response.statusCode == 401) {
      showSnackBar(context, 'Unauthorized user', isError: true);
    } else {
      showSnackBar(context, response.errorMessage, isError: true);
    }
    Navigator.pop(context, _shouldRefreshPrevPage);
  }
}
