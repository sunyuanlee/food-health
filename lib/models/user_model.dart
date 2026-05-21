import 'package:flutter/foundation.dart';

@immutable
class UserModel {
  final int id;
  final String phone;
  final String nickname;
  final String? avatarUrl;
  final String? bio;
  final String? city;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.phone,
    required this.nickname,
    this.avatarUrl,
    this.bio,
    this.city,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      phone: json['phone'] as String,
      nickname: json['nickname'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      bio: json['bio'] as String?,
      city: json['city'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'phone': phone,
        'nickname': nickname,
        'avatarUrl': avatarUrl,
        'bio': bio,
        'city': city,
        'createdAt': createdAt.toIso8601String(),
      };
}
