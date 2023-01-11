import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DetailedUser {
  // Image profilePicture;
  String? id;
  String? name;
  String? rating;
  String? tournamentCode;

  DetailedUser({
    required this.id,
    required this.name,
    required this.rating,
    required this.tournamentCode,
  });

  DetailedUser.fromJSON(Map<String, dynamic> snapshot, String docId) {
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
  DetailedUser? owner;

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
  DetailedUser? white;
  DetailedUser? black;

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

Future<List<DetailedUser>> getTournamentParticipants(
    BuildContext context, String tournamentCode) async {
  List<DetailedUser> participants = List.empty(growable: true);
  var firebaseResponse =
      await FirebaseFirestore.instance.collection('users').get();
  firebaseResponse.docs.forEach(
      (doc) => participants.add(DetailedUser.fromJSON(doc.data(), doc.id)));
  participants
      .removeWhere((element) => element.tournamentCode != tournamentCode);
  return participants;
}

void addUserToDB(DetailedUser user) async {
  var firebaseResponse =
      await FirebaseFirestore.instance.collection('users').add({
    "userId": user.id,
    "name": user.name,
    "rating": user.rating,
    "tournamentCode": user.tournamentCode,
  });
}

Future<DetailedUser?> getUserById(String id) async {
  //TODO Maybe filter this serverside
  DetailedUser? returnVal;
  var firebaseResponse =
      await FirebaseFirestore.instance.collection('users').get();
  firebaseResponse.docs.forEach(
    (doc) {
      if (doc.data()["id"] == id) {
        returnVal = DetailedUser.fromJSON(doc.data(), id);
      }
    },
  );
  return returnVal;
}

Future<DetailedUser?> getUserByName(String name) async {
  //TODO Maybe filter this serverside
  DetailedUser? returnVal;
  var firebaseResponse =
      await FirebaseFirestore.instance.collection('users').get();
  firebaseResponse.docs.forEach(
    (doc) {
      if (doc.data()["name"] == name) {
        returnVal = DetailedUser.fromJSON(doc.data(), doc.id);
      }
    },
  );
  return returnVal;
}

int generateCode() {
  return Random().nextInt(899999) + 100000;
}

Future<String> addTournament(DetailedUser owner) async {
  int code = generateCode();
  while ((await codeExistsInDB(code.toString()))) {
    code = generateCode();
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
      .doc(user.uid)
      .update({"tournamentCode": code});
  return true;
}

Future<http.Response> fetchFromApi(String url) {
  return http.get(Uri.parse(url));
}

Future<DetailedUser> getChessUser(String userName) async {
  var jsonResponse =
      await fetchFromApi("https://api.chess.com/pub/player/$userName/stats");
  if (jsonResponse.statusCode == 200) {
    try {
      var json = jsonDecode(jsonResponse.body);
      DetailedUser user = DetailedUser(
        id: "",
        name: userName,
        rating: json["chess_rapid"]["last"]["rating"].toString(),
        tournamentCode: "",
      );
      return user;
    } catch (error) {
      throw error;
    }
  }
  throw jsonDecode(jsonResponse.body);
}
