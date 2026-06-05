import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/food_provider.dart';
import '../../core/router/app_router.dart';
import '../../models/ingredient_model.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(analysisHistoryProvider.notifier).load();
      ref.read(weeklyStatsProvider.notifier).load();
      ref.read(healthGoalsProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final user = auth is AuthAuthenticated ? auth.user : null;
    final history = ref.watch(analysisHistoryProvider);
    final goals = ref.watch(healthGoalsProvider);
    final weeklyAsync = ref.watch(weeklyStatsProvider);
    final totalThisWeek =
        weeklyAsync.whenOrNull(data: (s) => s.total) ?? history.length;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: CustomScrollView(
        slivers: [
          // ── 顶部用户信息 ──────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 16,
                bottom: 20,
                left: 20,
                right: 20,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 34,
                    backgroundColor: AppColors.primaryBg,
                    child: Text(
                      _initial(user?.nickname),
                      style: const TextStyle(
                          fontSize: 24,
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.nickname ?? '未登录',
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          user != null ? '手机号 ${user.phone}' : '登录后享受个性化服务',
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings_outlined,
                        color: AppColors.textSecondary),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),

          // ── 统计数据 ──────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: _StatsRow(
                total: history.length,
                thisWeek: totalThisWeek,
              ),
            ),
          ),

          // ── 我的健康偏好 ──────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: _SectionCard(
                title: '我的健康偏好',
                trailing: GestureDetector(
                  onTap: () {},
                  child: const Text('编辑',
                      style:
                          TextStyle(fontSize: 13, color: AppColors.primary)),
                ),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: goals.map((g) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(g.icon,
                              style: const TextStyle(fontSize: 14)),
                          const SizedBox(width: 4),
                          Text(g.label,
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),

          // ── 识别历史预览 ─────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: _SectionCard(
                title: '识别历史',
                trailing: GestureDetector(
                  onTap: () => context.go(AppRoutes.records),
                  child: const Text('查看全部',
                      style:
                          TextStyle(fontSize: 13, color: AppColors.primary)),
                ),
                child: Column(
                  children: [
                    ...history.take(3).map((item) {
                      final scoreColor = item.score >= 80
                          ? AppColors.scoreHigh
                          : item.score >= 50
                              ? AppColors.scoreMid
                              : AppColors.scoreLow;
                      return InkWell(
                        onTap: () => context.push(
                            AppRoutes.analysisResult, extra: item),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryBg,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.local_drink_outlined,
                                    color: AppColors.primary, size: 20),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(item.productName,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.textPrimary)),
                                    Text(_formatDate(item.analyzedAt),
                                        style: const TextStyle(
                                            fontSize: 11,
                                            color: AppColors.textHint)),
                                  ],
                                ),
                              ),
                              Text(
                                '${item.score}',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: scoreColor),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    if (history.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Text('还没有识别记录',
                            style: TextStyle(
                                fontSize: 13, color: AppColors.textHint)),
                      ),
                  ],
                ),
              ),
            ),
          ),

          // ── 功能设置 ─────────────────────────────────────────────
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: _SettingsCard(),
            ),
          ),

          // ── 退出登录 ─────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
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
                child: _MenuItem(
                  icon: Icons.logout_rounded,
                  iconColor: AppColors.error,
                  label: '退出登录',
                  labelColor: AppColors.error,
                  onTap: () => _confirmLogout(context, ref),
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  String _initial(String? name) {
    if (name == null || name.isEmpty) return '?';
    return name[0];
  }

  String _formatDate(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays < 1) return '今天 ${_p(dt.hour)}:${_p(dt.minute)}';
    if (diff.inDays < 2) return '昨天 ${_p(dt.hour)}:${_p(dt.minute)}';
    return '${dt.month}月${dt.day}日';
  }

  String _p(int v) => v.toString().padLeft(2, '0');

  void _confirmLogout(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('退出登录'),
        content: const Text('确定要退出当前账号吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('取消',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) context.go(AppRoutes.splash);
            },
            child: const Text('退出',
                style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

// ── 统计行 ────────────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  final int total;
  final int thisWeek;

  const _StatsRow({required this.total, required this.thisWeek});

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
      child: Row(
        children: [
          _StatItem(value: '$total', label: '累计识别'),
          Container(width: 1, height: 40, color: AppColors.divider),
          _StatItem(value: '$thisWeek', label: '本周识别'),
          Container(width: 1, height: 40, color: AppColors.divider),
          const _StatItem(value: '12', label: '关注成分'),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Column(
          children: [
            Text(value,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 2),
            Text(label,
                style: const TextStyle(
                    fontSize: 11, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

// ── 通用 Section 卡 ───────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final Widget child;

  const _SectionCard({
    required this.title,
    this.trailing,
    required this.child,
  });

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
              const Spacer(),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

// ── 设置卡 ────────────────────────────────────────────────────────────────────

class _SettingsCard extends StatelessWidget {
  const _SettingsCard();

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
        children: [
          _MenuItem(
              icon: Icons.notifications_none_outlined,
              label: '消息通知',
              onTap: () {}),
          const Divider(height: 1, indent: 52),
          _MenuItem(
              icon: Icons.privacy_tip_outlined,
              label: '隐私设置',
              onTap: () {}),
          const Divider(height: 1, indent: 52),
          _MenuItem(
              icon: Icons.help_outline_rounded,
              label: '帮助与反馈',
              onTap: () {}),
          const Divider(height: 1, indent: 52),
          _MenuItem(
              icon: Icons.info_outline_rounded,
              label: '关于成分雷达',
              onTap: () {}),
        ],
      ),
    );
  }
}

// ── 菜单项 ────────────────────────────────────────────────────────────────────

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String label;
  final Color? labelColor;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    this.iconColor,
    required this.label,
    this.labelColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon,
                size: 22, color: iconColor ?? AppColors.textSecondary),
            const SizedBox(width: 14),
            Expanded(
              child: Text(label,
                  style: TextStyle(
                      fontSize: 15,
                      color: labelColor ?? AppColors.textPrimary)),
            ),
            const Icon(Icons.chevron_right_rounded,
                size: 20, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }
}

