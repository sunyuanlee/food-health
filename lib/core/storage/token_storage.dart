import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// 安全存储 JWT Token
class TokenStorage {
  static const _storage = FlutterSecureStorage();
  static const _keyAccess = 'access_token';
  static const _keyRefresh = 'refresh_token';

  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      _storage.write(key: _keyAccess, value: accessToken),
      _storage.write(key: _keyRefresh, value: refreshToken),
    ]);
  }

  static Future<String?> getAccessToken() =>
      _storage.read(key: _keyAccess);

  static Future<String?> getRefreshToken() =>
      _storage.read(key: _keyRefresh);

  static Future<bool> hasToken() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  static Future<void> clear() async {
    await Future.wait([
      _storage.delete(key: _keyAccess),
      _storage.delete(key: _keyRefresh),
    ]);
  }
}
