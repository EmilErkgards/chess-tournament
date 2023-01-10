import 'package:chess_tournament/src/frontend/pages/tournament_lobby.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<List<TournamentParticipant>> getTournamentParticipants(
    BuildContext context, String tournamentCode) async {
  List<TournamentParticipant> participants = List.empty(growable: true);
  var fgahusf = await FirebaseFirestore.instance.collection('test').get();
  fgahusf.docs.forEach((doc) => {
        print(doc.id),
        participants.add(TournamentParticipant.fromJSON(doc.data(), doc.id))
      });
  return participants;
}
