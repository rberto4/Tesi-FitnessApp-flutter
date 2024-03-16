import 'package:app_fitness_test_2/services/schedaModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

String COLLEZIONE = "clienti";

class DatabaseService {
  final FirebaseFirestore _instance = FirebaseFirestore.instance;
  late final CollectionReference _reference;

  DatabaseService() {
    _reference = _instance.collection(COLLEZIONE).withConverter<schedaModel>(
          fromFirestore: schedaModel.fromFirestore,
          toFirestore: (schedaModel, _) => schedaModel.toFirestore(),
        );

        getListaDocuments();
  }

  Stream<QuerySnapshot> getScheda() {
    return _reference.get().asStream();
  }

  void getListaDocuments() async {
    final docSnap = await _reference.get();
    final schedaModel = docSnap.docs.map((e) => docSnap.docs.toList()); // Convert to City object
    if (schedaModel != null) {
      print(schedaModel.first);
    } else {
      print("No such document.");
    }
  }

  void addScheda(schedaModel schedaModel) async {
    _reference.add(schedaModel);
  }
}
