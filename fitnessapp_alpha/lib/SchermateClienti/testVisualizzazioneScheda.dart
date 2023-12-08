import 'package:flutter/material.dart';

class testScheda extends StatefulWidget {
  const testScheda({super.key});

  @override
  State<testScheda> createState() => _testSchedaState();
}

class _testSchedaState extends State<testScheda> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            children: [
              Text("data"),
            ],
          ),
        ),
      ),
    );
  }
}
