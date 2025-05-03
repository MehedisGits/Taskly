import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/modules/auth/views/login_screen.dart';
import 'package:task_manager/widgets/custom_button.dart';
import 'package:task_manager/widgets/custom_text_field.dart';

class ForgetPassUi extends StatelessWidget {
  ForgetPassUi({super.key});

  final TextEditingController controller = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context, controller),
    );
  }
}

Widget _buildBody(BuildContext context, TextEditingController controller) {
  return SafeArea(
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Your email address',
                style: TextStyle(
                    fontSize:
                        Theme.of(context).textTheme.headlineLarge?.fontSize),
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 8),
              Text(
                'A 6 digit code will be sent to your email address',
                style: TextStyle(
                    fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize),
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 20),
              CustomTextField(labelText: 'Email', controller: controller),
              SizedBox(height: 20),
              CustomButton(text: 'Continue', onPressed: () {

              }),
              SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Have a account?'),
                  SizedBox(
                    width: 8,
                  ),
                  InkWell(
                    onTap: () {
                      Get.offAll(LoginScreen(), transition: Transition.leftToRight);
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.blue),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    ),
  );
}
