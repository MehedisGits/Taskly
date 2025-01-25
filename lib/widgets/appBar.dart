import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/app_bar_controller.dart'; // Import your controller

class CustomAppBar extends StatelessWidget {
  CustomAppBar({super.key});

  final CustomAppBarController controller = Get.put(CustomAppBarController());

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Card(
      elevation: 1, // Slight elevation for a professional look
      shadowColor: Colors.grey.withOpacity(0.2),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Obx(() => AnimatedCrossFade(
          duration: const Duration(milliseconds: 300),
          firstChild: _buildDefaultAppBar(screenWidth),
          secondChild: _buildSearchBar(),
          crossFadeState: controller.isSearchActive.value
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
        )),
      ),
    );
  }

  /// Builds the default app bar with a title and profile avatar
  Widget _buildDefaultAppBar(double screenWidth) {
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
        ),
        _buildAppBarTitle(screenWidth),
        _buildProfileAvatar(
          onTap: () => Get.snackbar(
            'Profile Opening',
            'Profile is being opened',
            margin: const EdgeInsets.all(10),
          ),
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
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search...',
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.grey[600]),
            ),
            style: const TextStyle(fontSize: 16),
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
          fontSize: screenWidth < 600 ? 16 : 20,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      )

    );
  }

  /// Builds the profile avatar on the right side
  Widget _buildProfileAvatar({required VoidCallback onTap}) {
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
  }) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon),
      tooltip: tooltip,
      color: Colors.black87,
    );
  }
}
