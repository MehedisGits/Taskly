import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskly/utils/responsive_size.dart';
import 'package:taskly/widgets/custom_button.dart';
import 'package:taskly/widgets/custom_text_field.dart';

import '../../controllers/login_controller.dart';
import '../../core/strings.dart';
import 'sign_up_screen.dart';

class LoginScreen extends StatelessWidget {
  // Register the LoginController via GetX
  final LoginController controller = Get.put(LoginController());

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Calculate scaling factor based on a reference width of 375
    double screenWidth = MediaQuery.of(context).size.width;
    double screenScale = screenWidth / 375;

    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) => Center(
                child: SingleChildScrollView(
                  child: Card(
                    margin: EdgeInsets.all(16 * screenScale),
                    // Use theme-aware card color
                    color: context.theme.cardColor,
                    elevation: 0,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 20 * screenScale,
                        horizontal: 12 * screenScale,
                      ),
                      child: Form(
                        key: controller.formKey,
                        child: Wrap(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      AppStrings.getStarted,
                                      // "Get started with Taskly"
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                // Email Field
                                buildTextFormField(),
                                const SizedBox(height: 14),
                                // Password Field
                                buildObxPasswordField(),
                                SizedBox(height: 14 * screenScale),
                                // Login Button
                                CustomButton(
                                  text: AppStrings.login,
                                  onPressed: () => controller.login(),
                                ),
                                const SizedBox(height: 20),
                                // Forget Password
                                buildForgetPassword(context),
                                const SizedBox(height: 10),
                                // Sign Up Row
                                buildSignUpRow(context),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Loading Indicator Overlay
          Obx(() {
            if (controller.isLoading.value) {
              return Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  // Build the row with "Don't have an account? Sign Up"
  Row buildSignUpRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppStrings.noAccount, // e.g., "Don't have an account?"
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
          onTap: () {
            Get.to(SignUpScreen(), transition: Transition.zoom);
          },
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

  // Build the "Forget password?" text with a tap gesture
  InkWell buildForgetPassword(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.snackbar(
            AppStrings.forgotPassword, "Forget password screen opening");
      },
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
          // Use theme hint color for proper dark/light adaptation
          color: context.theme.hintColor,
        ),
      ),
    );
  }

  // Build the password field wrapped in Obx to react to visibility toggles
  Obx buildObxPasswordField() {
    return Obx(
      () => CustomTextField(
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
      ),
    );
  }

  // Build the email field using a custom text field widget
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
