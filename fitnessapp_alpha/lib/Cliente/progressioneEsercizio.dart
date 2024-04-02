import 'package:app_fitness_test_2/services/SchedaModel.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class progressioneEsercizio extends StatefulWidget {
  late String nome_es;
  late SchedaModel sm;
  progressioneEsercizio({super.key, required this.nome_es, required this.sm});

  @override
  State<progressioneEsercizio> createState() =>
      _progressioneEsercizioState(this.sm, this.nome_es);
}

class _progressioneEsercizioState extends State<progressioneEsercizio> {
  late String _nome_es;
  late SchedaModel sm;
  late esercizio _es = new esercizio(
      nome_esercizio: null, lista_carichi: null, giorni_esecuzioni: null);
  _progressioneEsercizioState(this.sm, this._nome_es);

  @override
  void initState() {
    recuperaStoricoEs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          ListTile(
            title: Text(
              _nome_es,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          LineChart(LineChartData(lineBarsData: [
            LineChartBarData(
                isCurved: true,
                barWidth: 2,
                color: Theme.of(context).primaryColor,
                spots: getListaDatiPlottati())
          ])),
          ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 8),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: _es.giorni_esecuzioni!.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  title: Text("Data"),
                  subtitle: Text(DateFormat("yMMMMd", "it-IT")
                      .format(_es.giorni_esecuzioni![index].toDate())),
                  trailing: Text(
                    _es.lista_carichi![index] + " Kg",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  void recuperaStoricoEs() {
    sm.storico_esercizi!.forEach((element) {
      if (_nome_es == element.nome_esercizio) {
        _es = element;
      }
    });
  }

  double getCaricoMassimo() {
    late double max = 0;
    _es.lista_carichi!.forEach((element) {
      if (double.parse(element) > max) {
        max = double.parse(element);
      }
    });
    return max;
  }

  double getCaricoMinimo() {
    late double min = 100000;
    _es.lista_carichi!.forEach((element) {
      if (double.parse(element) < min) {
        min = double.parse(element);
      }
    });
    return min;
  }

  List<FlSpot> getListaDatiPlottati() {
    List<FlSpot> list = List.generate(
        _es.lista_carichi!.length,
        (index) =>
            FlSpot(index.toDouble(), double.parse(_es.lista_carichi![index])));

    return list;
  }
}
