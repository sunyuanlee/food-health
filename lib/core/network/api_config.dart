/// API 基础配置
abstract class ApiConfig {
  /// 服务端地址，通过 --dart-define=BASE_URL=xxx 注入，默认为本地开发地址
  /// 生产部署时请通过 CI/CD 注入实际地址，不要在此文件中硬编码
  static const String baseUrl =
      String.fromEnvironment('BASE_URL', defaultValue: 'http://localhost:3000/api/v1');

  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
