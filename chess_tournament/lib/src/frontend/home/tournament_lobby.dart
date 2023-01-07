import 'package:chess_tournament/src/frontend/base_screen.dart';
import 'package:flutter/material.dart';

class TournamentLobbyScreen extends BasePageScreen {
  final String tournamentCode;
  final bool isLeader;
  const TournamentLobbyScreen(
      {super.key, required this.tournamentCode, required this.isLeader});

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
    return "Tournament Lobby";
  }

  late List<TournamentParticipant> participants = [
    TournamentParticipant("Emil"),
    TournamentParticipant("Anton"),
    TournamentParticipant("Oskar"),
    TournamentParticipant("Joel"),
    TournamentParticipant("Anton"),
  ];

  @override
  Widget body() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 100,
            child: Text(
              widget.tournamentCode,
              style: const TextStyle(
                fontSize: 60,
              ),
            ),
          ),
          Expanded(
            flex: 10,
            child: participantList(),
          )
        ],
      ),
    );
  }

  Widget participantList() {
    return ListView(
      shrinkWrap: true,
      children: participants.map((participant) {
        return Center(
          child: Container(
            width: 400,
            height: 100,
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.brown,
            ),
            child: Center(
              child: participantCard(participant),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget participantCard(TournamentParticipant participant) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(participant.name),
        Text("Rating 800"),
      ],
    );
  }
}

class TournamentParticipant {
  late String name;

  TournamentParticipant(this.name);
}
