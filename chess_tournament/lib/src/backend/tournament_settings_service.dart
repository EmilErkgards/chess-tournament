import 'package:cloud_firestore/cloud_firestore.dart';

class TournamentSettings {
  String? docId;
  String? format;
  String? increment;
  String? timePerMatch;

  TournamentSettings({
    this.docId,
    required this.format,
    required this.increment,
    required this.timePerMatch,
  });

  Future<TournamentSettings> fromJSON(
      Map<String, dynamic> snapshot, String docId) async {
    var format = snapshot["format"];
    var increment = snapshot["increment"];
    var timePerMatch = snapshot["timePerMatch"];
    return TournamentSettings(
      docId: docId,
      format: format,
      increment: increment,
      timePerMatch: timePerMatch,
    );
  }
}

class TournamentSettingsService {
  static Future<void> setTournamentSettings(
      String tournamentCode, TournamentSettings settings) async {
    var tournamentSettingsId = await FirebaseFirestore.instance
        .collection("tournaments")
        .where('code', isEqualTo: tournamentCode)
        .get()
        .then((value) async {
      value.docs.forEach((element) {
        FirebaseFirestore.instance
            .collection('tournamentSettings')
            .doc(element.data()["settings"])
            .update({
          "format": settings.format,
          "increment": settings.increment,
          "timePerMatch": settings.timePerMatch
        });
      });
    });

    FirebaseFirestore.instance
        .collection('users')
        .where('tournamentCode', isEqualTo: tournamentCode)
        .get()
        .then((value) async {
      value.docs.forEach((element) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(element.id)
            .update({"tournamentCode": ""});
      });
    });
  }
}
