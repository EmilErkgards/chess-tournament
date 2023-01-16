import 'package:chess_tournament/src/frontend/base_screen.dart';
import 'package:chess_tournament/src/frontend/common/base_button.dart';
import 'package:chess_tournament/src/frontend/common/base_input_field.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/scheduler.dart';
import 'package:sizer/sizer.dart';

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
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;
      Navigator.pushNamed(context, '/');
    });
  }

  @override
  String appBarTitle() {
    return "Login";
  }

  @override
  Widget body(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            child: Padding(
              padding: EdgeInsets.all(2.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(2.w),
                    child: SizedBox(
                      width: 70.w,
                      child: BaseInputField(
                        numbersOnly: false,
                        placeholderText: 'Email',
                        textFieldController: emailController,
                        validatorCallback: (String) {},
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(2.w),
                    child: SizedBox(
                      width: 70.w,
                      child: BaseInputField(
                        numbersOnly: false,
                        placeholderText: 'Password',
                        textFieldController: passwordController,
                        validatorCallback: (String) {},
                        valueVisible: false,
                        callbackOnSubmitted: tryLoginCallback,
                      ),
                    ),
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
                    onPressed: (() =>
                        Navigator.pushNamed(context, "registration_screen")),
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
        Navigator.pushNamed(context, "/");
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      showSpinner = false;
    });
  }
}
