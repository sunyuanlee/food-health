import 'package:dio/dio.dart';
import '../network/api_client.dart';
import '../../models/user_model.dart';

class UsersException implements Exception {
  final String message;
  const UsersException(this.message);
  @override
  String toString() => message;
}

class UsersRepository {
  UsersRepository._();
  static final UsersRepository instance = UsersRepository._();

  final Dio _dio = ApiClient.instance.dio;

  Future<UserModel> getMe() async {
    try {
      final resp = await _dio.get('/users/me');
      return UserModel.fromJson(resp.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw UsersException(e.message ?? '获取用户信息失败');
    }
  }

  Future<UserModel> updateMe({
    String? nickname,
    String? avatarUrl,
    String? bio,
    String? city,
  }) async {
    try {
      final resp = await _dio.patch('/users/me', data: {
        if (nickname != null) 'nickname': nickname,
        if (avatarUrl != null) 'avatarUrl': avatarUrl,
        if (bio != null) 'bio': bio,
        if (city != null) 'city': city,
      });
      return UserModel.fromJson(resp.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw UsersException(e.message ?? '更新失败');
    }
  }

  Future<List<String>> getGoals() async {
    try {
      final resp = await _dio.get('/users/me/goals');
      final data = resp.data as Map<String, dynamic>;
      return (data['goals'] as List<dynamic>).cast<String>();
    } on DioException catch (e) {
      throw UsersException(e.message ?? '获取健康目标失败');
    }
  }

  Future<List<String>> updateGoals(List<String> goals) async {
    try {
      final resp = await _dio.put('/users/me/goals', data: {'goals': goals});
      final data = resp.data as Map<String, dynamic>;
      return (data['goals'] as List<dynamic>).cast<String>();
    } on DioException catch (e) {
      throw UsersException(e.message ?? '更新健康目标失败');
    }
  }
}
