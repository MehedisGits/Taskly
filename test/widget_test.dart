import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskly/core/routes.dart';
import 'package:taskly/main.dart';
import 'package:taskly/controllers/user_controller.dart';
import 'package:taskly/services/auth_service.dart';
import 'package:taskly/modules/auth/login_screen.dart';
import 'package:taskly/views/splash_screen.dart';

void main() {
  // Mock SharedPreferences
  late SharedPreferences sharedPreferences;

  setUp(() async {
    // Initialize SharedPreferences with mock data
    SharedPreferences.setMockInitialValues({});
    sharedPreferences = await SharedPreferences.getInstance();

    // Initialize GetX bindings
    Get.testMode = true; // Enable test mode for GetX
    Get.put(sharedPreferences);
    Get.put(AuthService(sharedPreferences));
    Get.put(UserController());
  });

  tearDown(() {
    // Clean up GetX bindings after each test
    Get.reset();
  });

  testWidgets('SplashScreen loads and navigates to LoginScreen', (WidgetTester tester) async {
    // Build the app with the SplashScreen as the initial route
    await tester.pumpWidget(
      MyApp(sharedPreferences: sharedPreferences),
    );

    // Verify that the SplashScreen is displayed
    expect(find.byType(SplashScreen), findsOneWidget);

    // Simulate a delay (e.g., for loading data)
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Verify that the app navigates to the LoginScreen
    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('LoginScreen displays email and password fields', (WidgetTester tester) async {
    // Build the app with the LoginScreen as the initial route
    await tester.pumpWidget(
      MyApp(sharedPreferences: sharedPreferences),
    );

    // Navigate to the LoginScreen
    Get.toNamed(Routes.login);
    await tester.pumpAndSettle();

    // Verify that the email and password fields are displayed
    expect(find.byKey(const Key('emailField')), findsOneWidget);
    expect(find.byKey(const Key('passwordField')), findsOneWidget);
  });

  testWidgets('DashboardScreen displays task list', (WidgetTester tester) async {
    // Build the app with the DashboardScreen as the initial route
    await tester.pumpWidget(
      MyApp(sharedPreferences: sharedPreferences),
    );

    // Navigate to the DashboardScreen
    Get.toNamed(Routes.home);
    await tester.pumpAndSettle();

    // Verify that the task list is displayed
    expect(find.byType(ListView), findsOneWidget);
  });
}