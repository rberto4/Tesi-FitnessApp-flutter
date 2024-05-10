// ignore_for_file: unnecessary_const, camel_case_types, unnecessary_new, non_constant_identifier_names

import 'package:app_fitness_test_2/services/ChatModel.dart';
import 'package:app_fitness_test_2/services/UserModel.dart';
import 'package:app_fitness_test_2/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class conversazioneChat extends StatefulWidget {

  CoachModel coachModel;
  conversazioneChat({super.key, required this.coachModel});

  @override
  State<conversazioneChat> createState() => _conversazioneChatState(this.coachModel);
}

class _conversazioneChatState extends State<conversazioneChat> {
  final DatabaseService _dbs = DatabaseService();
  final TextEditingController _textEditingController = TextEditingController();
  late Chat? chat;
  late CoachModel coachModel;
  _conversazioneChatState(this.coachModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
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
      ),
      body: Column(
        children: [
          StreamBuilder(
            stream: _dbs.getStreamConversazione(coachModel.uid!),
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
                                      padding: const EdgeInsets.all(24.0),
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
                        ? inviaMessaggio(_textEditingController.text,
                            coachModel.uid!, Timestamp.now())
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

  void inviaMessaggio(String text, String uid, Timestamp timestamp) {
    Messaggio messaggio = Messaggio(testo: text, dataInvio: timestamp, destinatarioUid: uid);
    chat!.listaMessaggi!.add(messaggio);
    _dbs
        .getInstanceDb()
        .collection(_dbs.getCollezioneUtenti())
        .doc(_dbs.getAuth().currentUser!.uid)
        .collection(_dbs.getCollezioneChat())
        .doc(uid)
        .set(chat!.toFirestore(), SetOptions(mergeFields: ['listaMessaggi']));
    _textEditingController.clear();
  }

  void creaDocumento() {}
}
