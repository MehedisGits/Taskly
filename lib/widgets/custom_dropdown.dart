import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatelessWidget {
  final String label;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final String? errorText;
  final String? hint; // Optional hint text to show before selection
  final bool isLoading; // Flag to show loading indicator

  const CustomDropdown({
    required this.label,
    required this.items,
    required this.value,
    this.onChanged,
    this.errorText,
    this.hint,
    this.isLoading = false, // Defaults to false
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label text for the dropdown
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),

        // Dropdown button
        DropdownButtonFormField<T>(
          value: value,
          items: isLoading
              ? [
            // Show a loading spinner if isLoading is true
             DropdownMenuItem<T>(
              value: null,
              child: Center(child: CircularProgressIndicator()),
            ),
          ]
              : items,
          onChanged: onChanged,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            errorText: errorText,
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[400]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.green),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
          icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
          isExpanded: true,
          style: TextStyle(
            fontSize: 14,
            color: errorText != null ? Colors.red : Colors.grey[800],
          ),
          // Display hint when no value is selected
          hint: hint != null ? Text(hint!) : null,
        ),
      ],
    );
  }
}
