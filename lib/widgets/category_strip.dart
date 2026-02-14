import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CategoryStrip extends StatelessWidget {
  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const CategoryStrip({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: labels.asMap().entries.map((entry) {
          final isActive = entry.key == selectedIndex;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: () => onSelected(entry.key),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.ink : AppColors.card,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  entry.value,
                  style: TextStyle(
                    color: isActive ? AppColors.card : AppColors.muted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
