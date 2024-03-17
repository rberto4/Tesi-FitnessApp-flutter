import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class SchedaModel {
  final String? nome_scheda;
  final List<Allenamento>? allenamento;

  SchedaModel(
      {required this.nome_scheda,required this.allenamento});

  factory SchedaModel.fromFirestore(Map<dynamic, dynamic> json) => SchedaModel(
      nome_scheda: json["nome_scheda"],
      allenamento:  Allenamento.fromFirestore(json["allenamenti"]) is Iterable
      ? List.from((json["allenamenti"]))
            : null,
  );

  Map<String, Object?> toFirestore() {
    return {
      if (nome_scheda != null) "nome_scheda": nome_scheda,
      if (allenamento != null) "allenamenti": allenamento,

    };
  }
}

class Allenamento {
  final String? giornoSettimana;
  final List<String>? nomi_es;
  final List<String>? serie_es;
  final List<String>? ripetizioni_es;

  Allenamento(
      {required this.nomi_es,
      required this.ripetizioni_es,
      required this.serie_es,
      required this.giornoSettimana
 } );

  factory Allenamento.fromFirestore(Map<dynamic, dynamic> json) => Allenamento(

    giornoSettimana: json['giorno_settimana'],
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
            if (giornoSettimana != null) "giorno_settimana": giornoSettimana,
      if (nomi_es != null) "nomi_esercizi": nomi_es,
      if (serie_es != null) "serie_esercizi": serie_es,
      if (ripetizioni_es != null) "ripetizioni_esercizi": ripetizioni_es,
    };
  }
}

