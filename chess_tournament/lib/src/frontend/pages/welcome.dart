import 'package:chess_tournament/src/frontend/common/base_button.dart';
import 'package:flutter/material.dart';

import '../base_screen.dart';

class WelcomeScreen extends BasePageScreen {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends BasePageScreenState<WelcomeScreen>
    with BaseScreen {
  @override
  String appBarTitle() {
    return "Welcome";
  }

  @override
  Widget body() {
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            BaseButton(
              text: 'Log In',
              callback: () {
                Navigator.pushNamed(context, 'login_screen');
              },
            ),
            BaseButton(
                text: 'Register',
                callback: () {
                  Navigator.pushNamed(context, 'registration_screen');
                }),
          ]),
    );
  }
}
