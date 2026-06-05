import 'package:flutter/foundation.dart';
import 'ingredient_model.dart';

/// 评分等级
enum ScoreLevel {
  recommended, // 推荐 80-100
  caution,     // 谨慎选择 50-79
  avoid,       // 不建议 0-49
}

extension ScoreLevelExt on ScoreLevel {
  String get label {
    switch (this) {
      case ScoreLevel.recommended: return '推荐';
      case ScoreLevel.caution:     return '谨慎选择';
      case ScoreLevel.avoid:       return '不建议';
    }
  }
}

ScoreLevel scoreToLevel(int score) {
  if (score >= 80) return ScoreLevel.recommended;
  if (score >= 50) return ScoreLevel.caution;
  return ScoreLevel.avoid;
}

@immutable
class FoodAnalysisModel {
  final String id;
  final String productName;
  final String? brand;
  final String? spec;          // 规格，如 250mL
  final String? imageUrl;
  final int score;             // 0-100
  final ScoreLevel scoreLevel;
  final List<IngredientModel> ingredients;
  final List<String> tags;     // 如：含代糖、钠偏高
  final List<GoalFitResult> goalFits;
  final int additiveCount;
  final DateTime analyzedAt;

  const FoodAnalysisModel({
    required this.id,
    required this.productName,
    this.brand,
    this.spec,
    this.imageUrl,
    required this.score,
    required this.scoreLevel,
    required this.ingredients,
    required this.tags,
    required this.goalFits,
    required this.additiveCount,
    required this.analyzedAt,
  });

  factory FoodAnalysisModel.fromJson(Map<String, dynamic> json) {
    return FoodAnalysisModel(
      id: json['id'] as String,
      productName: json['productName'] as String,
      brand: json['brand'] as String?,
      spec: json['spec'] as String?,
      imageUrl: json['imageUrl'] as String?,
      score: json['score'] as int,
      scoreLevel: scoreToLevel(json['score'] as int),
      tags: (json['tags'] as List<dynamic>).cast<String>(),
      additiveCount: json['additiveCount'] as int,
      analyzedAt: DateTime.parse(json['analyzedAt'] as String),
      ingredients: (json['ingredients'] as List<dynamic>)
          .map((e) => IngredientModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      goalFits: (json['goalFits'] as List<dynamic>)
          .map((e) => GoalFitResult.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
