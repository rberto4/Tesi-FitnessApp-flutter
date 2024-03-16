import 'package:cloud_firestore/cloud_firestore.dart';

class SchedaModel {
  String? nome_scheda;
  Lunedi? lunedi;
  SchedaModel({
    required this.nome_scheda,
    required this.lunedi
  });

  factory SchedaModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return SchedaModel(
      nome_scheda: data?["nome_scheda"],
      lunedi: Lunedi.fromFirestore(data?["lunedi"],options)
    );
  }

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

  factory Lunedi.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Lunedi(
      nomi_es: data?['nomi_esercizi'] is Iterable
          ? List.from(data?['nomi_esercizi'])
          : null,
      serie_es: data?['serie_esercizi'] is Iterable
          ? List.from(data?['serie_esercizi'])
          : null,
      ripetizioni_es: data?['ripetizioni_esercizi'] is Iterable
          ? List.from(data?['ripetizioni_esercizi'])
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (nomi_es != null) "nomi_esercizi": nomi_es,
      if (serie_es != null) "serie_esercizi": serie_es,
      if (ripetizioni_es != null) "ripetizioni_esercizi": ripetizioni_es,
    };
  }
}
