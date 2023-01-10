import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class User {
  // Image profilePicture;
  String? id;
  String? name;
  String? rating;
  String? tournamentCode;

  User({
    required this.id,
    required this.name,
    required this.rating,
    required this.tournamentCode,
  });

  User.fromJSON(Map<String, dynamic> snapshot, String docId) {
    id = docId;
    name = snapshot["name"];
    rating = snapshot["rating"];
    tournamentCode = snapshot["tournamentCode"];
  }
}

class Tournament {
  String? id;
  String? code;
  String? state;
  String? format;
  User? owner;

  Tournament({
    required this.id,
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
    var owner = await getUserById(snapshot["black"]);
    return Tournament(
        id: docId, code: code, state: state, format: format, owner: owner);
  }
}

class ChessMatch {
  String? id;
  User? white;
  User? black;

  ChessMatch({
    required this.id,
    required this.white,
    required this.black,
  });

  Future<ChessMatch> fromJSON(Map<String, dynamic> snapshot, String id) async {
    var white = await getUserById(snapshot["white"]);
    var black = await getUserById(snapshot["black"]);
    return ChessMatch(id: id, white: white, black: black);
  }
}

Future<List<User>> getTournamentParticipants(
    BuildContext context, String tournamentCode) async {
  List<User> participants = List.empty(growable: true);
  var firebaseResponse =
      await FirebaseFirestore.instance.collection('users').get();
  firebaseResponse.docs
      .forEach((doc) => participants.add(User.fromJSON(doc.data(), doc.id)));
  participants
      .removeWhere((element) => element.tournamentCode != tournamentCode);
  return participants;
}

Future<User?> getUserById(String id) async {
  //TODO Maybe filter this serverside
  User? returnVal;
  var firebaseResponse =
      await FirebaseFirestore.instance.collection('users').get();
  firebaseResponse.docs.forEach(
    (doc) {
      if (doc.data()["id"] == id) {
        returnVal = User.fromJSON(doc.data(), id);
      }
    },
  );
  return returnVal;
}

Future<User?> getUserByName(String name) async {
  //TODO Maybe filter this serverside
  User? returnVal;
  var firebaseResponse =
      await FirebaseFirestore.instance.collection('users').get();
  firebaseResponse.docs.forEach(
    (doc) {
      if (doc.data()["name"] == name) {
        returnVal = User.fromJSON(doc.data(), doc.id);
      }
    },
  );
  return returnVal;
}

Future<String> addTournament(User owner) async {
  int code = Random().nextInt(899999) + 100000;
  while ((await codeExistsInDB(code.toString()))) {
    code = Random().nextInt(899999) + 100000;
  }

  FirebaseFirestore.instance.collection('tournaments').add({
    "code": code,
    "state": "notStarted",
    "format": "roundRobin",
    "owner": owner.id
  });

  return code.toString();
}

Future<bool> codeExistsInDB(String code) async {
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

Future<bool> addUserToTournament(User user, String code) async {
  var codeExists = await codeExistsInDB(code);

  if (!codeExists) {
    return false;
  }

  FirebaseFirestore.instance
      .collection('users')
      .doc(user.id)
      .update({"tournamentCode": code});
  return true;
}
