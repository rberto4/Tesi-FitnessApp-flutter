import 'package:app_fitness_test/Autenticazione/controlloUtente.dart';
import 'package:app_fitness_test/SchermateClienti/testVisualizzazioneScheda.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class schermataHomeCliente extends StatefulWidget {
  const schermataHomeCliente({super.key});

  @override
  State<schermataHomeCliente> createState() => _schermataHomeState();
}

class _schermataHomeState extends State<schermataHomeCliente> {
  int _selectedIndex = 0;

  void _onItemTapped(int value) {
    setState(() {
      _selectedIndex = value;
    });
  }

  void esci() {
    final as = Provider.of<authService>(context, listen: false);
    as.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home CLIENTE"), actions: [
        IconButton(onPressed: esci, icon: const Icon(Icons.logout))
      ]),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${authService().getEmailFromDb()}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  // Puoi aggiungere altri dettagli utente qui se necessario
                ],
              ),
            )
          ],
        ),
      ),
      body: testScheda(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        unselectedItemColor:
            Colors.black, // Colore degli elementi non selezionati
        selectedItemColor: Colors.lightBlue, // Colore dell'elemento selezionato
        showUnselectedLabels:
            false, // Mostra le etichette degli elementi non selezionati
        showSelectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.today),
            label: 'Workout di oggi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Lista Schede',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
        ],
      ),
    );
  }
}
