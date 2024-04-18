import 'package:app_fitness_test_2/Coach/intefacciaSmartphone.dart';
import 'package:app_fitness_test_2/Coach/interfacciaDesktop.dart';
import 'package:app_fitness_test_2/Coach/interfacciaTablet.dart';
import 'package:app_fitness_test_2/autenticazione/login.dart';
import 'package:app_fitness_test_2/autenticazione/metodi_autenticazione.dart';
import 'package:app_fitness_test_2/responsive.dart';
import 'package:app_fitness_test_2/services/database_service.dart';
import 'package:flutter/material.dart';

final DatabaseService _dbs = DatabaseService();

class MainPageCoach extends StatefulWidget {
  const MainPageCoach({super.key});

  @override
  State<MainPageCoach> createState() => _MainPageCoachState();
}


/*
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
*/
class _MainPageCoachState extends State<MainPageCoach> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ciaoooo"),
      ),
      body: ResponsiveLayout(
            smartphoneScaffold: HomeSmartphone(),
            tabletScaffold: HomeTablet(),
            desktopScaffold: HomeDesktop(),
          )
      );
  }
}


