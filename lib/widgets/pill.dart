import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class Pill extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  const Pill({
    super.key,
    required this.label,
    this.isActive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final background = isActive ? AppColors.ink : const Color(0xFFF1F3F6);
    final textColor = isActive ? AppColors.card : AppColors.muted;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 12, color: textColor),
        ),
      ),
    );
  }
}
