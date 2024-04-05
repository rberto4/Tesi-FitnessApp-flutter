import 'package:app_fitness_test_2/Cliente/dettagliAllenamento.dart';
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
import 'package:flutter/widgets.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:intl/intl.dart';

final DatabaseService _dbs = DatabaseService();

late SchedaModel sm = new SchedaModel(
    nome_scheda: null,
    allenamenti: null,
    inizio_scheda: null,
    fine_scheda: null,
    storico_esercizi: null,
    id_scheda: null);

int _selectedIndex = 0;

class MainPageUtente extends StatefulWidget {
  const MainPageUtente({super.key});

  @override
  State<MainPageUtente> createState() => _MainPageUtenteState();
}

class _MainPageUtenteState extends State<MainPageUtente> {
  final ScrollController _scrollController = new ScrollController();
  bool scroll_visibility = true;

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels > 0 ||
          _scrollController.position.pixels <
              _scrollController.position.maxScrollExtent)
        scroll_visibility = false;
      else
        scroll_visibility = true;

      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("FITNESSAPP", style: TextStyle(letterSpacing: 2),),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => gestioneCalendario(sm: sm)),
                  );
                },
                icon: Icon(Icons.edit_calendar_rounded)),
            IconButton(
                onPressed: () {
                  AuthenticationHelper().signOut().then((result) {
                    if (result == null) {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(result)),
                      );
                    }
                  });
                },
                icon: const Icon(Icons.logout)),
          ],
        ),

        // DRAWER NAVIGATION
        drawer: const Drawer(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        // bottom nav bar
        floatingActionButton: SafeArea(
          child: Visibility(
            visible: scroll_visibility,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Container(
                constraints: BoxConstraints(minWidth: 300, maxWidth: 300),
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
                  tabMargin: EdgeInsets.all(8),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                  duration: Duration(milliseconds: 300),
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
        ),

        extendBody: true,
        body: tabPages[_selectedIndex]);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> tabPages = [
    const paginaSchedaCorrente(),
    const paginaProgressi(),
    const paginaArchivioSchede(),
  ];
}

// TAB SCHEDA CORRENTE E CALENDARIO

// ignore: camel_case_types
class paginaSchedaCorrente extends StatefulWidget {
  const paginaSchedaCorrente({super.key});

  @override
  State<paginaSchedaCorrente> createState() => _paginaSchedaCorrenteState();
}

class _paginaSchedaCorrenteState extends State<paginaSchedaCorrente> {
  late Timestamp selectedDay = Timestamp.now();
  List<Allenamento?> lista_sedute_allenamenti = new List.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  // CONTROLLO SULLO STREAM DI DATI
                  List lista = snapshot.data!.docs;
                  sm = lista[0].data();

                  lista_sedute_allenamenti.clear();
                  // caricamento dati nella lista locale in base al giorno di allenamento selezionato
                  sm.allenamenti!.forEach((element_allenamento) =>
                      element_allenamento.giorniAssegnati!.forEach(
                          (element_giorno) =>
                              DateUtils.dateOnly(element_giorno.toDate()) ==
                                      DateUtils.dateOnly(selectedDay.toDate())
                                  ? {
                                      lista_sedute_allenamenti
                                          .add(element_allenamento)
                                    }
                                  : ()));

                  return lista_sedute_allenamenti.isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                            controller:
                                _MainPageUtenteState()._scrollController,
                            padding: EdgeInsets.all(8),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: lista_sedute_allenamenti.length,
                            itemBuilder: (context, index_allenamenti) {
                              return Card(
                                child: Column(children: [
                                  // titolo allenamento
                                  ListTile(
                                    trailing: Visibility(
                                        visible: true,
                                        child: Text(
                                          "14:30",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                    title: Text(
                                      lista_sedute_allenamenti[
                                              index_allenamenti]!
                                          .nomeAllenamento!,
                                      style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  ListView.builder(
                                    itemCount: lista_sedute_allenamenti[
                                            index_allenamenti]!
                                        .nomi_es!
                                        .length,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (context, index_esercizi) {
                                      return ExpansionTile(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(48))),
                                        leading: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 8),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                Theme.of(context).dividerColor,
                                          ),
                                          child: Text(
                                            "#"
                                            "${index_esercizi + 1}",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                        title: Text(
                                          lista_sedute_allenamenti[
                                                  index_allenamenti]!
                                              .nomi_es![index_esercizi],
                                        ),
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
                                                    lista_sedute_allenamenti[
                                                                index_allenamenti]!
                                                            .ripetizioni_es![
                                                        index_esercizi],
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                                    lista_sedute_allenamenti[
                                                            index_allenamenti]!
                                                        .serie_es![index_esercizi],
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Wrap(
                                                  verticalDirection:
                                                      VerticalDirection.down,
                                                  crossAxisAlignment:
                                                      WrapCrossAlignment.center,
                                                  direction: Axis.vertical,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColor),
                                                      padding:
                                                          EdgeInsets.all(8),
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
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                                color: Theme.of(context)
                                                    .dividerColor,
                                              ),
                                            ),
                                          ),
                                          ListTile(
                                            minLeadingWidth: 8,
                                            leading: Icon(
                                              Icons.bookmark,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            title: Text(
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
                                                "ciao, queste sono note di esempio relative a questo esercizio",
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: ElevatedButton.icon(
                                          icon: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8),
                                            child:
                                                Icon(Icons.play_circle_outline),
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        svolgimentoAllenamento(
                                                            sm: sm, i: index_allenamenti)));
                                          },
                                          label: Text("Inizia allenamento"),
                                          style: ButtonStyle(
                                              elevation:
                                                  MaterialStatePropertyAll(1),
                                              backgroundColor:
                                                  MaterialStatePropertyAll(
                                                      Colors.red),
                                              shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(48.0),
                                              )))),
                                    ),
                                  )
                                ]),
                              );
                            },
                          ),
                        )
                      : Expanded(
                          child: Center(
                              child: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  direction: Axis.vertical,
                                  children: [
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
                              SizedBox(
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
                                    TextSpan(
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
                                    TextSpan(
                                      text: " in alto ",
                                    ),
                                  ],
                                ),
                              ),
                            ])));
                } else {
                  return Text("");
                }
              }),
        ],
      ),
    );
  }
}

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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Archivio",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
            ),
            Card(
              child: TextField(
                controller: searchbar_controller,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: "Ricerca le schede per nome ...",
                  hintMaxLines: 1,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        searchbar_controller.clear();
                      });
                    },
                    icon: Icon(Icons.clear_rounded),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    nome_scheda_filtrato = value;
                  });
                },
              ),
            ),
            StreamBuilder(
              stream: _dbs.getTotaleSchede(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  final List schede = snapshot.data!.docs ?? [];
                  return ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: schede.length,
                    itemBuilder: (context, index) {
                      final SchedaModel sm = schede[index].data();

                      // CONTROLLO PER LA RICERCA PER NOME

                      if (searchbar_controller.text.isEmpty ||
                          sm.nome_scheda!
                              .toLowerCase()
                              .replaceAll(" ", "")
                              .characters
                              .containsAll(nome_scheda_filtrato
                                  .toLowerCase()
                                  .replaceAll(" ", "")
                                  .characters)) {
                        print(nome_scheda_filtrato);

                        return Card(
                          // CARD SCHEDA

                          child: Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 8),
                            child: Theme(
                              data: ThemeData()
                                  .copyWith(dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                  title: ListTile(
                                    leading: CircleAvatar(
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        child: const Icon(
                                          Icons.book_rounded,
                                          color: Colors.white,
                                        )),
                                    title: Text(
                                      sm.nome_scheda!,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text("Dal " +
                                        DateFormat.yMd().format(
                                            sm.inizio_scheda!.toDate()) +
                                        " al " +
                                        DateFormat.yMd()
                                            .format(sm.fine_scheda!.toDate())),
                                  ),
                                  children: []),
                            ),
                          ),
                        );
                      }
                    },
                  );
                } else {
                  return Text("");
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

class paginaProgressi extends StatefulWidget {
  const paginaProgressi({super.key});

  @override
  State<paginaProgressi> createState() => _paginaProgressiState();
}

class _paginaProgressiState extends State<paginaProgressi> {
  @override
  Widget build(BuildContext context) {
    List<String> lista_esercizi_scheda = new List.empty(growable: true);
    sm.allenamenti!.forEach((element) => element.nomi_es!
        .forEach((element) => lista_esercizi_scheda.add(element)));
    return Expanded(
      child: Column(
        children: [
          ListTile(
            title: Text(
              "Esercizi in scheda",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
          ),
          GridView.count(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              crossAxisCount: 2,
              children: List.generate(lista_esercizi_scheda.length, (index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => progressioneEsercizio(
                                sm: sm,
                                nome_es: lista_esercizi_scheda[index])));
                  },
                  child: Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [Text(lista_esercizi_scheda[index])],
                    ),
                  ),
                );
              })),
        ],
      ),
    );
  }
}
