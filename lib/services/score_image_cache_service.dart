import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ScoreImageCacheService {
  static const int _warmupLimit = 40;

  static Future<void> prefetchUrls(Iterable<String> urls) async {
    final manager = DefaultCacheManager();
    final seen = <String>{};

    for (final url in urls) {
      if (url.isEmpty || !seen.add(url)) {
        continue;
      }
      if (seen.length > _warmupLimit) {
        break;
      }

      try {
        await manager.downloadFile(url, force: false);
      } catch (error) {
        debugPrint('Score image prefetch failed: $url');
        debugPrint('Error: $error');
      }
    }
  }
}
