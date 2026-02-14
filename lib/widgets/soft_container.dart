import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SoftContainer extends StatelessWidget {
  final Widget child;

  const SoftContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [AppColors.softShadow],
      ),
      child: child,
    );
  }
}
