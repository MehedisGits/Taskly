import 'package:flutter/material.dart';
import 'package:task_manager/utils/responsive_size.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({
    required this.text,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: responsiveSize(context,
          mobileSize: 42, tabletSize: 48, desktopSize: 52),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
              fontSize: responsiveSize(context), fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
