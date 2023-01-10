import 'package:chess_tournament/src/backend/backend_file.dart';
import 'package:chess_tournament/src/frontend/base_screen.dart';
import 'package:chess_tournament/src/frontend/common/base_button.dart';
import 'package:chess_tournament/src/frontend/pages/tournament_overview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
            child: participantList(context),
          ),
        ],
      ),
    );
  }

  Widget participantList(BuildContext context) {
    var participants = getTournamentParticipants(context, "");
    return FutureBuilder(
      future: participants,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return participantCard(snapshot.data![index]);
              });
        }
      },
    );
  }

  Widget participantCard(TournamentParticipant participant) {
    return Center(
      child: Container(
        width: 400,
        height: 30,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.brown,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(participant.userName!),
            Text("Rating: " + participant.rating!),
          ],
        ),
      ),
    );
  }
}

class TournamentParticipant {
  // Image profilePicture;
  String? id;
  String? userName;
  String? rating;

  TournamentParticipant({
    required this.id,
    required this.userName,
    required this.rating,
  });

  TournamentParticipant.fromJSON(Map<String, dynamic> snapshot, String id) {
    id = id;
    userName = snapshot["userName"];
    rating = snapshot["rating"];
  }
}
