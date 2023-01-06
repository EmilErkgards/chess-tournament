import 'package:chess_tournament/src/base_screen.dart';
import 'package:flutter/material.dart';

class TournamentLobbyScreen extends BasePageScreen {
  late final tournamentCode;
  TournamentLobbyScreen({super.key, @required this.tournamentCode});

  @override
  TournamentLobbyScreenState createState() => TournamentLobbyScreenState();
}

class TournamentLobbyScreenState
    extends BasePageScreenState<TournamentLobbyScreen> with BaseScreen {
  @override
  void initState() {
    super.initState();
  }

  @override
  String appBarTitle() {
    return "Tournament Lobby" + widget.tournamentCode;
  }

  @override
  Widget body() {
    return const Center(
      child: Text("CART SCREEN BODY"),
    );
  }
}
