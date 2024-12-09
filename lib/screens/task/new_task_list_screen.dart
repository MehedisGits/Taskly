import 'package:flutter/material.dart';
import 'package:taskly/api/models/network_response.dart';
import 'package:taskly/api/models/task_list_model.dart';
import 'package:taskly/api/models/task_model.dart';
import 'package:taskly/api/services/network_caller.dart';
import 'package:taskly/screens/widgets/show_snackbar.dart';
import 'package:taskly/screens/widgets/task_card.dart';
import 'package:taskly/screens/widgets/tm_appBar.dart';
import 'package:taskly/style/style.dart';

import '../../api/urls.dart';
import 'create_new_task_screen.dart';

class Newtasklistscreen extends StatefulWidget {
  const Newtasklistscreen({super.key});

  @override
  State<Newtasklistscreen> createState() => _NewtasklistscreenState();
}

class _NewtasklistscreenState extends State<Newtasklistscreen> {
  bool _newTaskListIsInProgress = false;
  List<TaskModel> _newTaskList = [];

  @override
  void initState() {
    super.initState();
    _getNewTaskList();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width and height to make the UI responsive
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: TmAppBar(),
      floatingActionButton: FloatingActionButton.small(
        onPressed: _onTapAddFAB,
        elevation: 10,
        shape: CircleBorder(),
        backgroundColor: Colors.white,
        child: Icon(Icons.add_task, color: colorGreen),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _getNewTaskList();
        },
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Stack(
              children: [
                screenBackground(context),
                Visibility(
                  visible: !_newTaskListIsInProgress,
                  replacement: Center(child: CircularProgressIndicator()),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Summary Row (Status Cards)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStatusCard(
                              _newTaskList.length, 'Cancelled', screenWidth),
                          _buildStatusCard(12, 'Completed', screenWidth),
                          _buildStatusCard(20, 'In Progress', screenWidth),
                          _buildStatusCard(32, 'New Task', screenWidth),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      // Dynamic space based on screen height

                      // Task List Header
                      Text(
                        'New Tasks Overview',
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
                          itemCount: _newTaskList.length,
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: () {
                              // Handle task item tap, maybe navigate to a task detail screen
                              debugPrint('Task $index clicked');
                            },
                            child: BuildTaskCard(
                                index: index, taskModel: _newTaskList[index]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Future<void> _onTapAddFAB() async {
    try {
      // Pass the shouldRefresh flag to the next screen
      final bool? shouldRefresh = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TaskCreateScreen()),
      );

      // If a new task was added, refresh the task list
      if (shouldRefresh == true) {
        await _getNewTaskList(); // Refresh the task list
      }
    } catch (e) {
      showSnackBar(context, 'Failed to refresh tasks.');
    }
  }

  Future<void> _getNewTaskList() async {
    try {
      setState(() {
        _newTaskListIsInProgress = true;
      });

      final NetworkResponse response =
          await NetworkCaller.getRequest(url: getNewTaskListUrl);

      if (response.isSuccess) {
        final TaskListModel taskListModel =
            TaskListModel.fromJson(response.responseData);
        setState(() {
          _newTaskList = taskListModel.taskList ?? [];
        });
      } else {
        showSnackBar(
            context, response.errorMessage ?? 'Failed to fetch tasks.');
      }
    } catch (e) {
      showSnackBar(context, 'An unexpected error occurred.');
    } finally {
      setState(() {
        _newTaskListIsInProgress = false;
      });
    }
  }

  // Custom widget for the status cards with gradient water box effect
  Widget _buildStatusCard(int count, String status, double screenWidth) {
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
                '$count',
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
}
