import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

String root_mappa_schede = "{}";

class Esercizio {
  final String? nome;
  final String? ripetizioni;
  final String? serie;
  final String? recupero;
  final String? carico;

  Esercizio({
    this.nome,
    this.ripetizioni,
    this.serie,
    this.recupero,
    this.carico,
  });

  factory Esercizio.recuperaMappaDaDb(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Esercizio(
      nome: data?['nome'],
      ripetizioni: data?['ripetizioni'],
      serie: data?['serie'],
      recupero: data?['recupero'],
      carico: data?['carico'],
    );
  }

  Map<String, dynamic> creaMappaPerDb() {
    return {
      if (nome != null) "nome": nome,
      if (ripetizioni != null) "ripetizioni": ripetizioni,
      if (serie != null) "serie": serie,
      if (recupero != null) "recupero": recupero,
      if (carico != null) "carico": carico,
    };
  }

  String? getNome() {
    return Esercizio().nome;
  }
}
