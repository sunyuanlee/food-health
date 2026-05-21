import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../models/buddy_model.dart';

/// 发布搭子需求页面表单状态
class _PublishFormState {
  final List<WorkoutType> workoutTypes;
  final FitnessLevel? level;
  final String gym;
  final String workoutTime;
  final String preferredTime;
  final String note;

  const _PublishFormState({
    this.workoutTypes = const [],
    this.level,
    this.gym = '',
    this.workoutTime = '',
    this.preferredTime = '',
    this.note = '',
  });

  _PublishFormState copyWith({
    List<WorkoutType>? workoutTypes,
    Object? level = const _Undefined(),
    String? gym,
    String? workoutTime,
    String? preferredTime,
    String? note,
  }) {
    return _PublishFormState(
      workoutTypes: workoutTypes ?? this.workoutTypes,
      level: level is _Undefined ? this.level : level as FitnessLevel?,
      gym: gym ?? this.gym,
      workoutTime: workoutTime ?? this.workoutTime,
      preferredTime: preferredTime ?? this.preferredTime,
      note: note ?? this.note,
    );
  }
}

class _Undefined {
  const _Undefined();
}

class PublishPage extends ConsumerStatefulWidget {
  const PublishPage({super.key});

  @override
  ConsumerState<PublishPage> createState() => _PublishPageState();
}

class _PublishPageState extends ConsumerState<PublishPage> {
  _PublishFormState _form = const _PublishFormState();
  final _gymController = TextEditingController();
  final _noteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final List<String> _timeSlots = [
    '06:00 - 08:00',
    '08:00 - 10:00',
    '12:00 - 14:00',
    '18:00 - 20:00',
    '19:00 - 21:00',
    '20:00 - 22:00',
  ];

  final List<String> _preferredTimes = [
    '工作日',
    '周末',
    '随时',
    '上午',
    '下午',
    '晚上',
  ];

  @override
  void dispose() {
    _gymController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: const Text('发布搭子需求'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _handleSubmit,
            child: const Text(
              '发布',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 训练方向（多选）
              _SectionCard(
                title: '训练方向',
                subtitle: '可多选',
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: WorkoutType.values.map((t) {
                    final selected = _form.workoutTypes.contains(t);
                    return _SelectableChip(
                      label: '${t.emoji} ${t.label}',
                      selected: selected,
                      onTap: () {
                        final list = List<WorkoutType>.from(
                            _form.workoutTypes);
                        if (selected) {
                          list.remove(t);
                        } else {
                          list.add(t);
                        }
                        setState(
                            () => _form = _form.copyWith(workoutTypes: list));
                      },
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 12),

              // 健身经验
              _SectionCard(
                title: '健身经验',
                child: Wrap(
                  spacing: 8,
                  children: FitnessLevel.values.map((l) {
                    return _SelectableChip(
                      label: l.label,
                      selected: _form.level == l,
                      onTap: () =>
                          setState(() => _form = _form.copyWith(level: l)),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 12),

              // 健身房
              _SectionCard(
                title: '常去健身房',
                child: TextFormField(
                  controller: _gymController,
                  decoration: const InputDecoration(
                    hintText: '输入健身房名称',
                    prefixIcon: Icon(Icons.fitness_center,
                        color: AppColors.primary, size: 20),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (v) =>
                      setState(() => _form = _form.copyWith(gym: v)),
                ),
              ),

              const SizedBox(height: 12),

              // 训练时间段
              _SectionCard(
                title: '训练时间',
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _timeSlots.map((slot) {
                    return _SelectableChip(
                      label: slot,
                      selected: _form.workoutTime == slot,
                      onTap: () => setState(
                          () => _form = _form.copyWith(workoutTime: slot)),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 12),

              // 偏好时段
              _SectionCard(
                title: '偏好时段',
                subtitle: '可多选',
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _preferredTimes.map((pt) {
                    final selected = _form.preferredTime
                        .split('/')
                        .map((s) => s.trim())
                        .contains(pt);
                    return _SelectableChip(
                      label: pt,
                      selected: selected,
                      onTap: () {
                        final parts = _form.preferredTime.isEmpty
                            ? <String>[]
                            : _form.preferredTime
                                .split('/')
                                .map((s) => s.trim())
                                .toList();
                        if (selected) {
                          parts.remove(pt);
                        } else {
                          parts.add(pt);
                        }
                        setState(() => _form = _form.copyWith(
                            preferredTime: parts.join(' / ')));
                      },
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 12),

              // 备注
              _SectionCard(
                title: '补充说明',
                child: TextFormField(
                  controller: _noteController,
                  maxLines: 4,
                  maxLength: 200,
                  decoration: const InputDecoration(
                    hintText: '描述你的训练目标、配对要求等（选填）',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (v) =>
                      setState(() => _form = _form.copyWith(note: v)),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSubmit() {
    if (_form.workoutTypes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请至少选择一个训练方向')),
      );
      return;
    }
    // TODO: 调用 API 发布需求
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('发布成功！'),
        backgroundColor: AppColors.primary,
      ),
    );
    Navigator.pop(context);
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;

  const _SectionCard({
    required this.title,
    this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(title, style: AppTextStyles.h3.copyWith(fontSize: 15)),
              if (subtitle != null) ...[
                const SizedBox(width: 6),
                Text(subtitle!, style: AppTextStyles.caption),
              ],
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _SelectableChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SelectableChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary
              : AppColors.primary.withOpacity(0.06),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.primary : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: selected ? Colors.white : AppColors.textSecondary,
            fontWeight:
                selected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
