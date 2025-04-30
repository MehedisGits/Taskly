// models/task_category.dart
import 'package:flutter/material.dart';

class TaskCategory {
  final String name;
  final IconData icon;
  final Color color;

  const TaskCategory({
    required this.name,
    required this.icon,
    required this.color,
  });
}
