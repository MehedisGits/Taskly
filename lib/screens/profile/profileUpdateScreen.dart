import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taskly/screens/widgets/tm_appBar.dart';
import 'package:taskly/style/style.dart';

class ProfileUpdateScreen extends StatefulWidget {
  const ProfileUpdateScreen({super.key});

  @override
  State<ProfileUpdateScreen> createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  File? _profileImage;

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
      // Handle any errors during image picking
      print("Error picking image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TmAppBar(isProfileScreenOpen: true),
      body: Stack(
        children: [
          ScreenBackground(context),
          SingleChildScrollView(
            padding: const EdgeInsets.all(40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 20),
                _buildPhotoPicker(),
                const SizedBox(height: 12),
                _buildTextField("Email"),
                const SizedBox(height: 12),
                _buildTextField("First Name"),
                const SizedBox(height: 12),
                _buildTextField("Last Name"),
                const SizedBox(height: 12),
                _buildTextField("Mobile"),
                const SizedBox(height: 12),
                _buildTextField("Password", isPassword: true),
                const SizedBox(height: 20),
                _buildSubmitButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Header widget
  Widget _buildHeader() {
    return Text(
      'Update Profile',
      style: const TextStyle(
        color: Colors.black87,
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  // Photo picker widget
  Widget _buildPhotoPicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 80,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
              ),
              child: const Icon(Icons.photo_camera, color: Colors.white),
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

  // Custom text field widget
  Widget _buildTextField(String label, {bool isPassword = false}) {
    return TextFormField(
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.green, width: 2),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // Submit button widget
  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () {
        // Handle the submit action
      },
      style: AppButtonStyle(),
      child: SuccessButtonChild('Continue'),
    );
  }
}
