import 'dart:async';

import 'package:flutter/material.dart';

extension DateTimeExtension on DateTime {
  String get formatDate => "$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}";

  String get formatTime => "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
}

extension PickerExtension on BuildContext {
  Future<DateTime?> onPickDateTime(DateTime initialValue) async {
    final date = await showDatePicker(
      context: this,
      initialDate: initialValue,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (date == null || !mounted) return null;

    final time = await showTimePicker(
      context: this,
      initialTime: TimeOfDay.fromDateTime(initialValue),
    );

    if (time == null) return null;

    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }
}