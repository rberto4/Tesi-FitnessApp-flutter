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
  late final Query _col_reference_schedacorrente;

  DatabaseService() {
    
  }

/*
  void getSchedaCorrente() async {
    await _instance
        .collection(COLLEZIONE_UTENTI)
        .doc(uid_user_loggato)
        .collection(COLLEZIONE_SCHEDE)
        .where("fineScheda", isGreaterThanOrEqualTo: Timestamp.now())
        .limit(1)
        .get()
        .then(
      (querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          print('${docSnapshot.id} => ${docSnapshot.data()}');
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
  }
*/


// OTTIENI ISTANZA DB FIRESTORE
FirebaseFirestore getInstanceDb(){
  return _instance;
}

String getCollezioneUtenti(){
  return COLLEZIONE_UTENTI;
}

  Stream<DocumentSnapshot> getDocumentoUtenteStream() {
    return _instance
        .collection(COLLEZIONE_UTENTI)
        .doc(uid_user_loggato)
        .withConverter<UserModel>(
          fromFirestore: UserModel.fromFirestore,
          toFirestore: (um, _) => um.toFirestore(),
        ).snapshots();
  }

  Stream<QuerySnapshot> getSchedaCorrente (){
    return _instance
        .collection(COLLEZIONE_UTENTI)
        .doc(uid_user_loggato)
        .collection(COLLEZIONE_SCHEDE)
        .withConverter<SchedaModel>(fromFirestore: (snapshot, options) => SchedaModel.fromFirestore(snapshot.data()!), toFirestore: (value, options) => value.toFirestore(),)
        .where("fineScheda", isGreaterThanOrEqualTo: Timestamp.now())
        .limit(1).snapshots();
  }
}
