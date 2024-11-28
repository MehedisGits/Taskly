import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taskly/api/models/network_response.dart';
import 'package:taskly/api/services/networkCaller.dart';
import 'package:taskly/api/urls.dart';
import 'package:taskly/screens/widgets/tm_appBar.dart';
import 'package:taskly/style/style.dart';

import '../widgets/show_snackbar.dart';

class ProfileUpdateScreen extends StatefulWidget {
  const ProfileUpdateScreen({super.key});

  @override
  State<ProfileUpdateScreen> createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileNumberTEController =
      TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  File? _profileImage;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      showErrorSnackBar(e.toString());
    }
  }

  void _onTapContinue() {
    if (_globalKey.currentState?.validate() ?? false) {
      _profileUpdate();
    }
  }

  Future<void> _profileUpdate() async {
    setState(() {
      _isLoading = true;
    });

    Map<String, dynamic> formValues = {
      "email": _emailTEController.text.trim(),
      "firstName": _firstNameTEController.text.trim(),
      "lastName": _lastNameTEController.text.trim(),
      "mobile": _mobileNumberTEController.text.trim(),
      "password": _passwordTEController.text,
    };

    NetworkResponse response = await NetworkCaller.postRequest(
        url: profileUpdateUrl, body: formValues);

    setState(() {
      _isLoading = false;
    });

    if (response.isSuccess) {
      showSnackBar(context, 'Profile updated successfully');
      Navigator.pop(context);
    } else {
      showErrorSnackBar('Something went wrong!');
    }
  }

  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TmAppBar(isProfileScreenOpen: true),
      body: Stack(
        children: [
          screenBackground(context),
          SingleChildScrollView(
            padding: const EdgeInsets.all(40),
            child: Form(
              key: _globalKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 20),
                  _buildPhotoPicker(),
                  const SizedBox(height: 12),
                  _buildTextField(
                      label: "Email",
                      controller: _emailTEController,
                      validator: _validateEmail),
                  const SizedBox(height: 12),
                  _buildTextField(
                      label: "First Name", controller: _firstNameTEController),
                  const SizedBox(height: 12),
                  _buildTextField(
                      label: "Last Name", controller: _lastNameTEController),
                  const SizedBox(height: 12),
                  _buildTextField(
                      label: "Mobile", controller: _mobileNumberTEController),
                  const SizedBox(height: 12),
                  _buildTextField(
                      label: "Password",
                      controller: _passwordTEController,
                      isPassword: true),
                  const SizedBox(height: 20),
                  _buildSubmitButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return const Text(
      'Update Profile',
      style: TextStyle(
          color: Colors.black87, fontSize: 22, fontWeight: FontWeight.w600),
    );
  }

  Widget _buildPhotoPicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 120,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: _profileImage == null
                  ? Container(
                      height: 80,
                      width: 80,
                      color: Colors.grey.shade300,
                      child:
                          const Icon(Icons.photo_camera, color: Colors.white),
                    )
                  : Image.file(
                      _profileImage!,
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _profileImage == null ? "Choose Photo" : "Photo Selected",
                style: const TextStyle(color: Colors.black87, fontSize: 16),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool isPassword = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.green, width: 1),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      controller: controller,
      textInputAction: TextInputAction.next,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
    );
  }

  String? _validateEmail(String? value) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]{2,}$');
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    }
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _onTapContinue,
      style: appButtonStyle(),
      child: _isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : successButtonChild('Submit'),
    );
  }
}
