// ignore_for_file: camel_case_types, non_constant_identifier_names, no_leading_underscores_for_local_identifiers, duplicate_ignore, file_names

import 'package:app_fitness_test_2/Cliente/gestioneCalendario.dart';
import 'package:app_fitness_test_2/Cliente/progressioneEsercizio.dart';
import 'package:app_fitness_test_2/Cliente/svolgimentoAllenamento.dart';
import 'package:app_fitness_test_2/autenticazione/login.dart';
import 'package:app_fitness_test_2/autenticazione/metodi_autenticazione.dart';
import 'package:app_fitness_test_2/services/SchedaModel.dart';
import 'package:app_fitness_test_2/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
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
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "FITNESSAPP",
            style: TextStyle(letterSpacing: 2),
          ),
          actions: [
            IconButton(
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
                      leading: const Icon(Icons.logout_rounded),
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              constraints: const BoxConstraints(minWidth: 300, maxWidth: 300),
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
                gap: 6,
                activeColor: Colors.white,
                iconSize: 24,
                tabMargin: const EdgeInsets.all(8),
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
              padding: const EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
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
                if (snapshot.hasData) {
                  // SCHEDA PRESENTE
                  List lista = snapshot.data!.docs;
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
                      controller: scrollController,
                      padding: const EdgeInsets.all(8),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: listaAllenamentiSelezionati.length,
                      itemBuilder: (context, indexAllenamenti) {
                        return Card(
                          child: Column(children: [
                            // titolo allenamento
                            ListTile(
                              trailing: const Visibility(
                                  visible: true,
                                  child: Text(
                                    "",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                              title: Text(
                                listaAllenamentiSelezionati[
                                        indexAllenamenti]
                                    .nomeAllenamento!,
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ),
                            ListView.builder(
                              itemCount: listaAllenamentiSelezionati[
                                      indexAllenamenti]
                                  .listaEsercizi!
                                  .length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index_esercizi) {
                                return ExpansionTile(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(48))),
                                  leading: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 8),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context).dividerColor,
                                    ),
                                    child: Text(
                                      "#"
                                      "${index_esercizi + 1}",
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  title: Text(listaAllenamentiSelezionati[
                                          indexAllenamenti]
                                      .listaEsercizi![index_esercizi]
                                      .nomeEsercizio!),
                                  children: [
                                    // quando espando l'esercizi
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Wrap(
                                          verticalDirection:
                                              VerticalDirection.down,
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          direction: Axis.vertical,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                              padding: const EdgeInsets.all(8),
                                              child: const Icon(
                                                color: Colors.white,
                                                Icons.replay,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              listaAllenamentiSelezionati[
                                                      indexAllenamenti]
                                                  .listaEsercizi![
                                                      index_esercizi]
                                                  .ripetizioniEsercizio!
                                                  .first,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            const Text(
                                              "Ripetizioni",
                                              style: TextStyle(),
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 32,
                                        ),
                                        Wrap(
                                          verticalDirection:
                                              VerticalDirection.down,
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          direction: Axis.vertical,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                              padding: const EdgeInsets.all(8),
                                              child: const Icon(
                                                color: Colors.white,
                                                Icons.dataset_outlined,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              listaAllenamentiSelezionati[
                                                      indexAllenamenti]
                                                  .listaEsercizi![
                                                      index_esercizi]
                                                  .serieEsercizio!,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            const Text(
                                              "Serie",
                                              style: TextStyle(),
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 32,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Wrap(
                                            verticalDirection:
                                                VerticalDirection.down,
                                            crossAxisAlignment:
                                                WrapCrossAlignment.center,
                                            direction: Axis.vertical,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                                padding: const EdgeInsets.all(8),
                                                child: const Icon(
                                                  color: Colors.white,
                                                  Icons.timer,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Text(
                                                "${listaAllenamentiSelezionati[indexAllenamenti].listaEsercizi![index_esercizi].recuperoEsercizio!}s",
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                              const SizedBox(
                                                height: 4,
                                              ),
                                              const Text(
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
                                          color: Theme.of(context).dividerColor,
                                        ),
                                      ),
                                    ),
                                    ListTile(
                                      minLeadingWidth: 8,
                                      leading: Icon(
                                        Icons.bookmark,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      title: const Text(
                                        "Note",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 16, left: 16),
                                      child: ListTile(
                                        title: Text(
                                          listaAllenamentiSelezionati[
                                                  indexAllenamenti]
                                              .noteAllenamento!,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            const Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: 8),
                              child: Divider(),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(right: 8, bottom: 8),
                                child: SizedBox(
                                  height: 48,
                                  child: allenamentoGiaSvolto(
                                          scheda,
                                          listaAllenamentiSelezionati[
                                              indexAllenamenti],
                                          selectedDay.toDate())
                                      ? ElevatedButton.icon(
                                          style: ButtonStyle(
                                              elevation:
                                                  const MaterialStatePropertyAll(1),
                                              backgroundColor:
                                                  const MaterialStatePropertyAll(
                                                      Colors.red),
                                              shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16.0),
                                              ))),
                                          icon: const Icon(
                                              Icons.sports_esports_rounded),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        sedutaAllenamento(
                                                            allenamento:
                                                                listaAllenamentiSelezionati[
                                                                    indexAllenamenti],
                                                            scheda: scheda,
                                                            dataSelezionata:
                                                                selectedDay)));
                                          },
                                          label: const Text(
                                            "Allenamento",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      : ElevatedButton.icon(
                                          style: ButtonStyle(
                                              elevation:
                                                  const MaterialStatePropertyAll(1),
                                              backgroundColor:
                                                  MaterialStatePropertyAll(
                                                      Colors.blue.shade700),
                                              shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16.0),
                                              ))),
                                          icon: const Icon(Icons.edit_document),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        sedutaAllenamento(
                                                            allenamento:
                                                                listaAllenamentiSelezionati[
                                                                    indexAllenamenti],
                                                            scheda: scheda,
                                                            dataSelezionata:
                                                                selectedDay)));
                                          },
                                          label: const Text(
                                            "Resoconto",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ]),
                        );
                      },
                    );
                  } else {
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
                            color: Theme.of(context).primaryColor,
                          ),
                          Text("Giorno di riposo",
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Theme.of(context).hintColor,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(
                            height: 8,
                          ),
                          Text.rich(
                            textAlign: TextAlign.center,
                            TextSpan(
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).hintColor,
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
                                    color: Theme.of(context).primaryColor,
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
                List<Esercizio> _lista_esercizi =
                    List.empty(growable: true);
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
                                    "${(getAvanzamentoEsercizio(
                                                    _lista_esercizi[index]) *
                                                100)
                                            .toStringAsFixed(0)}%  Eseguiti",
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
                                "${getNumeroEsecuzioniSvolte(
                                            _lista_esercizi[index])
                                        .toStringAsFixed(0)}/${getNumeroEsecuzioniInScheda(
                                            _lista_esercizi[index])
                                        .toStringAsFixed(0)}",
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
    return const Placeholder();
  }
}
