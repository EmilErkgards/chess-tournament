import 'dart:async';
import 'dart:convert';

import 'package:chess_tournament/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:jovial_svg/jovial_svg.dart';

class ChessUser {
  String? docId;
  String? userId;
  String? name;
  String? rating;
  String? tournamentCode;
  String? avatarUrl;

  ChessUser({
    this.docId,
    this.userId,
    required this.name,
    this.rating,
    this.tournamentCode,
    this.avatarUrl,
  });

  ChessUser.fromJSON(Map<String, dynamic> snapshot, String dId) {
    docId = dId;
    userId = snapshot["userId"];
    name = snapshot["name"];
    rating = snapshot["rating"];
    tournamentCode = snapshot["tournamentCode"];
    avatarUrl = snapshot["avatarUrl"];
  }
}

class ChessUserService {
  static late final FirebaseFirestore firebaseInstance;

  static void init(FirebaseFirestore instance) {
    firebaseInstance = instance;
  }

  static Future<DocumentReference<Map<String, dynamic>>> addUserToDB(
      ChessUser user) async {
    return await firebaseInstance.collection('users').add({
      "userId": user.userId,
      "name": user.name,
      "rating": user.rating,
      "tournamentCode": user.tournamentCode,
      "avatarUrl": user.avatarUrl
    });
  }

  static Future<ChessUser?> getUserById(String id) async {
    //TODO Maybe filter this serverside
    ChessUser? returnVal;
    await firebaseInstance
        .collection('users')
        .get()
        .then(
          (value) => value.docs.forEach(
            (doc) {
              if (doc.data()["id"] == id) {
                returnVal = ChessUser.fromJSON(doc.data(), id);
              }
            },
          ),
        )
        .catchError(onError);
    return returnVal;
  }

  static Future<ChessUser?> getUserByName(String name) async {
    //TODO Maybe filter this serverside
    ChessUser? returnVal;
    firebaseInstance
        .collection('users')
        .get()
        .then(
          (value) => value.docs.forEach(
            (element) {
              if (element.data()["name"] == name) {
                returnVal = ChessUser.fromJSON(element.data(), element.id);
              }
            },
          ),
        )
        .catchError(onError);
    return returnVal;
  }

  static Future<ChessUser?> getChessUserByUUID(String uuid) async {
    //TODO Maybe filter this serverside
    ChessUser? returnVal;
    try {
      await firebaseInstance
          .collection('users')
          .get()
          .then((value) => value.docs.forEach(
                (doc) {
                  if (doc.data()["userId"] == uuid) {
                    returnVal = ChessUser.fromJSON(doc.data(), doc.id);
                  }
                },
              ))
          .catchError(onError);
    } catch (error) {
      print(error.toString());
    }
    return returnVal;
  }

  static FutureOr<void> onError(Object object) {
    print(object);
  }

  static Future<http.Response> fetchFromApi(String url) {
    return http.get(Uri.parse(url));
  }

  static Future<ChessUser> createChessUser(String userName) async {
    var jsonProfile =
        await fetchFromApi("https://api.chess.com/pub/player/$userName");
    if (jsonProfile.statusCode == 200) {
      var jsonStats = await fetchFromApi(
          "https://api.chess.com/pub/player/$userName/stats");
      if (jsonStats.statusCode == 200) {
        try {
          var jsonS = jsonDecode(jsonStats.body);
          var jsonP = jsonDecode(jsonProfile.body);
          var avatarUrl = jsonP["avatar"];
          avatarUrl ??=
              "https://www.chess.com/bundles/web/images/user-image.007dad08.svg";

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

  static Widget getAvatarFromUrl(String url) {
    if (url.endsWith(".svg")) {
      return ScalableImageWidget.fromSISource(
          si: ScalableImageSource.fromSvgHttpUrl(Uri.parse(url)));
    } else {
      return Image.network(url);
    }
  }
}
