// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:taskly/screens/onboarding/emailVerificationScreen.dart';
import 'package:taskly/screens/onboarding/registrationScreen.dart';

import '../../style/style.dart';

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
  final _formKey = GlobalKey<FormState>();

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
                  controller: _emailController,
                  decoration: AppInputDecoration('Email address'),
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
                  controller: _passwordController,
                  decoration: AppInputDecoration('Password'),
                  obscureText: true, // Hides the password
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
                  width: double.infinity, // Full-width button
                  child: ElevatedButton(
                    onPressed: () {
                      // Validate form fields before proceeding
                      if (_formKey.currentState!.validate()) {
                        // Process login here
                      }
                    },
                    style: AppButtonStyle(),
                    child: SuccessButtonChild('Login'),
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

  @override
  void dispose() {
    // Dispose controllers to free resources
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
