import 'dart:async';

import 'package:flutter/material.dart';
import '../data/scores_api.dart';
import '../models/score_item.dart';
import '../services/score_image_cache_service.dart';
import '../theme/app_theme.dart';
import 'conti_tab.dart';
import 'home_tab.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _index = 0;
  late Future<List<ScoreItem>> _scoresFuture;
  String _prefetchedKey = '';

  @override
  void initState() {
    super.initState();
    _scoresFuture = ScoresApi().fetchScores();
  }

  Future<void> _refreshScores() async {
    setState(() {
      _scoresFuture = ScoresApi().fetchScores();
    });
    await _scoresFuture;
  }

  void _prefetchScoreImages(List<ScoreItem> scores) {
    final urls = scores
        .map((item) => item.downloadUrl ?? item.fileUrl ?? '')
        .where((url) => url.isNotEmpty && _isNetworkUrl(url))
        .toList();

    final key = urls.join('|');
    if (key.isEmpty || key == _prefetchedKey) {
      return;
    }
    _prefetchedKey = key;

    unawaited(ScoreImageCacheService.prefetchUrls(urls));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ScoreItem>>(
      future: _scoresFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          debugPrint('Future builder error : ${snapshot.error}');
          debugPrint('Future builder stack trace : ${snapshot.stackTrace}');
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('악보를 불러오지 못했어요'),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () {
                      setState(() {
                        _scoresFuture = ScoresApi().fetchScores();
                      });
                    },
                    child: const Text('다시 시도'),
                  ),
                ],
              ),
            ),
          );
        }

        final scores = snapshot.data ?? const <ScoreItem>[];
        _prefetchScoreImages(scores);
        return Scaffold(
          body: _index == 0
              ? HomeTab(scores: scores, onRefresh: _refreshScores)
              : ContiTab(scores: scores, onRefresh: _refreshScores),
          bottomNavigationBar: Container(
            padding: EdgeInsets.fromLTRB(
              0,
              8,
              0,
              MediaQuery.of(context).padding.bottom + 8,
            ),
            decoration: const BoxDecoration(
              color: AppColors.card,
              border: Border(top: BorderSide(color: Color(0x11000000))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _NavItem(
                  icon: Icons.auto_awesome_mosaic_rounded,
                  isActive: _index == 0,
                  onTap: () => setState(() => _index = 0),
                ),
                _NavItem(
                  icon: Icons.queue_music_rounded,
                  isActive: _index == 1,
                  onTap: () => setState(() => _index = 1),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  bool _isNetworkUrl(String value) {
    return value.startsWith('http://') || value.startsWith('https://');
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isActive ? AppColors.accent : AppColors.muted),
            const SizedBox(height: 6),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 2,
              decoration: BoxDecoration(
                color: isActive ? AppColors.accent : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
