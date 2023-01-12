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
  Future<List<ChessUser>>? participants;
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
  Widget body(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: SizedBox(
                width: 400,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        const Text(
                          "Tournament Code",
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                        Text(
                          widget.tournamentCode,
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 400,
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    "Participants",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: participantList(context),
            ),
            if (widget.isStarted) ...{
              Padding(
                padding: const EdgeInsets.all(8),
                child: BaseButton(
                  callback: goToTournament,
                  text: "Go To Tournament",
                ),
              ),
            } else if (widget.isOwner) ...{
              Padding(
                padding: const EdgeInsets.all(8),
                child: BaseButton(
                  callback: startTournament,
                  text: "Start",
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: BaseButton(
                  callback: openTournamentSettings,
                  text: "Tournament Settings",
                ),
              ),
            },
          ],
        ),
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
          return SizedBox(
            width: 400,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return participantCard(snapshot.data![index]);
              },
            ),
          );
        }
      },
    );
  }

  Widget participantCard(ChessUser participant) {
    return Card(
      child: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 50,
                height: 50,
                child: getAvatarFromUrl(participant.avatarUrl!),
              ),
            ),
            Text(participant.name!),
            Text("Rating: " + participant.rating!),
          ],
        ),
      ),
    );
  }
}
