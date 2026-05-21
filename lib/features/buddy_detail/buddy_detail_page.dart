import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../models/buddy_model.dart';

class BuddyDetailPage extends StatelessWidget {
  final String buddyId;
  final BuddyModel? buddy;

  const BuddyDetailPage({
    super.key,
    required this.buddyId,
    this.buddy,
  });

  @override
  Widget build(BuildContext context) {
    // 实际项目中应从 provider 按 id 获取，这里直接使用传入的 buddy
    if (buddy == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final b = buddy!;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildHeader(context, b),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBasicInfo(b),
                  const SizedBox(height: 16),
                  _buildWorkoutTypes(b),
                  const SizedBox(height: 16),
                  _buildScheduleCard(b),
                  const SizedBox(height: 16),
                  _buildBioCard(b),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(context, b),
    );
  }

  Widget _buildHeader(BuildContext context, BuddyModel b) {
    return SliverAppBar(
      expandedHeight: 240,
      pinned: true,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back_ios_new,
              color: Colors.white, size: 16),
        ),
        onPressed: () => context.pop(),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.more_horiz,
                color: Colors.white, size: 20),
          ),
          onPressed: () {},
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: b.avatarUrl,
              fit: BoxFit.cover,
              placeholder: (_, __) =>
                  Container(color: AppColors.scaffoldBg),
            ),
            // 底部渐变遮罩
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.5, 1.0],
                  colors: [Colors.transparent, Colors.black54],
                ),
              ),
            ),
            // 底部名字
            Positioned(
              left: 16,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        b.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (b.isOnline)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.online,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            '在线',
                            style: TextStyle(
                                color: Colors.white, fontSize: 11),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${b.age}岁 · ${b.city}${b.district} · ${b.distanceKm.toStringAsFixed(1)}km',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 13,
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

  Widget _buildBasicInfo(BuddyModel b) {
    return Row(
      children: [
        _StatChip(
          value: '${b.yearsOfTraining}年',
          label: '健身时长',
        ),
        const SizedBox(width: 12),
        _StatChip(
          value: '${b.daysPerWeek}天/周',
          label: '训练频率',
        ),
        const SizedBox(width: 12),
        _StatChip(
          value: b.level.label,
          label: '经验等级',
          valueColor: AppColors.primary,
        ),
      ],
    );
  }

  Widget _buildWorkoutTypes(BuddyModel b) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('训练方向', style: AppTextStyles.h3),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: b.workoutTypes.map((t) {
            return Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: AppColors.primary.withOpacity(0.3)),
              ),
              child: Text(
                '${t.emoji} ${t.label}',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildScheduleCard(BuddyModel b) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _InfoRow(
            icon: Icons.fitness_center,
            label: '健身房',
            value: b.gym,
          ),
          const Divider(height: 24),
          _InfoRow(
            icon: Icons.access_time_rounded,
            label: '训练时间',
            value: b.workoutTime,
          ),
          const Divider(height: 24),
          _InfoRow(
            icon: Icons.calendar_today_rounded,
            label: '偏好时段',
            value: b.preferredTime,
          ),
        ],
      ),
    );
  }

  Widget _buildBioCard(BuddyModel b) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('个人簡介', style: AppTextStyles.h3),
          const SizedBox(height: 10),
          Text(b.bio, style: AppTextStyles.body1),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, BuddyModel b) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // 空接按钮
          Expanded(
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primary),
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text('空接一下', style: TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(width: 12),
          // 打招呼按钮
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                context.push(
                  '/chat/${b.id}',
                  extra: {
                    'userName': b.name,
                    'avatarUrl': b.avatarUrl,
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text('打招呼', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String value;
  final String label;
  final Color? valueColor;

  const _StatChip({
    required this.value,
    required this.label,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: valueColor ?? AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(label, style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 10),
        Text(label, style: AppTextStyles.body2),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
