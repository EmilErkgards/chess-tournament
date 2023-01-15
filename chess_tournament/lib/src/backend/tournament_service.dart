import 'dart:math';

import 'package:chess_tournament/src/backend/backend_file.dart';
import 'package:chess_tournament/src/backend/match_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Tournament {
  String? docId;
  String? code;
  String? state;
  String? format;
  ChessUser? owner;

  Tournament({
    required this.docId,
    required this.code,
    required this.state,
    required this.format,
    required this.owner,
  });

  Future<Tournament> fromJSON(
      Map<String, dynamic> snapshot, String docId) async {
    var code = snapshot["code"];
    var state = snapshot["state"];
    var format = snapshot["format"];
    var owner = await ChessUserService.getUserById(snapshot["black"]);
    return Tournament(
        docId: docId, code: code, state: state, format: format, owner: owner);
  }
}

class TournamentService {
  static Future<List<ChessUser>> getTournamentParticipants(
      BuildContext context, String tournamentCode) async {
    List<ChessUser> participants = List.empty(growable: true);
    var firebaseResponse =
        await FirebaseFirestore.instance.collection('users').get();

    firebaseResponse.docs.forEach(
        (doc) => participants.add(ChessUser.fromJSON(doc.data(), doc.id)));
    participants
        .removeWhere((element) => element.tournamentCode != tournamentCode);
    return participants;
  }

  static int generateCode() {
    return Random().nextInt(899999) + 100000;
  }

  static Future<bool> codeExistsInDB(String code) async {
    bool retVal = false;
    var firebaseResponse =
        await FirebaseFirestore.instance.collection('tournaments').get();
    firebaseResponse.docs.forEach(
      (doc) {
        if (doc.data()["code"].toString() == code) {
          retVal = true;
        }
      },
    );
    return retVal;
  }

  static Future<String> addTournament(ChessUser owner) async {
    int code = generateCode();
    while ((await codeExistsInDB(code.toString()))) {
      code = generateCode();
    }

    FirebaseFirestore.instance.collection('tournaments').add({
      "code": code.toString(),
      "state": "notStarted",
      "format": "roundRobin",
      "owner": owner.docId
    });

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
      rethrow;
    }
    return true;
  }

  static Future<bool> isTournamentOwner(
      ChessUser user, String tournamentCode) async {
    var retVal = false;
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

    return retVal;
  }

  static Future<bool> isTournamentStarted(String tournamentCode) async {
    var retVal = false;
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

    return retVal;
  }

  static List<List<String>> generateRoundRobin(List<String> ids) {
    int n = ids.length;
    List<List<String>> schedule =
        List.generate(n - 1, (_) => List.filled(n, ""));

    for (int i = 0; i < n - 1; i++) {
      for (int j = 0; j < n; j++) {
        int opponent = (i + j) % (n - 1);
        if (j == 0) {
          schedule[i][j] = ids[n - 1];
        } else {
          schedule[i][j] = ids[opponent];
        }
      }
    }
    return schedule;
  }

  static Future<void> deleteTournament(String tournamentCode) async {
    var codeExists = await codeExistsInDB(tournamentCode);

    if (!codeExists) {
      throw "";
    }
    DocumentReference<Object?>? doc;
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
                  }
                })
              });
    } catch (error) {
      print(error);
    }

    try {
      final response = FirebaseFirestore.instance
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
      print(error);
    }
  }
}
