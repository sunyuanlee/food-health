import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/food_analysis_model.dart';
import '../../models/ingredient_model.dart';
import '../data/mock_food_data.dart';

// ── 分析历史 Provider ─────────────────────────────────────────────────────

final analysisHistoryProvider =
    StateNotifierProvider<AnalysisHistoryNotifier, List<FoodAnalysisModel>>(
  (ref) => AnalysisHistoryNotifier(),
);

class AnalysisHistoryNotifier extends StateNotifier<List<FoodAnalysisModel>> {
  AnalysisHistoryNotifier() : super(MockFoodData.analysisHistory);

  void addAnalysis(FoodAnalysisModel analysis) {
    state = [analysis, ...state];
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

  void toggle(HealthGoalType goal) {
    if (state.contains(goal)) {
      state = state.where((g) => g != goal).toList();
    } else {
      state = [...state, goal];
    }
  }

  void updateGoals(List<HealthGoalType> goals) {
    state = goals;
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
