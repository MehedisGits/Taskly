import 'package:get/get.dart';
import 'package:task_manager/controllers/login_controller.dart';
import 'package:task_manager/controllers/sign_up_controller.dart';

class InitialBinders extends Bindings {
  @override
  void dependencies() {
    // Using lazyPut for LoginController
    Get.lazyPut<LoginController>(() => LoginController());
    Get.lazyPut<SignUpController>(() => SignUpController());
  }
}
