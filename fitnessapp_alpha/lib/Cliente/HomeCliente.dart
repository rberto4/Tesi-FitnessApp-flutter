import 'package:app_fitness_test_2/autenticazione/login.dart';
import 'package:app_fitness_test_2/autenticazione/metodi_autenticazione.dart';
import 'package:app_fitness_test_2/services/SchedaModel.dart';
import 'package:app_fitness_test_2/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

final DatabaseService _dbs = DatabaseService();

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
     
      appBar: AppBar(
        elevation: 4,
        shadowColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          _dbs.getAuth().currentUser!.email.toString(),
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
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
              icon: const Icon(Icons.logout))
        ],
      ),

      // DRAWER NAVIGATION
      drawer: const Drawer(),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Scheda corrente',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_open_rounded),
            label: 'Archivio',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
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
    const paginaSchedaCorrente(),
    const paginaSchedaCorrente2(),
  ];
}

// ignore: camel_case_types
class paginaSchedaCorrente extends StatefulWidget {
  const paginaSchedaCorrente({super.key});

  @override
  State<paginaSchedaCorrente> createState() => _paginaSchedaCorrenteState();
}

class _paginaSchedaCorrenteState extends State<paginaSchedaCorrente> {
  late DateTime selectedDay = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          EasyDateTimeLine(
            locale: "it_IT",
            initialDate: DateTime.now(),
            onDateChange: (selectedDate) {
              setState(() {
                selectedDay = selectedDate;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: StreamBuilder(
                stream: _dbs.getSchedaCorrente(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    // CONTROLLO SULLO STREAM DI DATI
                    List lista = snapshot.data!.docs;
                    SchedaModel sm = lista[0].data();
                    List<Allenamento?> lista_sedute_allenamenti = [];
                    if (selectedDay.compareTo(sm.inizio_scheda!.toDate()) > 0 &&
                        selectedDay.compareTo(sm.fine_scheda!.toDate()) < 0) {
                      for (var a in sm.allenamenti!.toList(growable: true)) {
                        if (a.giornoAllenamento == selectedDay.weekday) {
                          lista_sedute_allenamenti.add(a);
                        }
                      }
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: lista_sedute_allenamenti.length,
                      itemBuilder: (context, index_allenamenti) {
                        //return Text(lista_sedute_allenamenti[index]!.giornoSettimana!);
                        return Card(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Text(
                                    lista_sedute_allenamenti[index_allenamenti]!
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
                                  itemBuilder: (context, index_esercizi) {
                                    return Theme(
                                      data: ThemeData().copyWith(
                                          dividerColor: Colors.transparent),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 8, right: 8, left: 8),
                                        child: ExpansionTile(
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8))),
                                          leading: CircleAvatar(
                                              backgroundColor: Theme.of(context)
                                                  .primaryColor,
                                              child: Text(
                                                "${index_esercizi + 1}°",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )),
                                          title: Text(
                                            lista_sedute_allenamenti[
                                                    index_allenamenti]!
                                                .nomi_es![index_esercizi],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
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
                                )
                              ]),
                        );
                      },
                    );
                  } else {
                    return Text("no data");
                  }
                }),
          )
        ],
      ),
    );
  }
}

class paginaSchedaCorrente2 extends StatefulWidget {
  const paginaSchedaCorrente2({super.key});
  @override
  State<paginaSchedaCorrente2> createState() => _paginaSchedaCorrenteState2();
}

class _paginaSchedaCorrenteState2 extends State<paginaSchedaCorrente2> {
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
                                        child: Icon(
                                          Icons.book_rounded,
                                          color: Colors.white,
                                        )),
                                    title: Text(
                                      sm.nome_scheda!,
                                      style: TextStyle(
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
                  return Text("no data");
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
