import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/widgets/custom_app_bar.dart';
import '../utils/get_device_type.dart';
import '../utils/responsive_size.dart';
import '../widgets/task_card.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final RxInt selectedCategoryIndex = 0.obs;
  final RxBool searchBarClicked = false.obs;

  @override
  Widget build(BuildContext context) {

    // Define breakpoints for responsiveness
    double taskCategoryButtonSize = responsiveSize(
        context, mobileSize: 12, tabletSize: 16, desktopSize: 20
    );

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
          size: screenScale(context) * 40, // Use screen scale here for dynamic size
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8.0),
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
                    child: ListView.builder(
                      itemCount: 100,
                      itemBuilder: (context, index) {
                        return TaskCard(
                          title: 'Task title $index',
                          description: 'Task description for task $index.',
                          isMobile: DeviceType.isMobile(context),
                        );
                      },
                    ),
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
    List<String> categories = [
      'New',
      'Work',
      'Personal',
      'Cancelled',
      'In Progress',
      'Completed'
    ];
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
