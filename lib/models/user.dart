// lib/models/user.dart
import 'dart:convert';
import 'package:uuid/uuid.dart';

class User {
  final String uid;          // 唯一标识符
  final String name;         // 用户名
  final Map<String, dynamic> metadata; // 预留字段：机器型号、OS版本等

  User({
    required this.uid,
    required this.name,
    this.metadata = const {},
  });

  // 转化为数据库存储的 Map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'metadata': jsonEncode(metadata), // Map 转为 JSON 字符串存储
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'],
      name: map['name'],
      metadata: jsonDecode(map['metadata'] ?? '{}'),
    );
  }

  // 创建一个新用户（生成 UUID 和设备信息）
  static User createNew(String name, String deviceModel) {
    return User(
      uid: const Uuid().v4(), // 生成唯一标识
      name: name,
      metadata: {'device': deviceModel, 'platform': 'android'}, 
    );
  }
}