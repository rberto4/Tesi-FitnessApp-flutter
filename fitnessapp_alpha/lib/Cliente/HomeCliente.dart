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
import 'package:google_nav_bar/google_nav_bar.dart';

final DatabaseService _dbs = DatabaseService();

Scheda scheda = Scheda(
    nomeScheda: null,
    allenamentiScheda: null,
    inizioScheda: null,
    fineScheda: null,
    idScheda: null);

class MainPageUtente extends StatefulWidget {
  const MainPageUtente({super.key});

  @override
  State<MainPageUtente> createState() => _MainPageUtenteState();
}

class _MainPageUtenteState extends State<MainPageUtente> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "FITNESSAPP",
            style: TextStyle(letterSpacing: 2),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  /*
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            gestioneCalendario(scheda: scheda)),
                  );
                  */
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
        floatingActionButton:
            Padding(
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
            
        resizeToAvoidBottomInset: false,
        body:  tabPages[_selectedIndex]);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
 
  final List<Widget> tabPages = [
    paginaSchedaCorrente(scheda: scheda),
    const paginaProgressi(),
    const paginaArchivioSchede(),
  ];
}

// TAB SCHEDA CORRENTE E CALENDARIO

class paginaSchedaCorrente extends StatefulWidget {
  late Scheda scheda;
  paginaSchedaCorrente({super.key, required this.scheda, });

  @override
  State<paginaSchedaCorrente> createState() =>
      _paginaSchedaCorrenteState(this.scheda, );
}

class _paginaSchedaCorrenteState extends State<paginaSchedaCorrente> {
  late Scheda scheda;
    late Function() updateBottomNavVisibility;
  late Timestamp selectedDay = Timestamp.now();
  List<Allenamento?> lista_sedute_allenamenti = new List.empty(growable: true);
  _paginaSchedaCorrenteState(this.scheda);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
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
                        scheda = lista[0].data();
            
                        if (allenamentiPerIlGiornoSelezionato(
                            scheda, selectedDay.toDate())) {
                          return ListView.builder(
                            
                            padding: EdgeInsets.all(8),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: scheda.allenamentiScheda!.length,
                            itemBuilder: (context, index_allenamenti) {
                              return Card(
                                child: Column(children: [
                                  // titolo allenamento
                                  ListTile(
                                    trailing: Visibility(
                                        visible: true,
                                        child: Text(
                                          "",
                                          style:
                                              TextStyle(fontWeight: FontWeight.bold),
                                        )),
                                    title: Text(
                                      scheda.allenamentiScheda![index_allenamenti]
                                          .nomeAllenamento!,
                                      style: const TextStyle(
                                          fontSize: 24, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  ListView.builder(
                                    itemCount: scheda
                                        .allenamentiScheda![index_allenamenti]
                                        .listaEsercizi!
                                        .length,
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
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
                                            color: Theme.of(context).dividerColor,
                                          ),
                                          child: Text(
                                            "#"
                                            "${index_esercizi + 1}",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                        title: Text(scheda
                                            .allenamentiScheda![index_allenamenti]
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
                                                    scheda
                                                        .allenamentiScheda![
                                                            index_allenamenti]
                                                        .listaEsercizi![
                                                            index_esercizi]
                                                        .ripetizioniEsercizio!
                                                        .first,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold,
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
                                                    scheda
                                                        .allenamentiScheda![
                                                            index_allenamenti]
                                                        .listaEsercizi![
                                                            index_esercizi]
                                                        .serieEsercizio!,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold,
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
                                                      "${scheda.allenamentiScheda![index_allenamenti].listaEsercizi![index_esercizi].recuperoEsercizio!}s",
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.bold,
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
                                                scheda
                                                    .allenamentiScheda![
                                                        index_allenamenti]
                                                    .noteAllenamento!,
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
                                            child: Icon(Icons.play_circle_outline),
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        sedutaAllenamento(
                                                          allenamento: scheda
                                                                  .allenamentiScheda![
                                                              index_allenamenti],
                                                        )));
                                          },
                                          label: Text("Inizia allenamento"),
                                          style: ButtonStyle(
                                              elevation: MaterialStatePropertyAll(1),
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
                          );
                        } else {
                          return Center(
                              child: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  direction: Axis.vertical,
                                  children: [
                                    SizedBox(
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
                              ]));
                        }
                      } else {
                        // LOGICA PER SCHEDA NON PRESENTE.
            
                        return Text("");
                      }
                    })
                /*
                StreamBuilder(
                    stream: _dbs.getSchedaCorrente(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                        // CONTROLLO SULLO STREAM DI DATI
                        List lista = snapshot.data!.docs;
                        scheda = lista[0].data();
            
                        /*
                        lista_sedute_allenamenti.clear();
                        // caricamento dati nella lista locale in base al giorno di allenamento selezionato
                        _scheda.allenamentiScheda!.forEach((element_allenamento) =>
                            element_allenamento.giorniAssegnati!.forEach(
                                (element_giorno) =>
                                    DateUtils.dateOnly(element_giorno.toDate()) ==
                                            DateUtils.dateOnly(selectedDay.toDate())
                                        ? {
                                            lista_sedute_allenamenti
                                                .add(element_allenamento)
                                          }
                                        : ()));
                                        */
                        scheda.allenamentiScheda!.any((e) => e.giorniAssegnati!.any(
                                (element) =>
                                    (DateUtils.dateOnly(element.toDate())) ==
                                    selectedDay.toDate()))
                            ? ListView.builder(
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
                                          lista_sedute_allenamenti[index_allenamenti]!
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
                                        physics: const NeverScrollableScrollPhysics(),
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
                                                color: Theme.of(context).dividerColor,
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
                                                              shape: BoxShape.circle,
                                                              color: Theme.of(context)
                                                                  .primaryColor),
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
                                                  color:
                                                      Theme.of(context).primaryColor,
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
                                                                sm: sm,
                                                                i: index_allenamenti)));
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
                              )
                            : Center(
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
                                  ]));
                      }else{
                        return Text("");
                      }
                    }),
                    */
              ],
            
          
        
      ),
    );
  }

  bool allenamentiPerIlGiornoSelezionato(Scheda s, DateTime d) {
    bool b = false;
    for (int i = 0; i < s.allenamentiScheda!.length; i++) {
      for (int j = 0;
          j < s.allenamentiScheda![i].giorniAssegnati!.length;
          j++) {
        if (DateUtils.dateOnly(
                s.allenamentiScheda![i].giorniAssegnati![j].toDate()) ==
            DateUtils.dateOnly(d)) {
          b = true;
        }
      }
    }
    return b;
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
    return Placeholder();
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
    return Placeholder();
  }
}
