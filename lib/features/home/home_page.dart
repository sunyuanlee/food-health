import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/food_provider.dart';
import '../../core/router/app_router.dart';
import '../../models/food_analysis_model.dart';
import '../../models/ingredient_model.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final user = auth is AuthAuthenticated ? auth.user : null;
    final history = ref.watch(analysisHistoryProvider);
    final goals = ref.watch(healthGoalsProvider);

    final hour = DateTime.now().hour;
    final greeting = hour < 12 ? "上午好" : hour < 18 ? "下午好" : "晚上好";

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            backgroundColor: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 0.5,
            title: Text(
              "$greeting，${user?.nickname ?? '朋友'} 👋",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_none_outlined,
                    color: AppColors.textPrimary),
                onPressed: () {},
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ScanBanner(onScan: () => context.go(AppRoutes.scan)),
                  const SizedBox(height: 16),
                  _SearchBar(onScanTap: () => context.go(AppRoutes.scan)),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Text("我的关注目标",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary)),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => _showGoalEditor(context, ref, goals),
                        child: const Text("编辑 >",
                            style: TextStyle(
                                fontSize: 13, color: AppColors.primary)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _GoalGrid(goals: goals),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Text("最近分析",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary)),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => context.go(AppRoutes.records),
                        child: const Text("查看全部 >",
                            style: TextStyle(
                                fontSize: 13, color: AppColors.primary)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          if (history.isEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 48),
                child: Center(
                  child: Text(
                    "还没有分析记录\n扫描配料表开始吧 📷",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14, color: AppColors.textHint, height: 1.8),
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
                    child: _AnalysisCard(
                      analysis: item,
                      onTap: () =>
                          context.push(AppRoutes.analysisResult, extra: item),
                    ),
                  );
                },
                childCount: history.take(5).length,
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  void _showGoalEditor(
      BuildContext context, WidgetRef ref, List<HealthGoalType> current) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => _GoalEditorSheet(currentGoals: current),
    );
  }
}

class _ScanBanner extends StatelessWidget {
  final VoidCallback onScan;
  const _ScanBanner({required this.onScan});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [Color(0xFF27AE60), Color(0xFF1DB954)]),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 16, 20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("AI 智能识别配料表",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
                const SizedBox(height: 4),
                Text("快速分析食品成分",
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.85))),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: onScan,
                  icon: const Icon(Icons.camera_alt_outlined, size: 16),
                  label: const Text("开始扫描"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    elevation: 0,
                    minimumSize: const Size(120, 36),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                    textStyle: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.document_scanner_outlined,
              size: 80, color: Colors.white24),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final VoidCallback onScanTap;
  const _SearchBar({required this.onScanTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 8,
              offset: Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          const Icon(Icons.search, color: AppColors.textHint, size: 20),
          const SizedBox(width: 8),
          const Expanded(
            child: Text("搜索食品、成分或添加剂",
                style: TextStyle(fontSize: 14, color: AppColors.textHint)),
          ),
          GestureDetector(
            onTap: onScanTap,
            child: Container(
              margin: const EdgeInsets.all(6),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                  color: AppColors.primaryBg,
                  borderRadius: BorderRadius.circular(16)),
              child: const Icon(Icons.qr_code_scanner,
                  color: AppColors.primary, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}

class _GoalGrid extends StatelessWidget {
  final List<HealthGoalType> goals;
  const _GoalGrid({required this.goals});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: goals.take(4).map((g) => _GoalChip(goal: g)).toList(),
    );
  }
}

class _GoalChip extends StatelessWidget {
  final HealthGoalType goal;
  const _GoalChip({required this.goal});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 6,
              offset: Offset(0, 2))
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(goal.icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 6),
          Text(goal.label,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}

class _AnalysisCard extends StatelessWidget {
  final FoodAnalysisModel analysis;
  final VoidCallback onTap;
  const _AnalysisCard({required this.analysis, required this.onTap});

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
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
                color: Color(0x0A000000),
                blurRadius: 8,
                offset: Offset(0, 2))
          ],
        ),
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                  color: AppColors.primaryBg,
                  borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.local_drink_outlined,
                  color: AppColors.primary, size: 28),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(analysis.productName,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 4),
                  Text(_formatTime(analysis.analyzedAt),
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textHint)),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    children: analysis.tags.take(2).map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                            color: AppColors.tagBgNeutral,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(tag,
                            style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary)),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            _ScoreBadge(score: analysis.score, color: scoreColor),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays < 1)
      return "今天 ${dt.hour.toString().padLeft(2,'0')}:${dt.minute.toString().padLeft(2,'0')}";
    if (diff.inDays < 2)
      return "昨天 ${dt.hour.toString().padLeft(2,'0')}:${dt.minute.toString().padLeft(2,'0')}";
    return "${dt.month}月${dt.day}日";
  }
}

class _ScoreBadge extends StatelessWidget {
  final int score;
  final Color color;
  const _ScoreBadge({required this.score, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 52,
      height: 52,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: score / 100,
            strokeWidth: 4,
            backgroundColor: color.withOpacity(0.15),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
          Text("$score",
              style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w800, color: color)),
        ],
      ),
    );
  }
}

class _GoalEditorSheet extends ConsumerStatefulWidget {
  final List<HealthGoalType> currentGoals;
  const _GoalEditorSheet({required this.currentGoals});

  @override
  ConsumerState<_GoalEditorSheet> createState() => _GoalEditorSheetState();
}

class _GoalEditorSheetState extends ConsumerState<_GoalEditorSheet> {
  late List<HealthGoalType> _selected;

  @override
  void initState() {
    super.initState();
    _selected = List.from(widget.currentGoals);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("编辑关注目标",
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: HealthGoalType.values.map((goal) {
              final active = _selected.contains(goal);
              return GestureDetector(
                onTap: () => setState(() {
                  active ? _selected.remove(goal) : _selected.add(goal);
                }),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: active ? AppColors.primaryBg : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: active
                            ? AppColors.primary
                            : AppColors.divider,
                        width: 1.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(goal.icon,
                          style: const TextStyle(fontSize: 16)),
                      const SizedBox(width: 6),
                      Text(goal.label,
                          style: TextStyle(
                              fontSize: 13,
                              color: active
                                  ? AppColors.primary
                                  : AppColors.textPrimary,
                              fontWeight: active
                                  ? FontWeight.w600
                                  : FontWeight.normal)),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                ref
                    .read(healthGoalsProvider.notifier)
                    .updateGoals(_selected);
                Navigator.pop(context);
              },
              child: const Text("确认"),
            ),
          ),
        ],
      ),
    );
  }
}
