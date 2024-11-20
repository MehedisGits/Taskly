// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:taskly/api/models/networkResponse.dart';
import 'package:taskly/api/services/networkCaller.dart';
import 'package:taskly/screens/onboarding/emailVerificationScreen.dart';
import 'package:taskly/screens/onboarding/registrationScreen.dart';

import '../../style/style.dart';
import '../widgets/show_snackbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers to capture user inputs
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Form key for validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false; // Track loading state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        ScreenBackground(context),
        Container(
          padding: const EdgeInsets.all(30),
          child: Form(
            key: _formKey, // Attach form key
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Get Started With Taskly',
                  style: Heading1(Colors.blueGrey),
                ),
                const SizedBox(height: 20),
                // Email TextFormField with validation
                TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: _emailController,
                  decoration: AppInputDecoration('Email address'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // Password TextFormField with validation
                TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: _passwordController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: AppInputDecoration('Password'),
                  obscureText: true,
                  // Hides the password
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // Login Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _onTapLogin,
                    style: AppButtonStyle(),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : SuccessButtonChild('Login'),
                  ),
                ),
                const SizedBox(height: 20),
                // Additional Links
                Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          // Implement forgot password functionality here
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const EmailVerificationScreen(),
                              ));
                        },
                        child: const Text(
                          'Forget password?',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account?"),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: () {
                              // Implement sign-up functionality here
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const RegistrationScreen(),
                                  ));
                            },
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  void _onTapLogin() {
    if (_formKey.currentState!.validate()) {
      _signIn();
    }
  }

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true; // Show loader
    });

    Map<String, dynamic> postRequest = {
      "email": _emailController.text.trim(),
      "password": _passwordController.text
    };

    NetworkResponse response = await NetworkCaller.postRequest(
      url: 'http://35.73.30.144:2005/api/v1/Login',
      body: postRequest,
    );

    setState(() {
      _isLoading = false; // Hide loader
    });

    if (response.isSuccess) {
      showSnackBar(context, 'Login successful');
      // This will replace the login screen and all previous screens with the dashboard
      Navigator.pushNamedAndRemoveUntil(
          context, '/dashboard', (Route<dynamic> route) => false);
    } else {
      showSnackBar(
        context,
        response.errorMessage ?? 'Login failed. Try again.',
        true,
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
