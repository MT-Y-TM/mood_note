// lib/services/data_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:mood_note/models/diary.dart';
import 'package:mood_note/services/database_helper.dart';

class DataService {
  //将数据库内容转换为 JSON 字节流，为保存做准备
  static Future<List<int>> generateBackupData() async {
    try {
      // 获取所有日记数据
      List<Diary> diaries = await DatabaseHelper.instance.getAllDiaries();
      
      // 转换为 Map 列表并序列化
      List<Map<String, dynamic>> jsonData = diaries.map((d) => d.toMap()).toList();
      String jsonString = jsonEncode(jsonData);
      
      // 返回 UTF8 编码后的字节流
      return utf8.encode(jsonString);
    } catch (e) {
      throw Exception("生成备份数据失败: $e");
    }
  }

  // 从选中的文件导入
  static Future<int> importFromJSON(File file) async {
    final content = await file.readAsString();
    final List<dynamic> jsonData = jsonDecode(content);

    int count = 0;
    for (var item in jsonData) {
      Diary backupDiary = Diary.fromMap(item as Map<String, dynamic>);

      // 重新构造，ID 设为 null 以便插入新记录
      final newDiary = Diary(
        id: null, 
        content: backupDiary.content,
        mood: backupDiary.mood,
        weather: backupDiary.weather,
        date: backupDiary.date,
        createdAt: backupDiary.createdAt,
        updatedAt: backupDiary.updatedAt,
        authorId: backupDiary.authorId,
      );

      await DatabaseHelper.instance.insertDiary(newDiary);
      count++;
    }
    return count;
  }
}