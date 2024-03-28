import 'package:app_fitness_test_2/Cliente/dettagliAllenamento.dart';
import 'package:app_fitness_test_2/services/SchedaModel.dart';
import 'package:app_fitness_test_2/services/database_service.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

DatabaseService _dbs = DatabaseService();

List<DateTime?> listaGiorniScheda = new List.empty(growable: true);
List<String> listaAssegnazioni = new List.empty(growable: true);

class gestioneCalendario extends StatefulWidget {
  late SchedaModel sm;

  gestioneCalendario({super.key, required this.sm});

  @override
  State<gestioneCalendario> createState() => _gestioneCalendarioState(this.sm);
}

class _gestioneCalendarioState extends State<gestioneCalendario> {
  late SchedaModel sm;
  _gestioneCalendarioState(this.sm);

  TimeOfDay orarioSelezionato = TimeOfDay.now();
  late DateTime data_selezionata = sm.inizio_scheda!.toDate();

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
          actions: [
            IconButton(
              icon: Icon(Icons.event_repeat_rounded),
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
                    sm.allenamenti!.forEach(
                        (element) => {element.giorniAssegnati!.clear()});
                    salvaInDb();
                  }
                });
              },
              itemBuilder: (BuildContext context) {
                return {'Ripristina assegnazioni'}.map((String choice) {
                  return PopupMenuItem<String>(
                    padding: EdgeInsets.all(8),
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
              headerProps: const EasyHeaderProps(
                dateFormatter: DateFormatter.fullDateDMonthAsStrY(),
              ),
              dayProps: const EasyDayProps(
                  activeDayStyle: DayStyle(
                    borderRadius: 48.0,
                    dayNumStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                    dayStrStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  width: 64.0,
                  height: 64.0,
                  dayStructure: DayStructure.dayNumDayStr,
                  inactiveDayStyle: DayStyle(
                      dayNumStyle: TextStyle(
                    fontSize: 18.0,
                  ))),
              locale: "it_IT",
              initialDate: sm.inizio_scheda!.toDate(),
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
              padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: sm.allenamenti!.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(children: [
                    ListTile(
                      contentPadding: EdgeInsets.only(right: 0),
                      horizontalTitleGap: 2,
                      leading: Checkbox(
                        value:
                            isChecked(sm.allenamenti![index].giorniAssegnati!),
                        onChanged: (bool? value) {
                          setState(() {
                            modificaSelezioneGiorno(
                              value!,
                              index,
                              sm,
                              data_selezionata,
                            );
                          });
                        },
                      ),
                      title: Text(
                        sm.allenamenti![index]!.nomeAllenamento!,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),

                      // pulsante selezione orario

                      trailing: Visibility(
                        visible:
                            isChecked(sm.allenamenti![index].giorniAssegnati!),
                        child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Visibility(
                                visible: isTimeSelected(
                                    sm.allenamenti![index].giorniAssegnati!),
                                child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1, color: Colors.teal),
                                        shape: BoxShape.rectangle,
                                        borderRadius:
                                            BorderRadius.circular(48)),
                                    child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: getOrarioAssegnato(sm
                                            .allenamenti![index]
                                            .giorniAssegnati!))),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.alarm_add_rounded,
                                  color: Theme.of(context).primaryColor,
                                ),
                                onPressed: () {
                                  _selectTime(index, sm, sm.id_scheda!);
                                },
                              ),
                            ]),
                      ),
                    ),
                    ListView.builder(
                      itemCount: sm.allenamenti![index]!.nomi_es!.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index_esercizi) {
                        return Theme(
                          data: ThemeData()
                              .copyWith(dividerColor: Colors.transparent),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                bottom: 8, right: 8, left: 8),
                            child: ExpansionTile(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(48))),
                              leading: CircleAvatar(
                                  radius: 16,
                                  backgroundColor: Colors.teal,
                                  child: Text(
                                    "${index_esercizi + 1}.",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  )),
                              title: Text(
                                sm.allenamenti![index]!
                                    .nomi_es![index_esercizi],
                              ),
                              children: [
                                ListTile(
                                    title: Text(
                                        "${sm.allenamenti![index]!.ripetizioni_es![index_esercizi]} ripetizioni")),
                                ListTile(
                                    title: Text(
                                        "${sm.allenamenti![index]!.serie_es![index_esercizi]} serie")),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    ListTile(
                        trailing: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.orange.shade700)),
                      child: Text("Dettagli"),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => dettagliScheda(
                                    allenamento: sm.allenamenti![index]!,
                                    id: sm.id_scheda!)));
                      },
                    )),
                    SizedBox(
                      height: 4,
                    )
                  ]),
                );
              },
            ),
          ],
        )));
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
                data_selezionata.year,
                data_selezionata.month,
                data_selezionata.day,
                orarioSelezionato.hour,
                orarioSelezionato.minute));
        orarioSelezionato.replacing(hour: 0, minute: 0);
      });
    }

    print(orarioSelezionato.toString());
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
    late String b = "";
    for (var a in list) {
      if (DateUtils.dateOnly(a.toDate()) ==
          DateUtils.dateOnly(data_selezionata)) {
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

  void modificaSelezioneGiorno(bool b, int index, SchedaModel sm, DateTime d) {
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
          icon: Icon(Icons.event_repeat_rounded),
          iconColor: Colors.teal,
          title: Text(
            'Assegnazione automatica',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
              'Questa opzione replicherà gli allenamenti che hai già assegnato, impostandoli automaticamente ogni 7 giorni, fino alla fine del periodo previsto dalla tua scheda.\n\nPotrai comunque modifichiare date e orari, ogni volta che lo desideri '),
          actions: [
            OutlinedButton(
             style: ButtonStyle(
              textStyle: MaterialStatePropertyAll(TextStyle(color: Theme.of(context).primaryColor)
              )
             ),
              child: Text('Annulla'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll(Theme.of(context).primaryColor)),
              child: Text('Assegna'),
              onPressed: () {
                for (var a in sm.allenamenti!) {
                  List<Timestamp> lista_nuove_date =
                      new List.empty(growable: true);
                  for (var b in a.giorniAssegnati!) {
                    late DateTime newdate = b.toDate();
                    while (DateUtils.dateOnly(newdate.add(Duration(
                                days: 7, minutes: 0, seconds: 0, hours: 0)))
                            .isBefore(
                                DateUtils.dateOnly(sm.fine_scheda!.toDate())) ||
                        DateUtils.dateOnly(newdate.add(Duration(
                                days: 7, minutes: 0, seconds: 0, hours: 0)))
                            .isAtSameMomentAs(
                                DateUtils.dateOnly(sm.fine_scheda!.toDate()))) {
                      newdate = newdate.add(const Duration(
                          days: 7, minutes: 0, seconds: 0, hours: 0));
                      print(a.nomeAllenamento.toString() +
                          ":" +
                          newdate.toString());
                      lista_nuove_date.add(Timestamp.fromDate(newdate));
                    }
                  }

                  a.giorniAssegnati!.addAll(lista_nuove_date);
                  lista_nuove_date.clear();

                  for (int i = 0; i < a.giorniAssegnati!.length; i++) {
                    print(a.giorniAssegnati![i].toDate());
                  }
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
        .doc(sm.id_scheda)
        .set(
          sm.toFirestore(),
        );
  }
}
