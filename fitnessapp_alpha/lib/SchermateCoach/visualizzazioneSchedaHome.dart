import 'package:app_fitness_test/Autenticazione/controlloUtente.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class tabellaScheda extends StatefulWidget {
  const tabellaScheda({super.key});

  @override
  State<tabellaScheda> createState() => _tabellaSchedaState();
}

class _tabellaSchedaState extends State<tabellaScheda> {
  List<DataRow> esercizi = [];

  @override
  Widget build(BuildContext context) {
    caricaDati(context);
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "${Provider.of<authService>(context).selectedName} ${Provider.of<authService>(context).selectedSurname}",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              DataTable(columns: [
                DataColumn(label: Text('Esercizio')),
                DataColumn(label: Text('Ripetizioni')),
                DataColumn(label: Text('Serie')),
                DataColumn(label: Text('Carico')),
                DataColumn(label: Text('Recupero')),
              ], rows: esercizi // Aggiunge le righe dinamicamente
                  ),
            ],
          ),
        ),
      ),
    );
  }

  void caricoEsercizio(String nome, String carico, String recupero,
      String ripetizioni, String serie) {
    setState(() {
      // Crea una nuova riga di dati con valori vuoti
      DataRow newRow = DataRow(
        cells: [
          DataCell(Text(nome)),
          DataCell(Text(ripetizioni)),
          DataCell(Text(serie)),
          DataCell(Text(carico)),
          DataCell(Text(recupero)),
        ],
      );
      // Aggiungi la nuova riga alla lista delle righe
      esercizi.add(newRow);
    });
  }

  Future<void> caricaDati(BuildContext context) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshotClienti = await _firestore
        .collection('clienti')
        .where('nome',
            isEqualTo: Provider.of<authService>(context).selectedName)
        .where('cognome',
            isEqualTo: Provider.of<authService>(context).selectedSurname)
        .get();
    List<QueryDocumentSnapshot> clienteSelezionato = querySnapshotClienti.docs;
    if (clienteSelezionato.isNotEmpty) {
      Map<String, dynamic> schedeClienteSelezionato;
      schedeClienteSelezionato = clienteSelezionato[0].get("schede");
      print(schedeClienteSelezionato);
    }
  }
}
