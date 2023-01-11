import 'dart:async';

import 'package:chess_tournament/src/backend/backend_file.dart';
import 'package:chess_tournament/src/frontend/base_screen.dart';
import 'package:chess_tournament/src/frontend/common/base_button.dart';
import 'package:chess_tournament/src/frontend/pages/tournament_overview.dart';
import 'package:flutter/material.dart';

class TournamentLobbyScreen extends BasePageScreen {
  final String tournamentCode;
  final bool isOwner;
  bool isStarted = false;

  TournamentLobbyScreen({
    super.key,
    required this.tournamentCode,
    required this.isOwner,
    required this.isStarted,
  });

  @override
  TournamentLobbyScreenState createState() => TournamentLobbyScreenState();
}

class TournamentLobbyScreenState
    extends BasePageScreenState<TournamentLobbyScreen> with BaseScreen {
  Future<List<DetailedUser>>? participants;
  Timer? fetchTimer;

  @override
  void initState() {
    super.initState();
    participants = getTournamentParticipants(context, widget.tournamentCode);
    setUpTimedFetch();
  }

  @override
  void dispose() {
    super.dispose();
    fetchTimer?.cancel();
  }

  @override
  String appBarTitle() {
    return "Tournament Lobby";
  }

  //TODO: this probably wastes a lot of battery. Find a way to subscribe
  //to changes instead
  setUpTimedFetch() {
    fetchTimer = Timer.periodic(
      const Duration(milliseconds: 5000),
      (timer) {
        setState(
          () {
            participants =
                getTournamentParticipants(context, widget.tournamentCode);
          },
        );
      },
    );
  }

  void startTournament() async {
    //TODO start tournament
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const TournamentOverviewScreen(),
      ),
    );
  }

  void goToTournament() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const TournamentOverviewScreen(),
      ),
    );
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
          } else if (widget.isOwner) ...{
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
            },
          );
        }
      },
    );
  }

  Widget participantCard(DetailedUser participant) {
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
            Image.network(participant.avatarUrl!),
            Text(participant.name!),
            Text("Rating: " + participant.rating!),
          ],
        ),
      ),
    );
  }
}
