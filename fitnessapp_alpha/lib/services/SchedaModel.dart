
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
      inizio_scheda: json['inizio_scheda'],
      fine_scheda: json['fine_scheda'],
      nome_scheda: json['nome_scheda'],
      allenamenti: allenamentiList,
    );
  }

  Map<String, Object?> toFirestore() {

        return {
      if (nome_scheda != null) "nome_scheda": nome_scheda,
      if (allenamenti != null) "allenamenti": allenamenti?.map((e) => e.toFirestore()) ,
      if (inizio_scheda != null) "inizio_scheda": inizio_scheda,
      if (fine_scheda != null) "fine_scheda": fine_scheda,
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
        nomeAllenamento: json['nome_allenamento'],
        giorniAssegnati: json['giorni_assegnati'] is Iterable
          ? List.from(json['giorni_assegnati'])
          : null,
        nomi_es:
            json['nomi_esercizi'] is Iterable ? List.from(json['nomi_esercizi']) : null,
        serie_es:
            json['serie_esercizi'] is Iterable ? List.from(json['serie_esercizi']) : null,
        ripetizioni_es: json['ripetizioni_esercizi'] is Iterable
            ? List.from(json['ripetizioni_esercizi'])
            : null,
      );

  Map<String, dynamic> toFirestore() {
    return {
      if (nomeAllenamento != null) "nome_allenamento": nomeAllenamento,
      if (nomi_es != null) "nomi_esercizi": nomi_es,
      if (serie_es != null) "serie_esercizi": serie_es,
      if (ripetizioni_es != null) "ripetizioni_esercizi": ripetizioni_es,
      if (giorniAssegnati != null) "giorni_assegnati": giorniAssegnati,
    };
  }
}
