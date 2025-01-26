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
    return OrientationBuilder(
      builder: (context, orientation) {
        // Adjust the button layout based on orientation (portrait or landscape)
        double buttonHeight = responsiveSize(
          context,
          mobileSize: orientation == Orientation.portrait ? 42 : 36,
          tabletSize: orientation == Orientation.portrait ? 48 : 44,
          desktopSize: orientation == Orientation.portrait ? 52 : 48,
        );
        double fontSize = responsiveSize(
          context,
          mobileSize: orientation == Orientation.portrait ? 16 : 14,
          tabletSize: orientation == Orientation.portrait ? 18 : 16,
          desktopSize: orientation == Orientation.portrait ? 20 : 18,
        );
        double paddingVertical = responsiveSize(
          context,
          mobileSize: orientation == Orientation.portrait ? 12 : 10,
          tabletSize: orientation == Orientation.portrait ? 16 : 14,
          desktopSize: orientation == Orientation.portrait ? 18 : 16,
        );

        return SizedBox(
          width: double.infinity,
          height: buttonHeight,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: paddingVertical),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}
