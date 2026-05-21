import 'package:dio/dio.dart';
import '../network/api_client.dart';
import '../network/api_config.dart';
import '../storage/token_storage.dart';
import '../../models/user_model.dart';

class AuthException implements Exception {
  final String message;
  const AuthException(this.message);
  @override
  String toString() => message;
}

class AuthRepository {
  AuthRepository._();
  static final AuthRepository instance = AuthRepository._();

  final Dio _dio = ApiClient.instance.dio;

  Future<UserModel> register({
    required String phone,
    required String password,
    required String nickname,
    String? city,
  }) async {
    try {
      final resp = await _dio.post('/auth/register', data: {
        'phone': phone,
        'password': password,
        'nickname': nickname,
        if (city != null) 'city': city,
      });
      final data = resp.data as Map<String, dynamic>;
      await TokenStorage.saveTokens(
        accessToken: data['accessToken'] as String,
        refreshToken: data['refreshToken'] as String,
      );
      return _fetchMe();
    } on DioException catch (e) {
      throw AuthException(e.message ?? '注册失败，请重试');
    }
  }

  Future<UserModel> login({
    required String phone,
    required String password,
  }) async {
    try {
      final resp = await _dio.post('/auth/login', data: {
        'phone': phone,
        'password': password,
      });
      final data = resp.data as Map<String, dynamic>;
      await TokenStorage.saveTokens(
        accessToken: data['accessToken'] as String,
        refreshToken: data['refreshToken'] as String,
      );
      return _fetchMe();
    } on DioException catch (e) {
      throw AuthException(e.message ?? '登录失败，请检查手机号或密码');
    }
  }

  /// 号码认证一键登录：将 SDK token 发送后端换取手机号并颁发 JWT
  Future<UserModel> phoneLogin({required String token}) async {
    try {
      final resp = await _dio.post('/auth/phone-login', data: {'token': token});
      final data = resp.data as Map<String, dynamic>;
      await TokenStorage.saveTokens(
        accessToken: data['accessToken'] as String,
        refreshToken: data['refreshToken'] as String,
      );
      return _fetchMe();
    } on DioException catch (e) {
      throw AuthException(e.message ?? '一键登录失败，请重试');
    }
  }

  /// 发送短信验证码
  Future<void> sendSmsCode({required String phone}) async {
    try {
      await _dio.post('/auth/sms/send', data: {'phone': phone});
    } on DioException catch (e) {
      final serverMsg = e.response?.data?['message'];
      final msg = serverMsg is String
          ? serverMsg
          : (serverMsg is List ? serverMsg.first as String : null);
      throw AuthException(msg ?? e.message ?? '发送失败，请重试');
    }
  }

  /// 短信验证码登录（无账号则自动注册）
  Future<UserModel> smsLogin({
    required String phone,
    required String code,
  }) async {
    try {
      final resp =
          await _dio.post('/auth/sms-login', data: {'phone': phone, 'code': code});
      final data = resp.data as Map<String, dynamic>;
      await TokenStorage.saveTokens(
        accessToken: data['accessToken'] as String,
        refreshToken: data['refreshToken'] as String,
      );
      return _fetchMe();
    } on DioException catch (e) {
      final serverMsg = e.response?.data?['message'];
      final msg = serverMsg is String
          ? serverMsg
          : (serverMsg is List ? serverMsg.first as String : null);
      throw AuthException(msg ?? e.message ?? '登录失败，请重试');
    }
  }

  Future<void> logout() async {
    try {
      final refreshToken = await TokenStorage.getRefreshToken();
      if (refreshToken != null) {
        await Dio(BaseOptions(baseUrl: ApiConfig.baseUrl))
            .post('/auth/logout', data: {'refreshToken': refreshToken});
      }
    } finally {
      await TokenStorage.clear();
    }
  }

  Future<UserModel?> tryRestoreSession() async {
    final hasToken = await TokenStorage.hasToken();
    if (!hasToken) return null;
    try {
      return await _fetchMe();
    } catch (_) {
      await TokenStorage.clear();
      return null;
    }
  }

  Future<UserModel> _fetchMe() async {
    final resp = await _dio.get('/auth/me');
    return UserModel.fromJson(resp.data as Map<String, dynamic>);
  }
}
