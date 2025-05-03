import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../widgets/custom_button.dart';
import 'login_screen.dart';

class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }
}

Widget _buildBody(BuildContext context) {
  return SafeArea(
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'OTP Verification',
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 16),
              Text(
                'Enter the 6-digit code sent to your email',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(
                height: 16,
              ),
              OtpTextField(
                numberOfFields: 6,
                showFieldAsBox: true,
                onCodeChanged: (String verificationCode) {
                  // Handle code change
                },
                onSubmit: ((String verificationCode) {
                  Get.snackbar('Code Submitted', verificationCode);
                  // Handle submission
                }),
              ),
              SizedBox(height: 20),
              CustomButton(text: 'Continue', onPressed: () {}),
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
                      Get.offAll(LoginScreen(), transition: Transition.rightToLeft);
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
