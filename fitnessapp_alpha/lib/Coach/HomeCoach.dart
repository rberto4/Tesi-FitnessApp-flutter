import 'package:app_fitness_test_2/autenticazione/login.dart';
import 'package:app_fitness_test_2/autenticazione/metodi_autenticazione.dart';
import 'package:app_fitness_test_2/services/database_service.dart';
import 'package:flutter/material.dart';

final DatabaseService _dbs = DatabaseService();

class MainPageCoach extends StatefulWidget {
  const MainPageCoach({super.key});

  @override
  State<MainPageCoach> createState() => _MainPageCoachState();
}

class _MainPageCoachState extends State<MainPageCoach> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        elevation: 4,
        shadowColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          _dbs.getAuth().currentUser!.email.toString(),
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
        ),
         actions: [
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
              icon: const Icon(Icons.logout))
        ],
       )
    );
  }
}