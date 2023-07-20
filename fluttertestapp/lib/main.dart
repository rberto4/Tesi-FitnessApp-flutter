import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(Applicazione());
}

int _currentIndex = 0;

final List<Widget> _screens = [
  FirestoreListViewWidget(),
  Screen2(),
  Screen3(),
  Screen3(),
];

class Applicazione extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Applicazione",
        theme: ThemeData(
            appBarTheme: const AppBarTheme(
                titleTextStyle: TextStyle(
                    color: Color.fromRGBO(31, 210, 201, 1),
                    letterSpacing: 2,
                    fontSize: 25,
                    fontWeight: FontWeight.bold))),
        home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  static of(BuildContext context, {bool root = false}) => root
      ? context.findRootAncestorStateOfType<_HomePageStato>()
      : context.findAncestorStateOfType<_HomePageStato>();

  @override
  _HomePageStato createState() => _HomePageStato();
}

class _HomePageStato extends State<HomePage> {
  void aggiornaStato(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizingInformation) {
      if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
        return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              centerTitle: false,
              elevation: 0,
              backgroundColor: Color.fromRGBO(31, 210, 201, 1),
            ),
            body: Row(
              children: [
                mydrawer(),
                Expanded(
                  child: Container(
                    alignment: AlignmentDirectional.topStart,
                    child: _screens[_currentIndex],
                  ),
                ),
              ],
            ));
      } else {
        return Scaffold(
            appBar: AppBar(
              backgroundColor: Color.fromRGBO(31, 210, 201, 1),
              elevation: 0,
              titleSpacing: 2,
            ),
            body: _screens[_currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.shifting,
              selectedItemColor: Color.fromRGBO(31, 210, 201, 1),
              unselectedItemColor: Colors.black,
              currentIndex: _currentIndex,
              onTap: (index) {
                aggiornaStato(index);
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: "ciao",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'Schermata 2',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Schermata 3',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.sports_gymnastics),
                  label: "ciao",
                ),
              ],
            ));
      }
    });
  }
}

class mydrawer extends StatefulWidget {
  @override
  _mydrawerStato createState() => _mydrawerStato();
}

class _mydrawerStato extends State<mydrawer> {
  void _selectOption(int index) {
    setState(() {
      _currentIndex = index;
      HomePage.of(context).aggiornaStato(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 200,
      elevation: 1,
      child: ListView(
        children: [
          ListTile(
            leading: Icon(
              Icons.home,
              color: _currentIndex == 0
                  ? const Color.fromRGBO(31, 210, 201, 1)
                  : null,
            ),
            title: Text(
              'Schermata 1',
            ),
            textColor: _currentIndex == 0
                ? const Color.fromRGBO(31, 210, 201, 1)
                : null,
            onTap: () => _selectOption(0),
          ),
          ListTile(
            leading: Icon(
              Icons.search,
              color: _currentIndex == 1
                  ? const Color.fromRGBO(31, 210, 201, 1)
                  : null,
            ),
            title: Text(
              'Schermata 2',
            ),
            textColor: _currentIndex == 1
                ? const Color.fromRGBO(31, 210, 201, 1)
                : null,
            onTap: () => _selectOption(1),
          ),
          ListTile(
            leading: Icon(Icons.person,
                color: _currentIndex == 2
                    ? const Color.fromRGBO(31, 210, 201, 1)
                    : null),
            title: Text('Schermata 3'),
            textColor: _currentIndex == 2
                ? const Color.fromRGBO(31, 210, 201, 1)
                : null,
            onTap: () => _selectOption(2),
          ),
        ],
      ),
    );
  }
}

class FirestoreListViewWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('esercizi').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        // Once the data is available, populate the ListView with "nome" field
        final documents = snapshot.data!.docs;
        return ListView.builder(
          itemCount: documents.length,
          itemBuilder: (context, index) {
            final nome = documents[index]['nome'];
            final value = documents[index]['value'];
            return ListTile(
              title: Text(
                nome,
                style: GoogleFonts.questrial(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                value.toString(),
                style: GoogleFonts.questrial(),
              ),
            );
          },
        );
      },
    );
  }
}

class Screen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Schermata 2 prova font',
        style: GoogleFonts.questrial(fontSize: 25, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class Screen3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Schermata 3 prova font',
        style: GoogleFonts.questrial(fontSize: 25, fontWeight: FontWeight.bold),
      ),
    );
  }
}
