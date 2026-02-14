import 'package:flutter/material.dart';
import 'package:hymn_app/screens/score_pager_screen.dart';
import '../models/score_item.dart';
import '../utils/date_utils.dart';
import '../widgets/category_strip.dart';
import '../widgets/pill.dart';
import '../widgets/soft_container.dart';
import '../widgets/score_row.dart';

class ContiTab extends StatefulWidget {
  final List<ScoreItem> scores;
  final Future<void> Function()? onRefresh;

  const ContiTab({super.key, required this.scores, this.onRefresh});

  @override
  State<ContiTab> createState() => _ContiTabState();
}

class _ContiTabState extends State<ContiTab> {
  int _selectedIndex = 0;
  int _selectedWeekIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = DateTime.now().month - 1;
    _selectedWeekIndex = _defaultWeekIndex(_selectedIndex + 1);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final now = DateTime.now();
    final months = List.generate(12, (index) => '${index + 1}월');
    final selectedMonth = _selectedIndex + 1;
    final weekLabels = HymnDateUtils.weekLabelsInMonth(now.year, selectedMonth);
    final safeWeekIndex = _selectedWeekIndex.clamp(0, weekLabels.length - 1);
    final monthItems = widget.scores.where((item) {
      if (item.date == null) {
        return false;
      }
      final itemWeek = HymnDateUtils.monthWeek(item.date!);
      return itemWeek.month == selectedMonth;
    }).toList();
    monthItems.sort((a, b) {
      final aDate = a.date ?? DateTime(0);
      final bDate = b.date ?? DateTime(0);
      return aDate.compareTo(bDate);
    });
    final selectedWeek = safeWeekIndex + 1;
    final filteredItems = monthItems
        .where((item) {
          final week = HymnDateUtils.weekOfMonthSundayStart(item.date!);
          return week == selectedWeek;
        })
        .map(_withWeekLabel)
        .toList();

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: widget.onRefresh ?? () async {},
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            Text('콘티', style: textTheme.headlineLarge),
            const SizedBox(height: 6),
            Text('월별·주차별로 정리된 콘티를 확인하세요', style: textTheme.bodySmall),
            const SizedBox(height: 18),
            CategoryStrip(
              labels: months,
              selectedIndex: _selectedIndex,
              onSelected: (index) => setState(() {
                _selectedIndex = index;
                _selectedWeekIndex = _defaultWeekIndex(index + 1);
              }),
            ),
            const SizedBox(height: 18),
            SoftContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$selectedMonth월 콘티', style: textTheme.titleMedium),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (var i = 0; i < weekLabels.length; i++) ...[
                          Pill(
                            label: weekLabels[i],
                            isActive: i == safeWeekIndex,
                            onTap: () => setState(() => _selectedWeekIndex = i),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (filteredItems.isEmpty)
                    Text('이번 주 콘티가 없습니다', style: textTheme.bodySmall)
                  else
                    ...filteredItems.map(
                      (item) => ScoreRow(
                        item: item,
                        onTap: () {
                          final initialIndex = filteredItems.indexWhere(
                            (x) => x.id == item.id,
                          );

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ScorePagerScreen(
                                items: filteredItems,
                                initialIndex: initialIndex < 0
                                    ? 0
                                    : initialIndex,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
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

  int _defaultWeekIndex(int month) {
    final now = DateTime.now();
    final upcomingSunday = _upcomingSunday(now);
    if (upcomingSunday.month == month) {
      final week = HymnDateUtils.weekOfMonthSundayStart(upcomingSunday);
      return (week - 1).clamp(0, 5);
    }
    return 0;
  }

  DateTime _upcomingSunday(DateTime date) {
    final daysUntilSunday = (7 - (date.weekday % 7)) % 7;
    return DateTime(
      date.year,
      date.month,
      date.day,
    ).add(Duration(days: daysUntilSunday));
  }
}
