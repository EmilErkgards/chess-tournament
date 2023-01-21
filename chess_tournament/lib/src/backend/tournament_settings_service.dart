import 'package:cloud_firestore/cloud_firestore.dart';

class TournamentSettings {
  String? docId;
  String? format;
  int? increment;
  int? totalTime;
  bool? evenTimeSplit;

  TournamentSettings({
    this.docId,
    required this.format,
    required this.increment,
    required this.totalTime,
    required this.evenTimeSplit,
  });

  static Future<TournamentSettings> fromJSON(
      Map<String, dynamic> snapshot, String docId) async {
    var format = snapshot["format"];
    var increment = snapshot["increment"];
    var timePerMatch = snapshot["totalTime"];
    var evenTimeSplit = snapshot["evenTimeSplit"];
    return TournamentSettings(
      docId: docId,
      format: format,
      increment: increment,
      totalTime: timePerMatch,
      evenTimeSplit: evenTimeSplit,
    );
  }
}

class TournamentSettingsService {
  static Future<void> setTournamentSettings(
      String tournamentCode, TournamentSettings settings) async {
    try {
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
            "totalTime": settings.totalTime,
            "evenTimeSplit": settings.evenTimeSplit,
          });
        });
      });
    } catch (error) {
      print("setTournamentSettings" + error.toString());
    }
  }

  static Future<TournamentSettings> getTournamentSettings(
      String tournamentCode) async {
    var response;

    try {
      var instance = FirebaseFirestore.instance;
      var tournamentCollection = await instance
          .collection('tournaments')
          .where('code', isEqualTo: tournamentCode)
          .get();
      var tournamentSettingsCollection =
          await instance.collection('tournamentSettings').get();

      tournamentCollection.docs.forEach((element) {
        var settingsId = element.data()["settings"].toString();
        tournamentSettingsCollection.docs.forEach((element2) {
          if (element2.id == settingsId) {
            response = element2;
          }
        });
      });
    } catch (error) {
      print("getTournamentSettings" + error.toString());
    }

    return await TournamentSettings.fromJSON(response.data(), response.id);
  }
}
