// ignore_for_file: camel_case_types, non_constant_identifier_names, no_leading_underscores_for_local_identifiers, duplicate_ignore, file_names, prefer_const_constructors, use_build_context_synchronously

import 'package:app_fitness_test_2/Cliente/conversazione.dart';
import 'package:app_fitness_test_2/Cliente/gestioneCalendario.dart';
import 'package:app_fitness_test_2/Cliente/progressioneEsercizio.dart';
import 'package:app_fitness_test_2/Cliente/svolgimentoAllenamento.dart';
import 'package:app_fitness_test_2/Cliente/widgetTabella.dart';
import 'package:app_fitness_test_2/autenticazione/login.dart';
import 'package:app_fitness_test_2/autenticazione/metodi_autenticazione.dart';
import 'package:app_fitness_test_2/services/ChatModel.dart';
import 'package:app_fitness_test_2/services/SchedaModel.dart';
import 'package:app_fitness_test_2/services/UserModel.dart';
import 'package:app_fitness_test_2/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

final DatabaseService _dbs = DatabaseService();

Scheda schedaGlobal = Scheda(
    nomeScheda: null,
    allenamentiScheda: null,
    inizioScheda: null,
    fineScheda: null,
    idScheda: null,
    allenamentiSvolti: null);

class MainPageUtente extends StatefulWidget {
  const MainPageUtente({super.key});

  @override
  State<MainPageUtente> createState() => _MainPageUtenteState();
}

class _MainPageUtenteState extends State<MainPageUtente> {
  late List<Widget> tabPages = List.empty(growable: true);
  int _selectedIndex = 0;
  bool _isVisible = true;

  updateBottomNavVisibility(bool b) {
    setState(() {
      _isVisible = b;
    });
  }

  @override
  void initState() {
    tabPages = [
      const paginaSchedaCorrente(),
      const paginaProgressi(),
      const paginaArchivioSchede(),
      const paginaChat()
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          toolbarHeight: 90,
          title: Image.asset(
            'lib/Immagini/Logo.png',
            height: 150,
            width: 150,
            alignment: Alignment.bottomCenter,
          ),
          actions: [
            IconButton(
                color: Theme.of(context).hintColor,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => gestioneCalendario(
                              scheda: schedaGlobal,
                            )),
                  );
                },
                icon: const Icon(Icons.edit_calendar_rounded)),
          ],
        ),

        // DRAWER NAVIGATION
        drawer: Drawer(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 32,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: CircleAvatar(
                      radius: 40,
                      child: Text(
                        "R",
                        style: TextStyle(
                            fontSize: 36, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  ListTile(
                    title: Text(
                      _dbs.getAuth().currentUser!.displayName!,
                      style: const TextStyle(
                          fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      _dbs.getAuth().currentUser!.email!,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Spacer(),
                  const Divider(),
                  ListTile(
                      onTap: () {
                        AuthenticationHelper().signOut().then((result) {
                          if (result == null) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(result)),
                            );
                          }
                        });
                      },
                      trailing: const Icon(Icons.logout_rounded),
                      title: const Text(
                        "Logout",
                        style: TextStyle(fontSize: 18),
                      ))
                ],
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        // bottom nav bar
        floatingActionButton: Visibility(
          visible: _isVisible,
          child: Container(
            width: MediaQuery.of(context).size.width - 64,
            constraints: const BoxConstraints(maxWidth: 400),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(48),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor,
                  spreadRadius: 1,
                  blurRadius: 48.0,
                ),
              ],
            ),
            child: GNav(
              rippleColor: Theme.of(context).focusColor,
              hoverColor: Theme.of(context).hoverColor,
              gap: 4,
              activeColor: Colors.white,
              iconSize: 24,
              tabMargin: const EdgeInsets.all(4),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
              duration: const Duration(milliseconds: 500),
              tabBackgroundColor: Theme.of(context).primaryColor,
              color: Colors.grey,
              tabs: const [
                GButton(
                  icon: Icons.calendar_month,
                  text: 'Calendario',
                ),
                GButton(
                  icon: Icons.bar_chart_rounded,
                  text: 'Progressi',
                ),
                GButton(
                  icon: Icons.folder,
                  text: 'Archivio',
                ),
                GButton(
                  icon: Icons.chat_rounded,
                  text: 'Chat',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
        resizeToAvoidBottomInset: true,
        body: tabPages[_selectedIndex]);
  }
}

// TAB SCHEDA CORRENTE E CALENDARIO

// ignore: camel_case_types
class paginaSchedaCorrente extends StatefulWidget {
  const paginaSchedaCorrente({super.key});

  @override
  State<paginaSchedaCorrente> createState() => _paginaSchedaCorrenteState();
}

// ignore: camel_case_types
class _paginaSchedaCorrenteState extends State<paginaSchedaCorrente> {
  late Timestamp selectedDay = Timestamp.now();
  // ignore: non_constant_identifier_names
  List<Allenamento?> lista_sedute_allenamenti = List.empty(growable: true);
  final ScrollController scrollController = ScrollController();
  // ignore: non_constant_identifier_names
  bool btn_nav_bar_visibility = true;
  _paginaSchedaCorrenteState();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          EasyDateTimeLine(
            headerProps: EasyHeaderProps(
              centerHeader: false,
              padding:
                  const EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
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
            initialDate: selectedDay.toDate(),
            onDateChange: (selectedDate) {
              setState(() {
                selectedDay = Timestamp.fromDate(selectedDate);
              });
            },
          ),
          StreamBuilder(
              stream: _dbs.getSchedaCorrente(),
              builder: (context, snapshot) {
                List lista = List.empty(growable: true);

                if (snapshot.hasData) {
                  // SCHEDA PRESENTE
                  lista = snapshot.data!.docs;
                  Scheda scheda = lista[0].data();
                  schedaGlobal = scheda;
                  List<Allenamento> listaAllenamentiSelezionati =
                      List.empty(growable: true);

                  // ASSEGNAZIONE ALLENAMENTI PER LA GIORNATA, IN LISTA LOCALE

                  listaAllenamentiSelezionati =
                      allenamentiPerIlGiornoSelezionato(
                          scheda, selectedDay.toDate());

                  if (listaAllenamentiSelezionati.isNotEmpty) {
                    return ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: listaAllenamentiSelezionati.length,
                      itemBuilder: (context, indexAllenamenti) {
                        return Column(
                          children: [
                            ListTile(
                              title: Text(
                                listaAllenamentiSelezionati[indexAllenamenti]
                                    .nomeAllenamento!,
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              trailing: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(48),
                                    border: Border.all(
                                        width: 1,
                                        color: Theme.of(context).primaryColor)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    "18:30",
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            widgetTabellaEsercizi(
                                    lista_esercizi: listaAllenamentiSelezionati[
                                            indexAllenamenti]
                                        .listaEsercizi,
                                    context: context)
                                .creaTabella(),
                            // pulsante di avvio allenamento / visualizza allenamento passato

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8),
                              child: SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton.icon(
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                    )),
                                    backgroundColor: MaterialStatePropertyAll(
                                        allenamentoGiaSvolto(
                                                scheda,
                                                listaAllenamentiSelezionati[
                                                    indexAllenamenti],
                                                selectedDay.toDate())
                                            ? Colors.red
                                            : Colors.blue),
                                  ),
                                  label: Text(
                                    allenamentoGiaSvolto(
                                            scheda,
                                            listaAllenamentiSelezionati[
                                                indexAllenamenti],
                                            selectedDay.toDate())
                                        ? "Allenamento"
                                        : "Resoconto allenamento",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  icon: Icon(Icons.flag_rounded),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => sedutaAllenamento(
                                                allenamento:
                                                    listaAllenamentiSelezionati[
                                                        indexAllenamenti],
                                                scheda: scheda,
                                                dataSelezionata: selectedDay)));
                                  },
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    // schermata , al posto della lista, che mostra la giornata di riposo, di default se non ho assegnato la giornata a nessun allenamento

                    return Center(
                        child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            direction: Axis.vertical,
                            children: [
                          const SizedBox(
                            height: 64,
                          ),
                          Icon(
                            Icons.hotel_rounded,
                            size: 108,
                            color: Theme.of(context).hintColor.withOpacity(0.3),
                          ),
                          Text("Giorno di riposo",
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Theme.of(context)
                                      .hintColor
                                      .withOpacity(0.3),
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(
                            height: 8,
                          ),
                          Text.rich(
                            textAlign: TextAlign.center,
                            TextSpan(
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context)
                                      .hintColor
                                      .withOpacity(0.3),
                                  fontWeight: FontWeight.bold),
                              children: [
                                const TextSpan(
                                  text:
                                      "Se vuoi modificare i tuoi programmi\n clicca sull'icona ",
                                ),
                                WidgetSpan(
                                  child: Icon(
                                    Icons.edit_calendar_rounded,
                                    size: 18,
                                    color: Theme.of(context)
                                        .hintColor
                                        .withOpacity(0.3),
                                  ),
                                ),
                                const TextSpan(
                                  text: " in alto ",
                                ),
                              ],
                            ),
                          ),
                        ]));
                  }
                } else {
                  // LOGICA PER SCHEDA NON PRESENTE.

                  return const Text("");
                }
              })
        ],
      ),
    );
  }

  List<Allenamento> allenamentiPerIlGiornoSelezionato(Scheda s, DateTime d) {
    List<Allenamento> list = List.empty(growable: true);

    for (int i = 0; i < s.allenamentiScheda!.length; i++) {
      for (int j = 0;
          j < s.allenamentiScheda![i].giorniAssegnati!.length;
          j++) {
        if (DateUtils.dateOnly(
                s.allenamentiScheda![i].giorniAssegnati![j].toDate()) ==
            DateUtils.dateOnly(d)) {
          list.add(s.allenamentiScheda![i]);
        }
      }
    }
    return list;
  }

  // metodo per controllare se un allenamento è presente nella lista degli allenamenti gia svolti, nel giorno selezionato

  bool allenamentoGiaSvolto(Scheda s, Allenamento a, DateTime d) {
    bool check = true;

    for (var element in s.allenamentiSvolti!) {
      if (a.nomeAllenamento == element.nomeAllenamento &&
          DateUtils.dateOnly(d) ==
              DateUtils.dateOnly(element.giorniAssegnati!.first.toDate())) {
        check = false;
      }
    }

    return check;
  }
}
// pagina progressi

class paginaProgressi extends StatefulWidget {
  const paginaProgressi({super.key});

  @override
  State<paginaProgressi> createState() => paginaProgressiState();
}

class paginaProgressiState extends State<paginaProgressi> {
  int? _index_allenamento_filtrato;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
            title: const Text(
              "Progressi esercizi",
              style: TextStyle(fontSize: 24),
            ),

            // pulsante annulla filtri

            trailing: Visibility(
              visible: (_index_allenamento_filtrato == null) ? false : true,
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      _index_allenamento_filtrato = null;
                    });
                  },
                  icon: const Icon(Icons.filter_list_off_rounded),
                  color: Colors.white,
                ),
              ),
            )),

        // filtri chips

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Wrap(
            runAlignment: WrapAlignment.start,
            runSpacing: 8,
            alignment: WrapAlignment.start,
            direction: Axis.horizontal,
            crossAxisAlignment: WrapCrossAlignment.start,
            spacing: 8,
            children: List<Widget>.generate(
              schedaGlobal.allenamentiScheda!.length,
              (int index) {
                return ChoiceChip(
                  showCheckmark: true,
                  checkmarkColor: Colors.white,
                  labelPadding: const EdgeInsets.all(8),
                  selectedColor: Theme.of(context).primaryColor,
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                  label: Text(
                    schedaGlobal.allenamentiScheda![index].nomeAllenamento!,
                    style: TextStyle(
                        color: _index_allenamento_filtrato == index
                            ? Colors.white
                            : null),
                  ),
                  selected: _index_allenamento_filtrato == index,
                  onSelected: (bool selected) {
                    setState(() {
                      _index_allenamento_filtrato = selected ? index : null;
                    });
                  },
                );
              },
            ).toList(),
          ),
        ),

        Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: getLenghtEsercizi(),
              itemBuilder: (context, index) {
                List<Esercizio> _lista_esercizi = List.empty(growable: true);
                _lista_esercizi = getListaEsercizi();
                return GestureDetector(
                  onTap: () {
                    getAvanzamentoEsercizio(_lista_esercizi[index]) != 0
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => progressioneEsercizio(
                                    list_esercizi: getListaEserciziSvolti(
                                        _lista_esercizi[index]),
                                    list_date: getDateEserciziSvolti(
                                        _lista_esercizi[index]))),
                          )
                        : null;
                  },
                  child: Card(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: ListTile(
                            minVerticalPadding: 8,
                            title: Padding(
                              padding: const EdgeInsets.only(bottom: 2),
                              child: Text(_lista_esercizi[index].nomeEsercizio!,
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold)),
                            ),
                            subtitle: getAvanzamentoEsercizio(
                                        _lista_esercizi[index]) ==
                                    0
                                ? const Text("Mai eseguito")
                                : Text(
                                    "${(getAvanzamentoEsercizio(_lista_esercizi[index]) * 100).toStringAsFixed(0)}%  Eseguiti",
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Visibility(
                            visible: getAvanzamentoEsercizio(
                                        _lista_esercizi[index]) ==
                                    0
                                ? false
                                : true,
                            child: CircularPercentIndicator(
                              radius: 48,
                              percent: getAvanzamentoEsercizio(
                                  _lista_esercizi[index]),
                              animation: true,
                              animationDuration: 1000,
                              progressColor: Theme.of(context).primaryColor,
                              addAutomaticKeepAlive: false,
                              lineWidth: 12,
                              circularStrokeCap: CircularStrokeCap.round,
                              center: Text(
                                "${getNumeroEsecuzioniSvolte(_lista_esercizi[index]).toStringAsFixed(0)}/${getNumeroEsecuzioniInScheda(_lista_esercizi[index]).toStringAsFixed(0)}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        )
      ],
    );
  }

  int getLenghtEsercizi() {
    int lenght = 0;
    if (_index_allenamento_filtrato == null) {
      for (var element in schedaGlobal.allenamentiScheda!) {
        lenght = lenght + element.listaEsercizi!.length;
      }
    } else {
      lenght = schedaGlobal.allenamentiScheda![_index_allenamento_filtrato!]
          .listaEsercizi!.length;
    }
    return lenght;
  }

  List<Esercizio> getListaEsercizi() {
    List<Esercizio> list = List.empty(growable: true);
    if (_index_allenamento_filtrato == null) {
      for (var element in schedaGlobal.allenamentiScheda!) {
        list.addAll(element.listaEsercizi!);
      }
    } else {
      list.addAll(schedaGlobal
          .allenamentiScheda![_index_allenamento_filtrato!].listaEsercizi!);
    }
    return list;
  }

  List<Esercizio> getListaEserciziSvolti(Esercizio es) {
    List<Esercizio> list = List.empty(growable: true);

    for (var element in schedaGlobal.allenamentiSvolti!) {
      for (var element in element.listaEsercizi!) {
        if (element.nomeEsercizio == es.nomeEsercizio) {
          list.add(element);
        }
      }
    }

    return list;
  }

  List<Timestamp> getDateEserciziSvolti(Esercizio es) {
    List<Timestamp> list = List.empty(growable: true);

    for (var element_allenamento in schedaGlobal.allenamentiSvolti!) {
      for (var element_esercizio in element_allenamento.listaEsercizi!) {
        if (element_esercizio.nomeEsercizio == es.nomeEsercizio) {
          list.add(element_allenamento.giorniAssegnati!.first);
        }
      }
    }

    return list;
  }

  double getNumeroEsecuzioniInScheda(Esercizio es) {
    double n = 0;
    for (var element in schedaGlobal.allenamentiScheda!) {
      if (element.listaEsercizi!.contains(es)) {
        n = n + 1;
        n = n * element.giorniAssegnati!.length;
      }
    }
    return n;
  }

  double getNumeroEsecuzioniSvolte(Esercizio es) {
    double n = 0;
    for (var element in schedaGlobal.allenamentiSvolti!) {
      for (var element_es in element.listaEsercizi!) {
        if (element_es.nomeEsercizio == es.nomeEsercizio) {
          n = n + 1;
        }
      }
    }
    return n;
  }

  double getAvanzamentoEsercizio(Esercizio es) {
    double daSvolgere = 0;
    double giaSvolti = 0;
    double avanzamento = 0;

    daSvolgere = getNumeroEsecuzioniInScheda(es);
    giaSvolti = getNumeroEsecuzioniSvolte(es);

    if (daSvolgere == 0 && giaSvolti != 0) {
      return 1;
    } else if (daSvolgere == 0 && giaSvolti == 0) {
      return 0;
    } else if (giaSvolti > daSvolgere) {
      return 1;
    } else {
      avanzamento = giaSvolti / daSvolgere;
      return avanzamento;
    }
  }
}
// pagina chat

class paginaChat extends StatefulWidget {
  const paginaChat({super.key});

  @override
  State<paginaChat> createState() => _paginaChatState();
}

class _paginaChatState extends State<paginaChat> {
  List<CoachModel> lista_contatti = List.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ListTile(
            title: Text(
              "Messaggi",
              style: TextStyle(fontSize: 24),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          StreamBuilder(
            stream: _dbs.getListaContatti(),
            builder: (context, snapshot) {
              lista_contatti.clear();

              if (snapshot.hasData) {
                for (var a in snapshot.data!.docs) {
                  lista_contatti.add(CoachModel(
                      listaEserciziStandard: null,
                      listaClientiSeguiti: null,
                      username: a.data().username,
                      email: a.data().email,
                      uid: a.id));
                }

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: lista_contatti.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        // DA MODIFICARE LA CREAZIONE DEL DOCUMENTO A LIVELLO DI COACH

                        if (await _dbs
                            .getInstanceDb()
                            .collection(_dbs.getCollezioneUtenti())
                            .doc(_dbs.getAuth().currentUser!.uid)
                            .collection(_dbs.getCollezioneChat())
                            .doc(lista_contatti[index].uid!)
                            .get()
                            .then((value) => !value.exists)) {
                          _dbs
                              .getInstanceDb()
                              .collection(_dbs.getCollezioneUtenti())
                              .doc(_dbs.getAuth().currentUser!.uid)
                              .collection(_dbs.getCollezioneChat())
                              .doc(lista_contatti[index].uid!)
                              .set(Chat(listaMessaggi: List.empty())
                                  .toFirestore());
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => conversazioneChat(
                                    coachModel: lista_contatti[index],
                                    mittenteCoach: false,
                                    uidDestinatarioCLiente: "",
                                  )),
                        );
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(
                            "AP",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                        subtitle: Text(lista_contatti[index].email!),
                        title: Text(
                          lista_contatti[index].username!,
                          style: TextStyle(fontSize: 18),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios_rounded),
                      ),
                    );
                  },
                );
              } else {
                return Text("");
              }
            },
          )
        ],
      ),
    );
  }
}

// pagina archivio

class paginaArchivioSchede extends StatefulWidget {
  const paginaArchivioSchede({super.key});
  @override
  State<paginaArchivioSchede> createState() => _paginaArchivioSchedeState();
}

class _paginaArchivioSchedeState extends State<paginaArchivioSchede> {
  String nome_scheda_filtrato = "";
  TextEditingController searchbar_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: Text(
                "Archivio schede",
                style: TextStyle(fontSize: 24),
              ),
            ),
            // barra di ricerca
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 16, right: 0),
                height: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextFormField(
                  onChanged: (value) {
                    setState(() {});
                  },
                  controller: searchbar_controller,
                  textAlign: TextAlign.start,
                  textAlignVertical: TextAlignVertical.center,
                  maxLines: 1,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(
                          Radius.circular(16.0),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      ),
                      filled: false,
                      alignLabelWithHint: true,
                      hintText: "Cerca..",
                      suffixIcon: Icon(
                        Icons.search,
                      ),
                      prefixIcon: searchbar_controller.text.isNotEmpty
                          ? IconButton(
                              color: Theme.of(context).primaryColor,
                              onPressed: () {
                                setState(() {
                                  searchbar_controller.clear();
                                });
                              },
                              icon: Icon(Icons.cancel_rounded))
                          : null),
                ),
              ),
            ),
            StreamBuilder(
              stream: _dbs.getTotaleSchede(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 64),
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasData) {
                  final List<Scheda> schede =
                      List.from(snapshot.data!.docs.map((e) => e.data()));

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: schede.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      if (searchbar_controller.text.isEmpty &&
                          schede[index].nomeScheda!.toLowerCase().contains(
                              searchbar_controller.text.toLowerCase())) {
                        return Padding(
                          padding:
                              const EdgeInsets.only(top: 8, left: 8, right: 8),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  leading: Icon(Icons.note_alt_rounded),
                                  title: Text(
                                    schede[index].nomeScheda!,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24),
                                  ),
                                  trailing: index == 0
                                      ? Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(48),
                                              border: Border.all(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  width: 1)),
                                          child: Text(
                                            "in uso",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      : null,
                                ),
                                ListTile(
                                  title: Text(
                                      "Dal  ${DateFormat.yMd(Locale('it', 'IT').countryCode).format(schede[index].inizioScheda!.toDate())}  al  ${DateFormat.yMd(Locale('it', 'IT').countryCode).format(schede[index].fineScheda!.toDate())}"),
                                ),
                                Divider(),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount:
                                      schede[index].allenamentiScheda!.length,
                                  itemBuilder: (context, index_allenamenti) {
                                    return ExpansionTile(
                                      shape: Border(),
                                      title: Text(schede[index]
                                          .allenamentiScheda![index_allenamenti]
                                          .nomeAllenamento!),
                                      children: [
                                        widgetTabellaEsercizi(
                                                lista_esercizi: schede[index]
                                                    .allenamentiScheda![
                                                        index_allenamenti]
                                                    .listaEsercizi!,
                                                context: context)
                                            .creaTabella()
                                      ],
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  );
                } else {
                  return Text("no data");
                }
              },
            ),
            SizedBox(
              height: 96,
            )
          ],
        ),
      ),
    );
  }
}
