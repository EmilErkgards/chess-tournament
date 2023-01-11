import 'package:chess_tournament/src/backend/backend_file.dart';
import 'package:chess_tournament/src/frontend/base_screen.dart';
import 'package:chess_tournament/src/frontend/common/base_button.dart';
import 'package:chess_tournament/src/frontend/common/base_input_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationScreen extends BasePageScreen {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends BasePageScreenState<RegistrationScreen>
    with BaseScreen {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;

  final emailController = TextEditingController();
  final chessUsernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  String appBarTitle() {
    return "Register";
  }

  @override
  Widget body() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.black,
            ),
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
                    validatorCallback: (String) {
                      //TODO check if already registered
                    },
                  ),
                  BaseInputField(
                    numbersOnly: false,
                    placeholderText: 'Chess.com Username',
                    textFieldController: chessUsernameController,
                    validatorCallback: (String) {
                      //TODO Check if exists
                    },
                  ),
                  BaseInputField(
                    numbersOnly: false,
                    placeholderText: 'Password',
                    textFieldController: passwordController,
                    validatorCallback: (String) {},
                    valueVisible: false,
                  ),
                  BaseInputField(
                    numbersOnly: false,
                    placeholderText: 'Confirm Password',
                    textFieldController: confirmPasswordController,
                    validatorCallback: (string) {
                      if (string == passwordController) {
                        return null;
                      }
                      return "Password doesn't match";
                    },
                    valueVisible: false,
                  ),
                  BaseButton(text: 'Register', callback: registerUser),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'Already a member? ',
                    style: TextStyle(color: Colors.black),
                  ),
                  TextSpan(
                    text: 'Login here!',
                    style: TextStyle(color: Colors.pink),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pushNamed(context, 'login_screen');
                      },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void registerUser() async {
    setState(() {
      showSpinner = true;
    });
    try {
      ChessUser user = await createChessUser(chessUsernameController.text);

      final newUser = await _auth.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);

      user.uuid = newUser.user!.uid;
      user.docId = (await addUserToDB(user)).id;

      Navigator.pushNamed(context, '/');
    } catch (e) {
      print(e);
    }
    setState(() {
      showSpinner = false;
    });
  }
}
