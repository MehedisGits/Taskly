import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/modules/auth/views/forget_pass_screen.dart';

import '../../../core/routes.dart';
import '../controller/login_controller.dart';
import '../../../core/strings.dart';
import '../../../utils/responsive_size.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';
import 'sign_up_screen.dart';

class LoginScreen extends StatelessWidget {
  final LoginController controller = Get.find<LoginController>();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenScale = screenWidth / 375;

    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Card(
                  margin: EdgeInsets.all(16 * screenScale),
                  color: context.theme.cardColor,
                  elevation: 0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 20 * screenScale,
                      horizontal: 12 * screenScale,
                    ),
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.getStarted,
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          const SizedBox(height: 16),
                          buildTextFormField(),
                          const SizedBox(height: 14),
                          buildObxPasswordField(),
                          SizedBox(height: 14 * screenScale),
                          CustomButton(
                            text: AppStrings.login,
                            onPressed: () => controller.login(),
                          ),
                          const SizedBox(height: 20),
                          buildForgetPassword(context),
                          const SizedBox(height: 10),
                          buildSignUpRow(context),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSignUpRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppStrings.noAccount,
          style: TextStyle(
            fontSize: responsiveSize(
              context,
              mobileSize: 14,
              tabletSize: 16,
              desktopSize: 18,
            ),
          ),
        ),
        const SizedBox(width: 6),
        InkWell(
          onTap: () => Get.to(SignUpScreen(), transition: Transition.downToUp),
          child: Text(
            AppStrings.signUp,
            style: TextStyle(
              color: Colors.green,
              fontSize: responsiveSize(
                context,
                mobileSize: 14,
                tabletSize: 16,
                desktopSize: 18,
              ),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildForgetPassword(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(ForgetPassUi(), transition: Transition.rightToLeft),
      child: Text(
        AppStrings.forgotPassword,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: responsiveSize(
            context,
            mobileSize: 13,
            tabletSize: 15,
            desktopSize: 17,
          ),
          color: context.theme.hintColor,
        ),
      ),
    );
  }

  Widget buildObxPasswordField() {
    return Obx(() => CustomTextField(
          labelText: AppStrings.password,
          hintText: AppStrings.enterYourPassword,
          controller: controller.passwordController,
          obscureText: !controller.isPasswordVisible.value,
          suffixIcon: IconButton(
            icon: Icon(
              controller.isPasswordVisible.value
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: Get.context?.theme.iconTheme.color,
            ),
            onPressed: controller.togglePasswordVisibility,
          ),
          validator: (value) => controller.validatePassword(value),
        ));
  }

  Widget buildTextFormField() {
    return CustomTextField(
      labelText: AppStrings.email,
      hintText: AppStrings.enterYourEmail,
      controller: controller.emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) => controller.validateEmail(value),
    );
  }
}
