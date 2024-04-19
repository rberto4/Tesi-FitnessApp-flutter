
// ignore_for_file: file_names

import 'package:app_fitness_test_2/Coach/intefacciaSmartphone.dart';
import 'package:app_fitness_test_2/Coach/interfacciaDesktop.dart';
import 'package:app_fitness_test_2/Coach/interfacciaTablet.dart';
import 'package:app_fitness_test_2/responsive.dart';
import 'package:flutter/material.dart';


class MainPageCoach extends StatefulWidget {
  const MainPageCoach({super.key});

  @override
  State<MainPageCoach> createState() => _MainPageCoachState();
}


/*

*/
class _MainPageCoachState extends State<MainPageCoach> {
  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
            smartphoneScaffold: HomeSmartphone(),
            tabletScaffold: HomeTablet(),
            desktopScaffold: HomeDesktop(),
          );
  }
}


