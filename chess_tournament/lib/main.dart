import 'package:chess_tournament/src/frontend/pages/home.dart';
import 'package:chess_tournament/src/frontend/themes/themes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: darkTheme,
      home: HomeScreen(),
    );
  }
}
