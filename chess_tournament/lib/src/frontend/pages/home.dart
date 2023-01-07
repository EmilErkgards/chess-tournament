import 'package:chess_tournament/src/frontend/base_screen.dart';
import 'package:chess_tournament/src/frontend/common/base_button.dart';
import 'package:chess_tournament/src/frontend/common/base_input_field.dart';
import 'package:chess_tournament/src/frontend/pages/tournament_lobby.dart';
import 'package:flutter/material.dart';

class HomeScreen extends BasePageScreen {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends BasePageScreenState<HomeScreen> with BaseScreen {
  bool isButtonTapped = false;

  final tournamentCodeController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  String appBarTitle() {
    return "Chess tournament planner";
  }

  @override
  Widget body() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
            key: formKey,
            child: Column(
              children: [
                BaseInputField(
                  numbersOnly: true,
                  placeholderText: "Enter tournament code...",
                  validatorCallback: ((value) {
                    if (value.length == 6) {
                      return null;
                    }
                    //TODO: Check backend
                    return 'Please enter a 6 digit code!';
                  }),
                  textFieldController: tournamentCodeController,
                ),
                BaseButton(callback: _onJoin, text: "Join"),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: SizedBox(
              width: 300,
              height: 20,
              child: Center(
                child: Text("OR"),
              ),
            ),
          ),
          BaseButton(callback: _onCreate, text: "Create")
        ],
      ),
    );
  }

  void _onCreate() {
    //TODO: GetCode from backend
    const code = "133769";
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const TournamentLobbyScreen(
              tournamentCode: code,
              isLeader: true,
              isStarted: false,
            )));
  }

  void _onJoin() {
    _join(tournamentCodeController.text);
  }

  void _join(String value) {
    if (formKey.currentState!.validate()) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => TournamentLobbyScreen(
            tournamentCode: value,
            isLeader: false,
            isStarted: true,
          ),
        ),
      );
    } else {
      print("The tournament code does not exist");
    }
  }
}
