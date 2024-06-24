// ignore_for_file: file_names

import 'package:flutter/material.dart';

class HomeTablet extends StatefulWidget {
  const HomeTablet({super.key});

  @override
  State<HomeTablet> createState() => _HomeTabletState();
}

class _HomeTabletState extends State<HomeTablet> {
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
