import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'package:mood_note/routes/main_routes.dart';
import 'package:mood_note/providers/diary_provider.dart'; 

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DiaryProvider()),
      ],
      child: getRootWidget(),
    ),
  );
}