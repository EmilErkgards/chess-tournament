import 'package:chess_tournament/src/backend/match_service.dart';
import 'package:chess_tournament/src/frontend/base_screen.dart';
import 'package:chess_tournament/src/frontend/pages/chess_clock.dart';
import 'package:flutter/material.dart';

import '../../backend/backend_file.dart';

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
  Widget body(BuildContext context) {
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

  late List<ChessUser> participants = [
    ChessUser(name: "Emil", rating: "1215", userId: "bla"),
    ChessUser(name: "Anton", rating: "1500", userId: "bla"),
    ChessUser(name: "Oskar", rating: "420", userId: "bla"),
    ChessUser(name: "Joel", rating: "69", userId: "bla"),
    ChessUser(name: "Anton", rating: "1337", userId: "bla"),
  ];

  late List<ChessUser> topThree = [
    participants[0],
    participants[3],
    participants[4],
  ];

  late List<ChessMatch> matches = [
    ChessMatch(
        docId: '',
        tournamentCode: "",
        white: participants[0],
        black: participants[1],
        whiteTime: 300,
        blackTime: 300,
        result: "notStarted"),
    ChessMatch(
        docId: '',
        tournamentCode: "",
        white: participants[2],
        black: participants[3],
        whiteTime: 300,
        blackTime: 300,
        result: "notStarted"),
    ChessMatch(
        docId: '',
        tournamentCode: "",
        white: participants[4],
        black: participants[2],
        whiteTime: 300,
        blackTime: 300,
        result: "notStarted"),
    ChessMatch(
        docId: '',
        tournamentCode: "",
        white: participants[3],
        black: participants[1],
        whiteTime: 300,
        blackTime: 300,
        result: "notStarted"),
  ];

  Widget minimizedLeaderBoard() {
    return ListView(
      shrinkWrap: true,
      children: topThree.map((participant) {
        return Center(
          child: SizedBox(
            width: 400,
            height: 60,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: leaderBoardCard(participant),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget leaderBoardCard(ChessUser participant) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(participant.name!),
        Text("W: 5, L: 2, D: 4"),
      ],
    );
  }

  Widget matchesToPlay() {
    return ListView(
      shrinkWrap: true,
      children: matches.map((match) {
        return Center(
          child: SizedBox(
            width: 400,
            height: 100,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: matchCard(match),
              ),
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
              Text(match.white!.name!),
              Text("Rating: " + match.white!.rating.toString()),
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
              Text(match.black!.name!),
              Text("Rating: " + match.black!.rating.toString()),
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
