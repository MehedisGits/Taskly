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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background for the screen
          screenBackground(context),

          Padding(
            padding: const EdgeInsets.all(30),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitle(),
                  const SizedBox(height: 8),
                  _buildSubtitle(),
                  const SizedBox(height: 20),
                  _buildEmailField(),
                  const SizedBox(height: 20),
                  _buildNextButton(),
                  const SizedBox(height: 24),
                  _buildSignInLink(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget for the main title
  Widget _buildTitle() {
    return Text(
      'Your Email Address',
      style: heading1(textColor: colorDarkBlue),
    );
  }

  // Widget for the subtitle
  Widget _buildSubtitle() {
    return const Text(
        'A 6-digit verification pin will be sent to your email address');
  }

  // Widget for the email input field
  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      decoration: appInputDecoration('Email Address'),
      textInputAction: TextInputAction.next,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: _validateEmail,
    );
  }

  // Email validation function
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    // You can add more complex validation (e.g., regex) if needed
    return null;
  }

  // Widget for the 'Next' button
  Widget _buildNextButton() {
    return ElevatedButton(
      onPressed: _onNextPressed,
      style: appButtonStyle(),
      child: successButtonChild('Next'),
    );
  }

  // Handle the Next button press
  void _onNextPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PinVerificationScreen(),
        ),
      );
    }
  }

  // Widget for the 'Sign in' link
  Widget _buildSignInLink() {
    return Container(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Have an account?'),
          const SizedBox(width: 8),
          InkWell(
            onTap: _onSignInTap,
            child: const Text(
              'Sign in',
              style: TextStyle(color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }

  // Navigate to the login screen
  void _onSignInTap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
