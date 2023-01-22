import 'package:chess_tournament/src/backend/backend_file.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum ChessMatchResult {
  notStarted,
  whiteWon,
  blackWon,
  draw,
}

class ChessMatch {
  String? docId;
  String? tournamentCode;
  ChessUser? white;
  ChessUser? black;

  double? whiteTime;
  double? blackTime;

  ChessMatchResult? result;

  ChessMatch({
    this.docId,
    required this.tournamentCode,
    required this.white,
    required this.black,
    required this.whiteTime,
    required this.blackTime,
    required this.result,
  });

  static Future<ChessMatch> fromJSON(
      Map<String, dynamic> snapshot, String id) async {
    var white = await ChessUserService.getUserByDocId(snapshot["white"]);
    var black = await ChessUserService.getUserByDocId(snapshot["black"]);
    var tournamentCode = snapshot["tournamentCode"];
    var whiteTime = snapshot["whiteTime"];
    var blackTime = snapshot["blackTime"];
    var result = ChessMatchService.convertToChessMatchState(snapshot["result"]);
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

class ChessMatchService {
  static ChessMatchResult convertToChessMatchState(int number) {
    return ChessMatchResult.values[number];
  }

  static Future<void> updateMatchResult(
      ChessMatch match, ChessMatchResult state) async {
    await FirebaseFirestore.instance
        .collection('matches')
        .doc(match.docId)
        .update({"result": state.index});
  }
}
