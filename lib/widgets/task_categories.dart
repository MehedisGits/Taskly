// utils/task_categories.dart
import 'package:flutter/material.dart';
import '../models/task_category.dart';

const List<TaskCategory> taskCategories = [
  TaskCategory(name: 'Cancelled', icon: Icons.cancel, color: Colors.red),
  TaskCategory(name: 'New', icon: Icons.new_releases, color: Colors.blue),
  TaskCategory(name: 'All', icon: Icons.all_inclusive, color: Colors.purple),
  TaskCategory(name: 'InProgress', icon: Icons.timelapse, color: Colors.orange),
  TaskCategory(name: 'Completed', icon: Icons.check_circle, color: Colors.green),
];
