import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerTaskCard extends StatelessWidget {
  final bool isMobile;

  const ShimmerTaskCard({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    // Accessing the current theme
    final ThemeData theme = Theme.of(context);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.symmetric(
        vertical: isMobile ? 8 : 12,
        horizontal: isMobile ? 12 : 20,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Shimmer.fromColors(
          baseColor: theme.cardColor.withOpacity(0.3), // Using theme's card color for base
          highlightColor: theme.highlightColor.withOpacity(0.1), // Using theme's highlight color
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 20,
                width: double.infinity,
                color: theme.cardColor, // Color from theme
              ),
              const SizedBox(height: 12),
              Container(
                height: 14,
                width: 100,
                color: theme.cardColor, // Color from theme
              ),
              const SizedBox(height: 12),
              Container(
                height: 14,
                width: double.infinity,
                color: theme.cardColor, // Color from theme
              ),
              const SizedBox(height: 8),
              Container(
                height: 14,
                width: double.infinity,
                color: theme.cardColor, // Color from theme
              ),
            ],
          ),
        ),
      ),
    );
  }
}
