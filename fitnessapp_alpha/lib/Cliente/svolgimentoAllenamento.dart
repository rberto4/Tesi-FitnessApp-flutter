import 'dart:async';

import 'package:app_fitness_test_2/Cliente/HomeCliente.dart';
import 'package:app_fitness_test_2/services/SchedaModel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class sedutaAllenamento extends StatefulWidget {
  late final Allenamento allenamento;
  sedutaAllenamento({super.key, required this.allenamento});

  @override
  State<sedutaAllenamento> createState() =>
      _sedutaAllenamentoState(this.allenamento);
}

class _sedutaAllenamentoState extends State<sedutaAllenamento> {
  late final Allenamento allenamento;

  late int serieCorrente = 0;
  late int esercizioCorrente = 0;

  late Timer _timer;
  late int tempoRimasto =
      allenamento.listaEsercizi![esercizioCorrente].recuperoEsercizio!;

  late List<TextEditingController> _lista_controllers_ripetizioni =
      new List.empty(growable: true);
  late List<TextEditingController> _lista_controllers_carichi =
      new List.empty(growable: true);

  _sedutaAllenamentoState(this.allenamento);

  @override
  void initState() {
    inizializzaTextControllers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Theme.of(context).canvasColor,
        titleSpacing: 0,
        title: Text(
          allenamento.nomeAllenamento!,
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
                onPressed: () {
                  setState(() {
                    proseguiScheda();
                  });
                },
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
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: allenamento.listaEsercizi!.length,
        itemBuilder: (context, index_esercizi) {
          return Column(
            children: [
              // Tile esercizio
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color:  esercizioCorrente > 0 && index_esercizi < esercizioCorrente? Theme.of(context).primaryColor: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(48)
                  ),
                  child:  esercizioCorrente > 0 && index_esercizi < esercizioCorrente
                        ? Icon(Icons.done_rounded)
                        : Text(
                            "#" + (index_esercizi + 1).toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: esercizioCorrente != index_esercizi
                                    ? Theme.of(context).hintColor
                                    : Colors.white, fontSize: 18),
                          )),
                   
                title: Text(
                  allenamento.listaEsercizi![index_esercizi].nomeEsercizio!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  allenamento.listaEsercizi![index_esercizi].serieEsercizio! +
                      " Serie",
                  style: TextStyle(color: Theme.of(context).hintColor),
                ),
              ),

              // lista serie

              Visibility(
                visible: esercizioCorrente == index_esercizi ? true : false,
                child: ListView.builder(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: int.parse(
                    allenamento.listaEsercizi![index_esercizi].serieEsercizio!,
                  ),
                  itemBuilder: (context, index_serie) {
                    if (index_serie == serieCorrente) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          side: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 2.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ListTile(
                              contentPadding:
                                  EdgeInsets.only(right: 8, left: 16),
                              title: Text(
                                "${index_serie + 1}°  Serie",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              trailing: IconButton(
                                  icon: Icon(Icons.description_rounded),
                                  onPressed: () {
                                    dialogNoteCoach(
                                        allenamento.noteAllenamento!);
                                  }),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 4),
                              child: Text("Carico (Kg)"),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, bottom: 8),
                              child: TextFormField(
                                controller: _lista_controllers_carichi[
                                    getIndexControllers(
                                        index_esercizi, index_serie)],
                                textAlign: TextAlign.right,
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
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
                                  prefixIcon:
                                      Icon(Icons.fitness_center_outlined),
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
                                controller: _lista_controllers_ripetizioni[
                                    getIndexControllers(
                                        index_esercizi, index_serie)],
                                textAlign: TextAlign.right,
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
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
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 16),
                            horizontalTitleGap: 8,
                            trailing: Text(
                              allenamento.listaEsercizi![index_esercizi]
                                      .carichiEsercizio![index_serie] +
                                  " Kg",
                              style:
                                  TextStyle(color: Theme.of(context).hintColor),
                            ),
                            title: Text(
                              "${index_serie + 1}°  Serie",
                              style:
                                  TextStyle(color: Theme.of(context).hintColor),
                            ),
                            leading: serieCorrente > index_serie
                                ? Icon(
                                    Icons.done_rounded,
                                    color: Theme.of(context).hintColor,
                                  )
                                : null,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
              Visibility(
                visible: esercizioCorrente == index_esercizi ? true : false,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: index_esercizi == allenamento.listaEsercizi!.length - 1
                      ? SizedBox(
                          height: 75,
                          width: double.maxFinite,
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.sports_score_rounded),
                            onPressed: () {
                              // TERMINA
                            },
                            label: Text(
                              "Termina allenamento",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            style: ButtonStyle(
                                elevation: MaterialStatePropertyAll(0),
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.green),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(48.0),
                                ))),
                          ),
                        )
                      : LinearPercentIndicator(
                          center: SizedBox(
                            width: double.maxFinite,
                            height: 70,
                            child: ElevatedButton.icon(
                              icon: Icon(Icons.timer_rounded),
                              onPressed: () {
                                startTimer();
                              },
                              label: Text(
                                "Timer recupero - " +
                                    tempoRimasto.toString() +
                                    "s",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              style: ButtonStyle(
                                  elevation: MaterialStatePropertyAll(0),
                                  backgroundColor: MaterialStatePropertyAll(
                                      Colors.transparent),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(48.0),
                                  ))),
                            ),
                          ),
                          lineHeight: 70,
                          percent: getPercentualeAvanzamento(),
                          progressColor: Colors.red,
                          backgroundColor: Theme.of(context).disabledColor,
                          barRadius: Radius.circular(48),
                        ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  void proseguiScheda() {
    if (int.parse(
                allenamento.listaEsercizi![esercizioCorrente].serieEsercizio!) -
            1 >
        serieCorrente) {
      serieCorrente++;
    } else if (esercizioCorrente < allenamento.listaEsercizi!.length) {
      serieCorrente = 0;
      esercizioCorrente++;
    }
    tempoRimasto =
        allenamento.listaEsercizi![esercizioCorrente].recuperoEsercizio!;
  }

  void startTimer() {
    const oneMilliSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneMilliSec,
      (Timer timer) {
        if (tempoRimasto == 0) {
          _timer.cancel();
          setState(() {
            proseguiScheda();
          });
        } else {
          setState(() {
            tempoRimasto--;
          });
        }
      },
    );
  }

  void salvaDatiFineAllenamento() {}

  double getPercentualeAvanzamento() {
    double p = (tempoRimasto) /
        (allenamento.listaEsercizi![esercizioCorrente].recuperoEsercizio!);
    return p;
  }

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

  void inizializzaTextControllers() {
    _lista_controllers_carichi.clear();
    _lista_controllers_ripetizioni.clear();

    for (var a in allenamento.listaEsercizi!) {
      for (int i = 0; i < a.ripetizioniEsercizio!.length; i++) {
        TextEditingController t = TextEditingController.fromValue(
            TextEditingValue(text: a.ripetizioniEsercizio![i]));

        _lista_controllers_ripetizioni.add(t);
      }

      for (int i = 0; i < a.carichiEsercizio!.length; i++) {
        TextEditingController t = TextEditingController.fromValue(
            TextEditingValue(text: a.carichiEsercizio![i]));

        _lista_controllers_carichi.add(t);
      }
    }

    for (var a in _lista_controllers_carichi) {
      print(a.text);
    }
    for (var a in _lista_controllers_ripetizioni) {
      print(a.text);
    }

    print("dimensioni:");
    print(_lista_controllers_carichi.length);
    print(_lista_controllers_ripetizioni.length);
  }

  int getIndexControllers(int index_esercizi, int index_serie) {
    int index = 0;
    for (int i = 0; i < allenamento.listaEsercizi!.length; i++) {
      if (i < index_esercizi) {
        index = index + allenamento.listaEsercizi![i].carichiEsercizio!.length;
      }
    }
    return index + index_serie;
  }
}





/*
class svolgimentoAllenamento extends StatefulWidget {
  late final Allenamento allenamento;
  svolgimentoAllenamento({super.key, required this.allenamento});
  
  @override
  State<svolgimentoAllenamento> createState() =>
      _svolgimentoAllenamentoState(this.allenamento);
}

class _svolgimentoAllenamentoState extends State<svolgimentoAllenamento> {
  late final Allenamento allenamento;

  _svolgimentoAllenamentoState(this.allenamento);

  late List<Step> steps;

  late ScrollController _scrollController = ScrollController();

  int currentStep = 0;
  int serieCorrente = 0;

  late Timer _timer;
  late int tempoRimasto = allenamento.listaEsercizi![currentStep].recuperoEsercizio!;


  @override
  void initState() {  
        caricaStepEsercizi(serieCorrente);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          titleSpacing: 0,
          title: Text(
            allenamento.nomeAllenamento!,
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
          connectorThickness: 0,
          margin: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
          controller: _scrollController,
          physics: ClampingScrollPhysics(),
          controlsBuilder: (context, ControlsDetails controlsDetails) {
            return LinearPercentIndicator(
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
                        allenamento.listaEsercizi![currentStep]
                                    .recuperoEsercizio!
                                    .toDouble() !=
                                tempoRimasto
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
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
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
          onStepTapped: (value) {
            setState(() {});
          },
          steps: steps,
        ));
  }

  void caricaStepEsercizi(int serieCorrente) {
    steps = new List.empty(growable: true);

    for (int i = 0; i < allenamento.listaEsercizi!.length; i++) {
      Step p = Step(
          title: ListTile(
            contentPadding: EdgeInsets.all(0),
            subtitle:
                Text(allenamento.listaEsercizi![i].serieEsercizio! + " Serie"),
            title: Text(
              allenamento.listaEsercizi![i].nomeEsercizio!,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          content: contenutoStep(
              esercizio: allenamento.listaEsercizi![i],
              note: allenamento.noteAllenamento, 
              serieCorrente: serieCorrente,
              ));

      steps.add(p);
    }

  }

  void startTimer() {
    const oneMilliSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneMilliSec,
      (Timer timer) {
        if (tempoRimasto == 0) {
          setState(() {
            timer.cancel();

            if (serieCorrente <
                int.parse(allenamento
                        .listaEsercizi![currentStep].serieEsercizio!) -
                    1) {
              serieCorrente++;
            } else {
              currentStep++;
              serieCorrente = 0;
            }

            tempoRimasto =
                allenamento.listaEsercizi![currentStep].recuperoEsercizio!;
                print(serieCorrente);
                        caricaStepEsercizi(serieCorrente);

          });
        } else {
          setState(() {
            tempoRimasto--;
          });
        }
      },
    );
  }

  void salvaDatiFineAllenamento() {}

  double getPercentualeAvanzamento() {
    double p = (tempoRimasto) /
        (allenamento.listaEsercizi![currentStep].recuperoEsercizio!);
    return p;
  }
}



class contenutoStep extends StatefulWidget {
  late final Esercizio esercizio;
  late final String? note;
  late final int? serieCorrente;

  contenutoStep({super.key, required this.esercizio, required this.note, required this.serieCorrente});

  @override
  State<contenutoStep> createState() =>
      _contenutoStepState(this.esercizio, this.note, this.serieCorrente);
}

class _contenutoStepState extends State<contenutoStep> {
  late final Esercizio esercizio;
  late final String? note;
  late final int? serieCorrente;


  late List<TextEditingController> _lista_controllers_ripetizioni =
      new List.empty(growable: true);
  late List<TextEditingController> _lista_controllers_carichi =
      new List.empty(growable: true);

  _contenutoStepState(
    this.esercizio,
    this.note,
    this.serieCorrente
    );

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
      ],
    );
  }

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

  void inizializzaTextControllers() {
    _lista_controllers_carichi.clear();
    _lista_controllers_ripetizioni.clear();

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

    for (var a in _lista_controllers_carichi) {
      print(a.text);
    }
    for (var a in _lista_controllers_ripetizioni) {
      print(a.text);
    }
  }
}
*/
