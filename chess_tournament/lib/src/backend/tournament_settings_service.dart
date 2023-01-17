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

  static Future<TournamentSettings> fromJSON(
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
  }

  static Future<TournamentSettings> getTournamentSettings(
      String tournamentCode) async {
    String settingsDocId = "";

    var instance = FirebaseFirestore.instance;
    var firebaseResponse = await instance.collection('tournaments').get();
    firebaseResponse.docs.forEach((element) {
      if (element.data()["code"] == tournamentCode) {
        settingsDocId = element.data()["settings"];
      }
    });

    QueryDocumentSnapshot<Map<String, dynamic>>? response;

    await instance.collection('tournamentSettings').get().then((value) => {
          value.docs.forEach((element) {
            if (element.id == settingsDocId) {
              response = element;
            }
          })
        });

    return TournamentSettings.fromJSON(response!.data(), response!.id);
  }
}
