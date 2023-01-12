import 'package:chess_tournament/src/frontend/base_screen.dart';
import 'package:chess_tournament/src/frontend/common/base_button.dart';
import 'package:chess_tournament/src/frontend/common/base_input_field.dart';
import 'package:chess_tournament/src/frontend/pages/home.dart';
import 'package:chess_tournament/src/frontend/pages/registration.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends BasePageScreen {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends BasePageScreenState<LoginScreen>
    with BaseScreen {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  String appBarTitle() {
    return "Login";
  }

  @override
  Widget body() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  BaseInputField(
                    numbersOnly: false,
                    placeholderText: 'Email',
                    textFieldController: emailController,
                    validatorCallback: (String) {},
                  ),
                  BaseInputField(
                    numbersOnly: false,
                    placeholderText: 'Password',
                    textFieldController: passwordController,
                    validatorCallback: (String) {},
                    valueVisible: false,
                    callbackOnSubmitted: tryLoginCallback,
                  ),
                  BaseButton(text: 'Login', callback: tryLogin)
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Not a member?"),
                  ),
                  ElevatedButton(
                    onPressed: (() => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegistrationScreen()))),
                    child: Text("Register here!"),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void tryLogin() {
    tryLoginCallback(null);
  }

  void tryLoginCallback(String? string) async {
    setState(() {
      showSpinner = true;
    });
    try {
      final user = await _auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      if (user != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      showSpinner = false;
    });
  }
}
