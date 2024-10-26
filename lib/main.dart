import 'package:flutter/material.dart';
import 'package:taskly/screens/onboarding/emailVerificationScreen.dart';
import 'package:taskly/screens/onboarding/loginScreen.dart';
import 'package:taskly/screens/onboarding/pinVerificationScreen.dart';
import 'package:taskly/screens/onboarding/registrationScreen.dart';
import 'package:taskly/screens/onboarding/setPasswordScreen.dart';
import 'package:taskly/screens/onboarding/splashScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      },
    );
  }
}
