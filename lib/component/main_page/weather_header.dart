import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/diary_provider.dart';

class WeatherHeader extends StatelessWidget {
  const WeatherHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //  提取当前是否为深色模式
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final provider = Provider.of<DiaryProvider>(context);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        //  动态渐变色适配
        gradient: LinearGradient(
          colors: isDarkMode
              ? [
                  Colors.blueGrey.shade800,
                  Colors.blueGrey.shade900,
                ] // 深色模式：更低沉的深蓝灰
              : [Colors.blue.shade400, Colors.blue.shade700], // 亮色模式：明亮的蓝色
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.5)
                : Colors.blue.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    provider.isLoading ? "正在定位..." : "当前位置天气信息",
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  if (provider.currentWeather == null && !provider.isLoading)
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Icon(
                        Icons.cloud_off,
                        color: Colors.white70,
                        size: 14,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                provider.currentWeather != null
                    ? "${provider.currentWeather!.temp}°C  ${provider.currentWeather!.text}"
                    : "离线模式，请连接网络", //  没网且没缓存时的友好显示
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          // 图标也可以根据天气状态动态显示，现在先保持白色
          const Icon(Icons.cloud_queue, color: Colors.white, size: 48),
        ],
      ),
    );
  }
}
