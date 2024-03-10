import 'package:app_fitness_test_2/autenticazione/login.dart';
import 'package:app_fitness_test_2/autenticazione/metodi_autenticazione.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainPageCliente extends StatefulWidget {
  const MainPageCliente({super.key});

  @override
  State<MainPageCliente> createState() => _MainPageClienteState();
}

class _MainPageClienteState extends State<MainPageCliente> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  get user => _auth.currentUser?.displayName;
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
            mainAxisAlignment: MainAxisAlignment.center,
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
    return Container(
      child: Column(
        children: [
        ],
      )
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
