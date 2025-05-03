import 'package:get/get.dart';
import 'package:task_manager/core/routes.dart';
import 'package:task_manager/modules/auth/views/forget_pass_screen.dart';
import 'package:task_manager/modules/auth/views/otp_verification_screen.dart';

import '../dashboard.dart';
import '../modules/auth/views/login_screen.dart';
import '../modules/auth/views/sign_up_screen.dart';
import '../modules/onboarding/splash_screen.dart';
import '../modules/profile/view/profile_screen.dart';

class AppPages {
  static final List<GetPage> routes = [
    GetPage(name: Routes.splash, page: () => SplashScreen()),
    GetPage(name: Routes.home, page: () => DashboardScreen()),
    GetPage(name: Routes.signUp, page: () => SignUpScreen()),
    GetPage(name: Routes.login, page: () => LoginScreen()),
    GetPage(name: Routes.profile, page: () => ProfileScreen()),
    GetPage(name: Routes.forgetPass, page: () => ForgetPassUi()),
    GetPage(name: Routes.otpVerification, page: () => OtpVerificationScreen())
  ];
}
