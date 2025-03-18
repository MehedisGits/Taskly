import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/modules/auth/login_screen.dart';

import '../../controllers/user_auth_controllers/sign_up_controller.dart';
import '../../core/strings.dart';
import '../../utils/responsive_size.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class SignUpScreen extends StatelessWidget {
  final SignUpController controller = Get.put(SignUpController());

  SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the responsive scale factor based on screen width.
    double screenWidth = MediaQuery.of(context).size.width;
    double screenScale = screenWidth / 375;

    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16 * screenScale),
            child: Card(
              // Use theme-aware card color
              color: context.theme.cardColor,
              elevation: 0,
              child: Padding(
                padding: EdgeInsets.all(16 * screenScale),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitle(context),
                      SizedBox(height: responsiveSize(context, mobileSize: 16)),
                      // First Name Field
                      CustomTextField(
                        labelText: 'First Name',
                        hintText: 'Enter your first name',
                        controller: controller.firstNameController,
                        validator: (value) => value != null && value.isEmpty
                            ? 'First Name cannot be empty'
                            : null,
                      ),
                      SizedBox(height: responsiveSize(context, mobileSize: 12)),
                      // Last Name Field
                      CustomTextField(
                        labelText: 'Last Name',
                        hintText: 'Enter your last name',
                        controller: controller.lastNameController,
                        validator: (value) => value != null && value.isEmpty
                            ? 'Last Name cannot be empty'
                            : null,
                      ),
                      SizedBox(height: responsiveSize(context, mobileSize: 12)),
                      // Email Field
                      CustomTextField(
                        labelText: AppStrings.email,
                        hintText: AppStrings.enterYourEmail,
                        controller: controller.emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) => !GetUtils.isEmail(value ?? '')
                            ? 'Enter a valid email address'
                            : null,
                      ),
                      SizedBox(height: responsiveSize(context, mobileSize: 12)),
                      // Phone Number Field
                      CustomTextField(
                        labelText: 'Phone Number',
                        hintText: 'Enter your phone number',
                        controller: controller.phoneController,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Phone number is required';
                          } else if (!RegExp(r'^[0-9]{10,15}$')
                              .hasMatch(value)) {
                            return 'Enter a valid phone number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: responsiveSize(context, mobileSize: 12)),
                      // Password Field
                      Obx(() => CustomTextField(
                            labelText: AppStrings.password,
                            hintText: AppStrings.enterYourPassword,
                            controller: controller.passwordController,
                            obscureText: controller.isPasswordHidden.value,
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.isPasswordHidden.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: controller.togglePasswordVisibility,
                            ),
                            validator: (value) => value != null &&
                                    value.length < 6
                                ? 'Password must be at least 6 characters long'
                                : null,
                          )),
                      SizedBox(height: responsiveSize(context, mobileSize: 12)),
                      // Confirm Password Field
                      Obx(() => CustomTextField(
                            labelText: 'Confirm Password',
                            hintText: 'Re-enter your password',
                            controller: controller.confirmPasswordController,
                            obscureText: controller.isPasswordHidden.value,
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.isPasswordHidden.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: controller.togglePasswordVisibility,
                            ),
                            validator: (value) =>
                                value != controller.passwordController.text
                                    ? 'Passwords do not match'
                                    : null,
                          )),
                      SizedBox(height: responsiveSize(context, mobileSize: 16)),
                      // Sign Up Button
                      CustomButton(
                        onPressed: () {
                          if (controller.formKey.currentState!.validate()) {
                            controller.signUp();
                          }
                        },
                        text: AppStrings.signUp,
                      ),
                      SizedBox(height: responsiveSize(context, mobileSize: 16)),
                      // Login Redirect Row
                      _buildLoginRow(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Title Widget
  Widget _buildTitle(BuildContext context) {
    return Text(
      'Create a Taskly Account',
      style: Theme.of(context).textTheme.headlineLarge,
      textAlign: TextAlign.center,
    );
  }

  // Login Redirect Row
  Widget _buildLoginRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account?',
          style: TextStyle(
            fontSize: responsiveSize(context, mobileSize: 14),
          ),
        ),
        SizedBox(width: 6),
        InkWell(
          onTap: () {
            Get.offAll(LoginScreen(), transition: Transition.zoom);
          },
          child: Text(
            'Log in',
            style: TextStyle(
              color: Colors.green,
              fontSize: responsiveSize(context, mobileSize: 14),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
