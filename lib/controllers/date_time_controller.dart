import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/dat_time_pair_model.dart';

class DateTimeController extends GetxController {
  Rx<DateTime> selectedDate = DateTime.now().obs;
  Rx<TimeOfDay> selectedTime = TimeOfDay.now().obs;

  Future<void> pickDate(BuildContext context) async {
    final datePicked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (datePicked != null) {
      selectedDate.value = datePicked;
    }
  }

  Future<void> pickTime(BuildContext context) async {
    final timePicked = await showTimePicker(
      context: context,
      initialTime: selectedTime.value,
    );
    if (timePicked != null) {
      selectedTime.value = timePicked;
    }
  }

  void setDateTime(DateTime date, TimeOfDay time) {
    selectedDate.value = date;
    selectedTime.value = time;
  }

  void confirm() {
    Get.back(
        result:
            DateTimePair(date: selectedDate.value, time: selectedTime.value));
  }
}
