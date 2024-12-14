import 'package:flutter/material.dart';
import 'package:taskly/api/models/network_response.dart';
import 'package:taskly/api/models/task_list_model.dart';
import 'package:taskly/api/models/task_model.dart';
import 'package:taskly/api/services/network_caller.dart';
import 'package:taskly/screens/widgets/show_snack_bar.dart';
import 'package:taskly/screens/widgets/task_card.dart';
import 'package:taskly/screens/widgets/tm_appBar.dart';
import 'package:taskly/style/style.dart';

import '../../api/urls.dart';

class TaskProgressScreen extends StatefulWidget {
  const TaskProgressScreen({super.key});

  @override
  State<TaskProgressScreen> createState() => _TaskProgressScreenState();
}

class _TaskProgressScreenState extends State<TaskProgressScreen> {
  bool _progressTaskInProgress = false;
  List<TaskModel> _progressTaskList = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, _getProgressTaskList);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: TmAppBar(),
      body: Stack(
        children: [
          screenBackground(context),
          Column(
            children: [
              SizedBox(height: screenHeight * 0.01), // Add spacing at the top
              Center(
                child: Text(
                  'Progress Tasks',
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.01,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                child: Divider(
                  color: Colors.grey.shade400,
                  thickness: 1.0,
                  height: 1.0,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.01,
                      horizontal: screenWidth * 0.02),
                  child: RefreshIndicator(
                    onRefresh: _getProgressTaskList,
                    child: _progressTaskInProgress
                        ? Center(child: CircularProgressIndicator())
                        : _progressTaskList.isEmpty
                            ? Center(
                                child: Text(
                                  'No tasks in progress!',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.05,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                itemCount: _progressTaskList.length,
                                itemBuilder: (context, index) =>
                                    GestureDetector(
                                  onTap: () {
                                    // Add desired onTap functionality
                                  },
                                  child: BuildTaskCard(
                                    index: index,
                                    taskModel: _progressTaskList[index],
                                    onRefreshList: _getProgressTaskList,
                                  ),
                                ),
                              ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _getProgressTaskList() async {
    setState(() {
      _progressTaskInProgress = true;
    });
    try {
      final NetworkResponse response =
          await NetworkCaller.getRequest(url: getProgressTaskListUrl);

      if (response.isSuccess) {
        final TaskListModel taskListModel =
            TaskListModel.fromJson(response.responseData);
        setState(() {
          _progressTaskList = taskListModel.taskList ?? [];
        });
      } else {
        showSnackBar(context, response.errorMessage ?? 'Failed to load tasks');
      }
    } catch (e) {
      showSnackBar(context, 'An error occurred while fetching tasks.');
    } finally {
      setState(() {
        _progressTaskInProgress = false;
      });
    }
  }
}
