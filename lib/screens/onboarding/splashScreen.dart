import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taskly/screens/onboarding/loginScreen.dart';
import 'package:taskly/utils/assetsPath.dart';

import '../../style/style.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
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
                  const SizedBox(
                    height: 24,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ));
                    },
                    style: AppButtonStyle(),
                    child: SuccessButtonChild('Get started'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
