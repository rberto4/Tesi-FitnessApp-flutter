// ignore_for_file: file_names

import 'package:app_fitness_test_2/autenticazione/login.dart';
import 'package:app_fitness_test_2/autenticazione/metodi_autenticazione.dart';
import 'package:app_fitness_test_2/services/database_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomeDesktop extends StatefulWidget {
  const HomeDesktop({super.key});

  @override
  State<HomeDesktop> createState() => _HomeDesktopState();
}

/*
 AuthenticationHelper().signOut().then((result) {
              if (result == null) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(result)),
                );
              }
            });
*/

class _HomeDesktopState extends State<HomeDesktop> {
  int _indexDrawer = 0;
  DatabaseService _dbs = DatabaseService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: SizedBox(
              height: double.infinity,
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Text(
                        "Menù",
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                    tileDrawer("H O M E", 0, Icons.home),
                    tileDrawer("C L I E N T I", 1, Icons.people_rounded),
                    tileDrawer("S C H E D E", 2, Icons.note_alt_rounded),
                    tileDrawer("C H A T", 3, Icons.message_rounded),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: double.infinity,
            width: 250,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StreamBuilder(
                    stream: _dbs.getListaClientiMiei(),
                    builder: (context, snapshot) {
                      List lista_clienti = List.empty(growable: true);
                      for (var a
                          in snapshot.data!.data()!.listaUidClientiSeguiti!) {
                        lista_clienti.add(a);
                      }
                      if (snapshot.hasData) {
                        return Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: lista_clienti.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                onTap: () {},
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                title: Text(
                                  lista_clienti[index],
                                  style: TextStyle(fontSize: 12),
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return Text("");
                      }
                    },
                  ),
                  SizedBox(
                    height: 36,
                    child: ElevatedButton.icon(
                      style: ButtonStyle(
                          alignment: Alignment.center,
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          )),
                          elevation: MaterialStatePropertyAll(0),
                          backgroundColor: MaterialStatePropertyAll(
                              Theme.of(context).primaryColor)),
                      label: Text(
                        "Nuovo cliente",
                        style: TextStyle(color: Colors.white),
                      ),
                      icon: Icon(Icons.add_rounded),
                      onPressed: () {
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

// TILE DI NAVIGAZIONE , MENU LATERALE
  Padding tileDrawer(String testo, int index, IconData icona) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Flexible(
        child: SizedBox(
          height: 36,
          width: 170,
          child: ElevatedButton.icon(
            style: ButtonStyle(
                alignment: Alignment.centerLeft,
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                )),
                elevation: _indexDrawer != index
                    ? MaterialStatePropertyAll(0)
                    : MaterialStatePropertyAll(2),
                backgroundColor: _indexDrawer != index
                    ? MaterialStatePropertyAll(Theme.of(context).cardColor)
                    : MaterialStatePropertyAll(Theme.of(context).primaryColor)),
            label: Text(
              testo,
              style: TextStyle(
                  color: _indexDrawer != index
                      ? Theme.of(context).hintColor
                      : Colors.white),
            ),
            icon: Icon(icona),
            onPressed: () {
              setState(() {
                _indexDrawer = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
