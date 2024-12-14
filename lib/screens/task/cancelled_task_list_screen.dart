import 'package:flutter/material.dart';
import 'package:taskly/api/models/network_response.dart';
import 'package:taskly/api/models/task_list_model.dart';
import 'package:taskly/api/models/task_model.dart';
import 'package:taskly/api/services/network_caller.dart';
import 'package:taskly/api/urls.dart';
import 'package:taskly/screens/widgets/show_snack_bar.dart';
import 'package:taskly/screens/widgets/task_card.dart';
import 'package:taskly/screens/widgets/tm_appBar.dart';
import 'package:taskly/style/style.dart';

class CancelledTaskListScreen extends StatefulWidget {
  const CancelledTaskListScreen({super.key});

  @override
  State<CancelledTaskListScreen> createState() =>
      _CancelledTaskListScreenState();
}

class _CancelledTaskListScreenState extends State<CancelledTaskListScreen> {
  bool _cancelledTaskListInProgress = false;
  bool _apiCallFailed = false;
  List<TaskModel> _cancelledTaskList = [];

  @override
  void initState() {
    super.initState();
    _getCancelledTaskList();
  }

  Future<void> _getCancelledTaskList() async {
    _cancelledTaskListInProgress = true;
    _apiCallFailed = false;
    setState(() {});
    final NetworkResponse response =
        await NetworkCaller.getRequest(url: getCancelledTaskListUrl);
    if (response.isSuccess) {
      final TaskListModel taskListModel =
          TaskListModel.fromJson(response.responseData);
      _cancelledTaskList = taskListModel.taskList ?? [];
    } else {
      _apiCallFailed = true;
      showSnackBar(context, response.errorMessage);
    }
    _cancelledTaskListInProgress = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width and height to make the UI responsive
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: TmAppBar(),
      body: Stack(
        children: [
          screenBackground(context),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: screenHeight * 0.01, horizontal: screenWidth * 0.02),
            child: RefreshIndicator(
              onRefresh: () async {
                await _getCancelledTaskList();
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Screen Title
                  Center(
                    child: Text(
                      textAlign: TextAlign.center,
                      'Cancelled Tasks',
                      style: _getTitleStyle(screenWidth),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Divider(
                    color: Colors.grey.shade400,
                    thickness: 1.0,
                    height: 1.0,
                  ),
                  SizedBox(height: screenHeight * 0.01),

                  // Cancelled Task List with Loading and Error Handling
                  Expanded(
                    child: _cancelledTaskListInProgress
                        ? Center(child: CircularProgressIndicator())
                        : _apiCallFailed
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Failed to load tasks. Please try again.',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.05,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * 0.02),
                                    ElevatedButton(
                                      onPressed: _getCancelledTaskList,
                                      child: Text('Retry'),
                                    ),
                                  ],
                                ),
                              )
                            : _cancelledTaskList.isEmpty
                                ? Center(
                                    child: Text(
                                      'No cancelled tasks available.',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.05,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: _cancelledTaskList.length,
                                    itemBuilder: (context, index) =>
                                        GestureDetector(
                                      onTap: () {},
                                      child: BuildTaskCard(
                                        index: index,
                                        taskModel: _cancelledTaskList[index],
                                        onRefreshList: _getCancelledTaskList,
                                      ),
                                    ),
                                  ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
}
