import 'package:flutter/material.dart';

/// A professional and customizable function to display snack bars.
void showSnackBar(
  BuildContext context,
  String message, {
  bool isError = false, // Whether the message represents an error
  bool isSuccess = false, // Whether the message represents a success
  Duration duration =
      const Duration(microseconds: 1), // Duration for the SnackBar
  String actionLabel = '', // Optional action button label
  VoidCallback? onActionPressed, // Action button handler
}) {
  // Define colors based on message type
  Color backgroundColor = isError
      ? Colors.red
      : isSuccess
          ? Colors.green
          : Colors.blue;

  // Display SnackBar with the customized parameters
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(
          color: Colors.white, // Ensures text is readable
          fontWeight: FontWeight.w600, // A bit of emphasis on text
        ),
      ),
      backgroundColor: backgroundColor,
      duration: duration,
      // Customizable duration
      behavior: SnackBarBehavior.floating,
      // Makes it appear floating
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(10.0), // Rounded corners for a modern look
      ),
      action: actionLabel.isNotEmpty
          ? SnackBarAction(
              label: actionLabel,
              textColor: Colors.white, // White text for action button
              onPressed: onActionPressed ?? () {}, // Custom action
            )
          : null,
    ),
  );
}
