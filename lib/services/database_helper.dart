import 'package:mood_note/models/diary.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('diary.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 2, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
  CREATE TABLE diaries (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    content TEXT,
    mood TEXT,
    weather TEXT,
    date TEXT,
    created_at TEXT,
    updated_at TEXT,
    author_id TEXT
  )
''');
    await db.execute('''
    CREATE TABLE IF NOT EXISTS weather_cache (
      id INTEGER PRIMARY KEY,
      text TEXT,
      temp TEXT,
      last_update INTEGER
    )
  ''');
  }

  // 插入数据
  Future<int> insertDiary(Diary diary) async {
    final db = await instance.database;
    return await db.insert('diaries', diary.toMap());
  }

  // 1. 获取所有日记：按更新时间倒序排列
  Future<List<Diary>> getAllDiaries() async {
    final db = await instance.database;

    // 逻辑：OrderBy updated_at DESC
    final result = await db.query('diaries', orderBy: 'updated_at DESC');

    return result.map((json) => Diary.fromMap(json)).toList();
  }

  // 更新日记（新增功能）
  Future<int> updateDiary(Diary diary) async {
    final db = await instance.database;
    return await db.update(
      'diaries',
      diary.toMap(),
      where: 'id = ?',
      whereArgs: [diary.id],
    );
  }

  // 删除日记
  Future<int> deleteDiary(int id) async {
    final db = await instance.database;
    return await db.delete('diaries', where: 'id = ?', whereArgs: [id]);
  }

  // 关闭数据库（防止资源泄露）
  Future close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }

  // 根据关键词搜索日记内容
  Future<List<Diary>> searchDiaries(String keyword) async {
    final db = await instance.database;
    final result = await db.query(
      'diaries',
      where: 'content LIKE ?',
      whereArgs: ['%$keyword%'],
      orderBy: 'updated_at DESC',
    );
    return result.map((json) => Diary.fromMap(json)).toList();
  }

  // 缓存天气数据
  Future<void> saveWeatherCache(String text, String temp) async {
    final db = await instance.database;
    int now = DateTime.now().millisecondsSinceEpoch;
    await db.insert(
      'weather_cache',
      {'id': 1, 'text': text, 'temp': temp, 'last_update': now},
      conflictAlgorithm: ConflictAlgorithm.replace, // 如果 ID 1 已存在则替换
    );
  }

  Future<Map<String, dynamic>?> getWeatherCache() async {
    final db = await instance.database;
    final maps = await db.query(
      'weather_cache',
      where: 'id = ?',
      whereArgs: [1],
    );
    if (maps.isNotEmpty) return maps.first;
    return null;
  }
}
