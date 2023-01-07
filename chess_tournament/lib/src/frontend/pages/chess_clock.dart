import 'package:chess_tournament/src/frontend/base_screen.dart';
import 'package:flutter/material.dart';

class ChessClockScreen extends BasePageScreen {
  const ChessClockScreen({
    super.key,
  });

  @override
  State<ChessClockScreen> createState() => _ChessClockScreenState();
}

class _ChessClockScreenState extends BasePageScreenState<ChessClockScreen>
    with BaseScreen {
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
                onTap: () => {print("test")},
                child: Container(
                  color: Colors.black,
                  child: Center(
                    child: Text(
                      "00:00",
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
                  onPressed: () => {},
                  child: Icon(Icons.pause),
                ),
              ),
              SizedBox(
                height: 100,
                width: 100,
                child: ElevatedButton(
                  onPressed: () => {},
                  child: Icon(Icons.play_arrow),
                ),
              ),
              SizedBox(
                height: 100,
                width: 100,
                child: ElevatedButton(
                  onPressed: () => {},
                  child: Icon(Icons.stop),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: GestureDetector(
                onTap: () => {print("test")},
                child: Container(
                  color: Colors.grey,
                  child: Center(
                    child: Text(
                      "00:00",
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
}
