import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/network/api_client.dart';
import 'core/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化网络客户端
  ApiClient.instance.init();

  // 创建 ProviderContainer，异步恢复 session（不阻塞 runApp 避免白屏）
  final container = ProviderContainer();
  // 不 await：让 runApp 立刻执行，由 SplashPage 监听 authProvider 状态变化后跳转
  container.read(authProvider.notifier).restoreSession();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const FoodHealthApp(),
    ),
  );
}

