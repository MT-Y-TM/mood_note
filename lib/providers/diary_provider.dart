import 'package:flutter/material.dart';
import 'package:mood_note/models/diary.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';
import 'package:intl/intl.dart';
import 'package:mood_note/services/database_helper.dart';

class DiaryProvider with ChangeNotifier {
  List<Diary> _diaries = [];
  bool _isLoading = false;
  Weather? _currentWeather;
  String _searchQuery = "";

  // Getter
  List<Diary> get diaries => _diaries;
  bool get isLoading => _isLoading;
  bool get isSearching => _searchQuery.isNotEmpty;
  Weather? get currentWeather => _currentWeather;

  final WeatherService _weatherService = WeatherService();

  // --- 初始化与加载 ---

  /// 初始化：从数据库读取已有的日记
  Future<void> loadDiaries() async {
    _searchQuery = "";
    final data = await DatabaseHelper.instance.getAllDiaries();
    _diaries = data;
    notifyListeners();
  }

  /// 自动获取当前位置并更新天气 (支持缓存与异常处理)
  Future<void> updateWeatherByLocation() async {
    _isLoading = true;
    notifyListeners();

    try {
      String? coordinates = await _weatherService.getCoordinatesByIP();
      // 如果定位失败，fetchWeatherWithCache 内部会处理，或者这里给个默认坐标
      coordinates ??= "114.05,22.54";

      _currentWeather = await _weatherService.fetchWeatherWithCache(
        coordinates,
      );
    } catch (e) {
      print("定位或获取天气异常: $e");
    }

    if (_currentWeather == null) {
      print("无法获取天气，已切换至默认状态");
      _currentWeather = Weather(text: "未知天气", temp: "0");
    }

    _isLoading = false;
    notifyListeners();
  }

  // --- 核心 CRUD 业务 ---

  /// 添加新日记
  Future<void> addDiary(
    String content,
    String mood, {
    required String authorId,
  }) async {
    final newDiary = Diary(
      content: content,
      mood: mood,
      authorId: authorId,
      weather: _currentWeather?.text ?? "未知天气",
      date: DateTime.now().toString(),
      createdAt: DateTime.now().toString(),
      updatedAt: DateTime.now().toString(),
    );

    await DatabaseHelper.instance.insertDiary(newDiary);
    await loadDiaries(); // 刷新列表
  }

  /// 更新（编辑）日记
  Future<void> updateDiary(
    int id,
    String content,
    String mood, {
    required String authorId,
  }) async {
    // 找到旧记录以保留创建时间和天气
    final oldDiary = _diaries.firstWhere((d) => d.id == id);

    final now = DateTime.now();
    // 格式化为标准 ISO 格式，方便数据库字符串排序对比
    final timeStamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    final updatedDiary = Diary(
      id: id,
      content: content,
      mood: mood,
      weather: oldDiary.weather,
      date: oldDiary.date,
      createdAt: oldDiary.createdAt,
      updatedAt: timeStamp,
      authorId: oldDiary.authorId,
    );

    await DatabaseHelper.instance.updateDiary(updatedDiary);
    await loadDiaries();
  }

  /// 删除日记
  Future<void> deleteDiary(int id) async {
    await DatabaseHelper.instance.deleteDiary(id);
    await loadDiaries();
  }

  // --- 搜索逻辑 ---

  /// 搜索日记
  Future<void> search(String keyword) async {
    _searchQuery = keyword; // 💡 记录关键词
    if (keyword.isEmpty) {
      await loadDiaries();
      return;
    }
    _diaries = await DatabaseHelper.instance.searchDiaries(keyword);
    notifyListeners();
  }
}
