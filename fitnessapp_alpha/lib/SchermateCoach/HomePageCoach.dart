import 'package:app_fitness_test/Autenticazione/controlloUtente.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'visualizzazioneSchedaHome.dart';

class schermataHomeCoach extends StatefulWidget {
  const schermataHomeCoach({super.key});

  @override
  State<schermataHomeCoach> createState() => _schermataHomeState();
}

class _schermataHomeState extends State<schermataHomeCoach> {
  void esci() {
    final as = Provider.of<authService>(context, listen: false);
    as.signOut();
  }

  int _selectedIndex = 0;
  int clienteIndex = -1;

  void _onItemTapped(int value) {
    setState(() {
      _selectedIndex = value;
    });
  }

  // lista clienti x drawer laterale
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<String>> getClientiList() async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('clienti')
        .where('mailCoach', isEqualTo: authService().getEmailFromDb())
        .get();

    List<String> clientiList = [];

    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      var nome = document['nome'];
      var cognome = document['cognome'];
      clientiList.add('$nome $cognome');
    }

    return clientiList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home coach"), actions: [
        IconButton(onPressed: esci, icon: const Icon(Icons.logout))
      ]),
      drawer: Drawer(
        child: FutureBuilder(
          future: getClientiList(),
          builder: (context, snapshot) {
            List<String> clientiList = snapshot.data as List<String>;

            return ListView.builder(
              itemCount: clientiList.length,
              itemBuilder: (context, index) {
                var cliente = clientiList[index];

                return GestureDetector(
                  onTap: () {
                    Provider.of<authService>(context, listen: false)
                        .setUserData(clientiList[index].split(" ").first,
                            clientiList[index].split(" ").last);

                    Navigator.pop(context);
                    setState(() {
                      clienteIndex = index;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        color: clienteIndex == index
                            ? Colors.blue.withOpacity(0.2)
                            : null,
                      ),
                      child: ListTile(
                        title: Text(
                          cliente,
                          style: TextStyle(
                            fontWeight:
                                clienteIndex == index ? FontWeight.bold : null,
                          ),
                        ),

                        // Altri widget o azioni associati al cliente possono essere aggiunti qui
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Mostra il bottom sheet quando il pulsante è premuto
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: 200.0, // Regola l'altezza del bottom sheet
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Contenuto del Bottom Sheet'),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        // Chiudi il bottom sheet quando il pulsante è premuto
                        Navigator.pop(context);
                      },
                      child: Text('Chiudi'),
                    ),
                  ],
                ),
              );
            },
          );
        },
        tooltip: 'Mostra Bottom Sheet',
        child: Icon(Icons.add),
      ),
      body: Container(alignment: Alignment.topCenter, child: tabellaScheda()),
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
            label: 'Ultima scheda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Archivio schede',
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
