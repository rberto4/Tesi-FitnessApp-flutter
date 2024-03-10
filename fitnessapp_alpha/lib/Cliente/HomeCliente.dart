import 'package:app_fitness_test_2/autenticazione/login.dart';
import 'package:app_fitness_test_2/autenticazione/metodi_autenticazione.dart';
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
      appBar: AppBar(
        elevation: 4,
        shadowColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
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
      drawer: Drawer(),

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
        child: Center(
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
    paginaSchedaCorrente(),
    paginaSchedaCorrente2(),
  ];
}

class paginaSchedaCorrente extends StatefulWidget {
  const paginaSchedaCorrente({super.key});

  @override
  State<paginaSchedaCorrente> createState() => _paginaSchedaCorrenteState();
}

class _paginaSchedaCorrenteState extends State<paginaSchedaCorrente> {
  @override
  Widget build(BuildContext context) {
    //leggiDati();
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        EasyDateTimeLine(
          locale: "it_IT",
          initialDate: DateTime.now(),
          onDateChange: (selectedDate) {
            //`selectedDate` the new date selected.
          },
        ),
        Text("ciaooo"),
      ],
    ));
  }

  Future leggiDati() async {
    if (_auth.currentUser != null) {
      await db.collection("roberto@mail.com").get().then((value) {
        for (var doc in value.docs) {
          print("${doc.id} => ${doc.data()}");
        }
      });
    }
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
