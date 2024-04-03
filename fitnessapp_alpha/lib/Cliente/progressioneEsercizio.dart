import 'package:app_fitness_test_2/services/SchedaModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
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
          Expanded(child: LineChart(getLineChartData())),
          ListView.builder(
            padding: EdgeInsets.all(16),
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
                  leading: Icon(Icons.calendar_month),
                  title: Text(DateFormat("yMMMMd", "it-IT")
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
    print(max);
    return max;
  }

  double getCaricoMinimo() {
    late double min = 100000;
    _es.lista_carichi!.forEach((element) {
      if (double.parse(element) < min) {
        min = double.parse(element);
      }
    });
    print(min);
    return min;
  }

  Timestamp getDataPiuRecente(List<Timestamp> list) {
    return list.reduce((min, e) => e.toDate().isBefore(min.toDate()) ? e : min);
  }

  Timestamp getDataMenoRecente(List<Timestamp> list) {
    return list.reduce((min, e) => e.toDate().isAfter(min.toDate()) ? e : min);
  }

  List<FlSpot> getChartData() {
    List<FlSpot> list = new List.empty(growable: true);
    for (int i = 0; i < _es.giorni_esecuzioni!.length; i++) {
      list.add(FlSpot(
          _es.giorni_esecuzioni![i].millisecondsSinceEpoch.toDouble(),
          double.parse(_es.lista_carichi![i])));
    }
    return list;
  }

  // grafico

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    DateTime date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
    text = Text(DateFormat("yMMMMd", "it-IT").format(date));
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }

  LineChartData getLineChartData() => LineChartData(
          titlesData: FlTitlesData(
              show: true,
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: bottomTitleWidgets
                )
                 )),

          minY: getCaricoMinimo(),
          maxY: getCaricoMassimo(),

          lineBarsData: [
            LineChartBarData(spots: getChartData(), isCurved: true, barWidth: 3)
          ]);
}
