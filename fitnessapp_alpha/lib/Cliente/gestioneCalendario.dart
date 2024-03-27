import 'package:app_fitness_test_2/Cliente/dettagliAllenamento.dart';
import 'package:app_fitness_test_2/services/SchedaModel.dart';
import 'package:app_fitness_test_2/services/database_service.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

DatabaseService _dbs = DatabaseService();
late SchedaModel sm;

List<DateTime?> listaGiorniScheda = new List.empty(growable: true);
List<String> listaAssegnazioni = new List.empty(growable: true);

class AssegnazioneGiornateAllenamentoPage extends StatefulWidget {
  const AssegnazioneGiornateAllenamentoPage({super.key});

  @override
  State<AssegnazioneGiornateAllenamentoPage> createState() =>
      _AssegnazioneGiornateAllenamentoPageState();
}

class _AssegnazioneGiornateAllenamentoPageState
    extends State<AssegnazioneGiornateAllenamentoPage> {

  List<DateTime?> lista_date_selezionate = new List.empty(growable: true);
  TimeOfDay orarioSelezionato = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        height: 48,
        padding: EdgeInsets.only(left: 16, right: 16),
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStatePropertyAll(Colors.orange.shade700)),
          onPressed: () {
            autoAssegnazioneGiorni(sm);
          },
          child: const Center(
            child: Text('Replica settimana'),
          ),
        ),
      ),

        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: false,
          title: Text(
            "Calendario scheda",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          automaticallyImplyLeading: true,
        ),
        body: SingleChildScrollView(
          child: StreamBuilder(
              stream: _dbs.getSchedaCorrente(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List lista = snapshot.data!.docs;
                  sm = lista[0].data();
                  return Column(
                    children: [
                      EasyDateTimeLine(
                        headerProps: const EasyHeaderProps(
                          dateFormatter: DateFormatter.fullDateDMonthAsStrY(),
                        ),
                        dayProps: const EasyDayProps(
                            activeDayStyle: DayStyle(
                              borderRadius: 48.0,
                              dayNumStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                              dayStrStyle: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            width: 56.0,
                            height: 56.0,
                            dayStructure: DayStructure.dayNumDayStr,
                            inactiveDayStyle: DayStyle(
                                dayNumStyle: TextStyle(
                              fontSize: 18.0,
                            ))),
                        locale: "it_IT",
                        initialDate: DateTime.now(),
                        onDateChange: (selectedDate) {
                          setState(() {
                            if (lista_date_selezionate.contains(selectedDate)) {
                              lista_date_selezionate.remove(selectedDate);
                            } else {
                              lista_date_selezionate.add(selectedDate);
                            }
                            print(selectedDate);
                          });
                        },
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Visibility(
                        visible: lista_date_selezionate.isNotEmpty,
                        child: ListTile(
                          title: Text(
                            "Sedute di allenamento",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          padding: EdgeInsets.only(bottom: 80),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: sm.allenamenti!.length,
                          itemBuilder: (context, index) {
                            if (lista_date_selezionate.isNotEmpty) {
                              return Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Theme(
                                      data: ThemeData().copyWith(
                                          dividerColor: Colors.transparent),
                                      child: ExpansionTile(
                                        initiallyExpanded: true,
                                        trailing: Visibility(
                                          visible: isChecked(sm
                                              .allenamenti![index]
                                              .giorniAssegnati!),
                                          child: Wrap(
                                              alignment: WrapAlignment.end,
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.center,
                                              children: [
                                                Visibility(
                                                  visible: isTimeSelected(sm
                                                      .allenamenti![index]
                                                      .giorniAssegnati!),
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              width: 1,
                                                              color:
                                                                  Colors.teal),
                                                          shape: BoxShape
                                                              .rectangle,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      48)),
                                                      child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  8.0),
                                                          child: getOrarioAssegnato(sm
                                                              .allenamenti![index]
                                                              .giorniAssegnati!))),
                                                ),
                                                IconButton(
                                                  color: Colors.orange.shade700,
                                                  icon: Icon(
                                                    Icons.alarm_add_rounded,
                                                  ),
                                                  onPressed: () {
                                                    _selectTime(
                                                        index,
                                                        sm,
                                                        snapshot.data!.docs
                                                            .first.id);
                                                  },
                                                ),
                                              ]),
                                        ),
                                        leading: Checkbox(
                                          activeColor: Colors.orange.shade700,
                                          value: isChecked(sm
                                              .allenamenti![index]
                                              .giorniAssegnati!),
                                          onChanged: (bool? value) {
                                            setState(() {
                                              modificaSelezioneGiorno(
                                                  value!,
                                                  index,
                                                  sm,
                                                  lista_date_selezionate.first!,
                                                  snapshot.data!.docs.first.id);
                                            });
                                          },
                                        ),
                                        title: Text(
                                          sm.allenamenti![index]
                                              .nomeAllenamento!,
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: sm
                                                    .allenamenti![index]
                                                    .nomi_es!
                                                    .length,
                                                scrollDirection: Axis.vertical,
                                                itemBuilder:
                                                    (context, index_es) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 16),
                                                    child: ListTile(
                                                      leading: CircleAvatar(
                                                          radius: 12,
                                                          backgroundColor:
                                                              Colors.teal,
                                                          child: Text(
                                                            "${index_es + 1}°",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12),
                                                          )),
                                                      title: Text(sm
                                                          .allenamenti![index]
                                                          .nomi_es![index_es]),
                                                      subtitle: Text(sm
                                                                  .allenamenti![
                                                                      index]
                                                                  .serie_es![
                                                              index_es] +
                                                          " serie, " +
                                                          sm.allenamenti![index]
                                                                  .ripetizioni_es![
                                                              index_es] +
                                                          " ripetizioni"),
                                                    ),
                                                  );
                                                }),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // pulsante card allenamento

                                    ListTile(
                                        trailing: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.orange.shade700)),
                                      child: Text("Visualizza e compila"),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                 dettagliScheda(allenamento: sm.allenamenti![index], id: snapshot.data!.docs[0].id)),
                                        );
                                      },
                                    )),
                                    SizedBox(
                                      height: 4,
                                    )
                                  ],
                                ),
                              );
                            } else {}
                          },
                        ),
                      ),
                    ],
                  );
                } else {
                  return Text("no data");
                }
              }),
        ));
  }

  void _selectTime(int i, SchedaModel sm, String docId) async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: orarioSelezionato,
    );
    if (newTime != null) {
      setState(() {
        orarioSelezionato = newTime;
        modificaSelezioneGiorno(
            true,
            i,
            sm,
            DateTime(
                lista_date_selezionate.first!.year,
                lista_date_selezionate.first!.month,
                lista_date_selezionate.first!.day,
                orarioSelezionato.hour,
                orarioSelezionato.minute),
            docId);
      });
    }
  }

// metodi bool utili a mostrare o meno i componenti quando attivi

  bool isChecked(List<Timestamp> l) {
    bool b = false;
    for (var a in l) {
      if (DateUtils.dateOnly(a.toDate()) ==
          DateUtils.dateOnly(lista_date_selezionate.first!)) {
        b = true;
      }
    }
    return b;
  }

  bool isTimeSelected(List<Timestamp> list) {
    bool b = false;
    for (var a in list) {
      if (DateUtils.dateOnly(a.toDate()) ==
          DateUtils.dateOnly(lista_date_selezionate.first!)) {
        if (a.toDate().hour != 0 || a.toDate().minute != 0) {
          b = true;
        }
      }
    }
    return b;
  }

// Widget di testo con l'orario selezionato

  Text getOrarioAssegnato(List<Timestamp> list) {
    late String b = "";
    for (var a in list) {
      if (DateUtils.dateOnly(a.toDate()) ==
          DateUtils.dateOnly(lista_date_selezionate.first!)) {
        if (a.toDate().hour != 0 || a.toDate().minute != 0) {
          if (a.toDate().hour < 10 && a.toDate().minute > 10) {
            b = "0" +
                a.toDate().hour.toString() +
                ":" +
                a.toDate().minute.toString();
          } else if (a.toDate().hour > 10 && a.toDate().minute < 10) {
            b = a.toDate().hour.toString() +
                ":0" +
                a.toDate().minute.toString();
          } else {
            b = a.toDate().hour.toString() + ":" + a.toDate().minute.toString();
          }
        }
      }
    }
    return Text(
      b,
      style: TextStyle(
          fontWeight: FontWeight.bold, color: Colors.teal, fontSize: 12),
    );
  }

  void modificaSelezioneGiorno(
      bool b, int index, SchedaModel sm, DateTime d, String id) {
    if (b) {
      for (var a in sm.allenamenti![index].giorniAssegnati!) {
        if (DateUtils.dateOnly(a.toDate()) == DateUtils.dateOnly(d)) {
          sm.allenamenti![index].giorniAssegnati!.remove(a);
          break;
        }
      }
      sm.allenamenti![index].giorniAssegnati!.add(Timestamp.fromDate(d));
    } else {
      print(b);
      for (var a in sm.allenamenti![index].giorniAssegnati!) {
        if (DateUtils.dateOnly(a.toDate()) == DateUtils.dateOnly(d)) {
          sm.allenamenti![index].giorniAssegnati!.remove(a);
          break;
        }
      }
    }
    print(
        "date per l'allenamento : " + sm.allenamenti![index].nomeAllenamento!);
    for (var a in sm.allenamenti![index].giorniAssegnati!) {
      print(a.toDate());
    }

    _dbs
        .getInstanceDb()
        .collection(_dbs.getCollezioneUtenti())
        .doc(_dbs.getAuth().currentUser!.uid)
        .collection(_dbs.getCollezioneSchede())
        .doc(id)
        .set(sm.toFirestore());
  }
  
  void autoAssegnazioneGiorni(SchedaModel sm) {
   for (int i = 0; i<sm.allenamenti!.length;i++){
    for(int j = 0; j<sm.allenamenti![i].giorniAssegnati!.length;j++){
      print(sm.allenamenti![i].giorniAssegnati![j].toDate());
    }
   }
  }
}
