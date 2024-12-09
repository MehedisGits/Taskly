// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:taskly/api/controller.dart';
import 'package:taskly/api/models/network_response.dart';
import 'package:taskly/api/services/network_caller.dart';
import 'package:taskly/api/urls.dart';
import 'package:taskly/screens/onboarding/email_verification_screen.dart';
import 'package:taskly/screens/onboarding/registration_screen.dart';

import '../../style/style.dart';
import '../widgets/show_snackbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Widget
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
                  const SizedBox(height: 20),
                  _buildEmailField(),
                  const SizedBox(height: 20),
                  _buildPasswordField(),
                  const SizedBox(height: 20),
                  _buildLoginButton(),
                  const SizedBox(height: 20),
                  _buildBottomLinks(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget for the title
  Widget _buildTitle() {
    return Text(
      'Get Started With Taskly',
      style: heading1(textColor: Colors.blueGrey),
    );
  }

  // Email input field
  Widget _buildEmailField() {
    return TextFormField(
      textInputAction: TextInputAction.next,
      controller: _emailController,
      decoration: appInputDecoration('Email address'),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) => _validateEmail(value),
    );
  }

  // Password input field
  Widget _buildPasswordField() {
    return TextFormField(
      textInputAction: TextInputAction.done,
      controller: _passwordController,
      decoration: appInputDecoration('Password'),
      obscureText: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) => _validatePassword(value),
    );
  }

  // Validation logic for the email
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    } else if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
        .hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  // Validation logic for the password
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  // Login Button Widget
  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _onTapLogin,
        style: appButtonStyle(),
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : successButtonChild('Login'),
      ),
    );
  }

  // Bottom link section for "Forgot password?" and "Sign Up"
  Widget _buildBottomLinks() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          _buildForgotPasswordLink(),
          const SizedBox(height: 12),
          _buildSignUpLink(),
        ],
      ),
    );
  }

  // Forgot password link
  Widget _buildForgotPasswordLink() {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const EmailVerificationScreen(),
        ),
      ),
      child: const Text(
        'Forget password?',
        style: TextStyle(color: Colors.blueGrey),
      ),
    );
  }

  // Sign-up link
  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account?"),
        const SizedBox(width: 8),
        InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const RegistrationScreen(),
            ),
          ),
          child: const Text(
            'Sign Up',
            style: TextStyle(color: Colors.green),
          ),
        ),
      ],
    );
  }

  // Handles login button tap
  void _onTapLogin() {
    if (_formKey.currentState!.validate()) {
      _signIn();
    }
  }

  // Sign-in logic
  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final Map<String, dynamic> postRequest = {
        "email": _emailController.text.trim(),
        "password": _passwordController.text,
      };

      final NetworkResponse response = await NetworkCaller.postRequest(
        url: loginUrl,
        body: postRequest,
      );

      if (response.isSuccess) {
        await AuthController.saveAccessToken(response.responseData['token']);
        showSnackBar(context, 'Login successful', isSuccess: true);
        Navigator.pushNamedAndRemoveUntil(
            context, '/dashboard', (route) => false);
      } else {
        showSnackBar(context, response.errorMessage ?? 'Login failed',
            isSuccess: true);
      }
    } catch (e) {
      showSnackBar(context, 'An error occurred. Please try again.',
          isError: true);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
