import 'dart:async';

import 'package:app_fitness_test_2/Cliente/HomeCliente.dart';
import 'package:app_fitness_test_2/services/SchedaModel.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class svolgimentoAllenamento extends StatefulWidget {
  late Allenamento allenamento;
  svolgimentoAllenamento({super.key, required this.allenamento});

  @override
  State<svolgimentoAllenamento> createState() =>
      _svolgimentoAllenamentoState(this.allenamento);
}

class _svolgimentoAllenamentoState extends State<svolgimentoAllenamento> {
  late Allenamento allenamento;

  late StreamController<int> _recuperoStreamController;
  _svolgimentoAllenamentoState(this.allenamento);

  List<Step> steps = new List.empty(growable: true);

  late ScrollController _scrollController = ScrollController();
  int currentStep = 0;

  @override
  void initState() {
    caricaStepEsercizi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            allenamento.nomeAllenamento!,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: false,
          leading: BackButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MainPageUtente()));
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              child: ElevatedButton.icon(
                  icon: Icon(Icons.note_alt_rounded),
                  onPressed: () {},
                  label: Text(
                    "Feedback",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: ButtonStyle(
                      elevation: MaterialStatePropertyAll(1),
                      backgroundColor: MaterialStatePropertyAll(
                          Theme.of(context).primaryColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(48.0),
                      )))),
            ),
          ],
        ),
        body: Stepper(
          controller: _scrollController,
          physics: ClampingScrollPhysics(),
          controlsBuilder: (context, ControlsDetails controlsDetails) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Visibility(
                visible: true,
                child: Container(
                    width: double.maxFinite,
                    child: controlsDetails.currentStep != steps.length - 1
                        ? ElevatedButton.icon(
                            icon: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Icon(Icons.timer_rounded),
                            ),
                            onPressed: () {
                                          controlsDetails.onStepContinue;
                              setState(() {
                                currentStep++;
                              });
                            },
                            label: Text("Avvia recupero"),
                            style: ButtonStyle(
                                elevation: MaterialStatePropertyAll(1),
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.red),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(48.0),
                                ))))

                        // Pulsante fine workout

                        : ElevatedButton.icon(
                            icon: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Icon(Icons.sports_score),
                            ),
                            onPressed: () {
                              controlsDetails.onStepContinue;
                              setState(() {});
                            },
                            label: Text("Fine allenamento"),
                            style: ButtonStyle(
                                elevation: MaterialStatePropertyAll(1),
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.green),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(48.0),
                                ))))),
              ),
            );
          },
          type: StepperType.vertical,
          currentStep: currentStep,
          onStepContinue: () {
            setState(() {
              if (currentStep < steps.length - 1) {
                currentStep += 1;
                print("ciao");
              } else {
                // You can perform any final actions here
              }
            });
          },
          onStepCancel: () {
            setState(() {
              if (currentStep > 0) {
                currentStep -= 1;
              } else {
                // Cancel button pressed on the first step
              }
            });
          },
          onStepTapped: (value) {
            setState(() {});
          },
          steps: steps,
        ));
  }

  void caricaStepEsercizi() {
    steps.clear;
    for (var a in allenamento.listaEsercizi!) {
      Step p = Step(
          title: ListTile(
            contentPadding: EdgeInsets.all(0),
            subtitle: Text(a.serieEsercizio! + " Serie"),
            title: Text(
              a.nomeEsercizio!,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          content: contenutoStep(
            esercizio: a,
            note: allenamento.noteAllenamento,
            notifyParent: aggiornaStato,
          ));
      steps.add(p);
    }
  }

  void aggiornaStato() {
    setState(() {
      currentStep++;
    });
  }
}

/*
void mostraDialogRecupero(context, StreamController controller) {
  Timer _timer;
  final int durationMiliseconds = 200; 

  controller = new StreamController<int>();
  controller.add(20);
  
  showDialog(
      context: context,
      builder: (context) => Dialog.fullscreen(
            child: StreamBuilder(stream: controller.stream, builder: (context, snapshot) {
              
            },)           
          ));
            /*
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    */  
                    
}
*/

class contenutoStep extends StatefulWidget {
  late Esercizio esercizio;
  late String? note;
  late Function() notifyParent;

  contenutoStep(
      {super.key,
      required this.esercizio,
      required this.note,
      required this.notifyParent});

  @override
  State<contenutoStep> createState() =>
      _contenutoStepState(this.esercizio, this.note, this.notifyParent);
}

class _contenutoStepState extends State<contenutoStep> {
  late Esercizio esercizio;
  late String? note;
  late Function() notifyParent;

  int serieCorrente = 0;

  late Timer _timer;
  late int tempoRimasto = esercizio.recuperoEsercizio!;

  late List<TextEditingController> _lista_controllers_ripetizioni =
      new List.empty(growable: true);
  late List<TextEditingController> _lista_controllers_carichi =
      new List.empty(growable: true);

  _contenutoStepState(this.esercizio, this.note, this.notifyParent);

  void startTimer() {
    const oneMilliSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneMilliSec,
      (Timer timer) {
        if (tempoRimasto == 0) {
          setState(() {
            timer.cancel();
            tempoRimasto = esercizio.recuperoEsercizio!;
            if (serieCorrente < int.parse(esercizio.serieEsercizio!) - 1) {
              serieCorrente++;
            } else {
              print("dovresti aggiornare");
            }
          });
        } else {
          setState(() {
            tempoRimasto--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    inizializzaTextControllers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: int.parse(esercizio.serieEsercizio.toString()),
          shrinkWrap: true,
          itemBuilder: (context, index_serie) {
            if (index_serie == serieCorrente) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  side: BorderSide(
                      color: Theme.of(context).primaryColor, width: 2.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.only(right: 8, left: 16),
                      title: Text(
                        "${index_serie + 1}°  Serie",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      trailing: IconButton(
                          icon: Icon(Icons.description_rounded),
                          onPressed: () {
                            dialogNoteCoach(note!);
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: Text("Carico (Kg)"),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                      child: TextFormField(
                        textAlign: TextAlign.right,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        controller: _lista_controllers_carichi[index_serie],
                        decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                          filled: true,
                          alignLabelWithHint: false,
                          prefixIcon: Icon(Icons.fitness_center_outlined),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: Text("Ripetizioni"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 16),
                      child: TextFormField(
                        textAlign: TextAlign.right,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        controller: _lista_controllers_ripetizioni[index_serie],
                        decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                          filled: true,
                          alignLabelWithHint: false,
                          prefixIcon: Icon(Icons.restart_alt_rounded),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Card(
                  child: ListTile(
                    trailing: Text(
                      esercizio.carichiEsercizio![index_serie] + " Kg",
                      style: TextStyle(color: Theme.of(context).hintColor),
                    ),
                    title: Text(
                      "${index_serie + 1}°  Serie",
                      style: TextStyle(color: Theme.of(context).hintColor),
                    ),
                  ),
                ),
              );
            }
          },
        ),
        SizedBox(
          height: 16,
        ),
        LinearPercentIndicator(
          center: Container(
            width: double.maxFinite,
            child: SizedBox(
              height: 85,
              child: ElevatedButton.icon(
                  icon: Icon(Icons.timer_rounded),
                  onPressed: () {
                    startTimer();
                  },
                  label: Text(
                    esercizio.recuperoEsercizio!.toDouble() != tempoRimasto
                        ? (tempoRimasto + 1).toStringAsFixed(0)
                        : "Avvia recupero  -  " +
                            (tempoRimasto).toStringAsFixed(0) +
                            "s",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  style: ButtonStyle(
                      elevation: MaterialStatePropertyAll(0),
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.transparent),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(48.0),
                      )))),
            ),
          ),
          lineHeight: 85,
          percent: getPercentualeAvanzamento(),
          progressColor: Colors.red,
          backgroundColor: Theme.of(context).disabledColor,
          barRadius: Radius.circular(48),
        ),
      ],
    );
  }

  void inizializzaTextControllers() {
    for (int i = 0; i < esercizio.ripetizioniEsercizio!.length; i++) {
      TextEditingController t = TextEditingController.fromValue(
          TextEditingValue(text: esercizio.ripetizioniEsercizio![i]));

      _lista_controllers_ripetizioni.add(t);
    }

    for (int i = 0; i < esercizio.carichiEsercizio!.length; i++) {
      TextEditingController t = TextEditingController.fromValue(
          TextEditingValue(text: esercizio.carichiEsercizio![i]));

      _lista_controllers_carichi.add(t);
    }
  }

  void salvaDatiFineAllenamento() {}

  void dialogNoteCoach(String note) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            actionsAlignment: MainAxisAlignment.end,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            icon: Icon(Icons.description_rounded),
            title: Text(
              "Note dal coach",
            ),
            content: Text(note),
            actions: [
              ElevatedButton.icon(
                  icon: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Icon(Icons.close),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  label: Text("Chiudi"),
                  style: ButtonStyle(
                      elevation: MaterialStatePropertyAll(1),
                      backgroundColor: MaterialStatePropertyAll(Colors.red),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(48.0),
                      ))))
            ],
          );
        });
  }

  double getPercentualeAvanzamento() {
    double p = (tempoRimasto) / (esercizio.recuperoEsercizio!);
    return p;
  }
}
