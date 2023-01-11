import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChessUser {
  String? docId;
  String? uuid;
  String? name;
  String? rating;
  String? tournamentCode;
  String? avatarUrl;

  ChessUser({
    this.docId,
    this.uuid,
    required this.name,
    this.rating,
    this.tournamentCode,
    this.avatarUrl,
  });

  ChessUser.fromJSON(Map<String, dynamic> snapshot, String dId) {
    docId = dId;
    uuid = snapshot["uuid"];
    name = snapshot["name"];
    rating = snapshot["rating"];
    tournamentCode = snapshot["tournamentCode"];
    avatarUrl = snapshot["avatarUrl"];
  }
}

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
    var owner = await getUserById(snapshot["black"]);
    return Tournament(
        docId: docId, code: code, state: state, format: format, owner: owner);
  }
}

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
    var white = await getUserById(snapshot["white"]);
    var black = await getUserById(snapshot["black"]);
    return ChessMatch(docId: id, white: white, black: black);
  }
}

Future<List<ChessUser>> getTournamentParticipants(
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

Future<DocumentReference<Map<String, dynamic>>> addUserToDB(
    ChessUser user) async {
  return await FirebaseFirestore.instance.collection('users').add({
    "userId": user.uuid,
    "name": user.name,
    "rating": user.rating,
    "tournamentCode": user.tournamentCode,
    "avatarUrl": user.avatarUrl
  });
}

Future<ChessUser?> getUserById(String id) async {
  //TODO Maybe filter this serverside
  ChessUser? returnVal;
  var firebaseResponse =
      await FirebaseFirestore.instance.collection('users').get();
  firebaseResponse.docs.forEach(
    (doc) {
      if (doc.data()["id"] == id) {
        returnVal = ChessUser.fromJSON(doc.data(), id);
      }
    },
  );
  return returnVal;
}

Future<ChessUser?> getUserByName(String name) async {
  //TODO Maybe filter this serverside
  ChessUser? returnVal;
  var firebaseResponse =
      await FirebaseFirestore.instance.collection('users').get();
  firebaseResponse.docs.forEach(
    (doc) {
      if (doc.data()["name"] == name) {
        returnVal = ChessUser.fromJSON(doc.data(), doc.id);
      }
    },
  );
  return returnVal;
}

Future<ChessUser?> getChessUserByUUID(String uuid) async {
  //TODO Maybe filter this serverside
  ChessUser? returnVal;
  var firebaseResponse =
      await FirebaseFirestore.instance.collection('users').get();
  firebaseResponse.docs.forEach(
    (doc) {
      if (doc.data()["userId"] == uuid) {
        returnVal = ChessUser.fromJSON(doc.data(), doc.id);
      }
    },
  );
  return returnVal;
}

int generateCode() {
  return Random().nextInt(899999) + 100000;
}

Future<String> addTournament(ChessUser owner) async {
  int code = generateCode();
  while ((await codeExistsInDB(code.toString()))) {
    code = generateCode();
  }

  FirebaseFirestore.instance.collection('tournaments').add({
    "code": code,
    "state": "notStarted",
    "format": "roundRobin",
    "owner": owner.uuid
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

  var dUser = await getChessUserByUUID(user.uid);
  if (dUser == null) throw "Could not find chess user with uuid: " + user.uid;
  try {
    FirebaseFirestore.instance
        .collection('users')
        .doc(dUser.docId)
        .update({"tournamentCode": code});
  } catch (error) {
    rethrow;
  }
  return true;
}

Future<http.Response> fetchFromApi(String url) {
  return http.get(Uri.parse(url));
}

Future<ChessUser> createChessUser(String userName) async {
  var jsonProfile =
      await fetchFromApi("https://api.chess.com/pub/player/$userName");
  if (jsonProfile.statusCode == 200) {
    var jsonStats =
        await fetchFromApi("https://api.chess.com/pub/player/$userName/stats");
    if (jsonStats.statusCode == 200) {
      try {
        var jsonS = jsonDecode(jsonStats.body);
        var jsonP = jsonDecode(jsonProfile.body);
        var avatarUrl = jsonP["avatar"];
        avatarUrl ??=
            "https://images.chesscomfiles.com/uploads/v1/images_users/tiny_mce/Inexperienced42/phpRwn5UJ.png";

        ChessUser user = ChessUser(
            name: userName,
            rating: jsonS["chess_rapid"]["last"]["rating"].toString(),
            avatarUrl: avatarUrl);
        return user;
      } catch (error) {
        rethrow;
      }
    } else {
      throw jsonDecode(jsonStats.body);
    }
  } else {
    throw jsonDecode(jsonProfile.body);
  }
}
