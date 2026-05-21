import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/router/app_router.dart';
import '../../models/food_analysis_model.dart';
import '../../models/ingredient_model.dart';

class AnalysisResultPage extends StatelessWidget {
  final FoodAnalysisModel analysis;
  const AnalysisResultPage({super.key, required this.analysis});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: Text(
          analysis.productName,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 产品信息卡 ─────────────────────────────────────────
            _ProductCard(analysis: analysis),
            const SizedBox(height: 16),

            // ── 评分卡 ─────────────────────────────────────────────
            _ScoreCard(analysis: analysis),
            const SizedBox(height: 16),

            // ── 成分解读入口 ───────────────────────────────────────
            GestureDetector(
              onTap: () => context.push(
                  AppRoutes.ingredientDetail, extra: analysis),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: const [
                    BoxShadow(
                        color: Color(0x0A000000),
                        blurRadius: 8,
                        offset: Offset(0, 2))
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: const Row(
                  children: [
                    Icon(Icons.list_alt_outlined,
                        color: AppColors.primary, size: 22),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('成分解读',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary)),
                          SizedBox(height: 2),
                          Text('查看每种配料的详细分析',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right,
                        color: AppColors.textHint),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── 适合你吗 ───────────────────────────────────────────
            if (analysis.goalFits.isNotEmpty) ...[
              const Text('适合你吗？',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 12),
              _GoalFitList(goalFits: analysis.goalFits),
            ],

            const SizedBox(height: 24),
            const Center(
              child: Text(
                '以上内容仅供参考，不构成医疗建议。',
                style: TextStyle(fontSize: 11, color: AppColors.textHint),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// ── 产品信息卡 ───────────────────────────────────────────────────────────────

class _ProductCard extends StatelessWidget {
  final FoodAnalysisModel analysis;
  const _ProductCard({required this.analysis});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, 2))
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: AppColors.primaryBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.local_drink_outlined,
                color: AppColors.primary, size: 36),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  analysis.productName,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary),
                ),
                const SizedBox(height: 4),
                if (analysis.brand?.isNotEmpty == true)
                  Text(
                    '规格：${analysis.spec ?? '-'}  品牌：${analysis.brand}',
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary),
                  ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  children: analysis.tags.map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: _tagColor(tag).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(
                            fontSize: 11, color: _tagColor(tag)),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _tagColor(String tag) {
    if (tag.contains('高') || tag.contains('含代糖') || tag.contains('添加剂')) {
      return AppColors.caution;
    }
    if (tag.contains('无') || tag.contains('推荐')) {
      return AppColors.safe;
    }
    return AppColors.textSecondary;
  }
}

// ── 评分卡 ───────────────────────────────────────────────────────────────────

class _ScoreCard extends StatelessWidget {
  final FoodAnalysisModel analysis;
  const _ScoreCard({required this.analysis});

  @override
  Widget build(BuildContext context) {
    final score = analysis.score;
    final scoreColor = score >= 80
        ? AppColors.scoreHigh
        : score >= 50
            ? AppColors.scoreMid
            : AppColors.scoreLow;
    final levelLabel = analysis.scoreLevel.label;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, 2))
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // 圆形评分
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 88,
                height: 88,
                child: CircularProgressIndicator(
                  value: score / 100,
                  strokeWidth: 7,
                  backgroundColor: scoreColor.withOpacity(0.15),
                  valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$score',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: scoreColor,
                    ),
                  ),
                  Text(
                    '/100',
                    style: TextStyle(
                      fontSize: 12,
                      color: scoreColor.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, color: scoreColor, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      levelLabel,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: scoreColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  _scoreDescription(score),
                  style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _scoreDescription(int score) {
    if (score >= 80) return '成分表整体较优，适合日常选购。';
    if (score >= 60) return '蛋白质较高，但含代糖与钠偏高，注意控制摄入量。';
    if (score >= 50) return '添加剂较多，建议偶尔选购，不宜频繁饮用。';
    return '成分复杂，添加剂多，建议慎重购买。';
  }
}

// ── 目标适配列表 ─────────────────────────────────────────────────────────────

class _GoalFitList extends StatelessWidget {
  final List<GoalFitResult> goalFits;
  const _GoalFitList({required this.goalFits});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, 2))
        ],
      ),
      child: Column(
        children: goalFits.asMap().entries.map((entry) {
          final i = entry.key;
          final fit = entry.value;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Text(fit.goal.icon,
                        style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(fit.goal.label,
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary)),
                          const SizedBox(height: 2),
                          Text(fit.reason,
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    _FitBadge(level: fit.level),
                  ],
                ),
              ),
              if (i < goalFits.length - 1)
                const Divider(height: 1, indent: 16, endIndent: 16),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _FitBadge extends StatelessWidget {
  final GoalFitLevel level;
  const _FitBadge({required this.level});

  @override
  Widget build(BuildContext context) {
    final Color color;
    switch (level) {
      case GoalFitLevel.suitable:
        color = AppColors.safe;
        break;
      case GoalFitLevel.general:
        color = AppColors.caution;
        break;
      case GoalFitLevel.caution:
        color = AppColors.warning;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        level.label,
        style: TextStyle(
            fontSize: 12, color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}
