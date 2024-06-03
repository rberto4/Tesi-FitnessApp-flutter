import 'package:app_fitness_test_2/services/SchedaModel.dart';
import 'package:flutter/material.dart';

class widgetTabellaEsercizi {
  List<Esercizio>? lista_esercizi;
  var context;
  widgetTabellaEsercizi({required this.lista_esercizi, required this.context});

  List<DataRow> _getRow() {
    List<DataRow> list = List.empty(growable: true);
    int index = 1;
    for (var a in lista_esercizi!) {
      list.add(DataRow(cells: [
        DataCell(Text("#$index")),
        DataCell(Text(a.nomeEsercizio!)),
        DataCell(Text(a.serieEsercizio!)),
        DataCell(Text(a.ripetizioniEsercizio!.first)),
        DataCell(Align(
          alignment: AlignmentDirectional.centerStart,
          child: IconButton(
            color: Theme.of(context).hintColor,
            onPressed: () {},
            icon: Icon(Icons.sticky_note_2_rounded),
          ),
        ))
      ]));
      index++;
    }

    return list;
  }

  Widget creaTabella() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Card(
        elevation: 0,
        child: SizedBox(
          width: double.infinity,
          child: DataTable(
            dividerThickness: 1,
            columnSpacing: 16,
            columns: const [
              DataColumn(label: Text("N°")),
              DataColumn(label: Text("Esercizio")),
              DataColumn(label: Text("Serie")),
              DataColumn(label: Text("Reps")),
              DataColumn(label: Text("Note")),
            ],
            rows: _getRow(),
          ),
        ),
      ),
    );
  }
}
