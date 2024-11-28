import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:taskly/screens/onboarding/email_verification_screen.dart';
import 'package:taskly/screens/onboarding/login_screen.dart';
import 'package:taskly/screens/onboarding/pin_verification_screen.dart';
import 'package:taskly/screens/onboarding/registration_screen.dart';
import 'package:taskly/screens/onboarding/set_new_pass_screen.dart';
import 'package:taskly/screens/onboarding/splash_screen.dart';
import 'package:taskly/screens/task/dashboard_screen.dart';

void main() {
  runApp(DevicePreview(
    enabled: !kReleaseMode,
    builder: (context) => const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // ignore: deprecated_member_use
      navigatorKey: navigatorKey,
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/registration': (context) => const RegistrationScreen(),
        '/emailVerification': (context) => const EmailVerificationScreen(),
        '/pinVerification': (context) => const PinVerificationScreen(),
        '/setPassword': (context) => const SetPasswordScreen(),
        '/dashboard': (context) => const NewTaskListScreen(),
      },
    );
  }
}
