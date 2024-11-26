// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:taskly/screens/onboarding/loginScreen.dart';
import 'package:taskly/screens/onboarding/pinVerificationScreen.dart';

import '../../style/style.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _emailTEController = TextEditingController();

  // TextEditingController _firstNameTEController = TextEditingController();
  // TextEditingController _lastNameTEController = TextEditingController();
  // TextEditingController _mobileNumberTEController = TextEditingController();
  // TextEditingController _passwordTEController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        ScreenBackground(context),
        Padding(
          padding: const EdgeInsets.all(30),
          child: Form(
            key: _globalKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Email Address',
                  style: Heading1(colorDarkBlue),
                ),
                const SizedBox(height: 8),
                const Text(
                    'A 6 digit verification pin will send to your email address'),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: AppInputDecoration('Email Address'),
                  controller: _emailTEController,
                  textInputAction: TextInputAction.next,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PinVerificationScreen(),
                        ));
                  },
                  style: AppButtonStyle(),
                  child: SuccessButtonChild('Next'),
                ),
                const SizedBox(height: 24),
                Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Have account?'),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ));
                        },
                        child: const Text(
                          'SIgn in',
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ]),
    );
  }

  void _onTapNext() {}

  @override
  void dispose() {
    super.dispose();
    _emailTEController.dispose();
  }
}
