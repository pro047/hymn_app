import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ScoreCachedImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;

  const ScoreCachedImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      placeholder: (context, _) =>
          const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) {
        debugPrint('Score image load failed: $url');
        debugPrint('Error: $error');
        return const Center(child: Text('이미지 로딩 실패'));
      },
    );
  }
}
