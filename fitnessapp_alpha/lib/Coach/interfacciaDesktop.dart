// ignore_for_file: file_names, prefer_const_constructors, camel_case_types, unnecessary_import, unnecessary_late, prefer_const_constructors_in_immutables, non_constant_identifier_names, sized_box_for_whitespace, must_be_immutable

import 'package:app_fitness_test_2/Cliente/conversazione.dart';
import 'package:app_fitness_test_2/autenticazione/login.dart';
import 'package:app_fitness_test_2/autenticazione/metodi_autenticazione.dart';
import 'package:app_fitness_test_2/services/ChatModel.dart';
import 'package:app_fitness_test_2/services/SchedaModel.dart';
import 'package:app_fitness_test_2/services/UserModel.dart';
import 'package:app_fitness_test_2/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomeDesktop extends StatelessWidget {
  CoachModel coach = CoachModel(
      listaClientiSeguiti: null,
      listaEserciziStandard: null,
      username: null,
      email: null);
  DatabaseService _dbs = DatabaseService();

  HomeDesktop({super.key});

  Future<void> ottieniDati() async {
    coach = await _dbs.getDataCoach();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ottieniDati(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (!snapshot.hasData) {
          return paginaPrincipale(
            coach: coach,
            dbs: _dbs,
          );
        } else {
          return const Center(
              child: Text(
                  "Problema di connessione, prova a ricaricare la pagina"));
        }
      },
    );
  }
}

class paginaPrincipale extends StatefulWidget {
  late CoachModel coach;
  late DatabaseService dbs;
  paginaPrincipale({super.key, required this.coach, required this.dbs});

  @override
  State<paginaPrincipale> createState() => _paginaPrincipaleState(coach, dbs);
}

class _paginaPrincipaleState extends State<paginaPrincipale> {
  late CoachModel coach;
  late DatabaseService _dbs;
  int _indexDrawer = 0;
  int _indexCliente = 0;
  int _indexTabcliente = 0;
  bool drawerEspanso = true;
  bool _chatVisibile = false;
  double larghezzaDrawer = 200;

  late conversazioneChat chat;

  TextEditingController cercaClientiTextEditController =
      TextEditingController();

  SchedaTextEditController schedaTextEditController = SchedaTextEditController(
      TextEditController: TextEditingController(),
      listaAllenamentiTextEditController: List.from([
        AllenamentoTextEditController(
            TextEditController: TextEditingController(),
            listaEserciziTextEditController: List.from([
              EsercizioTextEditController(
                  TextEditControllerNome: TextEditingController(),
                  TextEditControllerSerie: TextEditingController(),
                  TextEditControllerRipetizioni: TextEditingController(),
                  TextEditControllerRecupero: TextEditingController(),
                  TextEditControllerNote: TextEditingController())
            ], growable: true))
      ], growable: true),
      inizioScheda: null,
      fineScheda: null);

  _paginaPrincipaleState(this.coach, this._dbs);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Row(
        children: [
          AnimatedContainer(
            width: larghezzaDrawer,
            duration: const Duration(milliseconds: 250),
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                drawerEspanso = !drawerEspanso;
                                larghezzaDrawer == 200
                                    ? larghezzaDrawer = 80
                                    : larghezzaDrawer = 200;
                                if (_chatVisibile) {
                                  _chatVisibile = !_chatVisibile;
                                }
                              });
                            },
                            icon: Icon(Icons.menu_rounded)),
                      ),
                      AnimatedCrossFade(
                        firstChild: Text(
                          "Menu",
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        secondChild: SizedBox(),
                        crossFadeState: drawerEspanso
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        duration: const Duration(milliseconds: 250),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Divider(),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  tileDrawer("CLIENTI", 0, Icons.people_rounded),
                  tileDrawer("COACH", 1, Icons.person_2_rounded),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: const Divider(),
                  ),
                  tileDrawer("Logout", 10, Icons.logout_rounded),
                  SizedBox(
                    height: 8,
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: selettorePagine(),
            ),
          )
        ],
      ),
    );
  }

/*
  
*/
  Widget selettorePagine() {
    switch (_indexDrawer) {
      case 0:
        {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 250,
                height: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      height: 64,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {});
                        },
                        controller: cercaClientiTextEditController,
                        textAlign: TextAlign.start,
                        textAlignVertical: TextAlignVertical.center,
                        maxLines: 1,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.all(
                                Radius.circular(16.0),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16.0)),
                            ),
                            filled: false,
                            alignLabelWithHint: true,
                            hintText: "Cerca clienti...",
                            suffixIcon: CircleAvatar(
                              backgroundColor: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.3),
                              child: Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                            ),
                            prefixIcon: cercaClientiTextEditController
                                    .text.isNotEmpty
                                ? IconButton(
                                    onPressed: () {
                                      setState(() {
                                        cercaClientiTextEditController.clear();
                                      });
                                    },
                                    icon: Icon(Icons.cancel_rounded))
                                : null),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ListView.builder(
                      itemCount: coach.listaClientiSeguiti!.length,
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        if (cercaClientiTextEditController.text.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _indexCliente = index;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: _indexCliente == index
                                        ? Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.3)
                                        : null),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            coach.listaClientiSeguiti![index]
                                                .username!,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: _indexCliente != index
                                                    ? Theme.of(context)
                                                        .hintColor
                                                    : null),
                                          ),
                                          Text(
                                            coach.listaClientiSeguiti![index]
                                                .email!,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: _indexCliente == index
                                                    ? null
                                                    : Theme.of(context)
                                                        .hintColor),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else if (coach.listaClientiSeguiti![index].username!
                            .toLowerCase()
                            .contains(cercaClientiTextEditController.text
                                .toLowerCase())) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _indexCliente = index;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: _indexCliente == index
                                        ? Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.3)
                                        : null),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            coach.listaClientiSeguiti![index]
                                                .username!,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: _indexCliente != index
                                                    ? Theme.of(context)
                                                        .hintColor
                                                    : null),
                                          ),
                                          Text(
                                            coach.listaClientiSeguiti![index]
                                                .email!,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: _indexCliente == index
                                                    ? null
                                                    : Theme.of(context)
                                                        .hintColor),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return SizedBox();
                        }
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Spacer(),
                    SizedBox(
                      width: 250,
                      height: 48,
                      //width: MediaQuery.of(context).size.width * (1.5 / 8),
                      child: ElevatedButton.icon(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            )),
                            backgroundColor: MaterialStatePropertyAll(
                                Theme.of(context).primaryColor)),
                        label: const Text(
                          "Nuovo cliente",
                          style: TextStyle(color: Colors.white),
                        ),
                        icon: const Icon(Icons.add_rounded),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            pulsanteNavigazioneClienteTab(
                                "Info cliente",
                                0,
                                Icons.note_alt_rounded,
                                _indexTabcliente,
                                navigaTab),
                            SizedBox(
                              width: 8,
                            ),
                            pulsanteNavigazioneClienteTab(
                                "Schede",
                                1,
                                Icons.archive_sharp,
                                _indexTabcliente,
                                navigaTab),
                            SizedBox(
                              width: 8,
                            ),
                            pulsanteNavigazioneClienteTab(
                                "Nuova scheda",
                                2,
                                Icons.edit_calendar_rounded,
                                _indexTabcliente,
                                navigaTab),
                            Spacer(),
                            // pulsante visibilita chat

                            SizedBox(
                              height: 48,
                              child: ElevatedButton.icon(
                                style: ButtonStyle(
                                    elevation: MaterialStatePropertyAll(0),
                                    alignment: Alignment.centerLeft,
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                    )),
                                    backgroundColor: _chatVisibile
                                        ? MaterialStatePropertyAll(
                                            Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.3))
                                        : MaterialStatePropertyAll(
                                            Theme.of(context).cardColor)),
                                onPressed: () async {
                                  // serve per creare il documento qualora fosse la prima volta che si usa la chat per l'utente selezionato
                                  if (await _dbs
                                      .getInstanceDb()
                                      .collection(_dbs.getCollezioneUtenti())
                                      .doc(coach
                                          .listaClientiSeguiti![_indexCliente]
                                          .uid!)
                                      .collection(_dbs.getCollezioneChat())
                                      .doc(_dbs.uid_user_loggato)
                                      .get()
                                      .then((value) => !value.exists)) {
                                    _dbs
                                        .getInstanceDb()
                                        .collection(_dbs.getCollezioneUtenti())
                                        .doc(coach
                                            .listaClientiSeguiti![_indexCliente]
                                            .uid!)
                                        .collection(_dbs.getCollezioneChat())
                                        .doc(_dbs.uid_user_loggato)
                                        .set(Chat(listaMessaggi: List.empty())
                                            .toFirestore());
                                  }
                                  setState(() {
                                    _chatVisibile = !_chatVisibile;
                                    if (drawerEspanso) {
                                      drawerEspanso = !drawerEspanso;
                                      larghezzaDrawer == 200
                                          ? larghezzaDrawer = 80
                                          : larghezzaDrawer = 200;
                                    }
                                  });
                                },
                                icon: _chatVisibile == true
                                    ? Icon(
                                        Icons.visibility_rounded,
                                        color: Theme.of(context)
                                            .hintColor
                                            .withOpacity(0.8),
                                      )
                                    : Icon(
                                        Icons.visibility_off_rounded,
                                        color: Theme.of(context)
                                            .hintColor
                                            .withOpacity(0.8),
                                      ),
                                label: Text(
                                  "Chat",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).hintColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Widget tabs

                    SizedBox(
                      height: 16,
                    ),
                    Expanded(child: selettoreTabsPaginaCLiente())
                  ],
                ),
              ),

              // riquadro chat

              AnimatedCrossFade(
                firstChild: SizedBox(
                  width: 350,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: SizedBox(
                          height: 64,
                          width: double.infinity,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 16,
                                ),
                                CircleAvatar(child: Icon(Icons.person_rounded)),
                                SizedBox(
                                  width: 8,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      coach.listaClientiSeguiti![_indexCliente]
                                          .username!,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      coach.listaClientiSeguiti![_indexCliente]
                                          .email!,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Expanded(child: conversazione()),
                    ],
                  ),
                ),
                secondChild: SizedBox(),
                crossFadeState: _chatVisibile
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                duration: const Duration(milliseconds: 250),
              ),
            ],
          );
        }
      case 1:
        {
          return Align(
              alignment: Alignment.topLeft,
              child: infoUtente(coach.username!, coach.email!));
        }
      default:
        return Placeholder();
    }
  }

  Widget conversazione() {
    chat = conversazioneChat(
      coachModel: coach,
      mittenteCoach: true,
      uidDestinatarioCLiente: coach.listaClientiSeguiti![_indexCliente].uid!,
    );
    chat.createElement();
    return chat;
  }

  Container pulsanteNavigazioneClienteTab(
    String testo,
    int index_pulsante,
    IconData icona,
    int index_selezionato,
    void Function(int nuovaSelezione) navigaTab,
  ) {
    return Container(
      height: 48,
      child: ElevatedButton.icon(
        style: ButtonStyle(
            elevation: MaterialStatePropertyAll(0),
            alignment: Alignment.center,
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            )),
            backgroundColor: index_pulsante != index_selezionato
                ? MaterialStatePropertyAll(Colors.transparent)
                : MaterialStatePropertyAll(Theme.of(context).primaryColor)),
        label: Text(
          testo,
          style: TextStyle(
              color: index_pulsante == index_selezionato
                  ? Colors.white
                  : Theme.of(context).hintColor,
              letterSpacing: 2),
        ),
        icon: Icon(icona,
            color: index_pulsante == index_selezionato
                ? Colors.white
                : Theme.of(context).hintColor.withOpacity(0.8)),
        onPressed: () {
          navigaTab(index_pulsante);
        },
      ),
    );
  }

  void navigaTab(int nuovaSelezione) {
    setState(() {
      _indexTabcliente = nuovaSelezione;
    });
  }

  Padding tileDrawer(String testo, int index, IconData icona) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: AnimatedCrossFade(
        firstChild: SizedBox(
            width: 200,
            height: 48,
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                    _indexDrawer == index
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).cardColor.withOpacity(0.3),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ))),
              onPressed: () {
                setState(() {
                  // se index è 10 allora hai premuto il tasto logout
                  if (index == 10) {
                    AuthenticationHelper().signOut().then((result) {
                      if (result == null) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(result)),
                        );
                      }
                    });
                  } else {
                    _indexDrawer = index;
                  }
                });
              },
              child: Text(
                testo,
                maxLines: 1,
                style: TextStyle(
                    color: _indexDrawer == index
                        ? Colors.white
                        : Theme.of(context).hintColor),
              ),
            )),
        secondChild: SizedBox(
          height: 48,
          child: CircleAvatar(
            backgroundColor: _indexDrawer == index
                ? Theme.of(context).primaryColor
                : Theme.of(context).cardColor.withOpacity(0.3),
            child: IconButton(
              onPressed: () {
                setState(() {
                  // se index è 10 allora hai premuto il tasto logout
                  if (index == 10) {
                    AuthenticationHelper().signOut().then((result) {
                      if (result == null) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(result)),
                        );
                      }
                    });
                  } else {
                    _indexDrawer = index;
                  }
                });
              },
              icon: Icon(
                icona,
                color: _indexDrawer == index
                    ? Colors.white
                    : Theme.of(context).hintColor,
                size: 24,
              ),
            ),
          ),
        ),
        duration: const Duration(milliseconds: 250),
        reverseDuration: const Duration(milliseconds: 250),
        crossFadeState: drawerEspanso
            ? CrossFadeState.showFirst
            : CrossFadeState.showSecond,
      ),
    );
  }

  Widget selettoreTabsPaginaCLiente() {
    switch (_indexTabcliente) {
      case 0:
        {
          return infoUtente(coach.listaClientiSeguiti![_indexCliente].username!,
              coach.listaClientiSeguiti![_indexCliente].email!);
        }
      case 1:
        {
          return Placeholder();
        }
      case 2:
        {
          return creazioneNuovaScheda();
        }
      default:
        return Placeholder();
    }
  }

// elenco widget tab clienti + metodi
  Widget infoUtente(String username, String email) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 16,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: CircleAvatar(
            radius: 32,
            child: Icon(Icons.person_rounded),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            username,
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          ),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.email_rounded),
          title: Text(email),
        ),
      ],
    );
  }

  Widget creazioneNuovaScheda() {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          ListTile(
            title: Text(
              "Nuova scheda",
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            trailing: SizedBox(
              height: 48,
              child: ElevatedButton.icon(
                style: ButtonStyle(
                    elevation: MaterialStatePropertyAll(0),
                    alignment: Alignment.centerLeft,
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    )),
                    backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                onPressed: () {
                  stampaTutto();

                  salvaScheda();
                },
                icon: Icon(Icons.bookmark_added_rounded, color: Colors.white),
                label: Text(
                  "Salva scheda",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: TextFormField(
              // assegno il suo texteditcontroller

              controller: schedaTextEditController.TextEditController,
              textAlign: TextAlign.left,
              style: const TextStyle(),
              maxLines: 1,
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(16),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(
                      Radius.circular(16.0),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                  ),
                  filled: true,
                  alignLabelWithHint: true,
                  hintText: "Nome della scheda ...",
                  hintStyle: TextStyle(),
                  suffixIcon: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Icon(
                      Icons.tag_rounded,
                    ),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Row(
              children: [
                Text(
                  "Periodo di svolgimento",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Spacer(),
                Text(
                  "Dal ",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                schedaTextEditController.inizioScheda == null
                    ? IconButton(
                        onPressed: () {
                          dialogDataPicker(true);
                        },
                        icon: Icon(Icons.date_range_rounded))
                    : SizedBox(
                        height: 48,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                elevation: MaterialStatePropertyAll(0),
                                alignment: Alignment.centerLeft,
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(48.0),
                                )),
                                backgroundColor: MaterialStatePropertyAll(
                                    Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.3))),
                            onPressed: () {
                              dialogDataPicker(false);
                            },
                            child: Text(
                              schedaTextEditController.inizioScheda!
                                  .toDate()
                                  .toString(),
                              style: TextStyle(fontSize: 18),
                            )),
                      ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  " al ",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                schedaTextEditController.fineScheda == null
                    ? IconButton(
                        onPressed: () {
                          dialogDataPicker(false);
                        },
                        icon: Icon(Icons.date_range_rounded))
                    : SizedBox(
                        height: 48,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                elevation: MaterialStatePropertyAll(0),
                                alignment: Alignment.centerLeft,
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(48.0),
                                )),
                                backgroundColor: MaterialStatePropertyAll(
                                    Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.3))),
                            onPressed: () {
                              dialogDataPicker(false);
                            },
                            child: Text(
                              schedaTextEditController.fineScheda!
                                  .toDate()
                                  .toString(),
                              style: TextStyle(fontSize: 18),
                            )),
                      ),
              ],
            ),
          ),

          // inizio logica ui per scheda

          // lista allenamenti
          ListView.builder(
            shrinkWrap: true,
            itemCount: schedaTextEditController
                .listaAllenamentiTextEditController!.length,
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(
                    top: 16, right: 22, left: 22, bottom: 8),
                child: Card(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                    child: Column(
                      children: [
                        ListTile(
                          titleAlignment: ListTileTitleAlignment.center,
                          leading: Text(
                            "GIORNO ${index + 1}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          title: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: TextFormField(
                              controller: schedaTextEditController
                                  .listaAllenamentiTextEditController![index]
                                  .TextEditController,
                              textAlign: TextAlign.left,
                              style: TextStyle(),
                              maxLines: 1,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(16),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(16.0),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16.0)),
                                ),
                                filled: true,
                                alignLabelWithHint: true,
                                hintText:
                                    "Nome giornata di allenamento ${index + 1} (Es. Gambe, petto ecc..)",
                              ),
                            ),
                          ),
                          trailing: SizedBox(
                            height: 48,
                            child: ElevatedButton.icon(
                              style: ButtonStyle(
                                  elevation: MaterialStatePropertyAll(0),
                                  alignment: Alignment.centerLeft,
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    side:
                                        BorderSide(width: 0, color: Colors.red),
                                    borderRadius: BorderRadius.circular(16.0),
                                  )),
                                  backgroundColor:
                                      MaterialStatePropertyAll(Colors.red)),
                              onPressed: () {
                                setState(() {
                                  rimuoviAllenamento(index);
                                });
                              },
                              icon: Icon(Icons.remove_circle_rounded,
                                  color: Colors.white),
                              label: Text(
                                "Elimina allenamento",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                        // logica per tabella esercizi

                        Visibility(
                          visible: schedaTextEditController
                              .listaAllenamentiTextEditController![index]
                              .listaEserciziTextEditController!
                              .isNotEmpty,
                          child: SizedBox(
                            width: double.infinity,
                            child: DataTable(
                              dataRowMinHeight: 64,
                              dataRowMaxHeight: 100,
                              dividerThickness: 1,
                              columnSpacing: 16,
                              showCheckboxColumn: true,
                              horizontalMargin: 16,
                              columns: const [
                                DataColumn(
                                  label: Text('N°'),
                                ),
                                DataColumn(
                                  label: Text('Nome'),
                                ),
                                DataColumn(
                                  label: Text('Serie'),
                                ),
                                DataColumn(
                                  label: Text('Ripetizioni'),
                                ),
                                DataColumn(
                                  label: Text('Recupero'),
                                ),
                                DataColumn(
                                  label: Text('Note esercizio'),
                                ),
                                DataColumn(
                                  numeric: true,
                                  label: Text(''),
                                ),
                              ],
                              rows: getTableData(index),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: SizedBox(
                              height: 48,
                              child: ElevatedButton.icon(
                                style: ButtonStyle(
                                    elevation: MaterialStatePropertyAll(0),
                                    alignment: Alignment.centerLeft,
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                    )),
                                    backgroundColor: MaterialStatePropertyAll(
                                        Theme.of(context).cardColor)),
                                onPressed: () {
                                  setState(() {
                                    aggiungiEsercizio(index);
                                  });
                                },
                                icon: Icon(Icons.add_circle_rounded,
                                    color: Theme.of(context).primaryColor),
                                label: Text(
                                  "Nuovo esercizio",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 18),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          // pulsante per aggiungere alla lista di allenamenti

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  style: ButtonStyle(
                      elevation: MaterialStatePropertyAll(0),
                      alignment: Alignment.centerLeft,
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      )),
                      backgroundColor: MaterialStatePropertyAll(
                          Theme.of(context).cardColor)),
                  onPressed: () {
                    setState(() {
                      aggiungiGiornataAllenamento();
                    });
                  },
                  icon: Icon(Icons.add_rounded,
                      color: Theme.of(context).primaryColor),
                  label: Text(
                    "Nuova giornata di allenamento",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 18),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // metodi per creare giorni di allenamento oppure esercizi

  void aggiungiGiornataAllenamento() {
    schedaTextEditController.listaAllenamentiTextEditController!
        .add(AllenamentoTextEditController(
            TextEditController: TextEditingController(),
            listaEserciziTextEditController: List.from([
              EsercizioTextEditController(
                  TextEditControllerNome: TextEditingController(),
                  TextEditControllerSerie: TextEditingController(),
                  TextEditControllerRipetizioni: TextEditingController(),
                  TextEditControllerRecupero: TextEditingController(),
                  TextEditControllerNote: TextEditingController())
            ], growable: true)));
  }

  void aggiungiEsercizio(int index) {
    schedaTextEditController.listaAllenamentiTextEditController![index]
        .listaEserciziTextEditController!
        .add(EsercizioTextEditController(
            TextEditControllerNome: TextEditingController(),
            TextEditControllerSerie: TextEditingController(),
            TextEditControllerRipetizioni: TextEditingController(),
            TextEditControllerRecupero: TextEditingController(),
            TextEditControllerNote: TextEditingController()));
  }

  // metodo per righe della tabella esercizi di ogni giornata
  List<DataRow> getTableData(int index) {
    List<DataRow> list = List.empty(growable: true);

    for (int i = 0;
        i <
            schedaTextEditController.listaAllenamentiTextEditController![index]
                .listaEserciziTextEditController!.length;
        i++) {
      list.add(DataRow(cells: [
        DataCell(SizedBox(width: 24, child: Text((i + 1).toString()))),
        DataCell(
          SizedBox(
            child: TextFormField(
              controller: schedaTextEditController
                  .listaAllenamentiTextEditController![index]
                  .listaEserciziTextEditController![i]
                  .TextEditControllerNome,
              textAlign: TextAlign.left,
              style: TextStyle(),
              maxLines: 1,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(16),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(
                    Radius.circular(16.0),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                ),
                filled: true,
                alignLabelWithHint: true,
                hintText: "Nome esercizio",
              ),
            ),
          ),
        ),
        DataCell(
          SizedBox(
            child: TextFormField(
              controller: schedaTextEditController
                  .listaAllenamentiTextEditController![index]
                  .listaEserciziTextEditController![i]
                  .TextEditControllerSerie,
              textAlign: TextAlign.left,
              style: TextStyle(),
              maxLines: 1,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(16),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(
                    Radius.circular(16.0),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                ),
                filled: true,
                alignLabelWithHint: true,
                hintText: "Numero serie",
              ),
            ),
          ),
        ),
        DataCell(
          SizedBox(
            child: TextFormField(
              controller: schedaTextEditController
                  .listaAllenamentiTextEditController![index]
                  .listaEserciziTextEditController![i]
                  .TextEditControllerRipetizioni,
              textAlign: TextAlign.left,
              style: TextStyle(),
              maxLines: 1,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(16),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(
                    Radius.circular(16.0),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                ),
                filled: true,
                alignLabelWithHint: true,
                hintText: "Ripetizioni",
              ),
            ),
          ),
        ),
        DataCell(
          SizedBox(
            child: TextFormField(
              controller: schedaTextEditController
                  .listaAllenamentiTextEditController![index]
                  .listaEserciziTextEditController![i]
                  .TextEditControllerRecupero,
              textAlign: TextAlign.left,
              style: TextStyle(),
              maxLines: 1,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(16),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(
                    Radius.circular(16.0),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                ),
                filled: true,
                alignLabelWithHint: true,
                hintText: "Secondi di recupero",
              ),
            ),
          ),
        ),
        DataCell(
          Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width / 4, maxHeight: 84),
            child: TextFormField(
              controller: schedaTextEditController
                  .listaAllenamentiTextEditController![index]
                  .listaEserciziTextEditController![i]
                  .TextEditControllerNote,
              minLines: 1,
              maxLines: 5,
              textAlign: TextAlign.left,
              style: TextStyle(),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(16),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(
                    Radius.circular(16.0),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                ),
                filled: true,
                alignLabelWithHint: true,
                hintText: "Nota del coach per l'esercizio",
              ),
            ),
          ),
        ),
        DataCell(SizedBox(
            width: 50,
            child: IconButton(
              icon: Icon(Icons.delete_rounded),
              onPressed: () {
                setState(() {
                  rimuoviEsercizio(index, i);
                });
              },
            ))),
      ]));
    }

    return list;
  }

// metodi per rimuovere allenamenti o esercizi
  void rimuoviAllenamento(int index) {
    schedaTextEditController.listaAllenamentiTextEditController!
        .removeAt(index);
  }

  void rimuoviEsercizio(int index, int index_esercizio) {
    schedaTextEditController.listaAllenamentiTextEditController![index]
        .listaEserciziTextEditController!
        .removeAt(index_esercizio);
  }

// metodo stampa scheda
  void stampaTutto() {
    for (var a
        in schedaTextEditController.listaAllenamentiTextEditController!) {
      print("Nome allenamento : ${a.TextEditController!.text}");
      for (var b in a.listaEserciziTextEditController!) {
        print("- nome esercizio : ${b.TextEditControllerNome.text}");
        print("- serie : ${b.TextEditControllerSerie.text}");
        print("- ripetizioni: ${b.TextEditControllerRipetizioni.text}");
        print("- recupero : ${b.TextEditControllerRecupero.text}");
        print("- note : ${b.TextEditControllerNote.text}");
      }
    }
  }

// dialog per selezionare la data

  void dialogDataPicker(bool dataIniziale) {
    late Timestamp date;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            title: dataIniziale
                ? const Text(
                    "Data di inizio della scheda",
                  )
                : const Text(
                    "Data di fine scheda",
                  ),
            content: SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              height: MediaQuery.of(context).size.height / 3,
              child: Card(
                child: CalendarDatePicker(
                  onDateChanged: (DateTime value) {
                    setState(() {
                      if (dataIniziale) {
                        schedaTextEditController.inizioScheda =
                            Timestamp.fromDate(value);
                      } else {
                        schedaTextEditController.fineScheda =
                            Timestamp.fromDate(value);
                      }
                    });
                  },
                  firstDate: DateTime.now(),
                  initialDate: null,
                  lastDate: DateTime.now().add(Duration(days: 365)),
                ),
              ),
            ),
            actions: [
              Align(
                alignment: Alignment.bottomRight,
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                      icon: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Icon(Icons.close),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      label: const Text("Chiudi"),
                      style: ButtonStyle(
                          elevation: const MaterialStatePropertyAll(1),
                          backgroundColor:
                              const MaterialStatePropertyAll(Colors.red),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          )))),
                ),
              )
            ],
          );
        });
  }

// metodo per salvare scheda in db

  void salvaScheda() {
    List<Allenamento> lista_allenamenti = List.empty(growable: true);

    for (var a
        in schedaTextEditController.listaAllenamentiTextEditController!) {
      List<Esercizio> lista_esercizi = List.empty(growable: true);
      for (var b in a.listaEserciziTextEditController!) {
        lista_esercizi.add(Esercizio(
            noteEsercizio: b.TextEditControllerNote.text,
            nomeEsercizio: b.TextEditControllerNome.text,
            serieEsercizio: b.TextEditControllerSerie.text,
            ripetizioniEsercizio: List.generate(
                int.parse(b.TextEditControllerSerie.text),
                (index) => b.TextEditControllerRipetizioni.text),
            carichiEsercizio: List.generate(
                int.parse(b.TextEditControllerSerie.text), (index) => ""),
            recuperoEsercizio: int.parse(b.TextEditControllerRecupero.text)));
      }
      lista_allenamenti.add(Allenamento(
          nomeAllenamento: a.TextEditController!.text,
          listaEsercizi: lista_esercizi,
          giorniAssegnati: List.empty(growable: true),
          feedbackAllenamento: ""));
    }

    Scheda scheda = Scheda(
        nomeScheda: schedaTextEditController.TextEditController!.text,
        allenamentiScheda: lista_allenamenti,
        inizioScheda: Timestamp.now(),
        fineScheda: Timestamp.now(),
        idScheda: null,
        allenamentiSvolti: List.empty(growable: true));

    _dbs
        .getInstanceDb()
        .collection(_dbs.getCollezioneUtenti())
        .doc(coach.listaClientiSeguiti![_indexCliente].uid!)
        .collection(_dbs.getCollezioneSchede())
        .doc()
        .set(
          scheda.toFirestore(),
        );
  }
}
