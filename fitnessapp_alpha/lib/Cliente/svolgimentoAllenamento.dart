import 'dart:async';

import 'package:app_fitness_test_2/Cliente/HomeCliente.dart';
import 'package:app_fitness_test_2/services/SchedaModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class svolgimentoAllenamento extends StatefulWidget {
  late SchedaModel sm;
  late int i;

  svolgimentoAllenamento({super.key, required this.sm, required this.i});

  @override
  State<svolgimentoAllenamento> createState() =>
      _svolgimentoAllenamentoState(this.sm, this.i);
}

class _svolgimentoAllenamentoState extends State<svolgimentoAllenamento> {
  late SchedaModel sm;
  late int i;
  late StreamController<int> _recuperoStreamController;
  _svolgimentoAllenamentoState(this.sm, this.i);

  List<Step> steps = new List.empty(growable: true);

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
        leading: BackButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MainPageUtente()));
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Stepper(
          controlsBuilder: (context, ControlsDetails controlsDetails) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                              //mostraDialogRecupero(context,_recuperoStreamController);
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
                          label: Text("Fine llenamento"),
                          style: ButtonStyle(
                              elevation: MaterialStatePropertyAll(1),
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.green),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(48.0),
                              ))))),
            );
          },
          type: StepperType.vertical,
          currentStep: currentStep,
          onStepContinue: () {
            setState(() {
              if (currentStep < steps.length - 1) {
                currentStep += 1;
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
          steps: steps,
        ),
      ),
    );
  }

  void caricaStepEsercizi() {
    steps.clear;
    for (int j = 0; j < sm.allenamenti![i].nomi_es!.length; j++) {
      Step p = new Step(
          title: ListTile(
            contentPadding: EdgeInsets.all(0),
            trailing: (j == currentStep)
                ? IconButton.filled(
                    onPressed: () {},
                    icon: Icon(Icons.description_rounded),
                  )
                : null,
            subtitle: Text(sm.allenamenti![i].serie_es![j]! + " serie"),
            title: Text(
              sm.allenamenti![i].nomi_es![j],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          content: contenutoStep(
            sm: sm,
            i: i,
            index: j,
          ));
      steps.add(p);
    }
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
  late int index;
  late SchedaModel sm;
  late int i;

  contenutoStep(
      {super.key, required this.index, required this.sm, required this.i});

  @override
  State<contenutoStep> createState() =>
      _contenutoStepState(this.index, this.sm, this.i);
}

class _contenutoStepState extends State<contenutoStep> {
  late int index;
  late SchedaModel sm;
  late int i;

  int serieCorrente = 0;

  late List<TextEditingController> _lista_controllers_ripetizioni =
      new List.empty(growable: true);
  late List<TextEditingController> _lista_controllers_carichi =
      new List.empty(growable: true);

  _contenutoStepState(this.index, this.sm, this.i);

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
          itemCount: int.parse(sm.allenamenti![i].serie_es![index]),
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
                      title: Text(
                        "${index_serie + 1}°  Serie",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                      child: TextFormField(
                        textAlign: TextAlign.right,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        controller: null,
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
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 16),
                      child: TextFormField(
                        textAlign: TextAlign.right,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        controller: _lista_controllers_ripetizioni[index],
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
                      "120Kg",
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Container(
            width: double.maxFinite,
            child: ElevatedButton.icon(
                icon: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Icon(Icons.timer_rounded),
                ),
                onPressed: () {
                  setState(() {
                    serieCorrente++;
                  });
                },
                label: Text("Prossima serie"),
                style: ButtonStyle(
                    elevation: MaterialStatePropertyAll(1),
                    backgroundColor: MaterialStatePropertyAll(
                        Theme.of(context).primaryColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(48.0),
                    )))),
          ),
        ),
      ],
    );
  }

  void inizializzaTextControllers() {
    for (var a in sm.allenamenti![i].nomi_es!) {
      for (int j = 0; j < sm.allenamenti![i].serie_es![index].length; j++) {
        TextEditingController t = TextEditingController.fromValue(
            TextEditingValue(text: sm.allenamenti![i].ripetizioni_es![index]));
        _lista_controllers_ripetizioni.add(t);
      }
    }

    _lista_controllers_ripetizioni.forEach((element) {
      print(element.text);
    });

  }

}
