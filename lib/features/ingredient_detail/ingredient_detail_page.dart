import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../models/food_analysis_model.dart';
import '../../models/ingredient_model.dart';

class IngredientDetailPage extends StatelessWidget {
  final FoodAnalysisModel analysis;
  const IngredientDetailPage({super.key, required this.analysis});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: const Text(
          '成分解读',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        children: [
          // 产品名栏
          Container(
            color: Colors.white,
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                      color: AppColors.primary, size: 22),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        analysis.productName,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary),
                      ),
                      Text(
                        '共 ${analysis.ingredients.length} 种成分｜添加剂 ${analysis.additiveCount} 项',
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // 图例
          Container(
            color: Colors.white,
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: const Row(
              children: [
                _Legend(color: AppColors.safe, label: '推荐'),
                SizedBox(width: 16),
                _Legend(color: AppColors.caution, label: '谨慎'),
                SizedBox(width: 16),
                _Legend(color: AppColors.warning, label: '注意'),
                SizedBox(width: 16),
                _Legend(color: AppColors.neutral, label: '中性'),
              ],
            ),
          ),
          const Divider(height: 1),

          // 成分列表
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
              itemCount: analysis.ingredients.length,
              itemBuilder: (context, index) {
                return _IngredientTile(
                    ingredient: analysis.ingredients[index]);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).padding.bottom + 12,
          top: 12,
        ),
        child: const Text(
          '以上内容仅供参考，不构成医疗建议。数据来源于公开食品成分数据库。',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 11, color: AppColors.textHint),
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label,
            style: const TextStyle(
                fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }
}

class _IngredientTile extends StatefulWidget {
  final IngredientModel ingredient;
  const _IngredientTile({required this.ingredient});

  @override
  State<_IngredientTile> createState() => _IngredientTileState();
}

class _IngredientTileState extends State<_IngredientTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final ing = widget.ingredient;
    final riskColor = _riskColor(ing.risk);
    final riskLabel = _riskLabel(ing.risk);
    final bgColor = _riskBg(ing.risk);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
              color: Color(0x08000000), blurRadius: 6, offset: Offset(0, 2))
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            // 左侧色条 + 内容
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(width: 4, color: riskColor),
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() => _expanded = !_expanded),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    ing.name,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: bgColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    riskLabel,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: riskColor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  _expanded
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  color: AppColors.textHint,
                                  size: 20,
                                ),
                              ],
                            ),
                            if (!_expanded) ...[
                              const SizedBox(height: 4),
                              Text(
                                ing.description,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // 展开内容
            if (_expanded) ...[
              const Divider(height: 1, indent: 16),
              Padding(
                padding:
                    const EdgeInsets.fromLTRB(16, 12, 16, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ing.description,
                      style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textPrimary,
                          height: 1.5),
                    ),
                    if (ing.riskReason != null) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: riskColor.withOpacity(0.07),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.warning_amber_outlined,
                                color: riskColor, size: 15),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                ing.riskReason!,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: riskColor,
                                    height: 1.4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _riskColor(IngredientRisk risk) {
    switch (risk) {
      case IngredientRisk.safe:    return AppColors.safe;
      case IngredientRisk.neutral: return AppColors.neutral;
      case IngredientRisk.caution: return AppColors.caution;
      case IngredientRisk.warning: return AppColors.warning;
    }
  }

  Color _riskBg(IngredientRisk risk) {
    switch (risk) {
      case IngredientRisk.safe:    return AppColors.tagBgSafe;
      case IngredientRisk.neutral: return AppColors.tagBgNeutral;
      case IngredientRisk.caution: return AppColors.tagBgCaution;
      case IngredientRisk.warning: return AppColors.tagBgWarning;
    }
  }

  String _riskLabel(IngredientRisk risk) {
    switch (risk) {
      case IngredientRisk.safe:    return '推荐';
      case IngredientRisk.neutral: return '中性';
      case IngredientRisk.caution: return '谨慎';
      case IngredientRisk.warning: return '注意';
    }
  }
}
