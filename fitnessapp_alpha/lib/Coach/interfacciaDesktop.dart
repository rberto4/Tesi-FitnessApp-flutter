// ignore_for_file: file_names, prefer_const_constructors, camel_case_types

import 'package:app_fitness_test_2/Cliente/conversazione.dart';
import 'package:app_fitness_test_2/services/ChatModel.dart';
import 'package:app_fitness_test_2/services/SchedaModel.dart';
import 'package:app_fitness_test_2/services/UserModel.dart';
import 'package:app_fitness_test_2/services/database_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomeDesktop extends StatefulWidget {
  const HomeDesktop({super.key});

  @override
  State<HomeDesktop> createState() => _HomeDesktopState();
}

/*
 AuthenticationHelper().signOut().then((result) {
              if (result == null) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(result)),
                );
              }
            });
*/

DatabaseService _dbs = DatabaseService();
int _indexDrawer = 0;
int _indexCliente = 0;
bool _menuVisibility = true;

late CoachModel coach;
late List<Widget> listaPagine = List.empty(growable: true);

class _HomeDesktopState extends State<HomeDesktop> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          child: FutureBuilder(
            future: ottieniDati(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: const CircularProgressIndicator(),
                );
              } else if (!snapshot.hasData) {
                return paginaPrincipale();
              } else {
                return const Center(
                    child: Text(
                        "Problema di connessione, prova a ricaricare la pagina"));
              }
            },
          ),
        ));
  }
}

// Metodo future per ricavare dati da db relativi al coach loggato

Future<void> ottieniDati() async {
  coach = await _dbs.getDataCoach();
}

class paginaPrincipale extends StatefulWidget {
  const paginaPrincipale({super.key});

  @override
  State<paginaPrincipale> createState() => _paginaPrincipaleState();
}

class _paginaPrincipaleState extends State<paginaPrincipale> {
  @override
  void initState() {
    listaPagine = [
      const paginaHome(),
      const paginaEsercizi(),
      paginaCliente(),
    ];
    super.initState();
  }

  void notificaRicaricaStato() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // menu laterale con pulsanti di navigazione
        Visibility(
          visible: _menuVisibility,
          child: SizedBox(
            height: double.infinity,
            child: Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(18.0),
                        child: Text(
                          "Menù",
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                      tileDrawer("H O M E", 0, Icons.home),
                      tileDrawer(
                          "E S E R C I Z I", 1, Icons.fitness_center_rounded),
                      tileDrawer("C L I E N T I", 2, Icons.people_rounded),
                    ],
                  ),
                  Visibility(
                    visible: _indexDrawer == 2,
                    child: SizedBox(
                      height: double.infinity,
                      width: 250,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16.0)),
                                ),
                                filled: true,
                                alignLabelWithHint: true,
                                hintText: "Cerca clienti...",
                                hintStyle: TextStyle(),
                                suffixIcon: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  child: Icon(
                                    Icons.search,
                                  ),
                                )),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: coach.listaClientiSeguiti!.length,
                              shrinkWrap: true,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
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
                                          borderRadius:
                                              BorderRadius.circular(16),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.person_rounded,
                                              color: _indexCliente == index
                                                  ? null
                                                  : Theme.of(context)
                                                      .hintColor
                                                      .withOpacity(0.3),
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  coach
                                                      .listaClientiSeguiti![
                                                          index]
                                                      .username!,
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: _indexCliente !=
                                                              index
                                                          ? Theme.of(context)
                                                              .hintColor
                                                          : null),
                                                ),
                                                Text(
                                                  coach
                                                      .listaClientiSeguiti![
                                                          index]
                                                      .email!,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                      color: _indexCliente ==
                                                              index
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
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          SizedBox(
                            width: 250,
                            height: 48,
                            //width: MediaQuery.of(context).size.width * (1.5 / 8),
                            child: ElevatedButton.icon(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
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
                          const SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                    height: double.infinity,
                  )
                ],
              ),
            ),
          ),
        ),
        Flexible(child: listaPagine[_indexDrawer]),
      ],
    );
  }

  Padding tileDrawer(String testo, int index, IconData icona) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Flexible(
        child: SizedBox(
          width: 180,
          height: 48,
          child: ElevatedButton.icon(
            style: ButtonStyle(
                alignment: Alignment.center,
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                )),
                elevation: _indexDrawer != index
                    ? const MaterialStatePropertyAll(0)
                    : const MaterialStatePropertyAll(2),
                backgroundColor: _indexDrawer != index
                    ? MaterialStatePropertyAll(Theme.of(context).cardColor)
                    : MaterialStatePropertyAll(Theme.of(context).primaryColor)),
            label: Text(
              testo,
              style: TextStyle(
                  color: _indexDrawer != index
                      ? Theme.of(context).hintColor
                      : Colors.white),
            ),
            icon: Icon(icona,
                color: _indexDrawer == index
                    ? Colors.white
                    : Theme.of(context).hintColor),
            onPressed: () {
              setState(() {
                _indexDrawer = index;
              });
            },
          ),
        ),
      ),
    );
  }
}

class paginaHome extends StatefulWidget {
  const paginaHome({super.key});

  @override
  State<paginaHome> createState() => _paginaHomeState();
}

class _paginaHomeState extends State<paginaHome> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class paginaEsercizi extends StatefulWidget {
  const paginaEsercizi({super.key});

  @override
  State<paginaEsercizi> createState() => _paginaEserciziState();
}

class _paginaEserciziState extends State<paginaEsercizi> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class paginaCliente extends StatefulWidget {
  paginaCliente({super.key});

  @override
  State<paginaCliente> createState() => _paginaClienteState();
}

class _paginaClienteState extends State<paginaCliente> {
  int _selectedIndex = 0;
  bool _chatVisible = false;
  List<Widget> widgetSchermataCliente = List.empty(growable: true);

  void navigaTab(int nuovaSelezione) {
    setState(() {
      _selectedIndex = nuovaSelezione;
    });
  }

  void ricaricaStato() {
    setState(() {});
  }

  @override
  void initState() {
    widgetSchermataCliente = [
      infoCliente(),
      schedeCliente(),
      nuovaSchedaCliente()
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        _menuVisibility = !_menuVisibility;
                      });
                    },
                    icon: Icon(Icons.menu_rounded)),
                Spacer(),
                Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(48)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        pulsanteNavigazioneClienteTab("Info cliente", 0,
                            Icons.note_alt_rounded, _selectedIndex, navigaTab),
                        SizedBox(
                          width: 16,
                        ),
                        pulsanteNavigazioneClienteTab("Schede", 1,
                            Icons.archive_sharp, _selectedIndex, navigaTab),
                        SizedBox(
                          width: 16,
                        ),
                        pulsanteNavigazioneClienteTab(
                            "Nuova scheda",
                            2,
                            Icons.edit_calendar_rounded,
                            _selectedIndex,
                            navigaTab),
                      ],
                    ),
                  ),
                ),
                Spacer(),
                SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    style: ButtonStyle(
                        elevation: MaterialStatePropertyAll(0),
                        alignment: Alignment.centerLeft,
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(48.0),
                        )),
                        backgroundColor: _chatVisible
                            ? MaterialStatePropertyAll(
                                Theme.of(context).primaryColor.withOpacity(0.3))
                            : MaterialStatePropertyAll(
                                Theme.of(context).cardColor)),
                    onPressed: () async {
                      // serve per creare il documento qualora fosse la prima volta che si usa la chat per l'utente selezionato
                      if (await _dbs
                          .getInstanceDb()
                          .collection(_dbs.getCollezioneUtenti())
                          .doc(coach.listaClientiSeguiti![_indexCliente].uid!)
                          .collection(_dbs.getCollezioneChat())
                          .doc(_dbs.uid_user_loggato)
                          .get()
                          .then((value) => !value.exists)) {
                        _dbs
                            .getInstanceDb()
                            .collection(_dbs.getCollezioneUtenti())
                            .doc(coach.listaClientiSeguiti![_indexCliente].uid!)
                            .collection(_dbs.getCollezioneChat())
                            .doc(_dbs.uid_user_loggato)
                            .set(Chat(listaMessaggi: List.empty())
                                .toFirestore());
                      }
                      setState(() {
                        _chatVisible = !_chatVisible;
                      });
                    },
                    icon: _chatVisible == true
                        ? Icon(
                            Icons.visibility_rounded,
                            color: Theme.of(context).hintColor.withOpacity(0.8),
                          )
                        : Icon(
                            Icons.visibility_off_rounded,
                            color: Theme.of(context).hintColor.withOpacity(0.8),
                          ),
                    label: Text(
                      "Chat",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).hintColor),
                    ),
                  ),
                )
              ],
            ),
            Expanded(child: widgetSchermataCliente[_selectedIndex])
          ],
        ),
      ),
      floatingActionButton: Visibility(
        visible: _chatVisible,
        child: Align(
          alignment: Alignment.bottomRight,
          child: Card(
            child: SizedBox(
              width: 500,
              height: MediaQuery.of(context).size.height - 100,
              child: conversazioneChat(
                coachModel: coach,
                mittenteCoach: true,
                uidDestinatarioCLiente:
                    coach.listaClientiSeguiti![_indexCliente].uid!,
              ),
            ),
          ),
        ),
      ),
    );
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
              borderRadius: BorderRadius.circular(48.0),
            )),
            backgroundColor: index_pulsante != index_selezionato
                ? MaterialStatePropertyAll(Colors.transparent)
                : MaterialStatePropertyAll(Theme.of(context).primaryColor)),
        label: Text(
          testo,
          style: TextStyle(
              color: index_pulsante == index_selezionato
                  ? Colors.white
                  : Theme.of(context).hintColor.withOpacity(0.8),
              fontWeight: FontWeight.bold,
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

  Widget infoCliente() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
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
            coach.listaClientiSeguiti![_indexCliente].username!,
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          ),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.email_rounded),
          title: Text(coach.listaClientiSeguiti![_indexCliente].email!),
        ),
        Spacer(),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              height: 48,
              child: ElevatedButton.icon(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    )),
                    backgroundColor: MaterialStatePropertyAll(Colors.red)),
                label: const Text(
                  "Elimina cliente",
                  style: TextStyle(color: Colors.white),
                ),
                icon: const Icon(Icons.delete_forever_rounded),
                onPressed: () {},
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget schedeCliente() {
    return Column(
      children: const [],
    );
  }
}

class nuovaSchedaCliente extends StatefulWidget {
  const nuovaSchedaCliente({super.key});

  @override
  State<nuovaSchedaCliente> createState() => _nuovaSchedaClienteState();
}

class _nuovaSchedaClienteState extends State<nuovaSchedaCliente> {
  List<Allenamento> lista_allenamenti = List.empty(growable: true);

  @override
  void initState() {
    // giornata 1 vuota, aggiunta di default allinizio

    lista_allenamenti.add(Allenamento(
        nomeAllenamento: null,
        listaEsercizi: null,
        noteAllenamento: null,
        giorniAssegnati: null,
        feedbackAllenamento: null));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Nuova scheda",
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: TextFormField(
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
                  "Da ",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                IconButton(
                    onPressed: () {}, icon: Icon(Icons.date_range_rounded)),
                Text(
                  " a ",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                IconButton(
                    onPressed: () {}, icon: Icon(Icons.date_range_rounded)),
              ],
            ),
          ),

          // inizio logica ui per scheda

          // lista allenamenti
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Card(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: lista_allenamenti.length,
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        ListTile(
                          titleAlignment: ListTileTitleAlignment.center,
                          leading: Text(
                            "GIORNO ${index + 1}      ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          title: TextFormField(
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
                        // logica per tabella esercizi

                        DataTable(
                          dividerThickness: 1,
                          columnSpacing: 64,
                          columns: [
                            const DataColumn(
                              label: Text('N°'),
                            ),
                            const DataColumn(
                              label: Text('Nome'),
                            ),
                            const DataColumn(
                              label: Text('Serie'),
                            ),
                            const DataColumn(
                              label: Text('Recupero'),
                            ),
                            const DataColumn(
                              label: Text('Note esercizio'),
                            ),
                          ],
                          rows: [],
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          // pulsante per aggiungere alla lista di allenamenti

          Align(
            alignment: Alignment.center,
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
                    backgroundColor:
                        MaterialStatePropertyAll(Colors.transparent)),
                onPressed: () {
                  setState(() {
                    aggiungiGiornataVuotaAllenamento();
                  });
                },
                icon: Icon(Icons.add_rounded,
                    color: Theme.of(context).primaryColor),
                label: Text(
                  "Aggiungi giornata di allenamento",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 18),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void aggiungiGiornataVuotaAllenamento() {
    lista_allenamenti.add(Allenamento(
        nomeAllenamento: null,
        listaEsercizi: null,
        noteAllenamento: null,
        giorniAssegnati: null,
        feedbackAllenamento: null));
  }
}
