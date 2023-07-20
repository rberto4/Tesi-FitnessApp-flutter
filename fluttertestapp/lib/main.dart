import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

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
              title: Text("Sei su desktop "),
              automaticallyImplyLeading: false,
              centerTitle: false,
              elevation: 0,
              backgroundColor: Colors.transparent,
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
              title: Text("Sei su mobile "),
              backgroundColor: Colors.transparent,
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
      child: Text('Schermata 1'),
    );
  }
}

class Screen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Schermata 2'),
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
