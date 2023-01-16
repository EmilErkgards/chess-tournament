import 'package:chess_tournament/src/backend/tournament_service.dart';
import 'package:chess_tournament/src/backend/tournament_settings_service.dart';
import 'package:chess_tournament/src/frontend/common/base_button.dart';
import 'package:chess_tournament/src/frontend/common/base_input_increment.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../base_screen.dart';

class TournamentSettingsScreen extends BasePageScreen {
  final String tournamentCode;

  TournamentSettingsScreen({
    super.key,
    required this.tournamentCode,
  });

  @override
  _TournamentSettingsScreenState createState() =>
      _TournamentSettingsScreenState();
}

class _TournamentSettingsScreenState
    extends BasePageScreenState<TournamentSettingsScreen> with BaseScreen {
  int gameTime = 0;
  int incrementTime = 0;
  String format = 'Round Robin';

  @override
  String appBarTitle() {
    return "Tournament Settings";
  }

  //TODO: fetch format from db
  var items = [
    'Round Robin',
    'Knockout',
    'Teams',
  ];

  //TODO: apply settings to db row

  @override
  Widget body(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600.0;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: isMobile ? 35.w : 20.w,
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Text(
                    "Format",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 65.w,
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: DropdownButton(
                    isExpanded: true,
                    // Initial Value
                    value: format,

                    // Down Arrow Icon
                    icon: const Icon(Icons.keyboard_arrow_down),

                    // Array list of items
                    items: items.map<DropdownMenuItem<String>>((String item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Center(
                          child: Text(
                            item,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }).toList(),
                    // After selecting the desired option,it will
                    // change button value to selected value
                    onChanged: (String? newValue) {
                      setState(() {
                        format = newValue!;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 35.w,
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Text(
                    "Total game time",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 65.w,
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: BaseInputIncrement(
                    onChanged: onGameTimeCounterChanged,
                    maxValue: 60,
                    startValue: 10,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 35.w,
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Text(
                    "Increment",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 65.w,
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child:
                      BaseInputIncrement(onChanged: onIncrementCounterChanged),
                ),
              ),
            ],
          ),
          BaseButton(
            text: 'Apply',
            callback: onApply,
          ),
        ],
      ),
    );
  }

  void onIncrementCounterChanged(int value) {
    incrementTime = value;
  }

  void onGameTimeCounterChanged(int value) {
    gameTime = value;
  }

  void onApply() {
    TournamentSettingsService.setTournamentSettings(
        widget.tournamentCode,
        TournamentSettings(
          format: format,
          increment: incrementTime.toString(),
          timePerMatch: gameTime.toString(),
        ));
    Navigator.pop(context);
  }
}
