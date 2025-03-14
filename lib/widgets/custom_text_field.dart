import 'package:flutter/material.dart';
import '../utils/responsive_size.dart'; // Ensure this utility exists

class CustomTextField extends StatelessWidget {
  final String labelText;
  final String? hintText;
  final bool obscureText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final String? errorText;
  final bool enabled;
  final Function(String)? onChanged;

  const CustomTextField({
    super.key,
    required this.labelText,
    this.hintText,
    this.obscureText = false,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.validator,
    this.errorText,
    this.enabled = true,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Use the responsiveSize utility to adjust border radius (or other sizes) based on device size.
    double borderRadius = responsiveSize(
      context,
      mobileSize: 8,
      tabletSize: 10,
      desktopSize: 12,
    );

    // Get current theme colors to adapt to dark/light themes
    final ThemeData theme = Theme.of(context);
    // Use theme.cardColor as a base for the filled background, or a fallback if disabled.
    final Color fillColor = enabled ? theme.cardColor : Colors.grey.shade200;

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      onChanged: onChanged,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        filled: true,
        fillColor: fillColor,
        suffixIcon: suffixIcon,
        errorText: errorText,
      ),
      validator: validator,
    );
  }
}
