import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Fo
import 'package:taskly/api/models/network_response.dart';
import 'package:taskly/api/models/task_model.dart';
import 'package:taskly/api/services/network_caller.dart';
import 'package:taskly/api/urls.dart';
import 'package:taskly/screens/widgets/show_snackbar.dart';

class BuildTaskCard extends StatefulWidget {
  const BuildTaskCard({
    super.key,
    required this.index,
    required this.taskModel,
    required this.onRefreshList,
  });

  final int index;
  final TaskModel taskModel;
  final VoidCallback onRefreshList;

  @override
  State<BuildTaskCard> createState() => _BuildTaskCardState();
}

class _BuildTaskCardState extends State<BuildTaskCard> {
  String _selectedStatus = '';
  bool _changeStatusInProgress = false;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.taskModel.status!;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final formattedDate = widget.taskModel.createdDate != null
        ? DateFormat('yyyy-MM-dd')
            .format(DateTime.parse(widget.taskModel.createdDate!))
        : 'Date not available';

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
            SizedBox(
              height: screenHeight * 0.01,
            ),
            Text(
              'Created date: $formattedDate ' ?? '',
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
                        size: screenWidth * 0.02, // Responsive icon size
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.01),
                    // Dynamic space
                    Text(
                      widget.taskModel.status ?? '',
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
                    Visibility(
                      visible: !_changeStatusInProgress,
                      replacement: Center(
                        child: CircularProgressIndicator(),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.blue,
                          size: screenWidth * 0.05, // Responsive icon size
                        ),
                        onPressed: () {
                          _onTapEditButton();
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: screenWidth * 0.05, // Responsive icon size
                      ),
                      onPressed: () {
                        // Handle Delete action
                        _onTapDeleteButton();
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

  void _onTapDeleteButton() {
    _deleteTaskFromList();
  }

  Future<void> _deleteTaskFromList() async {
    _changeStatusInProgress = false;
    setState(() {});
    NetworkResponse response = await NetworkCaller.getRequest(
        url: deleteTask(widget.taskModel.sId ?? ''));
    if (response.isSuccess) {
      widget.onRefreshList();
      showSnackBar(context, 'Task Deleted successfully');
    } else {
      showSnackBar(context, response.errorMessage);
    }
    setState(() {
      _changeStatusInProgress = false;
    });
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
                  onTap: () {
                    _changeStatus(e);
                    Navigator.pop(context);
                  },
                  title: Text(e),
                  selected: _selectedStatus == e,
                  trailing:
                      _selectedStatus == e ? const Icon(Icons.check) : null,
                );
              }).toList(),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
            ],
          );
        });
  }

  Future<void> _changeStatus(String status) async {
    _changeStatusInProgress = true;
    setState(() {});

    final NetworkResponse response = await NetworkCaller.getRequest(
        url: updateTaskStatus(widget.taskModel.sId!, status));

    if (response.isSuccess) {
      setState(() {
        _selectedStatus = status; // Update the selected status locally
      });
      widget.onRefreshList(); // Notify parent to refresh the list

      // Special behavior for "Completed" status
      if (status == "Completed") {
        showSnackBar(context, 'Task marked as Completed successfully!');
      } else if (status == "New") {
        showSnackBar(context, 'Task marked as New successfully!');
      }
    } else {
      _changeStatusInProgress = false;
      setState(() {});
      showSnackBar(context, response.errorMessage);
    }
  }
}
