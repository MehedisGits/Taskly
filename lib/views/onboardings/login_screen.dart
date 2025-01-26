import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/main.dart';
import 'package:task_manager/utils/responsive_size.dart';
import '../../controllers/login_controller.dart';
import '../../widgets/custom_button.dart';

class LoginScreen extends StatelessWidget {
  // Ensure controller is registered using Get.put()
  final LoginController controller = Get.put(LoginController());

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenScale = screenWidth / 375;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => Center(
            child: Card(
              margin: EdgeInsets.all(20 * screenScale),
              color: Colors.grey[200],
              elevation: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 20 * screenScale, horizontal: 12 * screenScale),
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
                                style:
                                    Theme.of(context).textTheme.headlineLarge,
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
            Get.toNamed(Routes.signUp);
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
    return Obx(() => TextFormField(
          decoration: InputDecoration(
            labelText: 'Password',
            hintText: 'Enter your password',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            suffixIcon: IconButton(
              icon: Icon(controller.isPasswordVisible.value
                  ? Icons.visibility
                  : Icons.visibility_off),
              onPressed: () {
                controller.isPasswordVisible.value =
                    !controller.isPasswordVisible.value;
              },
            ),
          ),
          obscureText: !controller.isPasswordVisible.value,
          onChanged: (value) => controller.password.value = value,
          validator: controller.validatePassword,
        ));
  }

  TextFormField buildTextFormField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'Enter your email address',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onChanged: (value) => controller.email.value = value,
      validator: controller.validateEmail,
    );
  }
}
