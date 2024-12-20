// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_field

import 'package:app_fitness_test_2/services/ChatModel.dart';
import 'package:app_fitness_test_2/services/SchedaModel.dart';
import 'package:app_fitness_test_2/services/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

const String COLLEZIONE_UTENTI = "users";
const String COLLEZIONE_SCHEDE = "schede";
const String COLLEZIONE_CHAT = "chat";
const String COLLEZIONE_COACHES = "coach";

class DatabaseService {
  late final FirebaseAuth _auth = FirebaseAuth.instance;
  late String uid_user_loggato = _auth.currentUser!.uid;
  final FirebaseFirestore _instance = FirebaseFirestore.instance;

  DatabaseService();

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

  String getCollezioneSchede() {
    return COLLEZIONE_SCHEDE;
  }

  String getCollezioneChat() {
    return COLLEZIONE_CHAT;
  }

  FirebaseAuth getAuth() {
    return _auth;
  }

  // stream per recuperare l'ultima scheda ricevuta
  Stream<QuerySnapshot> getSchedaCorrente() {
    return _instance
        .collection(COLLEZIONE_UTENTI)
        .doc(uid_user_loggato)
        .collection(COLLEZIONE_SCHEDE)
        .withConverter<Scheda>(
          fromFirestore: (snapshot, options) =>
              Scheda.fromFirestore(snapshot.data()!),
          toFirestore: (value, options) => value.toFirestore(),
        )
        .where("fineScheda", isGreaterThanOrEqualTo: Timestamp.now())
        .snapshots();
  }

  // stream per recuperare elenco di tutte le schede, non faccio query, ordino solo per data

  Stream<QuerySnapshot> getTotaleSchede() {
    return _instance
        .collection(COLLEZIONE_UTENTI)
        .doc(uid_user_loggato)
        .collection(COLLEZIONE_SCHEDE)
        .withConverter<Scheda>(
          fromFirestore: (snapshot, options) =>
              Scheda.fromFirestore(snapshot.data()!),
          toFirestore: (value, options) => value.toFirestore(),
        )
        .orderBy("inizioScheda", descending: true)
        .snapshots();
  }

  Scheda getSchedaById(String id) {
    late Scheda scheda = Scheda(
        nomeScheda: null,
        allenamentiScheda: null,
        inizioScheda: null,
        fineScheda: null,
        idScheda: null,
        allenamentiSvolti: null);

    _instance
        .collection(COLLEZIONE_UTENTI)
        .doc(uid_user_loggato)
        .collection(COLLEZIONE_SCHEDE)
        .withConverter(
          fromFirestore: (snapshot, options) =>
              Scheda.fromFirestore(snapshot.data()!),
          toFirestore: (value, options) => value.toFirestore(),
        )
        .get()
        .then((value) {
      scheda = value.docs.first.data();
    });
    return scheda;
  }

  Stream<QuerySnapshot> getStreamElencoChat() {
    return _instance
        .collection(COLLEZIONE_UTENTI)
        .doc(uid_user_loggato)
        .collection(COLLEZIONE_CHAT)
        .withConverter<Chat>(
          fromFirestore: (snapshot, options) =>
              Chat.fromFirestore(snapshot.data()!),
          toFirestore: (value, options) => value.toFirestore(),
        )
        .snapshots();
  }

  Stream<DocumentSnapshot<Chat>> getStreamConversazione(
      String uid_cliente, String uid_coach) {
    return _instance
        .collection(COLLEZIONE_UTENTI)
        .doc(uid_cliente)
        .collection(COLLEZIONE_CHAT)
        .doc(uid_coach)
        .withConverter<Chat>(
          fromFirestore: (snapshot, options) =>
              Chat.fromFirestore(snapshot.data()!),
          toFirestore: (value, options) => value.toFirestore(),
        )
        .snapshots();
  }

  // ottengo una lista di Coach
  Stream<QuerySnapshot<Coach>> getListaCoach() {
    return _instance
        .collection(COLLEZIONE_COACHES)
        .withConverter<Coach>(
          fromFirestore: (snapshot, options) =>
              Coach.fromFirestore(snapshot.data()!),
          toFirestore: (value, options) => value.toFirestore(),
        )
        .snapshots();
  }

// lista di tutti i dati dei coach - utile per lista tutti i clienti o di esercizi standard creati dal coach
/*
  Stream<DocumentSnapshot<CoachModel>> getStreamCoach() {
    return _instance
        .collection(COLLEZIONE_COACHES)
        .doc(uid_user_loggato)
        .withConverter<CoachModel>(
          fromFirestore: (snapshot, options) =>
              CoachModel.fromFirestore(snapshot.data()!),
          toFirestore: (value, options) => value.toFirestore(),
        )
        .snapshots();
  }
  */

  Future<Coach> getDataCoach() async {
    return _instance
        .collection(COLLEZIONE_COACHES)
        .doc(uid_user_loggato)
        .withConverter<Coach>(
          fromFirestore: (snapshot, options) =>
              Coach.fromFirestore(snapshot.data()!),
          toFirestore: (value, options) => value.toFirestore(),
        )
        .get()
        .then((value) {
      return value.data()!;
    });
  }

  Future<DocumentSnapshot> controlloSeUtenteCoach() async {
    return await _instance
        .collection(COLLEZIONE_COACHES)
        .doc(_auth.currentUser!.uid)
        .get();
  }

  Stream<QuerySnapshot<Cliente>> getListaTotaleClienti() {
    return _instance
        .collection(COLLEZIONE_UTENTI)
        .withConverter<Cliente>(
          fromFirestore: (snapshot, options) =>
              Cliente.fromFirestore(snapshot.data()!),
          toFirestore: (value, options) => value.toFirestore(),
        )
        .snapshots();
  }
}
