import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../storage/token_storage.dart';
import 'api_config.dart';

class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  late final Dio _dio;

  Dio get dio => _dio;

  void init() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: ApiConfig.connectTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      contentType: 'application/json',  // 仅作默认值，FormData 会自动覆盖为 multipart
      headers: {
        // ngrok 免费版会对非浏览器请求插入警告页，加此头绕过
        'ngrok-skip-browser-warning': 'true',
      },
    ));

    _dio.interceptors.addAll([
      _AuthInterceptor(),
      _ErrorInterceptor(),
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (o) => debugPrint('[HTTP] $o'),
      ),
    ]);
  }
}

/// 自动在请求头附加 JWT Token
class _AuthInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await TokenStorage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Access token 过期（401）时，自动尝试刷新
    if (err.response?.statusCode == 401) {
      final refreshToken = await TokenStorage.getRefreshToken();
      if (refreshToken != null) {
        try {
          final dio = Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));
          final resp = await dio.post('/auth/refresh', data: {
            'refreshToken': refreshToken,
          });
          final newAccessToken =
              (resp.data as Map)['data']['accessToken'] as String;
          final newRefreshToken =
              (resp.data as Map)['data']['refreshToken'] as String;

          await TokenStorage.saveTokens(
            accessToken: newAccessToken,
            refreshToken: newRefreshToken,
          );

          // 重试原请求
          err.requestOptions.headers['Authorization'] =
              'Bearer $newAccessToken';
          final retryResp = await ApiClient.instance.dio.fetch(
            err.requestOptions,
          );
          return handler.resolve(retryResp);
        } catch (_) {
          // 刷新失败，清除 Token（用户需要重新登录）
          await TokenStorage.clear();
        }
      }
    }
    handler.next(err);
  }
}

/// 统一解析后端 {code, data, message} 响应格式
class _ErrorInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final data = response.data;
    if (data is Map && data['code'] != 0) {
      handler.reject(
        DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: data['message']?.toString() ?? '请求失败',
        ),
      );
      return;
    }
    // 解包 data 字段，让业务层直接拿到 payload
    if (data is Map && data.containsKey('data')) {
      response.data = data['data'];
    }
    handler.next(response);
  }
}
