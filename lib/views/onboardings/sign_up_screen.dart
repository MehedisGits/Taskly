import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/controllers/sign_up_controller.dart';
import 'package:task_manager/utils/responsive_size.dart';
import 'package:task_manager/widgets/custom_button.dart';

import '../../main.dart';

class SignUpScreen extends StatelessWidget {
  // Use Get.put() for proper dependency injection
  final SignUpController controller = Get.put(SignUpController());

  SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: SingleChildScrollView(
              child: Card(
                elevation: 0,
                margin: EdgeInsets.symmetric(
                  vertical: 16 * screenScale(context),
                  horizontal: 16 * screenScale(context)
                ),
                color: Colors.grey[200],
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 16 * screenScale(context),
                    horizontal: 12 * screenScale(context),
                  ),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Title
                        Row(
                          children: [
                            Text(
                              'Create a Taskly Account',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: responsiveSize(
                            context,
                            mobileSize: 16,
                            tabletSize: 20,
                            desktopSize: 24,
                          ),
                        ),
              
                        // Name Field
                        _nameField(),
              
                        // Email Field
                        SizedBox(
                          height: responsiveSize(
                            context,
                            mobileSize: 12,
                            tabletSize: 16,
                            desktopSize: 20,
                          ),
                        ),
                        _emailField(),
              
                        // Phone Field
                        SizedBox(
                          height: responsiveSize(
                            context,
                            mobileSize: 12,
                            tabletSize: 16,
                            desktopSize: 20,
                          ),
                        ),
                        _phoneField(),
              
                        // Password Field
                        SizedBox(
                          height: responsiveSize(
                            context,
                            mobileSize: 12,
                            tabletSize: 16,
                            desktopSize: 20,
                          ),
                        ),
                        _passwordField(),
              
                        // Confirm Password Field
                        SizedBox(
                          height: responsiveSize(
                            context,
                            mobileSize: 12,
                            tabletSize: 16,
                            desktopSize: 20,
                          ),
                        ),
                        _confirmPasswordField(),
              
                        // SignUp Button
                        SizedBox(
                          height: responsiveSize(
                            context,
                            mobileSize: 16,
                            tabletSize: 20,
                            desktopSize: 24,
                          ),
                        ),
                        _signUpButton(),
              
                        SizedBox(
                          height: responsiveSize(
                            context,
                            mobileSize: 16,
                            tabletSize: 20,
                            desktopSize: 24,
                          ),
                        ),
                        _loginRow(context),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Name Field
  TextFormField _nameField() {
    return TextFormField(
      controller: controller.nameController,
      decoration: InputDecoration(
        labelText: 'Name',
        hintText: 'Enter your full name',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      validator: (value) =>
          value != null && value.isEmpty ? 'Name cannot be empty' : null,
    );
  }

  // Email Field
  TextFormField _emailField() {
    return TextFormField(
      controller: controller.emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'Enter your email',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      validator: (value) =>
          !GetUtils.isEmail(value ?? '') ? 'Enter a valid email address' : null,
    );
  }

  // Phone Field
  TextFormField _phoneField() {
    return TextFormField(
      controller: controller.phoneController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: 'Phone Number',
        hintText: 'Enter your phone number',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Phone number is required';
        } else if (!RegExp(r'^[0-9]{10,15}$').hasMatch(value)) {
          return 'Enter a valid phone number';
        }
        return null;
      },
    );
  }

  // Password Field
  Obx _passwordField() {
    return Obx(
      () => TextFormField(
        controller: controller.passwordController,
        obscureText: controller.isPasswordHidden.value,
        decoration: InputDecoration(
          labelText: 'Password',
          hintText: 'Enter your password',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          suffixIcon: IconButton(
            icon: Icon(controller.isPasswordHidden.value
                ? Icons.visibility_off
                : Icons.visibility),
            onPressed: controller.togglePasswordVisibility,
          ),
        ),
        validator: (value) => value != null && value.length < 6
            ? 'Password must be at least 6 characters long'
            : null,
      ),
    );
  }

  // Confirm Password Field
  Obx _confirmPasswordField() {
    return Obx(
      () => TextFormField(
        controller: controller.confirmPasswordController,
        obscureText: controller.isPasswordHidden.value,
        decoration: InputDecoration(
          labelText: 'Confirm Password',
          hintText: 'Re-enter your password',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          suffixIcon: IconButton(
            icon: Icon(controller.isPasswordHidden.value
                ? Icons.visibility_off
                : Icons.visibility),
            onPressed: controller.togglePasswordVisibility,
          ),
        ),
        validator: (value) => value != controller.passwordController.text
            ? 'Passwords do not match'
            : null,
      ),
    );
  }

  // SignUp Button
  Widget _signUpButton() {
    return CustomButton(
      onPressed: () {
        if (controller.formKey.currentState!.validate()) {
          controller.signUp();
        }
      },
      text: 'Sign Up',
    );
  }

  Row _loginRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account?',
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
            Get.offAndToNamed(Routes.login);
          },
          child: Text(
            'Log in',
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
}
