import 'package:chess_tournament/src/backend/tournament_service.dart';
import 'package:chess_tournament/src/frontend/base_screen.dart';
import 'package:chess_tournament/src/frontend/common/base_button.dart';
import 'package:chess_tournament/src/frontend/common/base_input_field.dart';
import 'package:chess_tournament/src/frontend/pages/tournament_lobby.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

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
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) throw "Not logged in";

      var currUser = await ChessUserService.getChessUserByUUID(currentUser.uid);
      if (currUser!.tournamentCode != "") {
        bool isOwner = await TournamentService.isTournamentOwner(
            currUser, currUser.tournamentCode!);
        bool isStarted = await TournamentService.isTournamentStarted(
            currUser.tournamentCode!);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TournamentLobbyScreen(
              tournamentCode: currUser.tournamentCode!,
              isOwner: isOwner,
              isStarted: isStarted,
            ),
          ),
        );
      }
    });
  }

  @override
  String appBarTitle() {
    return "Chess tournament planner";
  }

  @override
  Widget body(BuildContext context) {
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
        ),
      ),
    );
  }

  void _onCreate() async {
    //TODO: Get name from cookies
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) throw "Not logged in";

    var owner = await ChessUserService.getChessUserByUUID(currentUser.uid);
    String code = await TournamentService.addTournament(owner!);
    await TournamentService.addUserToTournament(currentUser, code);
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

    var currUser = await ChessUserService.getChessUserByUUID(currentUser.uid);

    if (formKey.currentState!.validate() &&
        await TournamentService.addUserToTournament(currentUser, value)) {
      bool isOwner = await TournamentService.isTournamentOwner(
          currUser!, currUser.tournamentCode!);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => TournamentLobbyScreen(
            tournamentCode: value,
            isOwner: isOwner,
            isStarted: false,
          ),
        ),
      );
    } else {
      print("The tournament code does not exist");
    }
  }
}
