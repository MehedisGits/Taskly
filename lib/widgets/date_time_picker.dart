import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/date_time_controller.dart';

class DateTimePicker extends StatelessWidget {
  final DateTime initialDate;
  final TimeOfDay initialTime;
  final Color? buttonColor;

  DateTimePicker({
    super.key,
    required this.initialDate,
    required this.initialTime,
    this.buttonColor,
  });

  final DateTimeController controller = Get.put(DateTimeController());

  @override
  Widget build(BuildContext context) {
    controller.setDateTime(initialDate, initialTime);
    final Color btnColor = buttonColor ?? Theme.of(context).primaryColor;

    return SafeArea(
      child: Container(
        width: double.infinity, // Full width
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Date & Time',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Obx(() => _buildButton(
              onPressed: () => controller.pickDate(context),
              text:
              'Select Date: ${controller.selectedDate.value.toFormattedDate()}',
              icon: Icons.calendar_today,
              color: btnColor,
            )),
            const SizedBox(height: 8),
            Obx(() => _buildButton(
              onPressed: () => controller.pickTime(context),
              text:
              'Select Time: ${controller.selectedTime.value.format(context)}',
              icon: Icons.access_time,
              color: btnColor,
            )),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: controller.confirm,
              icon: const Icon(Icons.check, color: Colors.white),
              label: const Text('Confirm'),
              style: ElevatedButton.styleFrom(
                backgroundColor: btnColor,
                foregroundColor: Colors.white,
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required VoidCallback onPressed,
    required String text,
    required IconData icon,
    required Color color,
  }) {
    return ElevatedButton.icon(

      onPressed: onPressed,
      icon: Icon(icon, size: 20, color: Colors.white),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

// Extension for formatting DateTime
extension DateTimeFormatting on DateTime {
  String toFormattedDate() {
    return "${_twoDigits(day)}/${_twoDigits(month)}/$year";
  }

  static String _twoDigits(int n) {
    return n.toString().padLeft(2, '0');
  }
}
