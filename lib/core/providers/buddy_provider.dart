import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/buddy_model.dart';
import '../data/mock_data.dart';

/// 搭子列表过滤状态
class BuddyFilter {
  final String? city;
  final WorkoutType? workoutType;
  final FitnessLevel? level;

  const BuddyFilter({this.city, this.workoutType, this.level});

  BuddyFilter copyWith({
    Object? city = const _Undefined(),
    Object? workoutType = const _Undefined(),
    Object? level = const _Undefined(),
  }) {
    return BuddyFilter(
      city: city is _Undefined ? this.city : city as String?,
      workoutType: workoutType is _Undefined
          ? this.workoutType
          : workoutType as WorkoutType?,
      level: level is _Undefined ? this.level : level as FitnessLevel?,
    );
  }
}

class _Undefined {
  const _Undefined();
}

/// 过滤条件 provider
final buddyFilterProvider =
    StateProvider<BuddyFilter>((ref) => const BuddyFilter());

/// 搭子列表 provider（根据过滤条件筛选）
final buddyListProvider = Provider<List<BuddyModel>>((ref) {
  final filter = ref.watch(buddyFilterProvider);
  var list = MockData.buddies;

  if (filter.city != null) {
    list = list.where((b) => b.city == filter.city).toList();
  }
  if (filter.workoutType != null) {
    list = list
        .where((b) => b.workoutTypes.contains(filter.workoutType))
        .toList();
  }
  if (filter.level != null) {
    list = list.where((b) => b.level == filter.level).toList();
  }

  return list;
});

/// 会话列表 provider
final conversationListProvider = Provider<List<ConversationModel>>((ref) {
  return MockData.conversations;
});

/// 未读消息总数
final unreadCountProvider = Provider<int>((ref) {
  final conversations = ref.watch(conversationListProvider);
  return conversations.fold(0, (sum, c) => sum + c.unreadCount);
});

/// 单条会话聊天消息列表（按 userId 区分）
final chatMessagesProvider =
    StateProvider.family<List<ChatMessage>, String>((ref, userId) {
  return [
    ChatMessage(
      id: '1',
      senderId: userId,
      content: '嗨！看到你的健身计划，感觉我们很合适做搭子！',
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      isRead: true,
    ),
    ChatMessage(
      id: '2',
      senderId: 'me',
      content: '哈哈，是的！你一般几点训练？',
      createdAt:
          DateTime.now().subtract(const Duration(minutes: 55)),
      isRead: true,
    ),
    ChatMessage(
      id: '3',
      senderId: userId,
      content: '工作日晚上6点到8点，周末上午也可以',
      createdAt:
          DateTime.now().subtract(const Duration(minutes: 50)),
      isRead: true,
    ),
    ChatMessage(
      id: '4',
      senderId: 'me',
      content: '时间完美！那我们明晚一起去威尔士？',
      createdAt:
          DateTime.now().subtract(const Duration(minutes: 30)),
      isRead: true,
    ),
    ChatMessage(
      id: '5',
      senderId: userId,
      content: '没问题，明晚见！💪',
      createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      isRead: false,
    ),
  ];
});
