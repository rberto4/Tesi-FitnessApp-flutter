// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  List<Messaggio>? listaMessaggi;

  Chat({
    required this.listaMessaggi,
  });

  factory Chat.fromFirestore(Map<String, dynamic> json) {
    var listaMessaggi = json['listaMessaggi'] as List;
    List<Messaggio> listaMessagiLocal =
        listaMessaggi.map((i) => Messaggio.fromFirestore(i)).toList();

    return Chat(listaMessaggi: listaMessagiLocal);
  }

  Map<String, dynamic> toFirestore() {
    // stream per dettagli documento utente

    return {
      if (listaMessaggi != null)
        "listaMessaggi": listaMessaggi?.map((e) => e.toFirestore()),
    };
  }
}

class Messaggio {
  String? testo;
  Timestamp? dataInvio;
  String? destinatarioUid;

  Messaggio({
    required this.testo,
    required this.dataInvio,
    required this.destinatarioUid,
  });

  factory Messaggio.fromFirestore(Map<String, dynamic> json) {
    return Messaggio(
      testo: json['testo'],
      dataInvio: json['dataInvio'],
      destinatarioUid: json['destinatarioUid'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (testo != null) "testo": testo,
      if (dataInvio != null) "dataInvio": dataInvio,
      if (destinatarioUid != null) "destinatarioUid": destinatarioUid,
    };
  }
}
