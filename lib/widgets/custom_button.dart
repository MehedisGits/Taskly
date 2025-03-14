import 'package:flutter/material.dart';
import '../utils/responsive_size.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        // Calculate responsive sizes based on screen orientation and width.
        double buttonHeight = responsiveSize(
          context,
          mobileSize: orientation == Orientation.portrait ? 48 : 40,
          tabletSize: orientation == Orientation.portrait ? 58 : 54,
          desktopSize: orientation == Orientation.portrait ? 62 : 58,
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
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: paddingVertical),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
