import 'package:app_fitness_test_2/services/SchedaModel.dart';
import 'package:app_fitness_test_2/services/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

const String COLLEZIONE_UTENTI = "users";
const String COLLEZIONE_SCHEDE = "schede";

class DatabaseService {
  late String uid_user_loggato = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseFirestore _instance = FirebaseFirestore.instance;
  late final DocumentReference _doc_reference;

  DatabaseService() {
    _doc_reference = _instance
        .collection(COLLEZIONE_UTENTI)
        .doc(uid_user_loggato)
        .withConverter<UserModel>(
          fromFirestore: UserModel.fromFirestore,
          toFirestore: (um, _) => um.toFirestore(),
        );

    getSchedaCorrente();
  }

  Future getSchedaCorrente() async {
    print("data di adesso:" + Timestamp.now().toString());
    await _instance
        .collection(COLLEZIONE_UTENTI)
        .doc(uid_user_loggato)
        .collection(COLLEZIONE_SCHEDE)
        .where("fineScheda", isGreaterThanOrEqualTo: Timestamp.now())
        .limit(1)
        .get()
        .then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          print('${docSnapshot.id} => ${docSnapshot.data()}');
        }
        return querySnapshot.docs.toList();
      },
      onError: (e) => print("Error completing: $e"),
    );
  }

  Stream<DocumentSnapshot> getDocumentoUtenteStream() {
    return _doc_reference.snapshots();
  }
}
