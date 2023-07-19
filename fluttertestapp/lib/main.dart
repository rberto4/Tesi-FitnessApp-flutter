import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

void main() {
  runApp(Applicazione());
}

class Applicazione extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Applicazione",
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizingInformation) {
      if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
        return Scaffold(
            appBar: AppBar(
              title: Text("Sei su desktop "),
              automaticallyImplyLeading: false,
            ),
            body: Row(
              children: [
                mydrawer(),
                Expanded(
                  child: Container(
                      // Contenuto del corpo dell'applicazione
                      ),
                ),
              ],
            ));
      } else {
        return Scaffold(
          drawer: mydrawer(),
          appBar: AppBar(
            title: Text("Sei su mobile "),
          ),
        );
      }
    });
  }
}

class mydrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: Text('Opzione 1'),
            onTap: () {
              // Azione per l'opzione 1
            },
          ),
          ListTile(
            title: Text('Opzione 2'),
            onTap: () {
              // Azione per l'opzione 2
            },
          ),
        ],
      ),
    );
  }
}
