import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class SchedaModel {
  final String? nome_scheda;
  final List<Lunedi>? lunedi;
  SchedaModel({
    required this.nome_scheda,
    required this.lunedi
  });


 factory SchedaModel.fromFirestore(Map<dynamic, dynamic> json) => SchedaModel(
          nome_scheda: json["nome_scheda"],
      lunedi: json['lunedi'] is Iterable 
      ? List.from(Lunedi.fromFirestore(json['lunedi']) as Iterable): null
     );

  Map<String, Object?> toFirestore() {
    return {
      if (nome_scheda != null) "nome_scheda": nome_scheda,
            if (lunedi != null) "lunedi": lunedi,
    };
  }
}

class Lunedi {
  final List<String>? nomi_es;
  final List<String>? serie_es;
  final List<String>? ripetizioni_es;

  Lunedi(
      {required this.nomi_es,
      required this.ripetizioni_es,
      required this.serie_es});


factory Lunedi.fromFirestore(Map<dynamic, dynamic> json) => Lunedi(
   nomi_es: json?['nomi_esercizi'] is Iterable
          ? List.from(json?['nomi_esercizi'])
          : null,
      serie_es: json?['serie_esercizi'] is Iterable
          ? List.from(json?['serie_esercizi'])
          : null,
      ripetizioni_es: json?['ripetizioni_esercizi'] is Iterable
          ? List.from(json?['ripetizioni_esercizi'])
          : null,
  );


  Map<String, dynamic> toFirestore() {
    return {
      if (nomi_es != null) "nomi_esercizi": nomi_es,
      if (serie_es != null) "serie_esercizi": serie_es,
      if (ripetizioni_es != null) "ripetizioni_esercizi": ripetizioni_es,
    };
  }
}

  class Martedi {
  final List<String>? nomi_es;
  final List<String>? serie_es;
  final List<String>? ripetizioni_es;

  Martedi(
      {required this.nomi_es,
      required this.ripetizioni_es,
      required this.serie_es});


factory Martedi.fromFirestore(Map<dynamic, dynamic> json) => Martedi(
   nomi_es: json?['nomi_esercizi'] is Iterable
          ? List.from(json?['nomi_esercizi'])
          : null,
      serie_es: json?['serie_esercizi'] is Iterable
          ? List.from(json?['serie_esercizi'])
          : null,
      ripetizioni_es: json?['ripetizioni_esercizi'] is Iterable
          ? List.from(json?['ripetizioni_esercizi'])
          : null,
  );


  Map<String, dynamic> toFirestore() {
    return {
      if (nomi_es != null) "nomi_esercizi": nomi_es,
      if (serie_es != null) "serie_esercizi": serie_es,
      if (ripetizioni_es != null) "ripetizioni_esercizi": ripetizioni_es,
    };
  }
}
