import 'package:flutter/material.dart';

class PrioritySelector extends StatelessWidget {
  final String selectedPriority;
  final Function(String) onPrioritySelected;

  // List of available priorities
  final List<String> priorities = ['Low', 'Medium', 'High'];

  PrioritySelector({
    super.key,
    required this.selectedPriority,
    required this.onPrioritySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Wrap(
        children: priorities.map((priority) {
          final bool isSelected = priority == selectedPriority;
          return ListTile(
            title: Text(
              priority,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            trailing: isSelected ? const Icon(Icons.check) : null,
            onTap: () => onPrioritySelected(priority),
          );
        }).toList(),
      ),
    );
  }
}
