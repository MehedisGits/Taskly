import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/app_bar_controller.dart';
import '../core/routes.dart'; // Import your controller

class CustomAppBar extends StatelessWidget {
  CustomAppBar({super.key});

  final CustomAppBarController controller = Get.put(CustomAppBarController());

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context); // Access the global theme

    return Card(
      elevation: theme.cardTheme.elevation, // Use the theme elevation
      shadowColor: Colors.grey.withOpacity(0.2),
      shape: theme.cardTheme.shape, // Use the theme shape
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Obx(() => AnimatedCrossFade(
          duration: const Duration(milliseconds: 300),
          firstChild: _buildDefaultAppBar(context, screenWidth, theme),
          secondChild: _buildSearchBar(theme),
          crossFadeState: controller.isSearchActive.value
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
        )),
      ),
    );
  }

  /// Builds the default app bar with a title and profile avatar
  Widget _buildDefaultAppBar(BuildContext context, double screenWidth, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildIconButton(
          icon: Icons.more_vert,
          tooltip: 'More Options',
          onTap: () => Get.snackbar(
            'More',
            'More options selected',
            margin: const EdgeInsets.all(10),
          ),
          theme: theme,
        ),
        _buildAppBarTitle(screenWidth, theme),
        _buildProfileAvatar(
          onTap: () => Navigator.pushNamed(context, Routes.profile),
          theme: theme,
        ),
      ],
    );
  }

  /// Builds the search bar view
  Widget _buildSearchBar(ThemeData theme) {

    return Row(
      children: [
        IconButton(
          onPressed: controller.deactivateSearch,
          icon: Icon(Icons.arrow_back, color: theme.iconTheme.color), // Use theme icon color
          tooltip: 'Go Back',
        ),
        Expanded(
          flex: 1,
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search...',
              border: InputBorder.none,
              hintStyle: theme.inputDecorationTheme.hintStyle?.copyWith(
                color: theme.hintColor, // Use theme hint color
              ),
            ),
            style: theme.textTheme.bodyLarge?.copyWith(
              fontSize: 16, // Ensure consistent font size from the theme
            ),
            onChanged: (value) {
              // Perform search logic if needed
            },
          ),
        ),
        IconButton(
          onPressed: () {
            // Perform the search logic when the search icon is clicked
            Get.snackbar(
              'Search',
              'Searching...',
              margin: const EdgeInsets.all(10),
            );
          },
          icon: Icon(Icons.search, color: theme.iconTheme.color), // Use theme icon color
          tooltip: 'Search',
        ),
      ],
    );
  }


  /// Builds the title text in the default app bar
  Widget _buildAppBarTitle(double screenWidth, ThemeData theme) {
    return GestureDetector(
      onTap: controller.activateSearch,
      child: Text(
        'Discover',
        textAlign: TextAlign.center,
        style: theme.textTheme.titleLarge?.copyWith(
          fontSize: screenWidth < 600 ? 16 : 20, // More responsive title size
        ),
      ),
    );
  }

  /// Builds the profile avatar on the right side
  Widget _buildProfileAvatar({required VoidCallback onTap, required ThemeData theme}) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 42,
        height: 42,
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
    );
  }

  /// Builds the IconButton for the left side
  Widget _buildIconButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon),
      tooltip: tooltip,
      color: theme.iconTheme.color, // Use the theme icon color
    );
  }
}
