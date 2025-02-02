import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../modules/app_bar_controller.dart';

class CustomAppBar extends StatelessWidget {
  CustomAppBar({super.key});

  final CustomAppBarController controller = Get.put(CustomAppBarController());

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 2,
      color: isDarkMode ? Colors.grey[900] : Colors.white,
      shadowColor: isDarkMode ? Colors.black54 : Colors.grey.withOpacity(0.2),
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
              firstChild: _buildDefaultAppBar(screenWidth, isDarkMode),
              secondChild: _buildSearchBar(isDarkMode),
              crossFadeState: controller.isSearchActive.value
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the default app bar
  Widget _buildDefaultAppBar(double screenWidth, bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildIconButton(
          icon: Icons.menu,
          tooltip: 'Menu',
          onTap: controller.showMoreOptions,
          isDarkMode: isDarkMode,
        ),
        _buildAppBarTitle(screenWidth, isDarkMode),
        _buildProfileAvatar(
          onTap: controller.navigateToProfile,
          isDarkMode: isDarkMode,
        ),
      ],
    );
  }

  /// Builds the search bar
  Widget _buildSearchBar(bool isDarkMode) {
    return Row(
      children: [
        IconButton(
          onPressed: controller.deactivateSearch,
          icon: Icon(Icons.arrow_back,
              color: isDarkMode ? Colors.white : Colors.black87),
          tooltip: 'Go Back',
        ),
        Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
              borderRadius: BorderRadius.circular(25),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                border: InputBorder.none,
                hintStyle: TextStyle(
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600]),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear,
                      color: isDarkMode ? Colors.white : Colors.black87),
                  onPressed: () {
                    controller.searchController.clear();
                    controller.searchQuery.value = '';
                  },
                ),
              ),
              style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode ? Colors.white : Colors.black87),
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
          icon: Icon(Icons.search,
              color: isDarkMode ? Colors.white : Colors.black87),
          tooltip: 'Search',
        ),
      ],
    );
  }

  /// Builds the title text
  Widget _buildAppBarTitle(double screenWidth, bool isDarkMode) {
    return GestureDetector(
      onTap: controller.activateSearch,
      child: Text(
        'Discover',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: screenWidth < 600 ? 18 : 22,
          fontWeight: FontWeight.w600,
          color: isDarkMode ? Colors.white : Colors.black87,
        ),
      ),
    );
  }

  /// Builds the profile avatar
  Widget _buildProfileAvatar(
      {required VoidCallback onTap, required bool isDarkMode}) {
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
              border: Border.all(
                  color: isDarkMode ? Colors.white54 : Colors.grey.shade300,
                  width: 2),
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

  /// Builds the icon button
  Widget _buildIconButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon),
      tooltip: tooltip,
      color: isDarkMode ? Colors.white : Colors.black87,
      splashRadius: 20,
    );
  }
}
