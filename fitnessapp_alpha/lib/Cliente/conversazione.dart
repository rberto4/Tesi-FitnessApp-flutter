import 'package:app_fitness_test_2/services/ChatModel.dart';
import 'package:app_fitness_test_2/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class conversazioneChat extends StatefulWidget {
  const conversazioneChat({super.key});

  @override
  State<conversazioneChat> createState() => _conversazioneChatState();
}

class _conversazioneChatState extends State<conversazioneChat> {
  DatabaseService _dbs = DatabaseService();
  TextEditingController _textEditingController = TextEditingController();
  late Chat? chat;

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
            const SizedBox(
              width: 8,
            ),
            Expanded(child: Text("Andrea Presti")),
          ],
        ),
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          StreamBuilder(
            stream: _dbs.getStreamConversazione("coach"),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                chat = snapshot.data!.data();
                print(chat);
                List<Messaggio> lista_messaggi = new List.empty(growable: true);
                lista_messaggi = chat!.listaMessaggi!.reversed.toList();
                return Expanded(
                  child: ListView.builder(
                    reverse: true,
                    shrinkWrap: true,
                    itemCount: lista_messaggi.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Align(
                          alignment: lista_messaggi[index].destinatarioUid ==
                                  _dbs.getAuth().currentUser!.uid
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Card(
                            color: (lista_messaggi[index].destinatarioUid !=
                                    _dbs.getAuth().currentUser!.uid)
                                ? Theme.of(context).dividerColor
                                : Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(48),
                                    topRight: Radius.circular(48),
                                    bottomLeft: Radius.circular(
                                        lista_messaggi[index].destinatarioUid !=
                                                _dbs.getAuth().currentUser!.uid
                                            ? 0
                                            : 48),
                                    bottomRight: Radius.circular(
                                        lista_messaggi[index].destinatarioUid ==
                                                _dbs.getAuth().currentUser!.uid
                                            ? 0
                                            : 48))),
                            child: Flexible(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width / 1.5,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        lista_messaggi[index]!.testo!,
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: (lista_messaggi[index]
                                                        .destinatarioUid !=
                                                    _dbs
                                                        .getAuth()
                                                        .currentUser!
                                                        .uid)
                                                ? null
                                                : Colors.white),
                                      ),
                                      Text(
                                        DateFormat('d MMM HH:mm', "iT").format(
                                            lista_messaggi[index]
                                                .dataInvio!
                                                .toDate()),
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: (lista_messaggi[index]
                                                        .destinatarioUid !=
                                                    _dbs
                                                        .getAuth()
                                                        .currentUser!
                                                        .uid)
                                                ? null
                                                : Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else {
                return Expanded(
                  child: Center(
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
                    decoration: InputDecoration(
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
                    inviaMessaggio(_textEditingController.text,
                        _dbs.getAuth().currentUser!.uid, Timestamp.now());
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
    Messaggio messaggio =
        Messaggio(testo: text, dataInvio: timestamp, destinatarioUid: uid);
    chat!.listaMessaggi!.add(messaggio);
    _dbs
        .getInstanceDb()
        .collection(_dbs.getCollezioneUtenti())
        .doc(_dbs.getAuth().currentUser!.uid)
        .collection(_dbs.getCollezioneChat())
        .doc("coach")
        .set(chat!.toFirestore(), SetOptions(mergeFields: ['listaMessaggi']));
    _textEditingController.clear();
  }
}
