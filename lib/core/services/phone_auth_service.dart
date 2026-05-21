import 'package:flutter/services.dart';

/// 阿里云号码认证 SDK 的 Flutter Platform Channel 封装。
/// 原生侧（iOS/Android）实现在 AppDelegate.swift / MainActivity.kt 中。
class PhoneAuthService {
  static const _channel = MethodChannel('com.dazi.phone_auth');

  /// 预取号：在进入登录页前调用，加速后续授权页弹出速度
  Future<void> prefetch() async {
    await _channel.invokeMethod<void>('prefetch');
  }

  /// 拉起运营商授权页，用户确认后返回 SDK token（accessCode）
  /// [sceneCode] 对应阿里云控制台中的方案 code
  Future<String> getLoginToken({required String sceneCode}) async {
    final token = await _channel.invokeMethod<String>(
      'getLoginToken',
      {'sceneCode': sceneCode},
    );
    return token!;
  }
}
