class Diary {
  final int? id;
  final String content;
  final String mood;
  final String weather;
  final String date;        // 初始日期（显示的日期）
  final String createdAt;   // 创建时间戳
  final String updatedAt;   // 修改时间戳
  final String authorId;    

  Diary({
    this.id,
    required this.content,
    required this.mood,
    required this.weather,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
    required this.authorId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'mood': mood,
      'weather': weather,
      'date': date,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'author_id': authorId,
    };
  }

  factory Diary.fromMap(Map<String, dynamic> map) {
    return Diary(
      id: map['id'],
      content: map['content'],
      mood: map['mood'],
      weather: map['weather'],
      date: map['date'],
      createdAt: map['created_at'] ?? '',
      updatedAt: map['updated_at'] ?? '',
      authorId: map['author_id'] ?? 'anonymous', // 提供默认值
    );
  }
}