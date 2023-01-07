import 'package:chess_tournament/src/frontend/base_screen.dart';
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
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 200,
            width: 100,
            child: Container(
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }
}
