import 'package:dio/dio.dart';
import 'package:mood_note/const/api_key.dart';
import 'package:mood_note/services/database_helper.dart';
import '../models/weather.dart';

class WeatherService {
  final Dio _dio = Dio();
  final String _myHost = HostAPI;
  final String _apiKey = APIKey;

Future<Weather?> fetchWeatherWithCache(String coordinates) async {
  // 先拿缓存备用
  final cache = await DatabaseHelper.instance.getWeatherCache();
  int now = DateTime.now().millisecondsSinceEpoch;

  // 检查缓存是否在 1 小时内且有效
  if (cache != null && (now - (cache['last_update'] as int)) < 3600000) {
    print("🏠 网络状况未知或缓存未过期，读取本地缓存");
    return Weather(text: cache['text'], temp: cache['temp']);
  }

  // 尝试联网
  try {
    final response = await _dio.get(
      "https://$_myHost/v7/weather/now",
      queryParameters: {'location': coordinates, 'key': _apiKey, 'lang': 'zh'},
      options: Options(receiveTimeout: const Duration(seconds: 5)), // 设置超时
    );

    if (response.statusCode == 200 && response.data['code'] == '200') {
      final weather = Weather.fromJson(response.data['now']);
      await DatabaseHelper.instance.saveWeatherCache(weather.text, weather.temp);
      return weather;
    }
  } on DioException catch (e) {
    //捕获网络异常（断网、超时等）
    print("🌐 网络异常: ${e.type}。尝试回退至旧缓存数据。");
    if (cache != null) {
      // 即使缓存过期了，断网时也要显示它，总比显示 "--" 好
      return Weather(text: cache['text'], temp: cache['temp']);
    }
  }
  return null; 
}

  // IP 定位逻辑保持不变
  Future<String?> getCoordinatesByIP() async {
    try {
      final response = await _dio.get("http://ip-api.com/json/");
      if (response.statusCode == 200) {
        return "${response.data['lon']},${response.data['lat']}";
      }
    } catch (e) {
      print("IP 定位失败: $e");
    }
    return null;
  }
}
