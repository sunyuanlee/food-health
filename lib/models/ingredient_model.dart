import 'package:flutter/foundation.dart';

/// 成分风险等级
enum IngredientRisk {
  safe,     // 推荐
  neutral,  // 中性
  caution,  // 谨慎
  warning,  // 注意
}

/// 健康目标类型
enum HealthGoalType {
  lowSugar,      // 减脂控糖
  lessAdditives, // 少添加剂
  muscleGain,    // 健身增肌
  allergyFree,   // 过敏避雷
  lowSodium,     // 控钠
  lactoseFree,   // 乳糖不耐
  peanutFree,    // 花生过敏
}

extension HealthGoalTypeExt on HealthGoalType {
  String get label {
    switch (this) {
      case HealthGoalType.lowSugar:      return '减脂控糖';
      case HealthGoalType.lessAdditives: return '少添加剂';
      case HealthGoalType.muscleGain:    return '健身增肌';
      case HealthGoalType.allergyFree:   return '过敏避雷';
      case HealthGoalType.lowSodium:     return '低钠';
      case HealthGoalType.lactoseFree:   return '乳糖不耐';
      case HealthGoalType.peanutFree:    return '花生过敏';
    }
  }

  String get icon {
    switch (this) {
      case HealthGoalType.lowSugar:      return '🔥';
      case HealthGoalType.lessAdditives: return '🛡️';
      case HealthGoalType.muscleGain:    return '💪';
      case HealthGoalType.allergyFree:   return '🌸';
      case HealthGoalType.lowSodium:     return '🧂';
      case HealthGoalType.lactoseFree:   return '🥛';
      case HealthGoalType.peanutFree:    return '🥜';
    }
  }
}

@immutable
class IngredientModel {
  final String name;
  final String description;
  final IngredientRisk risk;
  final String? riskReason;

  const IngredientModel({
    required this.name,
    required this.description,
    required this.risk,
    this.riskReason,
  });

  factory IngredientModel.fromJson(Map<String, dynamic> json) {
    return IngredientModel(
      name: json['name'] as String,
      description: json['description'] as String,
      risk: _riskFromString(json['risk'] as String),
      riskReason: json['riskReason'] as String?,
    );
  }

  static IngredientRisk _riskFromString(String s) {
    switch (s) {
      case 'safe':    return IngredientRisk.safe;
      case 'caution': return IngredientRisk.caution;
      case 'warning': return IngredientRisk.warning;
      default:        return IngredientRisk.neutral;
    }
  }
}

/// 目标适合度评估
@immutable
class GoalFitResult {
  final HealthGoalType goal;
  final GoalFitLevel level; // suitable / general / caution
  final String reason;

  const GoalFitResult({
    required this.goal,
    required this.level,
    required this.reason,
  });

  factory GoalFitResult.fromJson(Map<String, dynamic> json) {
    return GoalFitResult(
      goal: _goalFromString(json['goal'] as String),
      level: _levelFromString(json['level'] as String),
      reason: json['reason'] as String,
    );
  }

  static HealthGoalType _goalFromString(String s) {
    return HealthGoalType.values.firstWhere(
      (e) => e.name == s,
      orElse: () => HealthGoalType.lowSugar,
    );
  }

  static GoalFitLevel _levelFromString(String s) {
    switch (s) {
      case 'suitable': return GoalFitLevel.suitable;
      case 'caution':  return GoalFitLevel.caution;
      default:         return GoalFitLevel.general;
    }
  }
}

enum GoalFitLevel {
  suitable,  // 适合
  general,   // 一般
  caution,   // 谨慎
}

extension GoalFitLevelExt on GoalFitLevel {
  String get label {
    switch (this) {
      case GoalFitLevel.suitable: return '适合';
      case GoalFitLevel.general:  return '一般';
      case GoalFitLevel.caution:  return '谨慎';
    }
  }
}
