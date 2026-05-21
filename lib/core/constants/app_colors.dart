import 'package:flutter/material.dart';

abstract class AppColors {
  // 主色调 —— 健康绿
  static const Color primary = Color(0xFF27AE60);
  static const Color primaryLight = Color(0xFF2ECC71);
  static const Color primaryDark = Color(0xFF1E8449);
  static const Color primaryBg = Color(0xFFE8F8F0);

  // 辅助色
  static const Color accent = Color(0xFF1890FF);

  // 背景色
  static const Color scaffoldBg = Color(0xFFF7F8FA);
  static const Color cardBg = Colors.white;

  // 文字
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textHint = Color(0xFFAAAAAA);
  static const Color textOnPrimary = Colors.white;

  // 分割线
  static const Color divider = Color(0xFFF0F0F0);

  // 成分风险色
  static const Color safe = Color(0xFF27AE60);       // 推荐
  static const Color caution = Color(0xFFE67E22);    // 谨慎
  static const Color warning = Color(0xFFE74C3C);    // 注意/警告
  static const Color neutral = Color(0xFF95A5A6);    // 中性

  // 评分色
  static const Color scoreHigh = Color(0xFF27AE60);   // 80-100 推荐
  static const Color scoreMid = Color(0xFFE67E22);    // 50-79 谨慎
  static const Color scoreLow = Color(0xFFE74C3C);    // 0-49 不建议

  // 标签背景色
  static const Color tagBgCaution = Color(0xFFFEF9E7);
  static const Color tagBgWarning = Color(0xFFFDEDEC);
  static const Color tagBgSafe = Color(0xFFE8F8F0);
  static const Color tagBgNeutral = Color(0xFFF2F3F4);

  // 状态色
  static const Color error = Color(0xFFE74C3C);

  // 兼容旧代码（保留防止编译错误）
  static const Color darkBg = Color(0xFF1A1A2E);
  static const Color darkCard = Color(0xFF16213E);
  static const Color online = Color(0xFF27AE60);
  static const Color offline = Color(0xFF95A5A6);
}
