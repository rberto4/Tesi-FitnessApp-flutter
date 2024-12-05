// ignore_for_file: file_names

import 'package:flutter/material.dart';

class HomeSmartphone extends StatefulWidget {
  const HomeSmartphone({super.key});

  @override
  State<HomeSmartphone> createState() => _HomeSmartphoneState();
}

class _HomeSmartphoneState extends State<HomeSmartphone> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
            "Allarga la schermata, oppure utilizza un dispositivo con un display più ampio"),
      ),
    );
  }
}
