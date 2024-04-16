
import 'package:app_fitness_test_2/Cliente/dettagliAllenamento.dart';
import 'package:app_fitness_test_2/services/SchedaModel.dart';
import 'package:app_fitness_test_2/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

DatabaseService _dbs = DatabaseService();



class gestioneCalendario extends StatefulWidget {

  late Scheda scheda;

  gestioneCalendario({super.key, required this.scheda});

  @override
  State<gestioneCalendario> createState() => _gestioneCalendarioState(this.scheda);
}

class _gestioneCalendarioState extends State<gestioneCalendario> {
  late Scheda scheda;
  _gestioneCalendarioState(this.scheda);

List<DateTime?> listaGiorniScheda = new List.empty(growable: true);
List<String> listaAssegnazioni = new List.empty(growable: true);

  TimeOfDay orarioSelezionato = TimeOfDay.now();
  late DateTime data_selezionata = DateUtils.dateOnly(DateTime.now());


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
                    scheda.allenamentiScheda!.forEach(
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
              headerProps: EasyHeaderProps(
                centerHeader: false,
                padding: EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
                monthPickerType: MonthPickerType.dropDown,
                showSelectedDate: true,
                selectedDateStyle: Theme.of(context).textTheme.titleMedium,
                dateFormatter: DateFormatter.fullDateDMonthAsStrY(),
              ),
              dayProps: EasyDayProps(
                activeDayStyle: DayStyle(
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
              padding: EdgeInsets.all(8),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: scheda.allenamentiScheda!.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Column(children: [
                     CheckboxListTile(
                        activeColor: Colors.red,
                        value:
                            isChecked(scheda.allenamentiScheda![index].giorniAssegnati!),
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
                        title:  Text(
                        scheda.allenamentiScheda![index]!.nomeAllenamento!,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      ),
                    
                      // pulsante selezione orario
                    
                    ListView.builder(
                      itemCount: scheda.allenamentiScheda![index]!.listaEsercizi!.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index_esercizi) {
                        return ExpansionTile(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(48))),
                          leading: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).dividerColor,
                            ),
                            child: Text(
                              "#"
                              "${index_esercizi + 1}",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          title: Text(
                            scheda.allenamentiScheda![index]!.listaEsercizi![index_esercizi].nomeEsercizio!,
                          ),
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Wrap(
                                  verticalDirection: VerticalDirection.down,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  direction: Axis.vertical,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.teal),
                                      padding: EdgeInsets.all(8),
                                      child: const Icon(
                                        color: Colors.white,
                                        Icons.replay,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      scheda.allenamentiScheda![index]
                                          .listaEsercizi![index_esercizi].ripetizioniEsercizio!.first,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      "Ripetizioni",
                                      style: TextStyle(),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  width: 32,
                                ),
                                Wrap(
                                  verticalDirection: VerticalDirection.down,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  direction: Axis.vertical,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.teal),
                                      padding: EdgeInsets.all(8),
                                      child: const Icon(
                                        color: Colors.white,
                                        Icons.dataset_outlined,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      scheda.allenamentiScheda![index]
                                          .listaEsercizi![index_esercizi].serieEsercizio!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      "Serie",
                                      style: TextStyle(),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  width: 32,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Wrap(
                                    verticalDirection: VerticalDirection.down,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    direction: Axis.vertical,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.teal),
                                        padding: EdgeInsets.all(8),
                                        child: const Icon(
                                          color: Colors.white,
                                          Icons.timer,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        scheda.allenamentiScheda![index].listaEsercizi![index_esercizi].recuperoEsercizio.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        "Recupero",
                                        style: TextStyle(),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 16, left: 16, right: 16),
                              child: SizedBox(
                                height: 1,
                                child: Container(
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ),
                            ListTile(
                              minLeadingWidth: 8,
                              leading: Icon(
                                Icons.bookmark,
                                color: Colors.teal,
                              ),
                              title: Text(
                                "Note",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 16, left: 16),
                              child: ListTile(
                                title: Text(
                                  "ciao, queste sono note di esempio relative a questo esercizio",
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Visibility(
                          visible:
                              isChecked(scheda.allenamentiScheda![index].giorniAssegnati!),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(48)),
                            child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                   Padding(
                                      padding: const EdgeInsets.only(left: 16),
                                      child: getOrarioAssegnato(scheda.allenamentiScheda![index].giorniAssegnati!),
                                    
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.alarm_add_rounded,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      _selectTime(index, scheda, scheda.idScheda!);
                                    },
                                  ),
                                ]),
                          ),
                        ),
                      ),
                    ),
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
    late String b = "Orario allenamento";
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
      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
      print(b);
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
                  textStyle: MaterialStatePropertyAll(
                      TextStyle(color: Theme.of(context).primaryColor))),
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
                for (var a in scheda.allenamentiScheda!) {
                  List<Timestamp> lista_nuove_date =
                      new List.empty(growable: true);
                  for (var b in a.giorniAssegnati!) {
                    late DateTime newdate = b.toDate();
                    while (DateUtils.dateOnly(newdate.add(Duration(
                                days: 7, minutes: 0, seconds: 0, hours: 0)))
                            .isBefore(
                                DateUtils.dateOnly(scheda.fineScheda!.toDate())) ||
                        DateUtils.dateOnly(newdate.add(Duration(
                                days: 7, minutes: 0, seconds: 0, hours: 0)))
                            .isAtSameMomentAs(
                                DateUtils.dateOnly(scheda.fineScheda!.toDate()))) {
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
        .doc(scheda.idScheda)
        .set(
          scheda.toFirestore(),
        );
  }
}
