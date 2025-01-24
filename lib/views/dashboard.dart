import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/task_card.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final RxInt selectedCategoryIndex =
      0.obs; // Reactive index to track selected button
  final RxBool searchBarClicked = false.obs;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 600; // Mobile screens
    bool isTablet = screenWidth >= 600 && screenWidth < 1024; // Tablet screens
    bool isDesktop = screenWidth >= 1024; // Desktop screens

    int newTasksCount = 100;
    String newCount = newTasksCount.toString();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.snackbar('Add a new task', 'Message here',
              margin: const EdgeInsets.all(12));
        },
        backgroundColor: Colors.grey[400],
        child: Icon(
          Icons.add,
          size: isMobile
              ? 30
              : isTablet
                  ? 35
                  : 40, // Adjust FAB size based on device
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  // Floating App Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: buildFloatingAppBarCard(screenWidth),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Responsive Task Category Buttons
                  buildTaskCategoryButton(
                      newCount, isMobile, isTablet, isDesktop),
                  const SizedBox(height: 12),
                  // Responsive ListView for tasks
                  Expanded(
                    child: ListView.builder(
                      itemCount: 100,
                      itemBuilder: (context, index) {
                        return TaskCard(
                          title: 'Task title $index',
                          description: 'Task description for task $index.',
                          isMobile: isMobile,
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

  /// Builds the task category buttons with dynamic layout for responsiveness
  Widget buildTaskCategoryButton(
      String newCount, bool isMobile, bool isTablet, bool isDesktop) {
    List<String> categories = ['New', 'Cancelled', 'In Progress', 'Completed'];

    return Obx(() => Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: isDesktop
              ? WrapAlignment.center
              : WrapAlignment.start, // Center buttons on desktop
          children: List.generate(categories.length, (index) {
            return buildCategoryButton(categories[index], index, isMobile);
          }),
        ));
  }

  /// Helper method to build each category button
  Widget buildCategoryButton(String text, int index, bool isMobile) {
    return TextButton(
      onPressed: () {
        selectedCategoryIndex.value = index; // Update selected button index
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          selectedCategoryIndex.value == index ? Colors.green : Colors.grey,
        ),
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(
            horizontal: isMobile ? 12 : 16,
            vertical: isMobile ? 8 : 12,
          ),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: isMobile ? 14 : 16,
        ),
      ),
    );
  }

  /// Builds the floating app bar card with responsive adjustments
  Card buildFloatingAppBarCard(double screenWidth) {
    return Card(
      elevation: 0,
      shadowColor: Colors.grey,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(99)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: SizedBox(
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    Get.snackbar('More', '', margin: const EdgeInsets.all(10));
                  },
                  icon: const Icon(Icons.more_vert)),
              Expanded(
                child: GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Rakibul Islam Mehedi',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screenWidth < 600 ? 16 : 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 42,
                height: 42,
                child: GestureDetector(
                  onTap: () {
                    Get.snackbar('Profile opening', 'This is description',
                        margin: const EdgeInsets.all(10));
                  },
                  child: ClipOval(
                    child: Image.network(
                      'https://avatars.githubusercontent.com/u/125388734?v=4',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
