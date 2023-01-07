import 'package:chess_tournament/src/frontend/base_screen.dart';
import 'package:chess_tournament/src/frontend/common/base_button.dart';
import 'package:chess_tournament/src/frontend/pages/tournament_overview.dart';
import 'package:flutter/material.dart';

class TournamentLobbyScreen extends BasePageScreen {
  final String tournamentCode;
  final bool isLeader;
  final bool isStarted;

  const TournamentLobbyScreen({
    super.key,
    required this.tournamentCode,
    required this.isLeader,
    required this.isStarted,
  });

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

  void startTournament() {
    //TODO start tournament
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => TournamentOverviewScreen()));
  }

  void goToTournament() {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => TournamentOverviewScreen()));
  }

  void openTournamentSettings() {}

  late List<TournamentParticipant> participants = [
    TournamentParticipant("Emil", 1215),
    TournamentParticipant("Anton", 1500),
    TournamentParticipant("Oskar", 420),
    TournamentParticipant("Joel", 69),
    TournamentParticipant("Anton", 1337),
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
          if (widget.isStarted) ...{
            BaseButton(
              callback: goToTournament,
              text: "Go To Tournament",
            ),
          } else if (widget.isLeader) ...{
            BaseButton(
              callback: startTournament,
              text: "Start",
            ),
            BaseButton(
              callback: openTournamentSettings,
              text: "Tournament Settings",
            ),
          },
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
        Text(participant.userName),
        Text("Rating: " + participant.rating.toString()),
      ],
    );
  }
}

class TournamentParticipant {
  late Image profilePicture;
  late String userName;
  late int rating;

  TournamentParticipant(this.userName, this.rating);
}
