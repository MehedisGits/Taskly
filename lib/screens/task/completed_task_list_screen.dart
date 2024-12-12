import 'package:flutter/material.dart';
import 'package:taskly/api/models/network_response.dart';
import 'package:taskly/api/models/task_list_model.dart';
import 'package:taskly/api/models/task_model.dart';
import 'package:taskly/api/services/network_caller.dart';
import 'package:taskly/api/urls.dart';
import 'package:taskly/screens/widgets/show_snackbar.dart';
import 'package:taskly/screens/widgets/task_card.dart';

import '../widgets/tm_appBar.dart';

class CompletedTaskListScreen extends StatefulWidget {
  const CompletedTaskListScreen({super.key});

  @override
  State<CompletedTaskListScreen> createState() =>
      _CompletedTaskListScreenState();
}

class _CompletedTaskListScreenState extends State<CompletedTaskListScreen> {
  bool _completedTaskListInProgress = false;
  List<TaskModel> _completedTaskList = [];

  @override
  void initState() {
    super.initState();
    _getCompletedTaskList();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    double screenWidth = mediaQuery.size.width;
    double screenHeight = mediaQuery.size.height;

    return Scaffold(
      appBar: TmAppBar(),
      body: RefreshIndicator(
        onRefresh: () async {
          await _getCompletedTaskList();
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Visibility(
            visible: !_completedTaskListInProgress,
            replacement: Center(
              child: CircularProgressIndicator(),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Screen Title
                Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    'Completed Tasks',
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Divider(
                  color: Colors.grey.shade400,
                  thickness: 1.0,
                  height: 1.0,
                ),
                SizedBox(height: screenHeight * 0.01),

                // Completed Task List
                Expanded(
                  child: _completedTaskList.isEmpty &&
                          !_completedTaskListInProgress
                      ? Center(child: Text('No completed tasks available.'))
                      : ListView.builder(
                          itemCount: _completedTaskList.length,
                          itemBuilder: (context, index) => BuildTaskCard(
                            index: index,
                            taskModel: _completedTaskList[index],
                            onRefreshList: _getCompletedTaskList,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _getCompletedTaskList() async {
    try {
      setState(() {
        _completedTaskListInProgress = true;
      });

      final NetworkResponse response =
          await NetworkCaller.getRequest(url: getCompletedTaskListUrl);

      if (response.isSuccess) {
        print('API Response Data: ${response.responseData}');
        final TaskListModel taskListModel =
            TaskListModel.fromJson(response.responseData);

        if (taskListModel.taskList == null || taskListModel.taskList!.isEmpty) {
          setState(() {
            _completedTaskList = [];
          });
          showSnackBar(context, 'No completed tasks found.');
        } else {
          setState(() {
            _completedTaskList = taskListModel.taskList!;
          });
        }
      } else {
        showSnackBar(context, 'API Error: ${response.errorMessage}');
      }
    } catch (e) {
      showSnackBar(context, 'An unexpected error occurred.');
      print('Error: $e');
    } finally {
      setState(() {
        _completedTaskListInProgress = false;
      });
    }
  }
}
