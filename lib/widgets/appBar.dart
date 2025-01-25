import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

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
        child: Row(
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
        ),
      ),
    );
  }

  /// Builds the IconButton for the left side.
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

  /// Builds the title text in the middle.
  Widget _buildAppBarTitle(double screenWidth) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          // Add logic for title click if needed
        },
        child: Text(
          'Rakibul Islam Mehedi',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: screenWidth < 600 ? 16 : 20,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  /// Builds the profile avatar on the right side.
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
}
