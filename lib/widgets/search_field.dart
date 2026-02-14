import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SearchField extends StatelessWidget {
  const SearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [AppColors.softShadow],
      ),
      child: Row(
        children: const [
          Icon(Icons.search_rounded, color: AppColors.muted),
          SizedBox(width: 10),
          Text('곡명, 작곡가 검색', style: TextStyle(color: AppColors.muted)),
        ],
      ),
    );
  }
}
