import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/task_model.dart';

class TaskStorageService {
  final SharedPreferences prefs;

  TaskStorageService(this.prefs);

  String _listKey(String category) => '${category}_Tasks';
  String _countKey(String category) => '${category}TaskCount';

  Future<List<Data>> loadTasks(String category) async {
    final jsonString = prefs.getString(_listKey(category));
    if (jsonString != null) {
      final List decoded = jsonDecode(jsonString);
      return decoded.map<Data>((json) => Data.fromJson(json)).toList();
    }
    return [];
  }

  Future<void> saveTasks(String category, List<Data> tasks) async {
    await prefs.setString(_listKey(category), jsonEncode(tasks.map((e) => e.toJson()).toList()));
    await prefs.setInt(_countKey(category), tasks.length);
  }

  int loadTaskCount(String category) {
    return prefs.getInt(_countKey(category)) ?? 0;
  }
}


