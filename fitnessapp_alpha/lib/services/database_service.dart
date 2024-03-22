import 'package:app_fitness_test_2/services/SchedaModel.dart';
import 'package:app_fitness_test_2/services/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

const String COLLEZIONE_UTENTI = "users";
const String COLLEZIONE_SCHEDE = "schede";
const String COLLEZIONE_COACHES = "coaches";

class DatabaseService {

  late final FirebaseAuth _auth;
  late String uid_user_loggato = _auth.currentUser!.uid;
  late final FirebaseFirestore _instance;
  late final DocumentReference _doc_reference;
  late final Query _col_reference_schedacorrente;

  DatabaseService() {

    _auth = FirebaseAuth.instance;
     _instance = FirebaseFirestore.instance;
     
  }



// OTTIENI ISTANZA DB FIRESTORE
  FirebaseFirestore getInstanceDb() {
    return _instance;
  }

  String getCollezioneUtenti() {
    return COLLEZIONE_UTENTI;
  }

  String getCollezioneCoaches() {
    return COLLEZIONE_COACHES;
  }

  FirebaseAuth getAuth (){
    return _auth;
  }

  Stream<DocumentSnapshot> getDocumentoUtenteStream() {
    return _instance
        .collection(COLLEZIONE_UTENTI)
        .doc(uid_user_loggato)
        .withConverter<UserModel>(
          fromFirestore: UserModel.fromFirestore,
          toFirestore: (um, _) => um.toFirestore(),
        )
        .snapshots();
  }

  Stream<QuerySnapshot> getSchedaCorrente() {

    return _instance
        .collection(COLLEZIONE_UTENTI)
        .doc(uid_user_loggato)
        .collection(COLLEZIONE_SCHEDE)
        .withConverter<SchedaModel>(
          fromFirestore: (snapshot, options) =>
              SchedaModel.fromFirestore(snapshot.data()!),
          toFirestore: (value, options) => value.toFirestore(),
        )
        .where("fineScheda", isGreaterThanOrEqualTo: Timestamp.now())
        .limit(1)
        .snapshots();
  }

  Stream<QuerySnapshot> getTotaleSchede() {
    return _instance
        .collection(COLLEZIONE_UTENTI)
        .doc(uid_user_loggato)
        .collection(COLLEZIONE_SCHEDE)
        .withConverter<SchedaModel>(
          fromFirestore: (snapshot, options) =>
              SchedaModel.fromFirestore(snapshot.data()!),
          toFirestore: (value, options) => value.toFirestore(),
        )
        .orderBy("inizioScheda", descending: true)
        .snapshots();
  }

  void assegnazioneAutomaticaGiorniAllenamento(){
   
  }

  Future<DocumentSnapshot> isCoach() async {

    // va a guardare nella collezione dei coaches, se esiste il docuemento relativo all'utente loggato, allora è un coach e returna true
    DocumentReference doc = _instance.collection(COLLEZIONE_COACHES).doc(_auth.currentUser?.uid);
    DocumentSnapshot ds = await doc.get(); 
    print(ds.exists.toString());
    return ds;
    
    }
}
