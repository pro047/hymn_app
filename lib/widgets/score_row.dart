import 'package:flutter/material.dart';
import '../models/score_item.dart';
import '../theme/app_theme.dart';
import 'score_cached_image.dart';

class ScoreRow extends StatelessWidget {
  final ScoreItem item;
  final VoidCallback? onTap;

  const ScoreRow({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final imageUrl = item.downloadUrl ?? item.fileUrl;
    final hasImage = imageUrl != null && imageUrl.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [AppColors.softShadow],
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.cardTint,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: hasImage
                      ? Hero(
                          tag: 'score-${item.id}',
                          transitionOnUserGestures: true,
                          child: ScoreCachedImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Icon(
                          Icons.library_music_rounded,
                          color: AppColors.accent,
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.title, style: textTheme.titleMedium),
                      if (item.subtitle.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(item.subtitle, style: textTheme.bodySmall),
                      ],
                    ],
                  ),
                ),
                if (item.mood.isNotEmpty)
                  Text(item.mood, style: textTheme.bodySmall),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
