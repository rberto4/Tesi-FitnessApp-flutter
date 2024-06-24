// ignore_for_file: file_names, camel_case_types, prefer_typing_uninitialized_variables

import 'package:app_fitness_test_2/services/SchedaModel.dart';
import 'package:flutter/material.dart';

class widgetTabellaEsercizi {
  List<Esercizio>? listaEsercizi;
  var context;
  widgetTabellaEsercizi({required this.listaEsercizi, required this.context});

  List<DataRow> _getRow() {
    List<DataRow> list = List.empty(growable: true);
    int index = 1;
    for (var a in listaEsercizi!) {
      list.add(DataRow(cells: [
        DataCell(Text("#$index")),
        DataCell(Text(a.nomeEsercizio!)),
        DataCell(Text(a.serieEsercizio!)),
        DataCell(Text(a.ripetizioniEsercizio!.first)),
        DataCell(Align(
          alignment: AlignmentDirectional.centerStart,
          child: IconButton(
            color: Theme.of(context).hintColor,
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      actionsAlignment: MainAxisAlignment.center,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      icon: const Icon(Icons.bookmark_rounded),
                      title: Text(
                        "Note per ${a.nomeEsercizio!}",
                      ),
                      content: Text(a.noteEsercizio!),
                      actions: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                              icon: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Icon(Icons.close),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              label: const Text("Chiudi"),
                              style: ButtonStyle(
                                  elevation: const MaterialStatePropertyAll(1),
                                  backgroundColor:
                                      const MaterialStatePropertyAll(
                                          Colors.red),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  )))),
                        )
                      ],
                    );
                  });
            },
            icon: const Icon(Icons.sticky_note_2_rounded),
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
