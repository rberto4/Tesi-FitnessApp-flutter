import 'package:flutter/material.dart';

class loginUtente extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Text("Login Utente"),
          ],
        ),
      )),
    );
  }
}
