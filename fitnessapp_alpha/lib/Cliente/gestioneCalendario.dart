import 'package:app_fitness_test_2/services/SchedaModel.dart';
import 'package:app_fitness_test_2/services/database_service.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

DatabaseService _dbs = DatabaseService();

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
  List<DateTime?> lista_date_selezionate = new List.empty();
  TimeOfDay orarioSelezionato = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  SchedaModel sm = lista[0].data();
                  return Column(
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CalendarDatePicker2(
                            config: CalendarDatePicker2Config(
                                dayBuilder: (
                                    {required date,
                                    decoration,
                                    isDisabled,
                                    isSelected,
                                    isToday,
                                    textStyle}) {},
                                selectedDayTextStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.white),
                                firstDate: sm.inizio_scheda!.toDate(),
                                lastDate: sm.fine_scheda!.toDate(),
                                calendarType: CalendarDatePicker2Type.single),
                            value: lista_date_selezionate,
                            onValueChanged: (value) {
                              setState(() {
                                lista_date_selezionate = value;
                              });
                            },
                          ),
                        ),
                      ),
                      Visibility(
                        visible: lista_date_selezionate.isNotEmpty,
                        child: ListTile(
                          title: Text(
                            "Allenamenti in scheda",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: sm.allenamenti!.length,
                        itemBuilder: (context, index) {
                          if (lista_date_selezionate.isNotEmpty) {
                            return Theme(
                              data: ThemeData(useMaterial3: false)
                                  .copyWith(dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                trailing: Visibility(
                                  visible: isChecked(
                                      sm.allenamenti![index].giorniAssegnati!),
                                  child: Wrap(
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
                                                      color: Colors.blue),
                                                  shape: BoxShape.rectangle,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          48)),
                                              child: Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: getOrarioAssegnato(sm
                                                      .allenamenti![index]
                                                      .giorniAssegnati!))),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.alarm_add_rounded,
                                          ),
                                          onPressed: () {
                                            _selectTime(index, sm,
                                                snapshot.data!.docs.first.id);
                                          },
                                        ),
                                      ]),
                                ),
                                leading: Checkbox(
                                  value: isChecked(
                                      sm.allenamenti![index].giorniAssegnati!),
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
                                  sm.allenamenti![index].nomeAllenamento!,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: sm.allenamenti![index]
                                              .nomi_es!.length,
                                          scrollDirection: Axis.vertical,
                                          itemBuilder: (context, index_es) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16),
                                              child: ListTile(
                                                leading: CircleAvatar(
                                                    radius: 12,
                                                    backgroundColor:
                                                        Colors.blue,
                                                    child: Text(
                                                      "${index_es + 1}°",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12),
                                                    )),
                                                title: Text(sm
                                                    .allenamenti![index]
                                                    .nomi_es![index_es]),
                                                subtitle: Text(sm
                                                        .allenamenti![index]
                                                        .serie_es![index_es] +
                                                    " serie, " +
                                                    sm.allenamenti![index]
                                                            .ripetizioni_es![
                                                        index_es] +
                                                    " ripetizioni"),
                                              ),
                                            );
                                          }),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {}
                        },
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

    print(orarioSelezionato.toString());
  }

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
          fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 12),
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
        .set(sm.toFirestore(),);
  }
}
