// ignore_for_file: unnecessary_const, camel_case_types, unnecessary_new, non_constant_identifier_names, unused_import, must_be_immutable, unnecessary_this, no_logic_in_create_state, prefer_const_constructors

import 'package:app_fitness_test_2/services/ChatModel.dart';
import 'package:app_fitness_test_2/services/UserModel.dart';
import 'package:app_fitness_test_2/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class conversazioneChat extends StatefulWidget {
  CoachModel coachModel;
  String uidDestinatarioCLiente;
  bool mittenteCoach;
  conversazioneChat(
      {super.key,
      required this.coachModel,
      required this.mittenteCoach,
      required this.uidDestinatarioCLiente});

  @override
  State<conversazioneChat> createState() => _conversazioneChatState(
      this.coachModel, this.mittenteCoach, this.uidDestinatarioCLiente);
}

class _conversazioneChatState extends State<conversazioneChat> {
  final DatabaseService _dbs = DatabaseService();
  final TextEditingController _textEditingController = TextEditingController();
  late Chat? chat;
  late CoachModel coachModel;
  bool mittenteCoach;
  String uidDestinatarioCLiente;
  _conversazioneChatState(
      this.coachModel, this.mittenteCoach, this.uidDestinatarioCLiente);

  @override
  void initState() {
    initializeDateFormatting("IT");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mittenteCoach ? Colors.transparent : null,
      resizeToAvoidBottomInset: true,
      appBar: !mittenteCoach
          ? AppBar(
              titleSpacing: 0,
              elevation: 4,
              backgroundColor: Theme.of(context).canvasColor,
              title: Row(
                children: [
                  CircleAvatar(
                    child: Text("AP"),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(coachModel.username!),
                ],
              ),
              automaticallyImplyLeading: true,
            )
          : null,
      body: Column(
        children: [
          StreamBuilder(
            stream: mittenteCoach
                ? _dbs.getStreamConversazione(
                    uidDestinatarioCLiente, _dbs.uid_user_loggato)
                : _dbs.getStreamConversazione(
                    _dbs.uid_user_loggato, coachModel.uid!),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                chat = snapshot.data!.data();
                List<Messaggio> lista_messaggi = new List.empty(growable: true);
                lista_messaggi = chat!.listaMessaggi!.reversed.toList();

                if (lista_messaggi.isNotEmpty) {
                  return Expanded(
                    child: ListView.builder(
                      reverse: true,
                      shrinkWrap: true,
                      itemCount: lista_messaggi.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: lista_messaggi[index].destinatarioUid ==
                                    _dbs.uid_user_loggato
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                            child: Column(
                              mainAxisAlignment:
                                  lista_messaggi[index].destinatarioUid ==
                                          _dbs.getAuth().currentUser!.uid
                                      ? MainAxisAlignment.start
                                      : MainAxisAlignment.end,
                              crossAxisAlignment:
                                  lista_messaggi[index].destinatarioUid ==
                                          _dbs.getAuth().currentUser!.uid
                                      ? CrossAxisAlignment.start
                                      : CrossAxisAlignment.end,
                              children: [
                                Card(
                                  color:
                                      (lista_messaggi[index].destinatarioUid ==
                                              _dbs.getAuth().currentUser!.uid)
                                          ? Theme.of(context).dividerColor
                                          : Theme.of(context).primaryColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: const Radius.circular(48),
                                          topRight: const Radius.circular(48),
                                          bottomLeft: Radius.circular(
                                              lista_messaggi[index]
                                                          .destinatarioUid ==
                                                      _dbs
                                                          .getAuth()
                                                          .currentUser!
                                                          .uid
                                                  ? 0
                                                  : 48),
                                          bottomRight: Radius.circular(
                                              lista_messaggi[index]
                                                          .destinatarioUid !=
                                                      _dbs
                                                          .getAuth()
                                                          .currentUser!
                                                          .uid
                                                  ? 0
                                                  : 48))),
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width /
                                              1.5,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            lista_messaggi[index]!.testo!,
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: (lista_messaggi[index]
                                                            .destinatarioUid ==
                                                        _dbs
                                                            .getAuth()
                                                            .currentUser!
                                                            .uid)
                                                    ? null
                                                    : Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    child: Text(
                                        DateFormat('d MMM HH:mm', "iT").format(
                                            lista_messaggi[index]
                                                .dataInvio!
                                                .toDate()),
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Theme.of(context).hintColor,
                                        )))
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return Expanded(
                      child: Center(
                          child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              direction: Axis.vertical,
                              children: [
                        const SizedBox(
                          height: 64,
                        ),
                        Icon(
                          Icons.message_rounded,
                          size: 108,
                          color: Theme.of(context).hintColor.withOpacity(0.3),
                        ),
                        Text("Nessun messaggio",
                            style: TextStyle(
                                fontSize: 24,
                                color: Theme.of(context)
                                    .hintColor
                                    .withOpacity(0.3),
                                fontWeight: FontWeight.bold)),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          "Inizia una conversazione, scrivendo un messaggio",
                          style: TextStyle(
                              fontSize: 16,
                              color:
                                  Theme.of(context).hintColor.withOpacity(0.3),
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ])));
                }
              } else {
                return const Expanded(
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    maxLines: 5,
                    minLines: 1,
                    decoration: const InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                        filled: true,
                        hintText: "Scrivi un messaggio..."),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                FloatingActionButton(
                  backgroundColor: Theme.of(context).primaryColor,
                  onPressed: () {
                    _textEditingController.text.isNotEmpty
                        ? inviaMessaggio(
                            _textEditingController.text,
                            !mittenteCoach
                                ? coachModel.uid!
                                : uidDestinatarioCLiente,
                            Timestamp.now())
                        : null;
                  },
                  child: const Icon(Icons.send_rounded),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void inviaMessaggio(
      String text, String uid_destinatario, Timestamp timestamp) {
    Messaggio messaggio = Messaggio(
        testo: text, dataInvio: timestamp, destinatarioUid: uid_destinatario);
    chat!.listaMessaggi!.add(messaggio);
    _dbs
        .getInstanceDb()
        .collection(_dbs.getCollezioneUtenti())
        .doc(mittenteCoach ? uidDestinatarioCLiente : _dbs.uid_user_loggato)
        .collection(_dbs.getCollezioneChat())
        .doc(mittenteCoach ? _dbs.uid_user_loggato : uid_destinatario)
        .set(chat!.toFirestore(), SetOptions(mergeFields: ['listaMessaggi']));

    _textEditingController.clear();
  }
}
