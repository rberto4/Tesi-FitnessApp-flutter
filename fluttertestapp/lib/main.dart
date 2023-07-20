import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(Applicazione());
}

int _currentIndex = 0;

final List<Widget> _screens = [
  Screen1(),
  Screen2(),
  Screen3(),
];

class Applicazione extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Applicazione",
        theme: ThemeData(
            primarySwatch: Colors.green,
            appBarTheme: AppBarTheme(
                titleTextStyle: TextStyle(
                    color: Colors.green,
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
              backgroundColor: Color.fromARGB(68, 68, 68, 68),
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
              backgroundColor: Colors.teal,
              elevation: 0,
              titleSpacing: 2,
            ),
            body: _screens[_currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                aggiornaStato(index);
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Schermata 1',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'Schermata 2',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Schermata 3',
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
              color: _currentIndex == 0 ? Colors.green : Colors.grey,
            ),
            title: Text(
              'Schermata 1',
            ),
            textColor: _currentIndex == 0 ? Colors.green : null,
            onTap: () => _selectOption(0),
          ),
          ListTile(
            leading: Icon(
              Icons.search,
              color: _currentIndex == 1 ? Colors.green : Colors.grey,
            ),
            title: Text(
              'Schermata 2',
            ),
            textColor: _currentIndex == 1 ? Colors.green : null,
            onTap: () => _selectOption(1),
          ),
          ListTile(
            leading: Icon(
              Icons.person,
              color: _currentIndex == 2 ? Colors.green : Colors.grey,
            ),
            title: Text('Schermata 3'),
            textColor: _currentIndex == 2 ? Colors.green : null,
            onTap: () => _selectOption(2),
          ),
        ],
      ),
    );
  }
}

class Screen1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.network(
        'data:image/png;base64,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',
        width: 200,
        height: 200,
      ),
    );
  }
}

class Screen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'prova font',
        style: GoogleFonts.questrial(fontSize: 25, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class Screen3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Schermata 3'),
    );
  }
}
