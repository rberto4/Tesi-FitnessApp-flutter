import 'package:app_fitness_test_2/services/SchedaModel.dart';
import 'package:app_fitness_test_2/services/database_service.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
            isExtended: true, label: Text("Salva"), onPressed: () {}),
        appBar: AppBar(
          automaticallyImplyLeading: true,
        ),
        body: StreamBuilder(
            stream: _dbs.getSchedaCorrente(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List lista = snapshot.data!.docs;
                SchedaModel sm = lista[0].data();
                return Column(
                  children: [
                    CalendarDatePicker2(
                      config: CalendarDatePicker2Config(
                          firstDate: sm.inizio_scheda!.toDate(),
                          lastDate: sm.fine_scheda!.toDate(),
                          calendarType: CalendarDatePicker2Type.single
                          ),
                      value: lista_date_selezionate,
                      onValueChanged: (value) {
                        setState(() {
                          lista_date_selezionate = value;
                        });
                      },
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: sm.allenamenti!.length,
                      itemBuilder: (context, index) {
                        if (lista_date_selezionate.isNotEmpty) {
                          return CheckboxListTile(
                           
                            title:
                                Text(sm.allenamenti![index].nomeAllenamento!),
                            value: isChecked(
                                sm.allenamenti![index].giorniAssegnati!),
                            onChanged: (value) {},
                          );
                        }
                      },
                    )
                  ],
                );
              } else {
                return Text("no data");
              }
            }));
  }

  bool isChecked(List<Timestamp> l) {
    bool b = false;
    for (var a in l) {
      if (a == lista_date_selezionate.first) {
        b = true;
      }
    }
    return b;
  }
}
