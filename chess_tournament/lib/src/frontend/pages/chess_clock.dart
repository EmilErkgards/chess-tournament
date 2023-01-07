import 'dart:async';

import 'package:chess_tournament/src/frontend/base_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChessClockScreen extends BasePageScreen {
  const ChessClockScreen({
    super.key,
  });

  @override
  State<ChessClockScreen> createState() => _ChessClockScreenState();
}

class _ChessClockScreenState extends BasePageScreenState<ChessClockScreen>
    with BaseScreen {
  Timer? timer;
  bool gameIsRunning = false;
  bool whitesTurn = true;

  late int whitesTimeInMilliSeconds;
  late int blacksTimeInMilliSeconds;

  late String whitesTime;
  late String blacksTime;

  @override
  void initState() {
    whitesTimeInMilliSeconds = 5 * 60 * 1000;
    whitesTimeInMilliSeconds = 10;
    blacksTimeInMilliSeconds = 5 * 60 * 1000;
    blacksTimeInMilliSeconds = 10;
    whitesTime = clockFormat.format(DateTime.fromMillisecondsSinceEpoch(
      whitesTimeInMilliSeconds.toInt(),
    ));
    blacksTime = clockFormat.format(DateTime.fromMillisecondsSinceEpoch(
      blacksTimeInMilliSeconds.toInt(),
    ));
    timer = Timer.periodic(
      Duration(milliseconds: 10),
      (Timer t) => {
        timerLogic(),
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  String appBarTitle() {
    return "Chess clock";
  }

  @override
  Widget body() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: GestureDetector(
                onTap: blackSwitchedTurns,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black,
                  ),
                  child: Center(
                    child: Text(
                      blacksTime.toString(),
                      style: const TextStyle(
                        fontSize: 100,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: 100,
                width: 100,
                child: ElevatedButton(
                  onPressed: onPauseButtonPressed,
                  child: Icon(Icons.pause),
                ),
              ),
              SizedBox(
                height: 100,
                width: 100,
                child: ElevatedButton(
                  onPressed: onPlayButtonPressed,
                  child: Icon(Icons.play_arrow),
                ),
              ),
              SizedBox(
                height: 100,
                width: 100,
                child: ElevatedButton(
                  onPressed: onStopButtonPressed,
                  child: Icon(Icons.stop),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: GestureDetector(
                onTap: whiteSwitchedTurns,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey,
                  ),
                  child: Center(
                    child: Text(
                      whitesTime.toString(),
                      style: const TextStyle(
                        fontSize: 100,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void whiteSwitchedTurns() {
    if (gameIsRunning && whitesTurn) whitesTurn = false;
  }

  void blackSwitchedTurns() {
    if (gameIsRunning && !whitesTurn) whitesTurn = true;
  }

  void onPlayButtonPressed() {
    gameIsRunning = true;
  }

  void onPauseButtonPressed() {
    gameIsRunning = false;
  }

  void onStopButtonPressed() {
    gameIsRunning = false;
    matchStopped();
  }

  var clockFormat = DateFormat('mm:ss');

  void timerLogic() {
    if (gameIsRunning) {
      if (whitesTurn) {
        whitesTimeInMilliSeconds -= 10;
        setState(() {
          whitesTime = checkTimeAndReturnFormatted(whitesTimeInMilliSeconds);
        });
      } else {
        blacksTimeInMilliSeconds -= 10;
        setState(() {
          blacksTime = checkTimeAndReturnFormatted(blacksTimeInMilliSeconds);
        });
      }
    }
  }

  String checkTimeAndReturnFormatted(int timeInMilliseconds) {
    if (timeInMilliseconds <= 0) {
      timer?.cancel();
      matchStopped(timeRanOut: true);
    }
    return clockFormat.format(
      DateTime.fromMillisecondsSinceEpoch(
        timeInMilliseconds.toInt(),
      ),
    );
  }

  void matchStopped({bool timeRanOut = false}) {
    if (timeRanOut) {
      if (whitesTimeInMilliSeconds <= 0) {
        print("Black won on time. Press to continue");
      } else {
        print("Black won on time. Press to continue");
      }
    } else {
      print("Someone won. Pick who");
    }
  }
}
