import 'package:chess_tournament/src/backend/match_service.dart';
import 'package:chess_tournament/src/backend/tournament_service.dart';
import 'package:chess_tournament/src/frontend/base_screen.dart';
import 'package:chess_tournament/src/frontend/pages/chess_clock.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../backend/backend_file.dart';

class TournamentOverviewScreen extends BasePageScreen {
  final String tournamentCode;

  const TournamentOverviewScreen({
    super.key,
    required this.tournamentCode,
  });

  @override
  State<TournamentOverviewScreen> createState() =>
      _TournamentOverviewScreenState();
}

class _TournamentOverviewScreenState
    extends BasePageScreenState<TournamentOverviewScreen> with BaseScreen {
  Future<List<ChessMatch>>? matches;

  @override
  void initState() {
    super.initState();
    matches = TournamentService.getTournamentMatches(widget.tournamentCode);
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
          // Padding(
          //   padding: const EdgeInsets.all(40),
          //   child: minimizedLeaderBoard(),
          // ),
          Expanded(
            flex: 7,
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 1.h),
              child: matchesToPlay(context),
            ),
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

  // Widget minimizedLeaderBoard() {
  //   return ListView(
  //     shrinkWrap: true,
  //     children: topThree.map((participant) {
  //       return Center(
  //         child: SizedBox(
  //           width: 400,
  //           height: 60,
  //           child: Card(
  //             child: Padding(
  //               padding: const EdgeInsets.all(8.0),
  //               child: Center(
  //                 child: leaderBoardCard(participant),
  //               ),
  //             ),
  //           ),
  //         ),
  //       );
  //     }).toList(),
  //   );
  // }

  Widget leaderBoardCard(ChessUser participant) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(participant.name!),
        Text("W: 5, L: 2, D: 4"),
      ],
    );
  }

  Widget matchesToPlay(BuildContext context) {
    return FutureBuilder(
      future: matches,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return SizedBox(
            width: 80.w,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return matchCard(snapshot.data![index]);
              },
            ),
          );
        }
      },
    );
  }

  Widget matchCard(ChessMatch match) {
    Future<ChessUser?> currentUser = ChessUserService.getChessUserByUserId(
        FirebaseAuth.instance.currentUser!.uid);
    return FutureBuilder(
        future: currentUser,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.all(2.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 10.w,
                            height: 4.h,
                            child: ChessUserService.getAvatarFromUrl(
                                match.white!.avatarUrl!),
                          ),
                          Text(
                            match.white!.name!,
                            style: TextStyle(
                              fontSize: 9.sp,
                            ),
                          ),
                          Text(
                            "Rating: " + match.white!.rating.toString(),
                            style: TextStyle(
                              fontSize: 9.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(.5.w),
                          child: Text(
                            "VS",
                            style: TextStyle(
                              fontSize: 9.sp,
                            ),
                          ),
                        ),
                        if (match.result == ChessMatchState.notStarted) ...{
                          ElevatedButton(
                            onPressed: () => startMatch(match),
                            child: Text(
                              "Start",
                              style: TextStyle(
                                fontSize: 9.sp,
                              ),
                            ),
                          ),
                        } else if (match.result == ChessMatchState.draw) ...{
                          drawWidget(),
                        } else if (match.white!.docId ==
                            snapshot.data!.docId) ...{
                          if (match.result == ChessMatchState.whiteWon) ...{
                            winWidget(),
                          } else ...{
                            loseWidget(),
                          }
                        } else ...{
                          if (match.result == ChessMatchState.whiteWon) ...{
                            loseWidget(),
                          } else ...{
                            winWidget(),
                          }
                        }
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.all(2.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 10.w,
                            height: 4.h,
                            child: ChessUserService.getAvatarFromUrl(
                                match.black!.avatarUrl!),
                          ),
                          Text(
                            match.black!.name!,
                            style: TextStyle(
                              fontSize: 9.sp,
                            ),
                          ),
                          Text(
                            "Rating: " + match.black!.rating.toString(),
                            style: TextStyle(
                              fontSize: 9.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        });
  }

  Widget drawWidget() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.all(Radius.circular(1.w))),
      child: Padding(
        padding: EdgeInsets.all(1.w),
        child: Text(
          "Draw",
          style: TextStyle(
            fontSize: 9.sp,
          ),
        ),
      ),
    );
  }

  Widget winWidget() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.green,
          ),
          borderRadius: BorderRadius.all(Radius.circular(1.w))),
      child: Padding(
        padding: EdgeInsets.all(1.w),
        child: Text(
          "Win",
          style: TextStyle(
            fontSize: 9.sp,
          ),
        ),
      ),
    );
  }

  Widget loseWidget() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.red,
          ),
          borderRadius: BorderRadius.all(Radius.circular(1.w))),
      child: Padding(
        padding: EdgeInsets.all(1.w),
        child: Text(
          "Lose",
          style: TextStyle(
            fontSize: 9.sp,
          ),
        ),
      ),
    );
  }

  void startMatch(ChessMatch match) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ChessClockScreen(currentMatch: match)));
  }
}
