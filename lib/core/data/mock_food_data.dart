import '../../models/food_analysis_model.dart';
import '../../models/ingredient_model.dart';

class MockFoodData {
  MockFoodData._();

  static final List<FoodAnalysisModel> analysisHistory = [
    FoodAnalysisModel(
      id: '1',
      productName: '高蛋白酸奶饮品',
      brand: 'XX 牧场',
      spec: '250mL',
      score: 72,
      scoreLevel: ScoreLevel.caution,
      tags: const ['含代糖', '钠偏高', '蛋白质较高', '添加剂 5 项'],
      additiveCount: 5,
      analyzedAt: DateTime.now().subtract(const Duration(hours: 2)),
      ingredients: const [
        IngredientModel(
          name: '赤藓糖醇',
          description: '常见代糖，热量较低，部分人摄入较多可能肠胃不适。',
          risk: IngredientRisk.caution,
          riskReason: '代糖摄入过多可能影响肠道菌群',
        ),
        IngredientModel(
          name: '麦芽糊精',
          description: '常用作填充剂，控糖人群需要注意。',
          risk: IngredientRisk.warning,
          riskReason: '升糖指数较高，控糖人群注意',
        ),
        IngredientModel(
          name: '乳清蛋白粉',
          description: '优质蛋白来源，适合补充蛋白。',
          risk: IngredientRisk.safe,
        ),
        IngredientModel(
          name: '白砂糖',
          description: '精制糖，提供甜味和能量。',
          risk: IngredientRisk.caution,
          riskReason: '控糖人群需要限制摄入',
        ),
        IngredientModel(
          name: '脱脂奶粉',
          description: '低脂牛奶成分，提供钙质和蛋白质。',
          risk: IngredientRisk.safe,
        ),
        IngredientModel(
          name: '柠檬酸',
          description: '食品级酸度调节剂，一般认为安全。',
          risk: IngredientRisk.neutral,
        ),
        IngredientModel(
          name: '三氯蔗糖',
          description: '人工甜味剂，甜度为蔗糖的 600 倍，健康影响仍有争议。',
          risk: IngredientRisk.caution,
          riskReason: '长期大量摄入的安全性仍需研究',
        ),
        IngredientModel(
          name: '安赛蜜',
          description: '人工合成甜味剂，常与其他甜味剂复配使用。',
          risk: IngredientRisk.caution,
          riskReason: '部分研究对长期大量摄入持谨慎态度',
        ),
        IngredientModel(
          name: '乳酸菌',
          description: '有益益生菌，有助于肠道健康。',
          risk: IngredientRisk.safe,
        ),
      ],
      goalFits: const [
        GoalFitResult(
          goal: HealthGoalType.lowSugar,
          level: GoalFitLevel.general,
          reason: '含代糖与糖精，钠含量偏高，少量饮用',
        ),
        GoalFitResult(
          goal: HealthGoalType.lowSodium,
          level: GoalFitLevel.caution,
          reason: '含代糖，注意每日摄入量',
        ),
        GoalFitResult(
          goal: HealthGoalType.muscleGain,
          level: GoalFitLevel.suitable,
          reason: '蛋白质含量较高，可作为加餐',
        ),
      ],
    ),
    FoodAnalysisModel(
      id: '2',
      productName: '无糖酸奶',
      brand: '优耕',
      spec: '200g',
      score: 86,
      scoreLevel: ScoreLevel.recommended,
      tags: const ['高蛋白', '无添加糖', '钙质丰富'],
      additiveCount: 1,
      analyzedAt: DateTime.now().subtract(const Duration(hours: 6)),
      ingredients: const [
        IngredientModel(
          name: '生牛乳',
          description: '天然牛奶，含丰富蛋白质和钙质。',
          risk: IngredientRisk.safe,
        ),
        IngredientModel(
          name: '乳酸菌',
          description: '有益益生菌，有助于肠道健康。',
          risk: IngredientRisk.safe,
        ),
      ],
      goalFits: const [
        GoalFitResult(
          goal: HealthGoalType.lowSugar,
          level: GoalFitLevel.suitable,
          reason: '无添加糖，适合控糖人群',
        ),
      ],
    ),
    FoodAnalysisModel(
      id: '3',
      productName: '能量棒',
      brand: '劲量',
      spec: '50g',
      score: 64,
      scoreLevel: ScoreLevel.caution,
      tags: const ['高糖', '添加剂较多', '高热量'],
      additiveCount: 8,
      analyzedAt: DateTime.now().subtract(const Duration(days: 1, hours: 5)),
      ingredients: const [
        IngredientModel(
          name: '葡萄糖',
          description: '快速供能糖，运动后补充合适，日常需限量。',
          risk: IngredientRisk.caution,
        ),
        IngredientModel(
          name: '果糖',
          description: '天然甜味来源，摄入过多会增加肝脏负担。',
          risk: IngredientRisk.caution,
        ),
      ],
      goalFits: const [],
    ),
    FoodAnalysisModel(
      id: '4',
      productName: '燕麦饮料',
      brand: '',
      spec: '330mL',
      score: 58,
      scoreLevel: ScoreLevel.caution,
      tags: const ['含添加糖', '膳食纤维', '添加剂 3 项'],
      additiveCount: 3,
      analyzedAt: DateTime.now().subtract(const Duration(days: 2)),
      ingredients: const [
        IngredientModel(
          name: '燕麦',
          description: '全谷物食材，富含膳食纤维，有助于控血糖。',
          risk: IngredientRisk.safe,
        ),
        IngredientModel(
          name: '白砂糖',
          description: '精制糖，提供甜味和能量。',
          risk: IngredientRisk.caution,
        ),
      ],
      goalFits: const [],
    ),
  ];

  static List<int> weeklyCount = [2, 3, 2, 1, 2, 2, 0]; // 周一到周日
}
