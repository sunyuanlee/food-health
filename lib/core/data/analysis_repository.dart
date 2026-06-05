import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../network/api_client.dart';
import '../../models/food_analysis_model.dart';

class AnalysisException implements Exception {
  final String message;
  const AnalysisException(this.message);
  @override
  String toString() => message;
}

class AnalysisHistoryResult {
  final int total;
  final int page;
  final int limit;
  final List<FoodAnalysisModel> items;

  const AnalysisHistoryResult({
    required this.total,
    required this.page,
    required this.limit,
    required this.items,
  });
}

class WeeklyStats {
  final List<WeeklyDay> days;
  final int total;

  const WeeklyStats({required this.days, required this.total});
}

class WeeklyDay {
  final String date;
  final int count;
  const WeeklyDay({required this.date, required this.count});
}

class AnalysisRepository {
  AnalysisRepository._();
  static final AnalysisRepository instance = AnalysisRepository._();

  final Dio _dio = ApiClient.instance.dio;

  /// 上传图片并触发 AI 分析
  Future<FoodAnalysisModel> scan({
    required String imagePath,
    required List<String> goals,
  }) async {
    // ── Step 1: 检查文件是否存在 ──
    final file = File(imagePath);
    final fileExists = file.existsSync();
    final fileSize = fileExists ? file.lengthSync() : -1;
    debugPrint('[SCAN] imagePath=$imagePath exists=$fileExists size=${fileSize}B');

    // ── Step 2: 前置 ping，验证 HTTPS 连通性（401/403 也算连通）──
    try {
      final pingResp = await _dio.get(
        '/analysis/history',
        queryParameters: {'page': 1, 'limit': 1},
      );
      debugPrint('[SCAN] ping OK → status=${pingResp.statusCode}');
    } on DioException catch (e) {
      // 4xx 表示服务器可达（只是鉴权问题），继续执行
      if (e.response?.statusCode != null) {
        debugPrint('[SCAN] ping reachable → status=${e.response!.statusCode}');
      } else {
        debugPrint('[SCAN] ping FAILED → type=${e.type} msg=${e.message}');
        debugPrint('[SCAN] ping inner=${e.error}');
        throw AnalysisException('连接服务器失败(ping): ${e.type} ${e.message}');
      }
    }

    // ── Step 3: 构建 FormData 并发起 multipart POST ──
    try {
      debugPrint('[SCAN] building FormData…');
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(imagePath, filename: 'food.jpg'),
        'goals': goals.isEmpty ? '[]' : '[${goals.map((g) => '"$g"').join(',')}]',
      });
      debugPrint('[SCAN] FormData ready, fields=${formData.fields}, files=${formData.files.length}');
      debugPrint('[SCAN] POSTing to /analysis/scan …');
      final resp = await _dio.post('/analysis/scan', data: formData);
      debugPrint('[SCAN] POST OK → status=${resp.statusCode}');
      return FoodAnalysisModel.fromJson(resp.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('[SCAN] POST FAILED → type=${e.type}');
      debugPrint('[SCAN] POST message=${e.message}');
      debugPrint('[SCAN] POST error=${e.error}');
      debugPrint('[SCAN] POST response=${e.response?.statusCode} ${e.response?.data}');
      final msg = e.response?.data?['message'];
      throw AnalysisException(msg is String ? msg : '分析失败(${e.type}): ${e.message}');
    }
  }

  /// 获取历史列表（分页）
  Future<AnalysisHistoryResult> getHistory({int page = 1, int limit = 20}) async {
    try {
      final resp = await _dio.get(
        '/analysis/history',
        queryParameters: {'page': page, 'limit': limit},
      );
      final data = resp.data as Map<String, dynamic>;
      return AnalysisHistoryResult(
        total: data['total'] as int,
        page: data['page'] as int,
        limit: data['limit'] as int,
        items: (data['items'] as List<dynamic>)
            .map((e) => FoodAnalysisModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } on DioException catch (e) {
      throw AnalysisException(e.message ?? '获取记录失败');
    }
  }

  /// 删除一条记录
  Future<void> delete(String id) async {
    try {
      await _dio.delete('/analysis/history/$id');
    } on DioException catch (e) {
      throw AnalysisException(e.message ?? '删除失败');
    }
  }

  /// 获取本周统计
  Future<WeeklyStats> getWeeklyStats() async {
    try {
      final resp = await _dio.get('/analysis/stats/weekly');
      final data = resp.data as Map<String, dynamic>;
      return WeeklyStats(
        total: data['total'] as int,
        days: (data['days'] as List<dynamic>)
            .map((e) => WeeklyDay(
                  date: e['date'] as String,
                  count: e['count'] as int,
                ))
            .toList(),
      );
    } on DioException catch (e) {
      throw AnalysisException(e.message ?? '获取统计失败');
    }
  }
}
