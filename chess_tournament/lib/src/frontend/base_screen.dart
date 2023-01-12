import 'package:chess_tournament/src/backend/dark_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

abstract class BasePageScreen extends StatefulWidget {
  const BasePageScreen({Key? key}) : super(key: key);
}

abstract class BasePageScreenState<Page extends BasePageScreen>
    extends State<Page> {
  BasePageScreenState({Key? key});

  String appBarTitle();
}

mixin BaseScreen<Page extends BasePageScreen> on BasePageScreenState<Page> {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: Text(
      //     appBarTitle(),
      //     style: const TextStyle(
      //       fontSize: 20,
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),
      // ),
      body: Container(
        child: body(context),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (() {
          themeChange.darkTheme = !themeChange.darkTheme;
        }),
      ),
      // bottomNavigationBar: BottomNavigationBar(items: const [
      //   BottomNavigationBarItem(
      //     label: "Sök",
      //     icon: Icon(
      //       Icons.search,
      //     ),
      //   ),
      //   BottomNavigationBarItem(
      //     label: "Hem",
      //     icon: Icon(
      //       Icons.home,
      //     ),
      //   ),
      //   BottomNavigationBarItem(
      //     label: "Konto",
      //     icon: Icon(
      //       Icons.account_circle,
      //     ),
      //   )
      // ]),
    );
  }

  Widget body(BuildContext context);
}
