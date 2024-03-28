import 'package:cloud_firestore/cloud_firestore.dart';

class SchedaModel {
  final String? nome_scheda;
  final List<Allenamento>? allenamenti;
  final Timestamp? inizio_scheda;
  final Timestamp? fine_scheda;
  final List<esercizio>? storico_esercizi;
  final String? id_scheda;

  SchedaModel({
    required this.nome_scheda,
    required this.allenamenti,
    required this.inizio_scheda,
    required this.fine_scheda,
    required this.storico_esercizi,
    required this.id_scheda,
  });

  factory SchedaModel.fromFirestore(Map<String, dynamic> json) {
    var list_allenamento = json['allenamenti'] as List;
    List<Allenamento> allenamentiList =
        list_allenamento.map((i) => Allenamento.fromFirestore(i)).toList();

    var list_storico = json['storico_esercizi'] as List;
    List<esercizio> storico_esercizi_list =
        list_storico.map((i) => esercizio.fromFirestore(i)).toList();

    return SchedaModel(
        inizio_scheda: json['inizio_scheda'],
        fine_scheda: json['fine_scheda'],
        nome_scheda: json['nome_scheda'],
        id_scheda: json['id_scheda'],
        allenamenti: allenamentiList,
        storico_esercizi: storico_esercizi_list);
  }

  Map<String, Object?> toFirestore() {
    return {
      if (nome_scheda != null) "nome_scheda": nome_scheda,
      if (allenamenti != null)
        "allenamenti": allenamenti?.map((e) => e.toFirestore()),
      if (inizio_scheda != null) "inizio_scheda": inizio_scheda,
      if (fine_scheda != null) "fine_scheda": fine_scheda,
      if (id_scheda != null) "id_scheda": id_scheda,
      if (storico_esercizi != null)
        "storico_esercizi": storico_esercizi?.map((e) => e.toFirestore()),
    };
  }
}

class Allenamento {
  final String? nomeAllenamento;
  final List<String>? nomi_es;
  final List<String>? serie_es;
  final List<String>? ripetizioni_es;
  final List<Timestamp>? giorniAssegnati;
  //final List<Carico>? carichi;

  Allenamento({
    required this.nomi_es,
    required this.ripetizioni_es,
    required this.serie_es,
    required this.nomeAllenamento,
    required this.giorniAssegnati,
    // required this.carichi
  });

  factory Allenamento.fromFirestore(Map<String, dynamic> json) {
    /*  var list = json['carichi'] as List;
    List<Carico> carichilist =
        list.map((i) => Carico.fromFirestore(i)).toList();
        */
    return Allenamento(
      nomeAllenamento: json['nome_allenamento'],
      nomi_es: json['nomi_esercizi'] is Iterable
          ? List.from(json['nomi_esercizi'])
          : null,
      ripetizioni_es: json['ripetizioni_esercizi'] is Iterable
          ? List.from(json['ripetizioni_esercizi'])
          : null,
      serie_es: json['serie_esercizi'] is Iterable
          ? List.from(json['serie_esercizi'])
          : null,
      giorniAssegnati: json['giorni_assegnati'] is Iterable
          ? List.from(json['giorni_assegnati'])
          : null,
      //carichi: carichilist,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (nomeAllenamento != null) "nome_allenamento": nomeAllenamento,
      if (nomi_es != null) "nomi_esercizi": nomi_es,
      if (serie_es != null) "serie_esercizi": serie_es,
      if (ripetizioni_es != null) "ripetizioni_esercizi": ripetizioni_es,
      if (giorniAssegnati != null) "giorni_assegnati": giorniAssegnati,
      //if (carichi != null) "carichi": carichi?.map((e) => e.toFirestore()) ,
    };
  }
}

class Carico {
  final List<String>? carichi_es;
  Carico({required this.carichi_es});
  factory Carico.fromFirestore(Map<dynamic, dynamic> json) => Carico(
        carichi_es: json['carichi_esercizi'] is Iterable
            ? List.from(json['carichi_esercizi'])
            : null,
      );

  Map<String, dynamic> toFirestore() {
    return {
      if (carichi_es != null) "carichi_esercizi": carichi_es,
    };
  }
}

class esercizio {
  final String nome_esercizio;
  final String carico;
  final Timestamp? giorno_esecuzione;

  esercizio({
    required this.nome_esercizio,
    required this.carico,
    required this.giorno_esecuzione,
  });

  factory esercizio.fromFirestore(Map<String, dynamic> json) {
    return esercizio(
      nome_esercizio: json['nome_esercizio'],
      carico: json['carico'],
      giorno_esecuzione: json['giorno_esecuzione'],
    );
  }

  Map<String, Object?> toFirestore() {
    return {
      if (nome_esercizio != null) "nome_esercizio": nome_esercizio,
      if (carico != null) "carico": carico,
      if (giorno_esecuzione != null) "giorno_esecuzione": giorno_esecuzione,
    };
  }
}
