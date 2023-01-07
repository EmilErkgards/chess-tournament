import 'package:chess_tournament/src/frontend/base_screen.dart';
import 'package:chess_tournament/src/frontend/common/base_button.dart';
import 'package:chess_tournament/src/frontend/pages/chess_clock.dart';
import 'package:chess_tournament/src/frontend/pages/tournament_lobby.dart';
import 'package:flutter/material.dart';

class TournamentOverviewScreen extends BasePageScreen {
  const TournamentOverviewScreen({super.key});

  @override
  State<TournamentOverviewScreen> createState() =>
      _TournamentOverviewScreenState();
}

class _TournamentOverviewScreenState
    extends BasePageScreenState<TournamentOverviewScreen> with BaseScreen {
  @override
  void initState() {
    super.initState();
  }

  @override
  String appBarTitle() {
    return "Tournament Overview";
  }

  @override
  Widget body() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(40),
            child: minimizedLeaderBoard(),
          ),
          Padding(
            padding: const EdgeInsets.all(80),
            child: matchesToPlay(),
          ),
        ],
      ),
    );
  }

  late List<TournamentParticipant> participants = [
    TournamentParticipant("Emil", 1215),
    TournamentParticipant("Anton", 1500),
    TournamentParticipant("Oskar", 420),
    TournamentParticipant("Joel", 69),
    TournamentParticipant("Anton", 1337),
  ];

  late List<TournamentParticipant> topThree = [
    participants[0],
    participants[3],
    participants[4],
  ];

  late List<ChessMatch> matches = [
    ChessMatch(participants[0], participants[1]),
    ChessMatch(participants[1], participants[2]),
    ChessMatch(participants[2], participants[3]),
    ChessMatch(participants[3], participants[4]),
  ];

  Widget minimizedLeaderBoard() {
    return ListView(
      shrinkWrap: true,
      children: topThree.map((participant) {
        return Center(
          child: Container(
            width: 400,
            height: 30,
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.brown,
            ),
            child: Center(
              child: leaderBoardCard(participant),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget leaderBoardCard(TournamentParticipant participant) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(participant.userName),
        Text("W: 5, L: 2, D: 4"),
      ],
    );
  }

  Widget matchesToPlay() {
    return ListView(
      shrinkWrap: true,
      children: matches.map((match) {
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
              child: matchCard(match),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget matchCard(ChessMatch match) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(match.white.userName),
              Text("Rating: " + match.white.rating.toString()),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("VS"),
              ElevatedButton(
                onPressed: () => startMatch(match),
                child: Text("Start"),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(match.black.userName),
              Text("Rating: " + match.black.rating.toString()),
            ],
          ),
        ),
      ],
    );
  }

  void startMatch(ChessMatch match) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ChessClockScreen()));
  }
}

class ChessMatch {
  TournamentParticipant white;
  TournamentParticipant black;

  ChessMatch(this.white, this.black);
}
