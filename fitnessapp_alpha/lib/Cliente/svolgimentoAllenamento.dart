// ignore_for_file: file_names, must_be_immutable, camel_case_types, no_logic_in_create_state, unnecessary_this, non_constant_identifier_names, unused_field

import 'dart:async';
import 'package:app_fitness_test_2/services/SchedaModel.dart';
import 'package:app_fitness_test_2/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class sedutaAllenamento extends StatefulWidget {
  late Allenamento allenamento;
  late Scheda scheda;
  late Timestamp dataSelezionata;

  sedutaAllenamento(
      {super.key,
      required this.allenamento,
      required this.scheda,
      required this.dataSelezionata});

  @override
  State<sedutaAllenamento> createState() => _sedutaAllenamentoState(
      this.allenamento, this.scheda, this.dataSelezionata);
}

class _sedutaAllenamentoState extends State<sedutaAllenamento> {
  late final Allenamento _allenamento;
  late Scheda scheda;
  late Timestamp dataSelezionata;

  _sedutaAllenamentoState(this._allenamento, this.scheda, this.dataSelezionata);

// contatori per il focus su esercizio e serie correnti
  late int serieCorrente = 0;
  late int esercizioCorrente = 0;

// timer e tempoRimasto
  late Timer _timer;
  late int tempoRimasto = 0;

// controllers per ripetizioni e serie

  late final List<TextEditingController> _lista_controllers_ripetizioni =
      List.empty(growable: true);
  late final List<TextEditingController> _lista_controllers_carichi =
      List.empty(growable: true);

// controller per il campo di testo dei feedback
  late TextEditingController _controller;

// oggetto per lo scorrimento
  final _focusNode = FocusNode();

  late bool modalitaAllenamento;

  @override
  void initState() {
    modalitaAllenamento = siamoInAllenamento();
    inizializzaTextControllers();
    _controller = TextEditingController.fromValue(
        TextEditingValue(text: _allenamento.feedbackAllenamento!));
    _timer = Timer(const Duration(milliseconds: 1), () {});
    tempoRimasto =
        _allenamento.listaEsercizi![esercizioCorrente].recuperoEsercizio!;
    _timer.cancel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async => (false),
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: !modalitaAllenamento
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 64,
                  child: FloatingActionButton.extended(
                    icon: const Icon(
                      Icons.save_rounded,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      salvaDatiFineAllenamento();
                      Navigator.pop(context);
                    },
                    label: const Text(
                      "Salva",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18),
                    ),
                    backgroundColor: Colors.green,
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      esercizioCorrente ==
                                  _allenamento.listaEsercizi!.length - 1 &&
                              serieCorrente ==
                                  int.parse(_allenamento.listaEsercizi!.last
                                          .serieEsercizio!) -
                                      1
                          ? Flexible(
                              child: SizedBox(
                                height: 64,
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.sports_score_rounded),
                                  onPressed: () {
                                    salvaDatiFineAllenamento();
                                    Navigator.pop(context);
                                  },
                                  label: const Text(
                                    "Termina allenamento",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  style: ButtonStyle(
                                      elevation:
                                          const MaterialStatePropertyAll(0),
                                      backgroundColor:
                                          const MaterialStatePropertyAll(
                                              Colors.green),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(48.0),
                                      ))),
                                ),
                              ),
                            )
                          : Flexible(
                              child: LinearPercentIndicator(
                                center: SizedBox(
                                  height: 70,
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    icon: !_timer.isActive
                                        ? const Icon(Icons.timer_rounded)
                                        : const Icon(null),
                                    onPressed: () {
                                      if (!_timer.isActive) {
                                        startTimer();
                                      }
                                    },
                                    label: !_timer.isActive
                                        ? Text(
                                            "Avvia recupero - ${tempoRimasto}s",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          )
                                        : Text(
                                            " ${tempoRimasto}s  ",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 28,
                                            ),
                                          ),
                                    style: ButtonStyle(
                                        elevation:
                                            const MaterialStatePropertyAll(0),
                                        backgroundColor:
                                            const MaterialStatePropertyAll(
                                                Colors.transparent),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(48.0),
                                        ))),
                                  ),
                                ),
                                lineHeight: 64,
                                percent: getPercentualeAvanzamento(),
                                progressColor: Colors.red,
                                backgroundColor:
                                    Theme.of(context).disabledColor,
                                barRadius: const Radius.circular(48),
                              ),
                            ),

                      // pulsante per skippare il timer

                      Visibility(
                          visible: _timer.isActive,
                          child: FloatingActionButton(
                              backgroundColor: Theme.of(context).primaryColor,
                              heroTag: "meno_15s",
                              onPressed: () {
                                _timer.cancel();
                                setState(() {
                                  proseguiScheda();
                                });
                              },
                              child: const Icon(
                                Icons.fast_forward_rounded,
                                color: Colors.white,
                              )))
                    ]),
              ),
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 2,
          backgroundColor: Theme.of(context).canvasColor,
          titleSpacing: 0,
          title: Text(
            _allenamento.nomeAllenamento!,
          ),
          centerTitle: false,
          leading: BackButton(onPressed: () {
            if (modalitaAllenamento) {
              dialogConfermaEsci();
            } else {
              Navigator.pop(context);
            }
          }),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              child: ElevatedButton.icon(
                  icon: const Icon(Icons.note_alt_rounded),
                  onPressed: () {
                    dialogFeedback();
                  },
                  label: const Text(
                    "Note",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: ButtonStyle(
                      elevation: const MaterialStatePropertyAll(1),
                      backgroundColor: MaterialStatePropertyAll(
                          Theme.of(context).primaryColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(48.0),
                      )))),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                scrollDirection: Axis.vertical,
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _allenamento.listaEsercizi!.length,
                itemBuilder: (context, index_esercizi) {
                  return Column(
                    children: [
                      // Tile esercizio
                      ListTile(
                        onTap: () {
                          if (!_timer.isActive) {
                            selezionaEsercizioAlTocco(index_esercizi);
                          }
                        },
                        leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: esercizioCorrente >= 0 &&
                                        index_esercizi <= esercizioCorrente &&
                                        modalitaAllenamento
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(48)),
                            child: esercizioCorrente > 0 &&
                                    index_esercizi < esercizioCorrente &&
                                    modalitaAllenamento
                                ? const Icon(
                                    Icons.done_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  )
                                : Text(
                                    "#${index_esercizi + 1}",
                                    style: TextStyle(
                                        color:
                                            esercizioCorrente != index_esercizi
                                                ? Theme.of(context).hintColor
                                                : null,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  )),
                        title: Text(
                          _allenamento
                              .listaEsercizi![index_esercizi].nomeEsercizio!,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "${_allenamento.listaEsercizi![index_esercizi].serieEsercizio!} Serie",
                          style: TextStyle(color: Theme.of(context).hintColor),
                        ),
                      ),

                      // lista serie

                      Visibility(
                        visible:
                            esercizioCorrente == index_esercizi ? true : false,
                        child: ListView.builder(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: int.parse(
                            _allenamento
                                .listaEsercizi![index_esercizi].serieEsercizio!,
                          ),
                          itemBuilder: (context, index_serie) {
                            // in base alla serie corrente mostro la scheda SELEZIONATA oppure no

                            if (index_serie == serieCorrente) {
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(16)),
                                  side: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      width: 2.0),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      contentPadding: const EdgeInsets.only(
                                          right: 8, left: 16),
                                      title: Text(
                                        "${index_serie + 1}°  Serie",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      trailing: IconButton(
                                          icon: const Icon(
                                              Icons.description_rounded),
                                          onPressed: () {
                                            dialogNoteCoach(
                                                _allenamento.noteAllenamento!);
                                          }),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
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
                                        keyboardType: const TextInputType
                                            .numberWithOptions(decimal: true),
                                        decoration: const InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(8.0),
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8.0)),
                                          ),
                                          filled: true,
                                          alignLabelWithHint: false,
                                          prefixIcon: Icon(
                                              Icons.fitness_center_outlined),
                                        ),
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 4),
                                      child: Text("Ripetizioni"),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16, right: 16, bottom: 16),
                                      child: TextFormField(
                                        controller:
                                            _lista_controllers_ripetizioni[
                                                getIndexControllers(
                                                    index_esercizi,
                                                    index_serie)],
                                        textAlign: TextAlign.right,
                                        keyboardType: const TextInputType
                                            .numberWithOptions(decimal: true),
                                        decoration: const InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(8.0),
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8.0)),
                                          ),
                                          filled: true,
                                          alignLabelWithHint: false,
                                          prefixIcon:
                                              Icon(Icons.restart_alt_rounded),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              // scheda esercizio non selezionato
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: GestureDetector(
                                  onTap: () {
                                    if (!_timer.isActive) {
                                      selezionaSerieAlTocco(index_serie);
                                    }
                                  },
                                  child: Card(
                                    child: ListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16),
                                      horizontalTitleGap: 8,
                                      trailing: Text(
                                        "${_lista_controllers_carichi[getIndexControllers(index_esercizi, index_serie)].text}Kg",
                                        style: TextStyle(
                                            color: Theme.of(context).hintColor),
                                      ),
                                      title: Text(
                                        "${index_serie + 1}°  Serie",
                                        style: TextStyle(
                                            color: Theme.of(context).hintColor),
                                      ),
                                      leading: serieCorrente > index_serie &&
                                              modalitaAllenamento
                                          ? Icon(
                                              Icons.done_rounded,
                                              color:
                                                  Theme.of(context).hintColor,
                                            )
                                          : null,
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(
              height: 100,
            )
          ],
        ),
      ),
    );
  }

  bool siamoInAllenamento() {
    bool check = true;
    for (var element in scheda.allenamentiSvolti!) {
      if (element.nomeAllenamento == _allenamento.nomeAllenamento &&
          DateUtils.dateOnly(element.giorniAssegnati!.first.toDate()) ==
              DateUtils.dateOnly(dataSelezionata.toDate())) {
        check = false;
      }
    }
    return check;
  }

  Allenamento recuperaDatiDaStorico() {
    late Allenamento a;
    for (var element in scheda.allenamentiSvolti!) {
      if (element.nomeAllenamento == _allenamento.nomeAllenamento &&
          DateUtils.dateOnly(element.giorniAssegnati!.first.toDate()) ==
              DateUtils.dateOnly(dataSelezionata.toDate())) {
        a = element;
      }
    }
    return a;
  }

  void selezionaSerieAlTocco(int i) {
    setState(() {
      serieCorrente = i;
    });
  }

  // cambio manuale dell'esercizio. devo anche cambiare il recupero

  void selezionaEsercizioAlTocco(int i) {
    setState(() {
      esercizioCorrente = i;
      serieCorrente = 0;
      tempoRimasto = _allenamento.listaEsercizi![i].recuperoEsercizio!;
    });
  }

/*
  METODI VARI, PER LO SVOLGIMENTO DELL'ALLENAMENTO
*/
  void proseguiScheda() {
    if (int.parse(_allenamento
                .listaEsercizi![esercizioCorrente].serieEsercizio!) -
            1 >
        serieCorrente) {
      serieCorrente++;
    } else if (esercizioCorrente < _allenamento.listaEsercizi!.length) {
      serieCorrente = 0;
      esercizioCorrente++;
    }

    tempoRimasto =
        _allenamento.listaEsercizi![esercizioCorrente].recuperoEsercizio!;
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

// metodo per salvare dati su db

  void salvaDatiFineAllenamento() {
    DatabaseService dbs = DatabaseService();

    // carico esercizi con i nuovi valori
    int i = 0;

    for (int a = 0; a < _allenamento.listaEsercizi!.length; a++) {
      for (int b = 0;
          b < _allenamento.listaEsercizi![a].carichiEsercizio!.length;
          b++) {
        _allenamento.listaEsercizi![a].carichiEsercizio![b] =
            _lista_controllers_carichi[i].text;
        _allenamento.listaEsercizi![a].ripetizioniEsercizio![b] =
            _lista_controllers_ripetizioni[i].text;
        i++;
      }
    }

    /*
    List<Timestamp> giorno_allenamento = new List.empty(growable: true);
    giorno_allenamento.add(Timestamp.now());
    */
    _allenamento.giorniAssegnati!.clear();
    _allenamento.giorniAssegnati!.add(dataSelezionata);
    _allenamento.feedbackAllenamento = _controller.text;

    // logica per capire se eliminare il campo e ricreare l'esercizio svolto, basandosi su nome esercizio e data, se già presente lo vado ad
    // eliminare prima di aggiornare allenamentiSvolti con _allenamento

    scheda.allenamentiSvolti!.removeWhere((element) =>
        element.nomeAllenamento == _allenamento.nomeAllenamento &&
        DateUtils.dateOnly(element.giorniAssegnati!.first.toDate()) ==
            DateUtils.dateOnly(dataSelezionata.toDate()));

    // carico l'allenamento nel campo array allenamentiSvolti.
    scheda.allenamentiSvolti!.add(_allenamento);

    // salvo tutta la scheda ma solo il campo viene aggiornato.

    scheda.allenamentiSvolti!.sort(
      (b, a) => a.giorniAssegnati!.first.compareTo(b.giorniAssegnati!.first),
    );

    dbs
        .getInstanceDb()
        .collection(dbs.getCollezioneUtenti())
        .doc(dbs.getAuth().currentUser!.uid)
        .collection(dbs.getCollezioneSchede())
        .doc(scheda.idScheda!)
        .set(scheda.toFirestore(),
            SetOptions(mergeFields: ['allenamentiSvolti']));
  }

  double getPercentualeAvanzamento() {
    double p = (tempoRimasto) /
        (_allenamento.listaEsercizi![esercizioCorrente].recuperoEsercizio!);
    return p;
  }

  // dialogs
  void dialogNoteCoach(String note) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            icon: const Icon(Icons.description_rounded),
            title: const Text(
              "Note dal coach",
            ),
            content: Text(note),
            actions: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                    icon: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Icon(Icons.close),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    label: const Text("Chiudi"),
                    style: ButtonStyle(
                        elevation: const MaterialStatePropertyAll(1),
                        backgroundColor: MaterialStatePropertyAll(
                            Theme.of(context).primaryColor),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        )))),
              )
            ],
          );
        });
  }

  void dialogFeedback() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            icon: const Icon(Icons.note_alt_rounded),
            title: const Text(
              "Note personali",
            ),
            content: TextFormField(
              controller: _controller,
              textAlign: TextAlign.left,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                filled: true,
                alignLabelWithHint: true,
              ),
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                    icon: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Icon(Icons.close),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    label: const Text("Chiudi"),
                    style: ButtonStyle(
                        elevation: const MaterialStatePropertyAll(1),
                        backgroundColor: MaterialStatePropertyAll(
                            Theme.of(context).primaryColor),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        )))),
              )
            ],
          );
        });
  }

  void dialogConfermaEsci() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            icon: const Icon(Icons.gpp_maybe_outlined),
            title: const Text(
              "Attenzione",
            ),
            content: const Text("Sei in una seduta di allenamento"),
            actions: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                    icon: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Icon(Icons.close),
                    ),
                    onPressed: () {
                      _timer.cancel();
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    label: const Text("Esci da allenamento"),
                    style: ButtonStyle(
                        elevation: const MaterialStatePropertyAll(1),
                        backgroundColor:
                            const MaterialStatePropertyAll(Colors.red),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        )))),
              )
            ],
          );
        });
  }

  void inizializzaTextControllers() {
    _lista_controllers_carichi.clear();
    _lista_controllers_ripetizioni.clear();

    if (modalitaAllenamento) {
      for (var a in _allenamento.listaEsercizi!) {
        for (int b = 0; b < a.ripetizioniEsercizio!.length; b++) {
          TextEditingController t = TextEditingController.fromValue(
              TextEditingValue(text: a.ripetizioniEsercizio![b]));

          _lista_controllers_ripetizioni.add(t);
        }

        for (int c = 0; c < a.carichiEsercizio!.length; c++) {
          TextEditingController t = TextEditingController.fromValue(
              TextEditingValue(text: a.carichiEsercizio![c]));

          _lista_controllers_carichi.add(t);
        }
      }
    } else {
      Allenamento allenamento_storico = recuperaDatiDaStorico();

      for (var a in allenamento_storico.listaEsercizi!) {
        for (int b = 0; b < a.ripetizioniEsercizio!.length; b++) {
          TextEditingController t = TextEditingController.fromValue(
              TextEditingValue(text: a.ripetizioniEsercizio![b]));

          _lista_controllers_ripetizioni.add(t);
        }

        for (int c = 0; c < a.carichiEsercizio!.length; c++) {
          TextEditingController t = TextEditingController.fromValue(
              TextEditingValue(text: a.carichiEsercizio![c]));

          _lista_controllers_carichi.add(t);
        }
      }
    }
  }

  int getIndexControllers(int index_esercizi, int index_serie) {
    int index = 0;
    for (int a = 0; a < _allenamento.listaEsercizi!.length; a++) {
      if (a < index_esercizi) {
        index = index + _allenamento.listaEsercizi![a].carichiEsercizio!.length;
      }
    }
    return index + index_serie;
  }
}
