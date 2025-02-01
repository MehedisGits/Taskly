import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../modules/app_bar_controller.dart'; // Import your controller

class CustomAppBar extends StatelessWidget {
  CustomAppBar({super.key});

  final CustomAppBarController controller = Get.put(CustomAppBarController());

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    // final double appBarHeight = screenWidth < 600 ? 60 : 80;

    return Card(
      elevation: 1,
      shadowColor: Colors.grey.withOpacity(0.2),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Obx(
                () => AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              firstChild: _buildDefaultAppBar(screenWidth),
              secondChild: _buildSearchBar(),
              crossFadeState: controller.isSearchActive.value
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the default app bar with a title and profile avatar
  Widget _buildDefaultAppBar(double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildIconButton(
          icon: Icons.menu,
          tooltip: 'Menu',
          onTap: controller.showMoreOptions,
        ),
        _buildAppBarTitle(screenWidth),
        _buildProfileAvatar(
          onTap: controller.navigateToProfile,
        ),
      ],
    );
  }

  /// Builds the search bar view
  Widget _buildSearchBar() {
    return Row(
      children: [
        IconButton(
          onPressed: controller.deactivateSearch,
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          tooltip: 'Go Back',
        ),
        Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(25),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey[600]),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear, color: Colors.black87),
                  onPressed: () {
                    controller.searchController.clear();
                    controller.searchQuery.value = '';
                  },
                ),
              ),
              style: const TextStyle(fontSize: 16),
              controller: controller.searchController,
              onChanged: controller.onSearchChanged,
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            Get.snackbar(
              'Search',
              'Searching for: ${controller.searchQuery.value}',
              margin: const EdgeInsets.all(10),
            );
          },
          icon: const Icon(Icons.search, color: Colors.black87),
          tooltip: 'Search',
        ),
      ],
    );
  }

  /// Builds the title text in the default app bar
  Widget _buildAppBarTitle(double screenWidth) {
    return GestureDetector(
      onTap: controller.activateSearch,
      child: Text(
        'Discover',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: screenWidth < 600 ? 18 : 22,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  /// Builds the profile avatar on the right side
  Widget _buildProfileAvatar({required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300, width: 2),
            ),
            child: ClipOval(
              child: Image.network(
                'https://avatars.githubusercontent.com/u/125388734?v=4',
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                          (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.error,
                  color: Colors.red,
                ),
              ),
            ),
          ),
          Obx(() => controller.notificationCount.value > 0
              ? Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10),
            ),
            constraints: const BoxConstraints(
              minWidth: 16,
              minHeight: 16,
            ),
            child: Text(
              controller.notificationCount.value.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
          )
              : const SizedBox.shrink()),
        ],
      ),
    );
  }

  /// Builds the IconButton for the left side
  Widget _buildIconButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon),
      tooltip: tooltip,
      color: Colors.black87,
      splashRadius: 20,
    );
  }
}