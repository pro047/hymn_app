import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ScoreCachedImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;

  const ScoreCachedImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.contain,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    if (!_isNetworkUrl(imageUrl)) {
      return Image.asset(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          debugPrint('Score image load failed: $imageUrl');
          debugPrint('Error: $error');
          return const Center(child: Text('이미지 로딩 실패'));
        },
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
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

  bool _isNetworkUrl(String value) {
    return value.startsWith('http://') || value.startsWith('https://');
  }
}
