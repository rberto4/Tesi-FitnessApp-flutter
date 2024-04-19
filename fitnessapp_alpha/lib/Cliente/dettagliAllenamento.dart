// ignore_for_file: file_names

/*
import 'package:app_fitness_test_2/services/SchedaModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_fitness_test_2/services/database_service.dart';

// ignore: must_be_immutable
class dettagliScheda extends StatefulWidget {

  late Allenamento allenamento;
  late String id;

  dettagliScheda({super.key, required this.allenamento, required this.id});

  @override
  State<dettagliScheda> createState() => _dettagliSchedaState(this.allenamento, this.id);
}


class _dettagliSchedaState extends State<dettagliScheda> {
  
  late Allenamento allenamento;
  
  late String id;
  _dettagliSchedaState(this.allenamento, this.id);

  DatabaseService _dbs = new DatabaseService();
  List<TextEditingController> list_edit_controller =
      new List.empty(growable: true);
  List<bool> lista_switch_state = new List.empty(growable: true);

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
          onPressed: () {},
          child: const Center(
            child: Text('Salva carichi'),
          ),
        ),
      ),
      appBar: AppBar(
        title: Text(allenamento.nomeAllenamento!),
        centerTitle: false,
        automaticallyImplyLeading: true,
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 80, right: 8, left: 8, top:8),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: allenamento.nomi_es!.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Wrap(children: [
                  ListTile(
                    minLeadingWidth: 8,
                    leading: Text(
                      "${index + 1}.",
                      style: TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    title: Text(allenamento.nomi_es![index],
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),

                  // info generali reps serie recupero
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
                                shape: BoxShape.circle, color: Colors.teal),
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
                            allenamento.ripetizioni_es![index],
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
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
                                shape: BoxShape.circle, color: Colors.teal),
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
                            allenamento.serie_es![index],
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
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
                          crossAxisAlignment: WrapCrossAlignment.center,
                          direction: Axis.vertical,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.teal),
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
                              "120s",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
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
                    padding:
                        const EdgeInsets.only(top: 16, left: 16, right: 16),
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
                    padding: const EdgeInsets.only(right: 16, left: 16),
                    child: ListTile(
                      title: Text(
                        "ciao, queste sono note di esempio relative a questo esercizio",
                      ),
                    ),
                  ),

                  ListTile(
                    minLeadingWidth: 8,
                    leading: Icon(
                      Icons.fitness_center_outlined,
                      color: Colors.teal,
                    ),
                    title: Text(
                      "Carico",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(right: 16, left: 16),
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: list_edit_controller.length + 1,
                        itemBuilder: (context, index_carico) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: TextFormField(
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp("[.0-9]", dotAll: true)),
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              controller: null,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: Theme.of(context).primaryColor),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                ),
                                filled: true,
                                alignLabelWithHint: false,
                              ),
                            ),
                          );
                        },
                      )),

                  SwitchListTile(
                    title: const Text("Costante per ogni serie"),
                    activeColor: Colors.orange.shade700,
                    value: true,
                    onChanged: (value) {
                      setState(() {
                        //lista_switch_state[index] = value;
                      });
                    },
                  )
                ]),
              );
            },
          ),
        ),
      ),
    );
  }


/*
  void impostoCarichi() {
    for (var a in allenamento.carichi!) {
      for (var b in a.carichi_es!) {
        list_edit_controller.add(TextEditingController(text: b));
      }

      if (a.carichi_es!.length + 1 == 1) {
        lista_switch_state.add(true);
      } else {
        lista_switch_state.add(false);
      }
    }
    print (list_edit_controller);

  }


  void aggiornamentoCarichiDb() {
 
    list_edit_controller.clear();
    _dbs
        .getInstanceDb()
        .collection(_dbs.getCollezioneUtenti())
        .doc(_dbs.getAuth().currentUser!.uid)
        .collection(_dbs.getCollezioneSchede())
        .doc(sm.id_scheda)
        .set(sm.toFirestore(), SetOptions(merge: true));
  }
  */
}
*/