import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taskly/api/controller.dart';
import 'package:taskly/screens/task/dashboard_screen.dart';
import 'package:taskly/utils/assetsPath.dart';

import '../../style/style.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthenticationAndNavigate();
  }

  /// Handles user authentication and navigates to the appropriate screen.
  Future<void> _checkAuthenticationAndNavigate() async {
    await AuthController.getAccessToken();

    // Decide the next screen based on login status
    Widget nextScreen = AuthController.isLoggedIn()
        ? const NewTaskListScreen()
        : const LoginScreen();

    // Navigate after a delay
    Future.delayed(const Duration(seconds: 3), () {
      _navigateToScreen(nextScreen);
    });
  }

  /// Navigate to the specified screen and replace the current screen.
  void _navigateToScreen(Widget screen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          screenBackground(context),
          const SplashContent(),
        ],
      ),
    );
  }
}

/// Reusable widget to display the splash screen content.
class SplashContent extends StatelessWidget {
  const SplashContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SVG Image
            SvgPicture.asset(
              AssetsPath.onBoardingSvg,
              alignment: Alignment.center,
            ),
            const SizedBox(height: 20),

            // Text Section
            Text(
              'Enjoy Your Time',
              textAlign: TextAlign.center,
              style: heading1(textColor: Colors.black),
            ),
            const SizedBox(height: 8),
            Text(
              'When you are confused about managing your tasks, come to us.',
              textAlign: TextAlign.center,
              style: heading6(textColor: colorDarkBlue),
            ),
          ],
        ),
      ),
    );
  }
}
