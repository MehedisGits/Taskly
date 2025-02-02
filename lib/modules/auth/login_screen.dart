import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/login_controller.dart';
import '../../utils/responsive_size.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import 'sign_up_screen.dart';

class LoginScreen extends StatelessWidget {
  // Ensure controller is registered using Get.put()
  final LoginController controller = Get.put(LoginController());

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenScale = screenWidth / 375;

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) => Center(
                child: SingleChildScrollView(
                  child: Card(
                    margin: EdgeInsets.all(16 * screenScale),
                    color: Colors.grey[200],
                    elevation: 0,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 20 * screenScale,
                          horizontal: 12 * screenScale),
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
                                      'Get started with Taskly',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),

                                // Email Field
                                buildTextFormField(),
                                SizedBox(height: 14),

                                // Password Field
                                buildObxPasswordField(),
                                SizedBox(height: 14 * screenScale),

                                // Login Button
                                CustomButton(
                                  text: 'Login',
                                  onPressed: () => controller.login(),
                                ),
                                SizedBox(height: 20),

                                // Forget Password
                                buildForgetPassword(context),
                                SizedBox(height: 10),

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

  Row buildSignUpRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Don\'t have an account?',
          style: TextStyle(
            fontSize: responsiveSize(
              context,
              mobileSize: 14,
              tabletSize: 16,
              desktopSize: 18,
            ),
          ),
        ),
        SizedBox(width: 6),
        InkWell(
          onTap: () {
            Get.to(SignUpScreen(), transition: Transition.zoom);
          },
          child: Text(
            'Sign Up',
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

  InkWell buildForgetPassword(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.snackbar('Forget Password', 'Forget password screen opening');
      },
      child: Text(
        'Forget password?',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: responsiveSize(
            context,
            mobileSize: 13,
            tabletSize: 15,
            desktopSize: 17,
          ),
          color: Colors.grey,
        ),
      ),
    );
  }

  Obx buildObxPasswordField() {
    return Obx(
          () => CustomTextField(
        labelText: 'Password',
        hintText: 'Enter your password',
        controller: controller.passwordController,
        obscureText: !controller.isPasswordVisible.value,
        suffixIcon: IconButton(
          icon: Icon(!controller.isPasswordVisible.value
              ? Icons.visibility_off
              : Icons.visibility),
          onPressed: controller.togglePasswordVisibility,
        ),
        validator: (value) => controller.validatePassword(value),
      ),
    );
  }

  Widget buildTextFormField() {
    return CustomTextField(
      labelText: 'Email',
      hintText: 'Enter your email',
      controller: controller.emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) => controller.validateEmail(value),
    );
  }
}
