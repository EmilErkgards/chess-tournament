import 'package:chess_tournament/src/base_screen.dart';
import 'package:chess_tournament/src/home/cart_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends BasePageScreen {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends BasePageScreenState<HomeScreen> with BaseScreen {
  bool isButtonTapped = false;

  final tournamentCodeController = TextEditingController();

  @override
  void initState() {
    isBackButton(false);
    super.initState();
  }

  // TO GIVE THE TITLE OF THE APP BAR
  @override
  String appBarTitle() {
    return "Chess tournament planner";
  }

  @override
  void isBackButton(bool isBack) {
    super.isBackButton(isBack);
  }

  // THIS IS BACK BUTTON CLICK HANDLER
  @override
  void onClickBackButton() {
    print("BACK BUTTON CLICKED FROM HOME");
    Navigator.of(context).pop();
  }

  // THIS IS RIGHT BAR BUTTON CLICK HANDLER
  @override
  void onClickCart() {
    print("CART BUTTON CLICKED");
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => CartScreen()));
  }

  // THIS WILL RETURN THE BODY OF THE SCREEN
  @override
  Widget body() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 300,
              height: 50,
              child: TextField(
                onSubmitted: _join,
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
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 300,
              height: 50,
              child: ElevatedButton(
                onPressed: _onJoin,
                child: const Text("Join"),
              ),
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

  void _onCreate() {}

  void _onJoin() {
    _join(tournamentCodeController.text);
  }

  void _join(String value) {
    print("you are trying to join tournament: $value");
    // Navigator.of(context)
    //     .push(MaterialPageRoute(builder: (context) => TournamentLobby()));
  }
}
