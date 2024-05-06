import 'package:app_fitness_test_2/services/database_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class conversazioneChat extends StatefulWidget {
  const conversazioneChat({super.key});

  @override
  State<conversazioneChat> createState() => _conversazioneChatState();
}

class _conversazioneChatState extends State<conversazioneChat> {
  DatabaseService _dbs = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        backgroundColor: Theme.of(context).canvasColor,
        title: const Text("Coach"),
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          /*
          StreamBuilder(stream: , builder: (context, snapshot) {
            if (snapshot.hasData){

            }
          },),
          */
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Expanded(
                  child: const TextField(
                    maxLines: 5,
                    minLines: 1,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                FloatingActionButton(
                  onPressed: () {},
                  child: const Icon(Icons.send_rounded),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
