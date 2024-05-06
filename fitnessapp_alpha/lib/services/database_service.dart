// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_field

import 'package:app_fitness_test_2/services/ChatModel.dart';
import 'package:app_fitness_test_2/services/SchedaModel.dart';
import 'package:app_fitness_test_2/services/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

const String COLLEZIONE_UTENTI = "users";
const String COLLEZIONE_SCHEDE = "schede";
const String COLLEZIONE_CHAT = "chat";
const String COLLEZIONE_COACHES = "coaches";

class DatabaseService {
  late final FirebaseAuth _auth = FirebaseAuth.instance;
  late String uid_user_loggato = _auth.currentUser!.uid;
  final FirebaseFirestore _instance = FirebaseFirestore.instance;
  late final DocumentReference _doc_reference;
  late final Query _col_reference_schedacorrente;

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

  FirebaseAuth getAuth() {
    return _auth;
  }

  // stream per dettagli documento utente

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
        .limit(1)
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

  Stream<QuerySnapshot> getStreamChat() {
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

  Stream<QuerySnapshot> getStreamConversazione() {
    return _instance
        .collection(COLLEZIONE_UTENTI)
        .doc(uid_user_loggato)
        .collection(COLLEZIONE_SCHEDE)
        .withConverter<Chat>(
          fromFirestore: (snapshot, options) =>
              Chat.fromFirestore(snapshot.data()!),
          toFirestore: (value, options) => value.toFirestore(),
        )
        .snapshots();
  }

  Future<DocumentSnapshot> checkIsCoach() async {
    return await _instance
        .collection(COLLEZIONE_COACHES)
        .doc(_auth.currentUser!.uid)
        .get();
  }
}
