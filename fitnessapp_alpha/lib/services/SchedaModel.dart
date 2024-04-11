import 'package:cloud_firestore/cloud_firestore.dart';

// OGGETTO MODELLIZZATO PER DB

class Scheda {
  final String? nomeScheda;
  final List<Allenamento>? allenamentiScheda;
  final Timestamp? inizioScheda;
  final Timestamp? fineScheda;
  final String? idScheda;
  final List<Allenamento>? allenamentiSvolti;
  // storico

  Scheda({
    required this.nomeScheda,
    required this.allenamentiScheda,
    required this.inizioScheda,
    required this.fineScheda,
    required this.idScheda,
    required this.allenamentiSvolti,
  });

  factory Scheda.fromFirestore(Map<String, dynamic> json) {

    var list_allenamento = json['allenamentiScheda'] as List;
    List<Allenamento> allenamentiScheda =
        list_allenamento.map((i) => Allenamento.fromFirestore(i)).toList();

    var list_allenamenti_svolti = json['allenamentiSvolti'] as List;
    List<Allenamento> allenamentiSvolti =
        list_allenamenti_svolti.map((i) => Allenamento.fromFirestore(i)).toList();
    return Scheda(
        inizioScheda: json['inizioScheda'],
        fineScheda: json['fineScheda'],
        nomeScheda: json['nomeScheda'],
        idScheda: json['idScheda'],
        allenamentiScheda: allenamentiScheda,
        allenamentiSvolti: allenamentiSvolti);
  }

  Map<String, Object?> toFirestore() {
    return {
      if (nomeScheda != null) "nomeScheda": nomeScheda,
      if (allenamentiScheda != null)
        "allenamentiScheda": allenamentiScheda?.map((e) => e.toFirestore()),
      if (inizioScheda != null) "inizioScheda": inizioScheda,
      if (fineScheda != null) "fineScheda": fineScheda,
      if (idScheda != null) "idScheda": idScheda,
      if (allenamentiSvolti != null)
        "allenamentiSvolti": allenamentiSvolti?.map((e) => e.toFirestore()),
    };
  }
}

class Allenamento {
  final String? nomeAllenamento;
  final List<Esercizio>? listaEsercizi;
  final List<Timestamp>? giorniAssegnati;
  final String? noteAllenamento;
  late  String? feedbackAllenamento;

  // super set
  Allenamento(
      {required this.nomeAllenamento,
      required this.listaEsercizi,
      required this.noteAllenamento,
      required this.giorniAssegnati,
      required this.feedbackAllenamento});

  factory Allenamento.fromFirestore(Map<String, dynamic> json) {
    var _listaEsercizi = json['listaEsercizi'] as List;
    List<Esercizio> listaEsercizi =
        _listaEsercizi.map((i) => Esercizio.fromFirestore(i)).toList();

    return Allenamento(
      feedbackAllenamento: json['feedbackAllenamento'],
      nomeAllenamento: json['nomeAllenamento'],
      noteAllenamento: json['noteAllenamento'],
      giorniAssegnati: json['giorniAssegnati'] is Iterable
          ? List.from(json['giorniAssegnati'])
          : null,
      listaEsercizi: listaEsercizi,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (feedbackAllenamento != null)
        "feedbackAllenamento": feedbackAllenamento,
      if (nomeAllenamento != null) "nomeAllenamento": nomeAllenamento,
      if (noteAllenamento != null) "noteAllenamento": noteAllenamento,
      if (giorniAssegnati != null) "giorniAssegnati": giorniAssegnati,
      if (listaEsercizi != null)
        "listaEsercizi": listaEsercizi?.map((e) => e.toFirestore()),
    };
  }
}

class Esercizio {
  final String? nomeEsercizio;
  final String? serieEsercizio;
  final List<String>? ripetizioniEsercizio;
  final List<String>? carichiEsercizio;
  final int? recuperoEsercizio;

  Esercizio({
    required this.nomeEsercizio,
    required this.serieEsercizio,
    required this.ripetizioniEsercizio,
    required this.carichiEsercizio,
    required this.recuperoEsercizio,
  });

  factory Esercizio.fromFirestore(Map<String, dynamic> json) {
    return Esercizio(
      recuperoEsercizio: json['recuperoEsercizio'],
      nomeEsercizio: json['nomeEsercizio'],
      serieEsercizio: json['serieEsercizio'],
      ripetizioniEsercizio: json['ripetizioniEsercizio'] is Iterable
          ? List.from(json['ripetizioniEsercizio'])
          : null,
      carichiEsercizio: json['carichiEsercizio'] is Iterable
          ? List.from(json['carichiEsercizio'])
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (nomeEsercizio != null) "nomeEsercizio": nomeEsercizio,
      if (recuperoEsercizio != null) "recuperoEsercizio": recuperoEsercizio,
      if (serieEsercizio != null) "serieEsercizio": serieEsercizio,
      if (ripetizioniEsercizio != null)
        "ripetizioniEsercizio": ripetizioniEsercizio,
      if (carichiEsercizio != null) "carichiEsercizio": carichiEsercizio,
    };
  }
}


/*
class EsercizioSvolto extends Esercizio {

  final Timestamp? dataEsecuzione;



  EsercizioSvolto(
      {required super.nomeEsercizio,
      required super.serieEsercizio,
      required super.ripetizioniEsercizio,
      required super.carichiEsercizio,
      required super.recuperoEsercizio,
      required this.dataEsecuzione
      });

  factory EsercizioSvolto.fromFirestore(Map<String, dynamic> json) {
    return EsercizioSvolto(
      recuperoEsercizio: json['recuperoEsercizio'],
      nomeEsercizio: json['nomeEsercizio'],
            dataEsecuzione: json['dataEsecuzione'],
      serieEsercizio: json['serieEsercizio'],
      ripetizioniEsercizio: json['ripetizioniEsercizio'] is Iterable
          ? List.from(json['ripetizioniEsercizio'])
          : null,
      carichiEsercizio: json['carichiEsercizio'] is Iterable
          ? List.from(json['carichiEsercizio'])
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (nomeEsercizio != null) "nomeEsercizio": nomeEsercizio,
      if (dataEsecuzione != null) "dataEsecuzione": dataEsecuzione,
      if (recuperoEsercizio != null) "recuperoEsercizio": recuperoEsercizio,
      if (serieEsercizio != null) "serieEsercizio": serieEsercizio,
      if (ripetizioniEsercizio != null)
        "ripetizioniEsercizio": ripetizioniEsercizio,
      if (carichiEsercizio != null) "carichiEsercizio": carichiEsercizio,
    };
  }
}
*/
