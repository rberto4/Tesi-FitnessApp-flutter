// ignore_for_file: file_names, must_be_immutable, non_constant_identifier_names, camel_case_types

import 'package:app_fitness_test_2/services/SchedaModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

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
        elevation: 2,
        backgroundColor: Theme.of(context).canvasColor,
        automaticallyImplyLeading: true,
        title: Text(
          list_esercizi.first.nomeEsercizio!,
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                Icons.bar_chart_rounded,
                color: Theme.of(context).hintColor.withOpacity(0.6),
              ),
              title: const Text(
                "Progressione carichi",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                    ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3.3,
              child: Center(
                child: ListView.builder(
                  reverse: true,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: list_date.length,
                  itemBuilder: (context, index_esercizi) {
                    return RotatedBox(
                        quarterTurns: 3,
                        child: Wrap(
                            direction: Axis.horizontal,
                            spacing: 16,
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.width / 20,
                              ),
                              LinearPercentIndicator(
                                backgroundColor: Colors.transparent,
                                center: getPercentGrafico(index_esercizi) == 1 ? Text("Massimale", style: TextStyle(color: Colors.white.withOpacity(0.8),fontSize: 12 , fontWeight: FontWeight.bold),) : null,
                                trailing: RotatedBox(
                                    quarterTurns: 1,
                                    child: Text(
                                      getCaricoGrafico(index_esercizi)
                                          .toStringAsFixed(0),
                                      style: TextStyle(
                                        
                                          color: getPercentGrafico(index_esercizi) == 1 ? null : null,
                                          fontWeight: getPercentGrafico(index_esercizi) == 1 ? FontWeight.bold : null,
                                          fontSize: 12),
                                    )),
                                leading: RotatedBox(
                                  quarterTurns: 1,
                                    child: 
                                      Text(
                                        "${list_date[index_esercizi]
                                                .toDate()
                                                .day}/${list_date[index_esercizi]
                                                .toDate()
                                                .month}",
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                  ),
                                percent: getPercentGrafico(index_esercizi),
                                progressColor: getPercentGrafico(index_esercizi) == 1 ? Colors.blue : Theme.of(context).primaryColor,
                                animation: true,
                                animationDuration: 1000,
                                barRadius: const Radius.circular(48),
                                lineHeight: MediaQuery.of(context).size.width/20,
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.width / 30,
                              )
                            ]));
                  },
                ),
              ),
            ),
           const SizedBox(
            height: 16,
           ),
            ListTile(
               leading: Icon(
                            Icons.calendar_month_rounded,
                            color: Theme.of(context).hintColor.withOpacity(0.6),
                          ),
              title: const Text(
                "Storico esercizio",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Flexible(
              child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: list_esercizi.length,
                  itemBuilder: (context, index_esercizi) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                         
                          title: Text(
                            "${list_date[index_esercizi].toDate().day}/${list_date[index_esercizi]
                                    .toDate()
                                    .month}/${list_date[index_esercizi]
                                    .toDate()
                                    .year}",
                          ),
                          trailing: IconButton(
                              icon: const Icon(Icons.description_rounded),
                              color: Theme.of(context).primaryColor,
                              onPressed: () {
                                dialogFeedback(index_esercizi);
                              }),
                        ),
                        Card(
                          child: SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: DataTable(
                                  dividerThickness: 1,
                                  columnSpacing: 16,
                                  columns: [
                                    DataColumn(
                                      label: Text(
                                          controlloCaricoFisso(index_esercizi)
                                              ? "Serie"
                                              : "N° Serie"),
                                    ),
                                    const DataColumn(
                                      label: Text('Ripetizioni'),
                                    ),
                                    const DataColumn(
                                      label: Text('Carico'),
                                    ),
                                  ],
                                  rows: getTableData(index_esercizi)),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        const Divider()
                      ],
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }

  List<DataRow> getTableData(int index_esercizi) {
    List<DataRow> list = List.empty(growable: true);

    if (controlloCaricoFisso(index_esercizi)) {
      list.add(DataRow(cells: [
        DataCell(Text(list_esercizi[index_esercizi].serieEsercizio!)),
        DataCell(Text(list_esercizi[index_esercizi].ripetizioniEsercizio![0])),
        DataCell(
            Text("${list_esercizi[index_esercizi].carichiEsercizio![0]} Kg"))
      ]));
    } else {
      for (int i = 0;
          i < int.parse(list_esercizi[index_esercizi].serieEsercizio!);
          i++) {
        list.add(DataRow(cells: [
          DataCell(Text("#${i + 1}")),
          DataCell(
              Text(list_esercizi[index_esercizi].ripetizioniEsercizio![i])),
          DataCell(
              Text("${list_esercizi[index_esercizi].carichiEsercizio![i]} Kg"))
        ]));
      }
    }

    return list;
  }

  bool controlloCaricoFisso(int index_esercizi) {
    bool check = true;
    double? temp_carichi =
        double.tryParse(list_esercizi[index_esercizi].carichiEsercizio!.first);
    double? temp_reps = double.tryParse(
        list_esercizi[index_esercizi].ripetizioniEsercizio!.first);
    for (var a in list_esercizi[index_esercizi].carichiEsercizio!) {
      if (double.tryParse(a) != temp_carichi) {
        check = false;
      }
    }

    for (var a in list_esercizi[index_esercizi].ripetizioniEsercizio!) {
      if (double.tryParse(a) != temp_reps) {
        check = false;
      }
    }

    return check;
  }

  void dialogFeedback(int index_esercizi) {}

  double getPercentGrafico(int index_esercizi) {
    double percent = 0;
    double carico_max = 0;
    double carico_corrente = 0;
    double temp = 0;

    // recupero il carico massimo mai usato tra tutte le serie e tutti gli esercizi

    for (var a in list_esercizi) {
      for (var b in a.carichiEsercizio!) {
        if (double.tryParse(b)! > temp) {
          temp = double.tryParse(b)!;
        }
        carico_max = temp;
      }
    }
    temp = 0;
    // recupero il carico corrente della singola barra

    for (var a in list_esercizi[index_esercizi].carichiEsercizio!) {
      if (double.tryParse(a)! > temp) {
        temp = double.tryParse(a)!;
      }
      carico_corrente = temp;
    }
    // recupero in percentuale

    percent = carico_corrente / carico_max;
    return percent;
  }

  double getCaricoGrafico(int index_esercizi) {
    double carico = 0;

    if (controlloCaricoFisso(index_esercizi)) {
      carico =
          double.parse(list_esercizi[index_esercizi].carichiEsercizio!.first);
    } else {
      double temp = 0;
      for (var a in list_esercizi[index_esercizi].carichiEsercizio!) {
        if (double.parse(a) > temp) {
          temp = double.parse(a);
        }
      }
      carico = temp;
    }
    return carico;
  }
}
