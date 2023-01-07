import 'package:chess_tournament/src/frontend/base_screen.dart';
import 'package:chess_tournament/src/frontend/home/tournament_lobby.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends BasePageScreen {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends BasePageScreenState<HomeScreen> with BaseScreen {
  bool isButtonTapped = false;

  final tournamentCodeController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  double? temp = 50;
  @override
  void initState() {
    super.initState();
  }

  // TO GIVE THE TITLE OF THE APP BAR
  @override
  String appBarTitle() {
    return "Chess tournament planner";
  }

  // THIS WILL RETURN THE BODY OF THE SCREEN
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
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 300,
                    height: temp,
                    child: TextFormField(
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value != null && value.length == 6) {
                          return null;
                        }
                        return 'Please enter a 6 digit code!';
                      },
                      textAlign: TextAlign.center,
                      controller: tournamentCodeController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter tournament code ...',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 300,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _onJoin,
                      child: const Text("Join"),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: SizedBox(
              width: 300,
              height: 30,
              child: Center(
                child: Text("OR"),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 300,
              height: 50,
              child: ElevatedButton(
                onPressed: _onCreate,
                child: const Text("Create"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onCreate() {
    //Generate Code
    const code = "112111";
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const TournamentLobbyScreen(
              tournamentCode: code,
              isLeader: true,
            )));
  }

  void _onJoin() {
    _join(tournamentCodeController.text);
  }

  void _join(String value) {
    if (formKey.currentState!.validate()) {
      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.
      print("you are trying to join tournament: $value");
      setState(() {
        temp = 50;
      });
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => TournamentLobbyScreen(
                tournamentCode: value,
                isLeader: false,
              )));
    } else {
      setState(() {
        temp = 80;
      });
    }
  }
}
