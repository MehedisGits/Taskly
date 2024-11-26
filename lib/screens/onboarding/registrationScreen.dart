import 'package:flutter/material.dart';
import 'package:taskly/api/models/networkResponse.dart';
import 'package:taskly/api/services/networkCaller.dart';
import 'package:taskly/api/urls.dart';

import '../../style/style.dart';
import '../widgets/show_snackbar.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final Map<String, TextEditingController> _controllers = {
    'email': TextEditingController(),
    'firstName': TextEditingController(),
    'lastName': TextEditingController(),
    'mobileNumber': TextEditingController(),
    'password': TextEditingController(),
    'confirmPassword': TextEditingController(),
  };

  bool _isPasswordVisible = true;
  bool _isConfirmPasswordVisible = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _inProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          screenBackground(context),
          Center(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controllerKey: 'email',
                        label: 'Email address',
                        keyboardType: TextInputType.emailAddress,
                        validator: _emailValidator,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controllerKey: 'firstName',
                        label: 'First Name',
                        validator: _nameValidator,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controllerKey: 'lastName',
                        label: 'Last Name',
                        validator: _nameValidator,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controllerKey: 'mobileNumber',
                        label: 'Mobile Number',
                        keyboardType: TextInputType.number,
                        validator: _mobileValidator,
                      ),
                      const SizedBox(height: 20),
                      _buildPasswordField(
                        controllerKey: 'password',
                        label: 'Password',
                        isPassword: _isPasswordVisible,
                        toggleVisibility: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildPasswordField(
                        controllerKey: 'confirmPassword',
                        label: 'Confirm Password',
                        isPassword: _isConfirmPasswordVisible,
                        toggleVisibility: () {
                          setState(() {
                            _isConfirmPasswordVisible =
                                !_isConfirmPasswordVisible;
                          });
                        },
                        validator: _confirmPasswordValidator,
                      ),
                      const SizedBox(height: 20),
                      _buildRegisterButton(),
                      const SizedBox(height: 20),
                      _buildLoginRedirect(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Text(
      'Join With Us',
      style: heading1(textColor: Colors.blueGrey),
    );
  }

  Widget _buildTextField({
    required String controllerKey,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: _controllers[controllerKey],
      keyboardType: keyboardType,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: appInputDecoration(label),
      validator: validator,
    );
  }

  Widget _buildPasswordField({
    required String controllerKey,
    required String label,
    required bool isPassword,
    required VoidCallback toggleVisibility,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: _controllers[controllerKey],
      obscureText: !isPassword,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: appInputDecoration(label).copyWith(
        suffixIcon: IconButton(
          onPressed: toggleVisibility,
          icon: Icon(
            isPassword ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _onTapNextButton,
        style: appButtonStyle(),
        child: _inProgress
            ? const CircularProgressIndicator(color: Colors.white)
            : successButtonChild('Register'),
      ),
    );
  }

  Widget _buildLoginRedirect() {
    return Container(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Already have an account?"),
          const SizedBox(width: 8),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Sign in',
              style: TextStyle(color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }

  void _onTapNextButton() {
    if (_formKey.currentState!.validate()) {
      _signUp();
    }
  }

  Future<void> _signUp() async {
    setState(() {
      _inProgress = true;
    });

    Map<String, dynamic> requestBody = {
      "email": _controllers['email']!.text.trim(),
      "firstName": _controllers['firstName']!.text.trim(),
      "lastName": _controllers['lastName']!.text.trim(),
      "mobile": _controllers['mobileNumber']!.text.trim(),
      "password": _controllers['password']!.text,
    };

    try {
      NetworkResponse response = await NetworkCaller.postRequest(
        url: registrationUrl,
        body: requestBody,
      );

      setState(() {
        _inProgress = false;
      });

      if (response.isSuccess) {
        showSnackBar(context, 'Registration successful');
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        showSnackBar(
            context, response.errorMessage ?? 'Registration failed. Try again.',
            isError: true);
      }
    } catch (e) {
      setState(() {
        _inProgress = false;
      });
      showSnackBar(context, 'Network error occurred. Please try again later.',
          isError: true);
    }
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    } else if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? _nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? _mobileValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your mobile number';
    } else if (!RegExp(r'^\d{10,15}$').hasMatch(value)) {
      return 'Enter a valid mobile number';
    }
    return null;
  }

  String? _confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    } else if (value != _controllers['password']!.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  void dispose() {
    _controllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }
}
