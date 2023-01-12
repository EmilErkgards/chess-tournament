import 'package:chess_tournament/src/backend/backend_file.dart';

class ChessMatch {
  String? docId;
  ChessUser? white;
  ChessUser? black;

  ChessMatch({
    required this.docId,
    required this.white,
    required this.black,
  });

  Future<ChessMatch> fromJSON(Map<String, dynamic> snapshot, String id) async {
    var white = await ChessUserService.getUserById(snapshot["white"]);
    var black = await ChessUserService.getUserById(snapshot["black"]);
    return ChessMatch(docId: id, white: white, black: black);
  }
}
