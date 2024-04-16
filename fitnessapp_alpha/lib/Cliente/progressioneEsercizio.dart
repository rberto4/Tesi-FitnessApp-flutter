import 'package:app_fitness_test_2/services/SchedaModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class progressioneEsercizio extends StatelessWidget {
  late List<Esercizio> list_esercizi;
  late List<Timestamp> list_date;

  progressioneEsercizio(
      {super.key, required this.list_esercizi, required this.list_date});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          list_esercizi.first.nomeEsercizio!,
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 8),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: list_esercizi.length,
                itemBuilder: (context, index_esercizi) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.calendar_month_rounded,
                          color: Theme.of(context).hintColor,
                        ),
                        title: Text(
                          list_date[index_esercizi].toDate().day.toString() +
                              "/" +
                              list_date[index_esercizi]
                                  .toDate()
                                  .month
                                  .toString() +
                              "/" +
                              list_date[index_esercizi]
                                  .toDate()
                                  .year
                                  .toString(),
                          style: TextStyle(fontSize: 18),
                        ),
                        trailing: IconButton(
                            icon: Icon(Icons.description_rounded),
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              dialogFeedback(index_esercizi);
                            }),
                      ),
                      Card(
                        child: SizedBox(
                          width: double.infinity,
                          child: DataTable(
                              dividerThickness: 1,
                              columnSpacing: 16,
                              columns: [
                                DataColumn(
                                  label: Text(controlloCaricoFisso(index_esercizi)? "Serie" : "N° Serie"),
                                ),
                                DataColumn(
                                  label: Text('Ripetizioni'),
                                ),
                                DataColumn(
                                  label: Text('Carico'),
                                ),
                              ],
                              rows: getTableData(index_esercizi)),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Divider()
                    ],
                  );
                }),
          )
        ],
      ),
    );
  }

  List<DataRow> getTableData(int index_esercizi) {
    List<DataRow> list = new List.empty(growable: true);

    if (controlloCaricoFisso(index_esercizi)) {
      list.add(DataRow(cells: [
        DataCell(Text(list_esercizi[index_esercizi].serieEsercizio!)),
        DataCell(Text(list_esercizi[index_esercizi].ripetizioniEsercizio![0])),
        DataCell(
            Text(list_esercizi[index_esercizi].carichiEsercizio![0] + " Kg"))
      ]));
    } else {
      for (int i = 0;
          i < int.parse(list_esercizi[index_esercizi].serieEsercizio!);
          i++) {
        list.add(DataRow(cells: [
          DataCell(Text("#" + (i + 1).toString())),
          DataCell(
              Text(list_esercizi[index_esercizi].ripetizioniEsercizio![i])),
          DataCell(
              Text(list_esercizi[index_esercizi].carichiEsercizio![i] + " Kg"))
        ]));
      }
    }

    return list;
  }

  bool controlloCaricoFisso(int index_esercizi) {
    bool check = true;
    int? temp_carichi =
        int.tryParse(list_esercizi[index_esercizi].carichiEsercizio!.first);
    int? temp_reps =
        int.tryParse(list_esercizi[index_esercizi].ripetizioniEsercizio!.first);
    for (var a in list_esercizi[index_esercizi].carichiEsercizio!) {
      if (int.tryParse(a) != temp_carichi) {
        check = false;
      }
    }

     for (var a in list_esercizi[index_esercizi].ripetizioniEsercizio!) {
      if (int.tryParse(a) != temp_reps) {
        check = false;
      }
    }

    return check;
  }

  void dialogFeedback(int index_esercizi) {}
}
