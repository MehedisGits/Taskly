class TaskData {
  final String title;
  final String description;
  final String? priority;
  final DateTime? dueDate;
  final bool isImportant;

  TaskData({
    required this.title,
    required this.description,
    this.priority,
    this.dueDate,
    this.isImportant = false,
  });
}