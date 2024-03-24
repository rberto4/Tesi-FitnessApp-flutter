import 'dart:js';

import 'package:app_fitness_test_2/services/SchedaModel.dart';
import 'package:app_fitness_test_2/services/database_service.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
                resizeToAvoidBottomInset : false,
        appBar: AppBar(
          centerTitle: true,
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
                            "Sedute di allenamento",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: sm.allenamenti!.length,
                        itemBuilder: (context, index) {
                          if (lista_date_selezionate.isNotEmpty) {
                            return Card(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: CheckboxListTile(
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      title: Theme(
                                        data: ThemeData().copyWith(
                                              splashFactory: NoSplash.splashFactory,
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                            dividerColor: Colors.transparent),
                                        child: ExpansionTile(
                                          
                                          title: Text(
                                            sm.allenamenti![index]
                                                .nomeAllenamento!,
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          children: [
                                            ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: sm.allenamenti![index]
                                                    .nomi_es!.length,
                                                scrollDirection: Axis.vertical,
                                                itemBuilder: (context, index_es) {
                                                  return ListTile(
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
                                                        .serie_es![index_es]+ " serie, "+sm
                                                        .allenamenti![index]
                                                        .ripetizioni_es![index_es]+ " ripetizioni"),
                                                  );
                                                })
                                          ],
                                        ),
                                      ),
                                      value: isChecked(sm
                                          .allenamenti![index].giorniAssegnati!),
                                      onChanged: (bool? value) {
                                        setState(() {
                                          modificaSelezioneGiorno(value!, index,
                                              sm, snapshot.data!.docs.first.id);
                                        });
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top:12.0),
                                    child: Visibility(
                                      visible: true,
                                      child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1, color: Colors.blue),
                                              shape: BoxShape.rectangle,
                                              borderRadius:
                                                  BorderRadius.circular(48)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                             "",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue,
                                                  fontSize: 12),
                                            ),
                                          )),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Visibility(
                                        visible: isChecked(sm.allenamenti![index]
                                            .giorniAssegnati!),
                                        child: IconButton.filled(
                                          onPressed: () async {
                                            final TimeOfDay ? timeOfDay = await showTimePicker(context: context,
                                            initialTime: TimeOfDay.now(), initialEntryMode: TimePickerEntryMode.dial, 
                                            );
                                            if (timeOfDay != null){
                                              setState(() {
                                                orarioSelezionato = timeOfDay;
                                              });
                                            }
                                          },
                                          icon: Icon(
                                            Icons.alarm,
                                            color: Colors.blue,
                                          ),
                                        )),
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

  void modificaSelezioneGiorno(bool b, int index, SchedaModel sm, String id) {
    if (b) {
      sm.allenamenti![index].giorniAssegnati!
          .add(Timestamp.fromDate(lista_date_selezionate.first!));
    } else {
      print(b);
      for (var a in sm.allenamenti![index].giorniAssegnati!) {
        if (DateUtils.dateOnly(a.toDate()) == lista_date_selezionate.first!) {
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
}
