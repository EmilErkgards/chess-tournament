import 'dart:math';

import 'package:chess_tournament/src/backend/backend_file.dart';
import 'package:chess_tournament/src/backend/match_service.dart';
import 'package:chess_tournament/src/backend/tournament_settings_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Tournament {
  String? docId;
  String? code;
  String? state;
  String? settings;
  ChessUser? owner;

  Tournament({
    required this.docId,
    required this.code,
    required this.state,
    required this.settings,
    required this.owner,
  });

  static Future<Tournament> fromJSON(
      Map<String, dynamic> snapshot, String docId) async {
    var code = snapshot["code"];
    var state = snapshot["state"];
    var settings = snapshot["settings"];
    var owner = await ChessUserService.getUserById(snapshot["owner"]);
    return Tournament(
        docId: docId,
        code: code,
        state: state,
        settings: settings,
        owner: owner);
  }
}

class TournamentService {
  static Future<Tournament> getTournamentByCode(String tournamentCode) async {
    Tournament? tournament;
    try {
      await FirebaseFirestore.instance
          .collection("tournaments")
          .get()
          .then((value) {
        value.docs.forEach((element) async {
          if (element.data()["code"] == tournamentCode) {
            tournament = await Tournament.fromJSON(element.data(), element.id);
          }
        });
      });
    } catch (error) {
      print(error);
    }
    return tournament!;
  }

  static Future<List<ChessUser>> getTournamentParticipants(
      String tournamentCode) async {
    List<ChessUser> participants = List.empty(growable: true);
    try {
      var firebaseResponse =
          await FirebaseFirestore.instance.collection('users').get();

      firebaseResponse.docs.forEach(
          (doc) => participants.add(ChessUser.fromJSON(doc.data(), doc.id)));
      participants
          .removeWhere((element) => element.tournamentCode != tournamentCode);
    } catch (error) {
      print(error);
    }
    return participants;
  }

  static int generateCode() {
    return Random().nextInt(899999) + 100000;
  }

  static Future<bool> codeExistsInDB(String code) async {
    bool retVal = false;
    try {
      var firebaseResponse =
          await FirebaseFirestore.instance.collection('tournaments').get();
      firebaseResponse.docs.forEach(
        (doc) {
          if (doc.data()["code"].toString() == code) {
            retVal = true;
          }
        },
      );
    } catch (error) {
      print(error);
    }
    return retVal;
  }

  static Future<String> createDefaultTournamentSettings() async {
    String? id;
    try {
      id = (await FirebaseFirestore.instance
              .collection('tournamentSettings')
              .add({
        "format": "roundRobin",
        "totalTime": 10,
        "increment": 1,
        "evenTimeSplit": true,
      }))
          .id;
    } catch (error) {
      print("createDefaultTournamentSettings" + error.toString());
    }

    return id!;
  }

  static Future<String> addTournament(ChessUser owner) async {
    int code = generateCode();
    while ((await codeExistsInDB(code.toString()))) {
      code = generateCode();
    }

    var settingsDocRef = await createDefaultTournamentSettings();
    try {
      FirebaseFirestore.instance.collection('tournaments').add({
        "code": code.toString(),
        "state": "notStarted",
        "settings": settingsDocRef,
        "owner": owner.docId
      });
    } catch (error) {
      print("addTournament" + error.toString());
    }

    return code.toString();
  }

  static Future<bool> addUserToTournament(User user, String code) async {
    var codeExists = await codeExistsInDB(code);

    if (!codeExists) {
      return false;
    }

    var chessUser = await ChessUserService.getChessUserByUUID(user.uid);
    if (chessUser == null) {
      throw "Could not find chess user with uuid: " + user.uid;
    }
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(chessUser.docId)
          .update({"tournamentCode": code});
    } catch (error) {
      print("addUserToTournament" + error.toString());
    }
    return true;
  }

  static Future<bool> isTournamentOwner(
      ChessUser user, String tournamentCode) async {
    var retVal = false;
    try {
      await FirebaseFirestore.instance
          .collection('tournaments')
          .get()
          .then((value) => {
                value.docs.forEach((element) {
                  if (element.data()["code"] == tournamentCode &&
                      element.data()["owner"] == user.docId) {
                    retVal = true;
                  }
                })
              });
    } catch (error) {
      print("isTournamentOwner" + error.toString());
    }

    return retVal;
  }

  static Future<bool> isTournamentStarted(String tournamentCode) async {
    var retVal = false;
    try {
      await FirebaseFirestore.instance
          .collection('tournaments')
          .get()
          .then((value) => {
                value.docs.forEach((element) {
                  if (element.data()["code"] == tournamentCode &&
                      element.data()["state"] == "started") {
                    retVal = true;
                  }
                })
              });
    } catch (error) {
      print("isTournamentStarted" + error.toString());
    }

    return retVal;
  }

  static Future<List<ChessMatch>> generateRoundRobin(
      List<ChessUser> participants,
      TournamentSettings settings,
      String tournamentCode) async {
    int numberOfRounds = participants.length - 1;
    if (participants.length % 2 != 0) {
      numberOfRounds = participants.length;
    }
    List<ChessMatch> matches = List.empty(growable: true);

    int index = 0;

    for (int i = 0; i < participants.length; i++) {
      for (int j = i + 1; j < participants.length; j++) {
        ChessUser? white;
        ChessUser? black;
        if (index % 2 == 0) {
          white = participants[i];
          black = participants[j];
        } else {
          white = participants[j];
          black = participants[i];
        }
        double whiteTime = settings.totalTime! / 2;
        double blackTime = settings.totalTime! / 2;
        if (!settings.evenTimeSplit!) {
          //Call algorithm
        }
        matches.add(ChessMatch(
            tournamentCode: tournamentCode,
            white: white,
            black: black,
            whiteTime: whiteTime,
            blackTime: blackTime,
            result: "notStarted"));
      }
    }

    return matches;
  }

  static Future<void> setTournamentMatches(List<ChessMatch> matches) async {
    try {
      await FirebaseFirestore.instance
          .collection('matches')
          .where('tournamentCode', isEqualTo: matches[0].tournamentCode)
          .get()
          .then((value) async => {
                value.docs.forEach((element) {
                  FirebaseFirestore.instance
                      .runTransaction((Transaction myTransaction) async {
                    myTransaction.delete(element.reference);
                  });
                })
              });
    } catch (error) {
      print("setTournamentMatches" + error.toString());
    }
    for (int i = 0; i < matches.length; i++) {
      try {
        FirebaseFirestore.instance.collection("matches").add({
          "tournamentCode": matches[i].tournamentCode,
          "white": matches[i].white!.docId,
          "black": matches[i].black!.docId,
          "whiteTime": matches[i].whiteTime,
          "blackTime": matches[i].blackTime,
          "result": matches[i].result,
        });
      } catch (error) {
        print("setTournamentMatches" + error.toString());
      }
    }
  }

  static Future<void> deleteTournamentSettings(String id) async {
    await FirebaseFirestore.instance
        .collection('tournamentSettings')
        .get()
        .then((value) async => {
              value.docs.forEach((element) {
                if (element.id == id) {
                  FirebaseFirestore.instance
                      .runTransaction((Transaction myTransaction) async {
                    myTransaction.delete(element.reference);
                  });
                }
              })
            });
  }

  static Future<void> deleteTournament(String tournamentCode) async {
    var codeExists = await codeExistsInDB(tournamentCode);

    if (!codeExists) {
      throw "";
    }
    try {
      FirebaseFirestore.instance
          .collection("tournaments")
          .get()
          .then((value) async => {
                value.docs.forEach((element) {
                  if (element.data()["code"] == tournamentCode) {
                    FirebaseFirestore.instance
                        .runTransaction((Transaction myTransaction) async {
                      myTransaction.delete(element.reference);
                    });
                    deleteTournamentSettings(element.data()["settings"]);
                  }
                })
              });
    } catch (error) {
      print("deleteTournament" + error.toString());
    }

    try {
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
    } catch (error) {
      print("deleteTournament" + error.toString());
    }
  }

  static Future<void> leaveTournament() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    try {
      var currUser =
          await ChessUserService.getChessUserByUUID(currentUser!.uid);
      FirebaseFirestore.instance.collection('users').get().then((value) async {
        value.docs.forEach((element) {
          if (element.id == currUser!.docId) {
            FirebaseFirestore.instance
                .collection('users')
                .doc(element.id)
                .update({"tournamentCode": ""});
          }
        });
      });
    } catch (error) {
      print("leaveTournament" + error.toString());
    }
  }
}
