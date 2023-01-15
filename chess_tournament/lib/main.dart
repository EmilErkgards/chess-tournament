import 'package:chess_tournament/src/backend/backend_file.dart';
import 'package:chess_tournament/src/backend/dark_theme.dart';
import 'package:chess_tournament/src/frontend/pages/home.dart';
import 'package:chess_tournament/src/frontend/pages/login.dart';
import 'package:chess_tournament/src/frontend/pages/registration.dart';
import 'package:chess_tournament/src/frontend/pages/welcome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  ChessUserService.init(FirebaseFirestore.instance);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  void initState() {
    getCurrentAppTheme();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        return themeChangeProvider;
      },
      child: Consumer<DarkThemeProvider>(
        builder: (BuildContext context, value, Widget? child) {
          return MaterialApp(
            title: 'Chess Tournament Planner',
            initialRoute: '/',
            theme: Styles.themeData(themeChangeProvider.darkTheme, context),
            routes: {
              'welcome_screen': (context) => WelcomeScreen(),
              'registration_screen': (context) => RegistrationScreen(),
              'login_screen': (context) => LoginScreen(),
              '/': (context) => HomeScreen()
            },
          );
        },
      ),
    );
  }
}
