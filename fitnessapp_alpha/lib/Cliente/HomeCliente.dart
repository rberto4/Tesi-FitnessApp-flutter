
import 'package:app_fitness_test_2/autenticazione/login.dart';
import 'package:app_fitness_test_2/autenticazione/metodi_autenticazione.dart';
import 'package:app_fitness_test_2/services/SchedaModel.dart';
import 'package:app_fitness_test_2/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseFirestore db = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;
get user => _auth.currentUser?.displayName;

class MainPageCliente extends StatefulWidget {
  const MainPageCliente({super.key});

  @override
  State<MainPageCliente> createState() => _MainPageClienteState();
}

class _MainPageClienteState extends State<MainPageCliente> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        elevation: 4,
        shadowColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          "$user",
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
  final DatabaseService _dbs = DatabaseService();
  late DateTime selectedDay;
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
            child: Container(
              width: double.infinity,
              child: Card(
                  child: Column(
                children: [
                  StreamBuilder(
                      stream: _dbs.getSchedaCorrente(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List lista = snapshot.data!.docs;
                          SchedaModel sm = lista[0].data();

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  sm.nome_scheda!,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24),
                                ),
                              ),
                              ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: sm.lunedi!.nomi_es!
                                      .length, // lunghezza lista esercizi presa dalla lunga dell'array dei nomi
                                  itemBuilder: (context, index) {
                                    // liste nomi, reps, serie

                                    List<String>? lista_es_nomi =
                                        sm.lunedi!.nomi_es;
                                    List<String>? lista_es_ripetizioni =
                                        sm.lunedi!.ripetizioni_es;
                                    List<String>? lista_es_serie =
                                        sm.lunedi!.serie_es;

                                    return Theme(
                                      data: ThemeData().copyWith(
                                          dividerColor: Colors.transparent,
                                           highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
                                          ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ExpansionTile(
                                         
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          leading: Icon(
                                              Icons.book),
                                          title: Text(
                                            lista_es_nomi![index],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          children: <Widget>[
                                            ListTile(
                                          
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              title: Text(
                                                  "${lista_es_serie![index]} serie"),
                                            ),
                                            ListTile(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              title: Text(
                                                  "${lista_es_ripetizioni![index]} ripetizioni"),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            ],
                          );
                        } else {
                          return Text("no data");
                        }
                      }),
                ],
              )),
            ),
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
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("ciao2"),
    );
  }
}
