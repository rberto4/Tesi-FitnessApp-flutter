// ignore_for_file: no_logic_in_create_state, camel_case_types, non_constant_identifier_names, unnecessary_set_literal, avoid_function_literals_in_foreach_calls, file_names, must_be_immutable

import 'package:app_fitness_test_2/Cliente/widgetTabella.dart';
import 'package:app_fitness_test_2/services/SchedaModel.dart';
import 'package:app_fitness_test_2/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

DatabaseService _dbs = DatabaseService();

class gestioneCalendario extends StatefulWidget {
  late Scheda scheda;

  gestioneCalendario({super.key, required this.scheda});

  @override
  State<gestioneCalendario> createState() => _gestioneCalendarioState(scheda);
}

class _gestioneCalendarioState extends State<gestioneCalendario> {
  late Scheda scheda;
  _gestioneCalendarioState(this.scheda);

  List<DateTime?> listaGiorniScheda = List.empty(growable: true);
  List<String> listaAssegnazioni = List.empty(growable: true);

  TimeOfDay orarioSelezionato = TimeOfDay.now();
  late DateTime data_selezionata = DateUtils.dateOnly(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: false,
          title: const Text(
            "Assegnazione giornate",
          ),
          automaticallyImplyLeading: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.event_repeat_rounded),
              onPressed: () {
                setState(() {
                  autoAssegnaAllenamenti();
                });
              },
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                setState(() {
                  if (value == "Ripristina assegnazioni") {
                    scheda.allenamentiScheda!.forEach(
                        (element) => {element.giorniAssegnati!.clear()});
                    salvaInDb();
                  }
                });
              },
              itemBuilder: (BuildContext context) {
                return {'Ripristina assegnazioni'}.map((String choice) {
                  return PopupMenuItem<String>(
                    padding: const EdgeInsets.all(8),
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            EasyDateTimeLine(
              headerProps: EasyHeaderProps(
                centerHeader: false,
                padding: const EdgeInsets.only(
                    left: 16, right: 8, top: 8, bottom: 8),
                monthPickerType: MonthPickerType.dropDown,
                showSelectedDate: true,
                selectedDateStyle: Theme.of(context).textTheme.titleMedium,
                dateFormatter: const DateFormatter.fullDateDMonthAsStrY(),
              ),
              dayProps: EasyDayProps(
                activeDayStyle: const DayStyle(
                  borderRadius: 48.0,
                  dayNumStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                  ),
                  dayStrStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                width: 64.0,
                height: 64.0,
                dayStructure: DayStructure.dayNumDayStr,
                inactiveDayStyle: DayStyle(
                    dayNumStyle: Theme.of(context).textTheme.headlineSmall),
                borderColor: Theme.of(context).dividerColor,
                todayStyle: DayStyle(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border:
                            Border.all(color: Theme.of(context).primaryColor)),
                    dayNumStyle: Theme.of(context).textTheme.headlineSmall,
                    monthStrStyle: Theme.of(context).textTheme.headlineSmall),
              ),
              locale: "it_IT",
              initialDate: data_selezionata,
              onDateChange: (selectedDate) {
                setState(() {
                  data_selezionata = selectedDate;
                });
              },
            ),
            const ListTile(
              title: Text(
                "Allenamenti in scheda",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),

            // lista card di sedute allenamenti

            ListView.builder(
              padding: const EdgeInsets.all(8),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: scheda.allenamentiScheda!.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Column(children: [
                    CheckboxListTile(
                      activeColor: Colors.red,
                      value: isChecked(
                          scheda.allenamentiScheda![index].giorniAssegnati!),
                      onChanged: (bool? value) {
                        setState(() {
                          modificaSelezioneGiorno(
                            value!,
                            index,
                            scheda,
                            data_selezionata,
                          );
                        });
                      },
                      title: Text(
                        scheda.allenamentiScheda![index].nomeAllenamento!,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),

                    Align(
                      alignment: Alignment.center,
                      child: widgetTabellaEsercizi(
                              lista_esercizi: scheda
                                  .allenamentiScheda![index].listaEsercizi,
                              context: context)
                          .creaTabella(),
                    ),

                    // pulsante selezione orario

                    Align(
                      alignment: Alignment.centerRight,
                      child: Visibility(
                        visible: isChecked(
                            scheda.allenamentiScheda![index].giorniAssegnati!),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8),
                          child: SizedBox(
                            height: 48,
                            child: ElevatedButton.icon(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                )),
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.red),
                              ),
                              label: Text("Orario di allenamento"),
                              icon: Icon(Icons.alarm_add_rounded),
                              onPressed: () {
                                _selectTime(index, scheda, scheda.idScheda!);
                              },
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 8,
                    )
                  ]),
                );
              },
            ),
          ],
        )));
  }

  void _selectTime(int i, Scheda s, String docId) async {
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
            s,
            DateTime(
                data_selezionata.year,
                data_selezionata.month,
                data_selezionata.day,
                orarioSelezionato.hour,
                orarioSelezionato.minute));
        orarioSelezionato.replacing(hour: 0, minute: 0);
      });
    }
  }

  bool isChecked(List<Timestamp> l) {
    bool b = false;
    for (var a in l) {
      if (DateUtils.dateOnly(a.toDate()) ==
          DateUtils.dateOnly(data_selezionata)) {
        b = true;
      }
    }
    return b;
  }

  bool isTimeSelected(List<Timestamp> list) {
    bool b = false;
    for (var a in list) {
      if (DateUtils.dateOnly(a.toDate()) ==
          DateUtils.dateOnly(data_selezionata)) {
        if (a.toDate().hour != 0 || a.toDate().minute != 0) {
          b = true;
        }
      }
    }
    return b;
  }

  Text getOrarioAssegnato(List<Timestamp> list) {
    late String b = "Orario allenamento";
    for (var a in list) {
      if (DateUtils.dateOnly(a.toDate()) ==
          DateUtils.dateOnly(data_selezionata)) {
        if (a.toDate().hour != 0 || a.toDate().minute != 0) {
          if (a.toDate().hour < 10 && a.toDate().minute > 10) {
            b = "0${a.toDate().hour}:${a.toDate().minute}";
          } else if (a.toDate().hour > 10 && a.toDate().minute < 10) {
            b = "${a.toDate().hour}:0${a.toDate().minute}";
          } else {
            b = "${a.toDate().hour}:${a.toDate().minute}";
          }
        }
      }
    }
    return Text(
      b,
      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
    );
  }

  void modificaSelezioneGiorno(bool b, int index, Scheda s, DateTime d) {
    if (b) {
      for (var a in s.allenamentiScheda![index].giorniAssegnati!) {
        if (DateUtils.dateOnly(a.toDate()) == DateUtils.dateOnly(d)) {
          s.allenamentiScheda![index].giorniAssegnati!.remove(a);
          break;
        }
      }
      s.allenamentiScheda![index].giorniAssegnati!.add(Timestamp.fromDate(d));
    } else {
      for (var a in s.allenamentiScheda![index].giorniAssegnati!) {
        if (DateUtils.dateOnly(a.toDate()) == DateUtils.dateOnly(d)) {
          s.allenamentiScheda![index].giorniAssegnati!.remove(a);
          break;
        }
      }
    }

    salvaInDb();
  }

  void autoAssegnaAllenamenti() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.end,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          icon: const Icon(Icons.event_repeat_rounded),
          iconColor: Colors.teal,
          title: const Text(
            'Assegnazione automatica',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
              'Questa opzione replicherà gli allenamenti che hai già assegnato, impostandoli automaticamente ogni 7 giorni, fino alla fine del periodo previsto dalla tua scheda.\n\nPotrai comunque modifichiare date e orari, ogni volta che lo desideri '),
          actions: [
            OutlinedButton(
              style: ButtonStyle(
                  textStyle: MaterialStatePropertyAll(
                      TextStyle(color: Theme.of(context).primaryColor))),
              child: const Text('Annulla'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll(Theme.of(context).primaryColor)),
              child: const Text('Assegna'),
              onPressed: () {
                for (var a in scheda.allenamentiScheda!) {
                  List<Timestamp> lista_nuove_date = List.empty(growable: true);
                  for (var b in a.giorniAssegnati!) {
                    late DateTime newdate = b.toDate();
                    while (DateUtils.dateOnly(newdate.add(const Duration(
                                days: 7, minutes: 0, seconds: 0, hours: 0)))
                            .isBefore(DateUtils.dateOnly(
                                scheda.fineScheda!.toDate())) ||
                        DateUtils.dateOnly(newdate.add(const Duration(
                                days: 7, minutes: 0, seconds: 0, hours: 0)))
                            .isAtSameMomentAs(DateUtils.dateOnly(
                                scheda.fineScheda!.toDate()))) {
                      newdate = newdate.add(const Duration(
                          days: 7, minutes: 0, seconds: 0, hours: 0));
                      lista_nuove_date.add(Timestamp.fromDate(newdate));
                    }
                  }

                  a.giorniAssegnati!.addAll(lista_nuove_date);
                  lista_nuove_date.clear();

                  for (int i = 0; i < a.giorniAssegnati!.length; i++) {}
                }
                Navigator.of(context).pop();
                salvaInDb();
              },
            ),
          ],
        );
      },
    );
  }

  void salvaInDb() {
    _dbs
        .getInstanceDb()
        .collection(_dbs.getCollezioneUtenti())
        .doc(_dbs.getAuth().currentUser!.uid)
        .collection(_dbs.getCollezioneSchede())
        .doc(scheda.idScheda)
        .set(
          scheda.toFirestore(),
        );
  }
}
