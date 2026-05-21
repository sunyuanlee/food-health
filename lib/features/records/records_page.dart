import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/food_provider.dart';
import '../../core/router/app_router.dart';
import '../../core/data/mock_food_data.dart';
import '../../models/food_analysis_model.dart';

class RecordsPage extends ConsumerWidget {
  const RecordsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(analysisHistoryProvider);
    final weeklyCount = MockFoodData.weeklyCount;
    final totalThisWeek = weeklyCount.fold(0, (a, b) => a + b);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: const Text(
          '识别记录',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // ── 本周统计 ──────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: _WeeklyCard(
                weeklyCount: weeklyCount,
                totalThisWeek: totalThisWeek,
              ),
            ),
          ),

          // ── 分组列表标题 ─────────────────────────────────────────
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Text(
                '全部记录',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary),
              ),
            ),
          ),

          // ── 历史列表 ──────────────────────────────────────────────
          if (history.isEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 60),
                child: Center(
                  child: Text(
                    '还没有识别记录\n去扫描配料表吧 📷',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textHint,
                        height: 1.8),
                  ),
                ),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = history[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 4),
                    child: _RecordCard(
                      analysis: item,
                      onTap: () => context.push(
                          AppRoutes.analysisResult, extra: item),
                    ),
                  );
                },
                childCount: history.length,
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

// ── 本周统计卡 ───────────────────────────────────────────────────────────────

class _WeeklyCard extends StatelessWidget {
  final List<int> weeklyCount;
  final int totalThisWeek;

  const _WeeklyCard({
    required this.weeklyCount,
    required this.totalThisWeek,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, 2))
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                '本周识别',
                style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              Text(
                '坚持记录，让饮食更健康！',
                style: TextStyle(
                    fontSize: 11,
                    color: AppColors.primary.withOpacity(0.8)),
              ),
              const Icon(Icons.chevron_right,
                  color: AppColors.primary, size: 16),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '$totalThisWeek 件食品',
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          // 柱状图
          SizedBox(
            height: 80,
            child: _WeekBarChart(weeklyCount: weeklyCount),
          ),
          const SizedBox(height: 4),
          // 星期标签
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['一', '二', '三', '四', '五', '六', '日']
                .map((d) => Text(
                      d,
                      style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textHint),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _WeekBarChart extends StatelessWidget {
  final List<int> weeklyCount;
  const _WeekBarChart({required this.weeklyCount});

  @override
  Widget build(BuildContext context) {
    final maxY =
        (weeklyCount.reduce((a, b) => a > b ? a : b) + 1).toDouble();

    return BarChart(
      BarChartData(
        maxY: maxY,
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: const FlTitlesData(show: false),
        barTouchData: BarTouchData(enabled: false),
        barGroups: List.generate(weeklyCount.length, (i) {
          final today = DateTime.now().weekday - 1; // 0=Mon
          final isToday = i == today;
          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: weeklyCount[i].toDouble(),
                color: isToday
                    ? AppColors.primary
                    : AppColors.primary.withOpacity(0.25),
                width: 18,
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(6)),
              ),
            ],
          );
        }),
      ),
    );
  }
}

// ── 记录卡片 ─────────────────────────────────────────────────────────────────

class _RecordCard extends StatelessWidget {
  final FoodAnalysisModel analysis;
  final VoidCallback onTap;

  const _RecordCard({required this.analysis, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scoreColor = analysis.score >= 80
        ? AppColors.scoreHigh
        : analysis.score >= 50
            ? AppColors.scoreMid
            : AppColors.scoreLow;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
                color: Color(0x08000000),
                blurRadius: 6,
                offset: Offset(0, 2))
          ],
        ),
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                  color: AppColors.primaryBg,
                  borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.local_drink_outlined,
                  color: AppColors.primary, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    analysis.productName,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _formatDate(analysis.analyzedAt),
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textHint),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${analysis.score}',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: scoreColor),
                ),
                Text(
                  analysis.scoreLevel.label,
                  style: TextStyle(fontSize: 11, color: scoreColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '今天 ${_p(dt.hour)}:${_p(dt.minute)}';
    if (diff.inDays < 1) return '今天 ${_p(dt.hour)}:${_p(dt.minute)}';
    if (diff.inDays < 2) return '昨天 ${_p(dt.hour)}:${_p(dt.minute)}';
    return '${dt.month}月${dt.day}日 ${_p(dt.hour)}:${_p(dt.minute)}';
  }

  String _p(int v) => v.toString().padLeft(2, '0');
}
