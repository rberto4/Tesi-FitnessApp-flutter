import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class SchedaModel {
  final String? nome_scheda;
  final List<Allenamento>? allenamenti;
  final Timestamp? inizio_scheda;
  final Timestamp? fine_scheda;

  SchedaModel(
      {required this.nome_scheda,
      required this.allenamenti,
      required this.inizio_scheda,
      required this.fine_scheda,
      });

  factory SchedaModel.fromFirestore(Map<String, dynamic> json) {
    var list = json['allenamenti'] as List;
    List<Allenamento> allenamentiList =
        list.map((i) => Allenamento.fromFirestore(i)).toList();
    return SchedaModel(
      inizio_scheda: json['inizioScheda'],
      fine_scheda: json['fineScheda'],
      nome_scheda: json['nome_scheda'],
      allenamenti: allenamentiList,
    );
  }

  Map<String, Object?> toFirestore() {
    return {
      if (nome_scheda != null) "nome_scheda": nome_scheda,
      if (allenamenti != null) "allenamenti": allenamenti,
      if (inizio_scheda != null) "inizioScheda": inizio_scheda,
      if (fine_scheda != null) "fineScheda": fine_scheda,
    };
  }
}

class Allenamento {
  final String? nomeAllenamento;
  final List<String>? nomi_es;
  final List<String>? serie_es;
  final List<String>? ripetizioni_es;
    final List<Timestamp>? giorniAssegnati;

  Allenamento(
      {required this.nomi_es,
      required this.ripetizioni_es,
      required this.serie_es,
      required this.nomeAllenamento,
      required this.giorniAssegnati
      });

  factory Allenamento.fromFirestore(Map<dynamic, dynamic> json) => Allenamento(
        nomeAllenamento: json['nomeAllenamento'],
        giorniAssegnati: json['giorniAssegnati'] is Iterable
          ? List.from(json['giorniAssegnati'])
          : null,
        nomi_es:
            json['nomi_Es'] is Iterable ? List.from(json['nomi_Es']) : null,
        serie_es:
            json['serie_Es'] is Iterable ? List.from(json['serie_Es']) : null,
        ripetizioni_es: json['ripetizioni_Es'] is Iterable
            ? List.from(json['ripetizioni_Es'])
            : null,
      );

  Map<String, dynamic> toFirestore() {
    return {
      if (nomeAllenamento != null) "nomeAllenamento": nomeAllenamento,
      if (nomi_es != null) "nomi_Es": nomi_es,
      if (serie_es != null) "serie_Es": serie_es,
      if (ripetizioni_es != null) "ripetizioni_Es": ripetizioni_es,
            if (giorniAssegnati != null) "giorniAssegnati": giorniAssegnati,
    };
  }
}
