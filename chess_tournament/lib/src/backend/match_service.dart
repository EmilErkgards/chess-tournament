import 'package:chess_tournament/src/backend/backend_file.dart';

class ChessMatch {
  String? docId;
  ChessUser? white;
  ChessUser? black;

  double? whiteTime;
  double? blackTime;

  String? result;

  ChessMatch({
    this.docId,
    required this.white,
    required this.black,
    required this.whiteTime,
    required this.blackTime,
    required this.result,
  });

  Future<ChessMatch> fromJSON(Map<String, dynamic> snapshot, String id) async {
    var white = await ChessUserService.getUserById(snapshot["white"]);
    var black = await ChessUserService.getUserById(snapshot["black"]);
    var whiteTime = snapshot["whiteTime"];
    var blackTime = snapshot["blackTime"];
    var result = snapshot["result"];
    return ChessMatch(
        docId: id,
        white: white,
        black: black,
        whiteTime: whiteTime,
        blackTime: blackTime,
        result: result);
  }
}
