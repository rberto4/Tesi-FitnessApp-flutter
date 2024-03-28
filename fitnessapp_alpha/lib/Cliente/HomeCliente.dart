import 'package:app_fitness_test_2/Cliente/dettagliAllenamento.dart';
import 'package:app_fitness_test_2/Cliente/gestioneCalendario.dart';
import 'package:app_fitness_test_2/autenticazione/login.dart';
import 'package:app_fitness_test_2/autenticazione/metodi_autenticazione.dart';
import 'package:app_fitness_test_2/services/SchedaModel.dart';
import 'package:app_fitness_test_2/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final DatabaseService _dbs = DatabaseService();

late SchedaModel sm = new SchedaModel(
      nome_scheda: null,
      allenamenti: null,
      inizio_scheda: null,
      fine_scheda: null,
      storico_esercizi: null,
      id_scheda: null);

class MainPageUtente extends StatefulWidget {
  const MainPageUtente({super.key});

  @override
  State<MainPageUtente> createState() => _MainPageUtenteState();
}

class _MainPageUtenteState extends State<MainPageUtente> {
  int _selectedIndex = 0;
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton.extended(
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () {},
              label: Text("Allenamento"),
              icon: Icon(Icons.sports_score_rounded),
            )
          : null,
      appBar: AppBar(
        elevation: 4,
        shadowColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: false,
        title: Text(
          _dbs.getAuth().currentUser!.email.toString(),
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => gestioneCalendario(sm: sm)),
                );
              },
              icon: Icon(Icons.edit_calendar_rounded)),
          IconButton(
              onPressed: () {
                AuthenticationHelper().signOut().then((result) {
                  if (result == null) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(result)),
                    );
                  }
                });
              },
              icon: const Icon(Icons.logout)),
        ],
      ),

      // DRAWER NAVIGATION
      drawer: const Drawer(),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Calendario',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded),
            label: 'Progressi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: 'Archivio',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),

      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [tabPages[_selectedIndex]],
          ),
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> tabPages = [
    const paginaCalendario(),
    const paginaProgressi(),
    const paginaArchivioSchede(),
  ];
}

// ignore: camel_case_types
class paginaCalendario extends StatefulWidget {
  const paginaCalendario({super.key});

  @override
  State<paginaCalendario> createState() => _paginaCalendarioState();
}

class _paginaCalendarioState extends State<paginaCalendario> {
  late Timestamp selectedDay = Timestamp.now();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SafeArea(
              child: StreamBuilder(
                  stream: _dbs.getSchedaCorrente(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                      // CONTROLLO SULLO STREAM DI DATI
                      List lista = snapshot.data!.docs;
                      sm = lista[0].data();
                      List<Allenamento?> lista_sedute_allenamenti =
                          new List.empty(growable: true);

                      for (var a in sm.allenamenti!) {
                        for (int i = 0; i < a.giorniAssegnati!.length; i++) {
                          if (DateUtils.dateOnly(
                                  a.giorniAssegnati![i].toDate()) ==
                              DateUtils.dateOnly(selectedDay.toDate())) {
                            if (controlloData(
                                sm.inizio_scheda!, sm.fine_scheda!)) {
                              lista_sedute_allenamenti.add(a);
                            }
                          }
                        }
                      }

                      return Column(
                        children: [
                          EasyDateTimeLine(
                            headerProps: const EasyHeaderProps(
                              dateFormatter:
                                  DateFormatter.fullDateDMonthAsStrY(),
                            ),
                            dayProps: const EasyDayProps(
                                activeDayStyle: DayStyle(
                                  borderRadius: 48.0,
                                  dayNumStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                  ),
                                  dayStrStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                width: 64.0,
                                height: 64.0,
                                dayStructure: DayStructure.dayNumDayStr,
                                inactiveDayStyle: DayStyle(
                                    dayNumStyle: TextStyle(
                                  fontSize: 18.0,
                                ))),
                            locale: "it_IT",
                            initialDate: DateTime.now(),
                            onDateChange: (selectedDate) {
                              setState(() {
                                selectedDay = Timestamp.fromDate(selectedDate);
                              });
                            },
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: lista_sedute_allenamenti.length,
                            itemBuilder: (context, index_allenamenti) {
                              return Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(children: [
                                  ListTile(
                                    trailing: Visibility(
                                      visible: true,
                                      child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1, color: Colors.teal),
                                              shape: BoxShape.rectangle,
                                              borderRadius:
                                                  BorderRadius.circular(48)),
                                          child: const Wrap(
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.center,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text("18:30",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.teal,
                                                          fontSize: 12)),
                                                ),
                                              ])),
                                    ),
                                    title: Text(
                                      lista_sedute_allenamenti[
                                              index_allenamenti]!
                                          .nomeAllenamento!,
                                      style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  ListView.builder(
                                    itemCount: lista_sedute_allenamenti[
                                            index_allenamenti]!
                                        .nomi_es!
                                        .length,
                                    shrinkWrap: true,

                                    //scrollDirection: Axis.vertical,
                                    //physics: const BouncingScrollPhysics(),
                                    itemBuilder: (context, index_esercizi) {
                                      return Theme(
                                        data: ThemeData().copyWith(
                                            dividerColor: Colors.transparent),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8, right: 8, left: 8),
                                          child: ExpansionTile(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(48))),
                                            leading: CircleAvatar(
                                                radius: 16,
                                                backgroundColor: Colors.teal,
                                                child: Text(
                                                  "${index_esercizi + 1}.",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16),
                                                )),
                                            title: Text(
                                              lista_sedute_allenamenti[
                                                      index_allenamenti]!
                                                  .nomi_es![index_esercizi],
                                            ),
                                            children: [
                                              ListTile(
                                                  title: Text(
                                                      "${lista_sedute_allenamenti[index_allenamenti]!.ripetizioni_es![index_esercizi]} ripetizioni")),
                                              ListTile(
                                                  title: Text(
                                                      "${lista_sedute_allenamenti[index_allenamenti]!.serie_es![index_esercizi]} serie")),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  ListTile(
                                      trailing: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                Colors.orange.shade700)),
                                    child: Text("Dettagli"),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => dettagliScheda(
                                                  allenamento:
                                                      lista_sedute_allenamenti[
                                                          index_allenamenti]!,
                                                  id: snapshot
                                                      .data!.docs[0].id)));
                                    },
                                  )),
                                  SizedBox(
                                    height: 4,
                                  )
                                ]),
                              );
                            },
                          ),
                        ],
                      );
                    } else {
                      return Text("");
                    }
                  }),
            ),
          )
        ],
      ),
    );
  }

  bool controlloData(Timestamp inizio, Timestamp fine) {
    DateTime dt = selectedDay.toDate();
    print("data selezionata: ${DateUtils.dateOnly(dt)}");
    if (DateUtils.dateOnly(dt)
            .isAtSameMomentAs(DateUtils.dateOnly(fine.toDate())) ||
        DateUtils.dateOnly(dt)
            .isAtSameMomentAs(DateUtils.dateOnly(inizio.toDate())) ||
        (DateUtils.dateOnly(dt).isAfter(DateUtils.dateOnly(inizio.toDate())) &&
            DateUtils.dateOnly(dt)
                .isBefore(DateUtils.dateOnly(fine.toDate())))) {
      return true;
    } else {
      return false;
    }
  }
}

class paginaArchivioSchede extends StatefulWidget {
  const paginaArchivioSchede({super.key});
  @override
  State<paginaArchivioSchede> createState() => _paginaArchivioSchedeState();
}

class _paginaArchivioSchedeState extends State<paginaArchivioSchede> {
  String nome_scheda_filtrato = "";
  TextEditingController searchbar_controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Archivio",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
            ),
            Card(
              child: TextField(
                controller: searchbar_controller,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: "Ricerca le schede per nome ...",
                  hintMaxLines: 1,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        searchbar_controller.clear();
                      });
                    },
                    icon: Icon(Icons.clear_rounded),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    nome_scheda_filtrato = value;
                  });
                },
              ),
            ),
            StreamBuilder(
              stream: _dbs.getTotaleSchede(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  final List schede = snapshot.data!.docs ?? [];
                  return ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: schede.length,
                    itemBuilder: (context, index) {
                      final SchedaModel sm = schede[index].data();

                      // CONTROLLO PER LA RICERCA PER NOME

                      if (searchbar_controller.text.isEmpty ||
                          sm.nome_scheda!
                              .toLowerCase()
                              .replaceAll(" ", "")
                              .characters
                              .containsAll(nome_scheda_filtrato
                                  .toLowerCase()
                                  .replaceAll(" ", "")
                                  .characters)) {
                        print(nome_scheda_filtrato);

                        return Card(
                          // CARD SCHEDA

                          child: Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 8),
                            child: Theme(
                              data: ThemeData()
                                  .copyWith(dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                  title: ListTile(
                                    leading: CircleAvatar(
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        child: const Icon(
                                          Icons.book_rounded,
                                          color: Colors.white,
                                        )),
                                    title: Text(
                                      sm.nome_scheda!,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text("Dal " +
                                        DateFormat.yMd().format(
                                            sm.inizio_scheda!.toDate()) +
                                        " al " +
                                        DateFormat.yMd()
                                            .format(sm.fine_scheda!.toDate())),
                                  ),
                                  children: []),
                            ),
                          ),
                        );
                      }
                    },
                  );
                } else {
                  return Text("");
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

class paginaProgressi extends StatefulWidget {
  const paginaProgressi({super.key});

  @override
  State<paginaProgressi> createState() => _paginaProgressiState();
}

class _paginaProgressiState extends State<paginaProgressi> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: StreamBuilder(
      stream: _dbs.getSchedaCorrente(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          List data = snapshot.data!.docs;
          SchedaModel sm = data[0].data();
          return Container(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: sm.storico_esercizi!.length,
              itemBuilder: (context, index) {
                esercizio es = sm.storico_esercizi![index];
                return ListTile(
                  title: Text(es.nome_esercizio),
                );
              },
            ),
          );
        } else {
          return Container();
        }
      },
    ));
  }
}
