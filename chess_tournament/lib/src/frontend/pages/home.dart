import 'package:chess_tournament/src/frontend/base_screen.dart';
import 'package:chess_tournament/src/frontend/common/base_button.dart';
import 'package:chess_tournament/src/frontend/common/base_input_field.dart';
import 'package:chess_tournament/src/frontend/pages/tournament_lobby.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../backend/backend_file.dart';

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
      // child: Container(
      //   decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(20),
      //     color: Colors.black,
      //   ),
      //   child: Padding(
      //     padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
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
                    //TODO
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
      //   ),
      // ),
    );
  }

  void _onCreate() async {
    //TODO: Get name from cookies
    var owner = await getUserByName("Emil");
    String code = await addTournament(owner!);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TournamentLobbyScreen(
          tournamentCode: code,
          isOwner: true,
          isStarted: false,
        ),
      ),
    );
  }

  void _onJoin() {
    _join(tournamentCodeController.text);
  }

  void _join(String value) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) throw "Not logged in";

    if (formKey.currentState!.validate() &&
        await addUserToTournament(currentUser, value)) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => TournamentLobbyScreen(
            tournamentCode: value,
            isOwner: false,
            isStarted: true,
          ),
        ),
      );
    } else {
      print("The tournament code does not exist");
    }
  }
}
