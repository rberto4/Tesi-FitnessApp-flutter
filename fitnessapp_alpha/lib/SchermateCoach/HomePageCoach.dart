import 'package:app_fitness_test/Autenticazione/controlloUtente.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class schermataHomeCoach extends StatefulWidget {
  const schermataHomeCoach({super.key});

  @override
  State<schermataHomeCoach> createState() => _schermataHomeState();
}

class _schermataHomeState extends State<schermataHomeCoach> {
  void esci() {
    final as = Provider.of<authService>(context, listen: false);
    as.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home COACH"),
        actions: [IconButton(onPressed: esci, icon: const Icon(Icons.logout))],
      ),
    );
  }
}
