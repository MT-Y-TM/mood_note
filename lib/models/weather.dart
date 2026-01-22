class Weather {
  final String text; // 天气描述（阴、晴等）
  final String temp; // 温度

  Weather({required this.text, required this.temp});

  // Service 已经传了 data['now'] 进来，这里直接取 key
  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      text: json['text'] ?? "未知",
      temp: json['temp'] ?? "N/A",
    );
  }
}