import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerTaskCard extends StatelessWidget {
  final bool isMobile;

  const ShimmerTaskCard({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.symmetric(
        vertical: isMobile ? 8 : 12,
        horizontal: isMobile ? 12 : 20,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade200,
          highlightColor: Colors.grey.shade100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(height: 20, width: double.infinity, color: Colors.white),
              const SizedBox(height: 12),
              Container(height: 14, width: 100, color: Colors.white),
              const SizedBox(height: 12),
              Container(height: 14, width: double.infinity, color: Colors.white),
              const SizedBox(height: 8),
              Container(height: 14, width: double.infinity, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
