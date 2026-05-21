import 'package:flutter/foundation.dart';

/// 健身标签枚举
enum WorkoutType {
  strength('力量训练', '💪'),
  cardio('有氧运动', '🏃'),
  hiit('HIIT', '🔥'),
  yoga('瑜伽', '🧘'),
  stretching('拉伸', '🤸'),
  crossfit('健美操', '🤼'),
  swimming('游泳', '🏊'),
  cycling('骑行', '🚴');

  final String label;
  final String emoji;
  const WorkoutType(this.label, this.emoji);
}

/// 健身经验
enum FitnessLevel {
  beginner('新手'),
  intermediate('进阶'),
  advanced('大神');

  final String label;
  const FitnessLevel(this.label);
}

/// 健身搭子数据模型
@immutable
class BuddyModel {
  final String id;
  final String name;
  final String avatarUrl;
  final int age;
  final String city;
  final String district;
  final FitnessLevel level;
  final int yearsOfTraining;
  final int daysPerWeek;
  final List<WorkoutType> workoutTypes;
  final String gym;
  final String bio;
  final String workoutTime; // e.g. "18:00 - 20:00"
  final String preferredTime; // e.g. "工作日/周末/随时"
  final double distanceKm;
  final bool isOnline;
  final DateTime lastActive;

  const BuddyModel({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.age,
    required this.city,
    required this.district,
    required this.level,
    required this.yearsOfTraining,
    required this.daysPerWeek,
    required this.workoutTypes,
    required this.gym,
    required this.bio,
    required this.workoutTime,
    required this.preferredTime,
    required this.distanceKm,
    required this.isOnline,
    required this.lastActive,
  });

  BuddyModel copyWith({
    String? id,
    String? name,
    String? avatarUrl,
    int? age,
    String? city,
    String? district,
    FitnessLevel? level,
    int? yearsOfTraining,
    int? daysPerWeek,
    List<WorkoutType>? workoutTypes,
    String? gym,
    String? bio,
    String? workoutTime,
    String? preferredTime,
    double? distanceKm,
    bool? isOnline,
    DateTime? lastActive,
  }) {
    return BuddyModel(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      age: age ?? this.age,
      city: city ?? this.city,
      district: district ?? this.district,
      level: level ?? this.level,
      yearsOfTraining: yearsOfTraining ?? this.yearsOfTraining,
      daysPerWeek: daysPerWeek ?? this.daysPerWeek,
      workoutTypes: workoutTypes ?? this.workoutTypes,
      gym: gym ?? this.gym,
      bio: bio ?? this.bio,
      workoutTime: workoutTime ?? this.workoutTime,
      preferredTime: preferredTime ?? this.preferredTime,
      distanceKm: distanceKm ?? this.distanceKm,
      isOnline: isOnline ?? this.isOnline,
      lastActive: lastActive ?? this.lastActive,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BuddyModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// 聊天消息模型
@immutable
class ChatMessage {
  final String id;
  final String senderId;
  final String content;
  final DateTime createdAt;
  final bool isRead;

  const ChatMessage({
    required this.id,
    required this.senderId,
    required this.content,
    required this.createdAt,
    required this.isRead,
  });
}

/// 会话列表项
@immutable
class ConversationModel {
  final String id;
  final BuddyModel buddy;
  final ChatMessage lastMessage;
  final int unreadCount;

  const ConversationModel({
    required this.id,
    required this.buddy,
    required this.lastMessage,
    required this.unreadCount,
  });
}

/// 发布搭子需求模型
@immutable
class BuddyRequest {
  final String id;
  final String userId;
  final List<WorkoutType> workoutTypes;
  final String gym;
  final String workoutTime;
  final String preferredTime;
  final FitnessLevel level;
  final String note;
  final DateTime createdAt;

  const BuddyRequest({
    required this.id,
    required this.userId,
    required this.workoutTypes,
    required this.gym,
    required this.workoutTime,
    required this.preferredTime,
    required this.level,
    required this.note,
    required this.createdAt,
  });
}
