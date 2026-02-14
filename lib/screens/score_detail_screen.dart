import 'package:flutter/material.dart';
import '../models/score_item.dart';
import '../theme/app_theme.dart';
import '../widgets/score_cached_image.dart';

class ScoreDetailScreen extends StatelessWidget {
  final ScoreItem item;

  const ScoreDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final imageUrl = item.downloadUrl ?? item.fileUrl;
    return Scaffold(
      appBar: AppBar(
        title: Text(item.title),
        backgroundColor: AppColors.card,
        elevation: 0,
      ),
      body: Container(
        color: AppColors.surface,
        alignment: Alignment.center,
        child: imageUrl == null || imageUrl.isEmpty
            ? const Text('악보 이미지를 불러올 수 없습니다')
            : InteractiveViewer(
                minScale: 1,
                maxScale: 4,
                child: ScoreCachedImage(imageUrl: imageUrl),
              ),
      ),
    );
  }
}
