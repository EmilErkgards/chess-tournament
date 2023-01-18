import 'package:chess_tournament/src/backend/backend_file.dart';

class ChessMatch {
  String? docId;
  String? tournamentCode;
  ChessUser? white;
  ChessUser? black;

  double? whiteTime;
  double? blackTime;

  String? result;

  ChessMatch({
    this.docId,
    required this.tournamentCode,
    required this.white,
    required this.black,
    required this.whiteTime,
    required this.blackTime,
    required this.result,
  });

  Future<ChessMatch> fromJSON(Map<String, dynamic> snapshot, String id) async {
    var white = await ChessUserService.getUserById(snapshot["white"]);
    var black = await ChessUserService.getUserById(snapshot["black"]);
    var tournamentCode = snapshot["tournamentCode"];
    var whiteTime = snapshot["whiteTime"];
    var blackTime = snapshot["blackTime"];
    var result = snapshot["result"];
    return ChessMatch(
        docId: id,
        tournamentCode: tournamentCode,
        white: white,
        black: black,
        whiteTime: whiteTime,
        blackTime: blackTime,
        result: result);
  }
}
