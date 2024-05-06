import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  List<Messaggio>? listaMessaggi;
  String? destinatarioUid;

  Chat({
    required this.listaMessaggi,
    required this.destinatarioUid,
  });

  factory Chat.fromFirestore(Map<String, dynamic> json) {
    return Chat(
      listaMessaggi: json['listaMessaggi'] is Iterable
          ? List.from(json['listaMessaggi'])
          : null,
      destinatarioUid: json['destinatarioUid'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (listaMessaggi != null) "listaMessaggi": listaMessaggi,
      if (destinatarioUid != null) "destinatarioUid": destinatarioUid,
    };
  }
}

class Messaggio {
  String? testo;
  Timestamp? dataInvio;

  Messaggio({
    required this.testo,
    required this.dataInvio,
  });

  factory Messaggio.fromFirestore(Map<String, dynamic> json) {
    return Messaggio(
      testo: json['testo'],
      dataInvio: json['dataInvio'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (testo != null) "testo": testo,
      if (dataInvio != null) "dataInvio": dataInvio,
    };
  }
}
