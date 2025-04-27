// 📦 Small clean widget for showing task summary
import 'package:flutter/material.dart';

class TaskSummaryCard extends StatelessWidget {
  final int totalTasks;
  final int completed;
  final int cancelled;
  final int inProgress;

  const TaskSummaryCard({
    super.key,
    required this.totalTasks,
    required this.completed,
    required this.cancelled,
    required this.inProgress,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Task Summary', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSummaryItem('Total', totalTasks, Colors.blue),
                _buildSummaryItem('Completed', completed, Colors.green),
                _buildSummaryItem('Cancelled', cancelled, Colors.red),
                _buildSummaryItem('In Progress', inProgress, Colors.orange),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String title, int count, Color color) {
    return Column(
      children: [
        Text('$count', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}