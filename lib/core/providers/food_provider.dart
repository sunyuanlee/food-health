import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/food_analysis_model.dart';
import '../../models/ingredient_model.dart';
import '../data/analysis_repository.dart';
import '../data/users_repository.dart';

// ── 分析历史 Provider ─────────────────────────────────────────────────────

final analysisHistoryProvider =
    StateNotifierProvider<AnalysisHistoryNotifier, List<FoodAnalysisModel>>(
  (ref) => AnalysisHistoryNotifier(),
);

class AnalysisHistoryNotifier extends StateNotifier<List<FoodAnalysisModel>> {
  AnalysisHistoryNotifier() : super([]);

  final _repo = AnalysisRepository.instance;
  bool _loaded = false;

  /// 首次加载（从服务器拉取）
  Future<void> load() async {
    if (_loaded) return;
    try {
      final result = await _repo.getHistory(page: 1, limit: 50);
      state = result.items;
      _loaded = true;
    } catch (_) {
      // 网络失败时保持空列表，不影响页面渲染
    }
  }

  /// 扫描完成后插入最新结果到列表头部
  void addAnalysis(FoodAnalysisModel analysis) {
    state = [analysis, ...state];
  }

  /// 删除一条记录
  Future<void> delete(String id) async {
    await _repo.delete(id);
    state = state.where((item) => item.id != id).toList();
  }

  /// 强制刷新
  Future<void> refresh() async {
    _loaded = false;
    await load();
  }
}

// ── 本周统计 Provider ─────────────────────────────────────────────────────

final weeklyStatsProvider =
    StateNotifierProvider<WeeklyStatsNotifier, AsyncValue<WeeklyStats>>(
  (ref) => WeeklyStatsNotifier(),
);

class WeeklyStatsNotifier extends StateNotifier<AsyncValue<WeeklyStats>> {
  WeeklyStatsNotifier() : super(const AsyncValue.loading());

  final _repo = AnalysisRepository.instance;

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final stats = await _repo.getWeeklyStats();
      state = AsyncValue.data(stats);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

// ── 健康目标 Provider ─────────────────────────────────────────────────────

final healthGoalsProvider =
    StateNotifierProvider<HealthGoalsNotifier, List<HealthGoalType>>(
  (ref) => HealthGoalsNotifier(),
);

class HealthGoalsNotifier extends StateNotifier<List<HealthGoalType>> {
  HealthGoalsNotifier()
      : super(const [
          HealthGoalType.lowSugar,
          HealthGoalType.lessAdditives,
          HealthGoalType.muscleGain,
          HealthGoalType.allergyFree,
        ]);

  final _repo = UsersRepository.instance;

  /// 从服务器加载健康目标
  Future<void> load() async {
    try {
      final goals = await _repo.getGoals();
      final parsed = goals
          .map((s) => HealthGoalType.values.firstWhere(
                (e) => e.name == s,
                orElse: () => HealthGoalType.lowSugar,
              ))
          .toList();
      if (parsed.isNotEmpty) state = parsed;
    } catch (_) {
      // 保持默认值
    }
  }

  void toggle(HealthGoalType goal) {
    if (state.contains(goal)) {
      state = state.where((g) => g != goal).toList();
    } else {
      state = [...state, goal];
    }
    _syncToServer();
  }

  void updateGoals(List<HealthGoalType> goals) {
    state = goals;
    _syncToServer();
  }

  void _syncToServer() {
    final goalNames = state.map((e) => e.name).toList();
    _repo.updateGoals(goalNames).catchError((_) {});
  }
}

// ── 当前分析结果 Provider（扫描完成后临时持有）─────────────────────────────

final currentAnalysisProvider = StateProvider<FoodAnalysisModel?>(
  (ref) => null,
);

// ── 扫描状态 Provider ─────────────────────────────────────────────────────

enum ScanStatus { idle, scanning, done, error }

final scanStatusProvider = StateProvider<ScanStatus>(
  (ref) => ScanStatus.idle,
);
