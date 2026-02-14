import 'package:flutter/material.dart';
import '../models/score_item.dart';
import '../screens/score_pager_screen.dart';
import '../theme/app_theme.dart';
import '../utils/date_utils.dart';
import '../widgets/search_field.dart';
import '../widgets/score_row.dart';

class HomeTab extends StatelessWidget {
  final List<ScoreItem> scores;
  final Future<void> Function()? onRefresh;

  const HomeTab({super.key, required this.scores, this.onRefresh});

  List<ScoreItem> _filterWeeklyScores(DateTime now) {
    final nextSundayWeek = HymnDateUtils.monthWeek(_upcomingSunday(now));
    return scores.where((item) {
      if (item.date == null) {
        return false;
      }
      final itemWeek = HymnDateUtils.monthWeek(item.date!);
      return itemWeek == nextSundayWeek;
    }).toList();
  }

  DateTime _upcomingSunday(DateTime date) {
    final daysUntilSunday = (7 - (date.weekday % 7)) % 7;
    return DateTime(
      date.year,
      date.month,
      date.day,
    ).add(Duration(days: daysUntilSunday));
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final now = DateTime.now();
    final weeklyScores = _filterWeeklyScores(now);
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: onRefresh ?? () async {},
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('이번 주', style: textTheme.headlineLarge),
                    const SizedBox(height: 6),
                    Text('이번 주 콘티를 여유롭게 확인하세요', style: textTheme.bodySmall),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: AppColors.card,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.notifications_none_rounded, size: 22),
                ),
              ],
            ),
            const SizedBox(height: 18),
            const SearchField(),
            const SizedBox(height: 24),
            Text('이번 주 악보', style: textTheme.titleMedium),
            const SizedBox(height: 12),
            if (weeklyScores.isEmpty)
              Text('이번 주 콘티가 없습니다', style: textTheme.bodySmall)
            else
              ...weeklyScores.map(
                (item) => ScoreRow(
                  item: _withWeekLabel(item),
                  onTap: () {
                    final initialIndex = weeklyScores.indexWhere(
                      (x) => x.id == item.id,
                    );
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ScorePagerScreen(
                          items: weeklyScores,
                          initialIndex: initialIndex < 0 ? 0 : initialIndex,
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  ScoreItem _withWeekLabel(ScoreItem item) {
    if (item.date == null) {
      return item;
    }
    return ScoreItem(
      id: item.id,
      title: item.title,
      subtitle: HymnDateUtils.monthWeekLabel(item.date!),
      mood: item.mood,
      date: item.date,
      fileUri: item.fileUri,
      fileUrl: item.fileUrl,
      downloadUrl: item.downloadUrl,
    );
  }
}
