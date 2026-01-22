import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mood_note/utils/toast_util.dart';
import 'package:path/path.dart';

class QuotesService {
  final Dio _dio = Dio();

  Future<String> getRandomQuote() async {
    try {
      // 一个开源的随机语录 API
      final response = await _dio.get("https://v1.hitokoto.cn/?c=i");
      if (response.statusCode == 200) {
        return response.data['hitokoto']; // 返回一句励志的话
      }
    } catch (e) {
      print("语录获取失败: $e");
      ToastUtil.show(
        context as BuildContext,
        "语录获取失败: $e",
        icon: Icons.error_outline,
      );
    }
    return "今天也要加油鸭！";
  }
}
