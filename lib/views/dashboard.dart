import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../utils/get_device_type.dart';
import '../utils/responsive_size.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/task_card.dart';
import '../controllers/task_list_controller.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final RxInt selectedCategoryIndex = 0.obs;
  final RxBool searchBarClicked = false.obs;

  final TaskListController taskListController = Get.put(TaskListController());
  final List<String> categories = [
    'New',
    'Cancelled',
    'InProgress',
    'Completed',
  ];

  @override
  void initState() {
    super.initState();
    // Fetch all data for the categories when the screen is opened
    _fetchAllData();
  }

  // Function to fetch all task data for all categories
  void _fetchAllData() {
    for (var category in categories) {
      _checkInternetConnection(category);
    }
  }

  // Function to check internet connectivity before fetching tasks
  void _checkInternetConnection(String endpoint) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      // If no internet connection, show a dialog
      _showNoInternetDialog();
    } else {
      // Fetch data only if the internet connection is available
      taskListController.fetchData(endpoint);
    }
  }

  // Show dialog when there is no internet connection
  void _showNoInternetDialog() {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("No Internet Connection"),
          content: Text("Please check your internet connection."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double taskCategoryButtonSize = responsiveSize(context,
        mobileSize: 12, tabletSize: 16, desktopSize: 20);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.snackbar('Add a new task', 'Click here to add a new task.',
              margin: const EdgeInsets.all(12));
        },
        backgroundColor: Colors.grey,
        focusColor: Colors.green,
        hoverColor: Colors.green,
        focusElevation: 5,
        child: Icon(
          Icons.add,
          size: screenScale(context) * 40,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8.0 * screenScale(context)),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  // Floating Custom App Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(flex: 1, child: CustomAppBar()),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Responsive Task Category Buttons
                  buildTaskCategoryButtons(taskCategoryButtonSize),
                  const SizedBox(height: 12),
                  // Task List View
                  Expanded(
                    flex: 1,
                    child: Obx(() {
                      final taskData = taskListController.taskData.value;
                      final isLoading = taskListController.isLoading.value;

                      // Show loading spinner while fetching data
                      if (isLoading) {
                        return Center(child: CircularProgressIndicator());
                      }

                      // Check if taskData is null or empty
                      if (taskData == null || (taskData['data'] as List).isEmpty) {
                        return const Center(
                          child: Text("No tasks available in your selected category."),
                        );
                      }

                      final tasks = taskData['data'] as List<dynamic>;

                      return ListView.builder(
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index];
                          return TaskCard(
                            title: task['title'],
                            description: task['description'],
                            isMobile: DeviceType.isMobile(context),
                            taskStatus: task['status'],
                          );
                        },
                      );
                    }),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  /// Builds a responsive row of task category buttons
  Widget buildTaskCategoryButtons(double buttonSize) {
    return Obx(() => Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(categories.length, (index) {
        return buildCategoryButton(categories[index], index, buttonSize);
      }),
    ));
  }

  /// Helper to build an individual category button
  Widget buildCategoryButton(String text, int index, double buttonSize) {
    return TextButton(
      onPressed: () {
        selectedCategoryIndex.value = index;

        // Trigger fetch task data when a category is selected
        final selectedCategory = categories[index];
        final endpoint = selectedCategory;

        // Check internet connection before fetching tasks
        _checkInternetConnection(endpoint);
      },
      style: TextButton.styleFrom(
        backgroundColor:
        selectedCategoryIndex.value == index ? Colors.green : Colors.grey,
        padding: EdgeInsets.symmetric(
          horizontal: buttonSize,
          vertical: buttonSize,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: buttonSize,
        ),
      ),
    );
  }
}
