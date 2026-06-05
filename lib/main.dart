import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/data/auth_repository.dart';
import 'core/network/api_client.dart';
import 'core/providers/auth_provider.dart';
import 'core/storage/token_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化网络客户端
  ApiClient.instance.init();

  // 创建 ProviderContainer，异步恢复 session（不阻塞 runApp 避免白屏）
  final container = ProviderContainer();

  // ── Dev only: 自动写入测试账号 token，跳过登录界面 ──
  if (kDebugMode) {
    final existing = await TokenStorage.getAccessToken();
    if (existing == null) {
      await _devAutoLogin();
    }
  }

  // 不 await：让 runApp 立刻执行，由 SplashPage 监听 authProvider 状态变化后跳转
  container.read(authProvider.notifier).restoreSession();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const FoodHealthApp(),
    ),
  );
}

/// 开发环境自动登录：调用 AuthRepository 获取真实 JWT 并存入 TokenStorage
/// restoreSession() 后续会读取 token 并设置 AuthAuthenticated 状态
Future<void> _devAutoLogin() async {
  try {
    await AuthRepository.instance.login(
      phone: '13800000001',
      password: 'dev123456',
    );
    debugPrint('[DEV] 自动登录成功，token 已保存');
  } catch (e) {
    debugPrint('[DEV] 自动登录失败: $e（将以未登录状态启动）');
  }
}
