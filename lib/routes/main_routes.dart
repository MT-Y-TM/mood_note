import 'package:flutter/material.dart';
import 'package:mood_note/pages/add/add_page.dart';
import 'package:mood_note/pages/main/mian_page.dart';

Widget getRootWidget() {
  return MaterialApp(
    title: 'Mood Note',
    debugShowCheckedModeBanner: false,
    routes: getRoutes(),
    theme: ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorSchemeSeed: Colors.blue,
      scaffoldBackgroundColor: const Color(0xFFF5F5F5),
    ),

    darkTheme: ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorSchemeSeed: Colors.blue,
      scaffoldBackgroundColor: const Color(0xFF121212),
      cardTheme: const CardThemeData(color: Color(0xFF1E1E1E)),
    ),
    themeMode: ThemeMode.system,
  );
}

Map<String, Widget Function(BuildContext)> getRoutes() {
  return {
    "/": (context) => const MainPage(),
    // 只有在点击“新增”按钮时才走这个路由
    "/add": (context) => const AddDiaryPage(),
  };
}
