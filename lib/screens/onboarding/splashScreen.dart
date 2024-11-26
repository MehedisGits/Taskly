import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taskly/api/controller.dart';
import 'package:taskly/screens/task/dashboardScreen.dart';
import 'package:taskly/utils/assetsPath.dart';

import '../../style/style.dart';
import 'loginScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _moveToNextScreen();
  }

  Future<void> _moveToNextScreen() async {
    // Automatically navigate to LoginScreen after 3 seconds
    await AuthController.getAccessToken();

    if (AuthController.isLoggedIn()) {
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => NewTaskListScreen(),
            ));
      });
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          ScreenBackground(context),
          Padding(
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
                    style: Heading1(Colors.black),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'When you are confused about managing your tasks, come to us.',
                    textAlign: TextAlign.center,
                    style: Heading6(colorDarkBlue),
                  ),
                  const SizedBox(height: 24),
                  /*ElevatedButton(
                    onPressed: () {
                      // Manually navigate to LoginScreen on button click
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    style: AppButtonStyle(),
                    child: SuccessButtonChild('Get started'),
                  ),*/
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
