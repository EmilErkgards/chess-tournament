import 'package:chess_tournament/src/frontend/pages/home.dart';
import 'package:chess_tournament/src/frontend/themes/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDC8NVap4whx5xbK6KmFtNaTmtJJqDYQmk",
      appId: "1:363984420063:web:46ed564ae8f860459cfd6a",
      messagingSenderId: "363984420063",
      projectId: "chesstournamentplanner",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chess Tournament Planner',
      theme: darkTheme,
      home: HomeScreen(),
    );
  }
}
