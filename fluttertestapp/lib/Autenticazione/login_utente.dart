import 'package:flutter/material.dart';
import 'package:fluttertestapp/Autenticazione/login_coach.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPageUtente extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        backgroundColor: Colors.grey[300],
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "utente",
                      style: TextStyle(
                        fontSize: 45,
                      ),
                    ),
                    SizedBox(height: 45),

                    Container(
                      constraints: BoxConstraints(maxWidth: 200),
                      child: Text(
                        "Accedi con il codice utente fornito dal tuo coach ",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 25),
                    Container(
                        constraints: BoxConstraints(maxWidth: 250),
                        child: TextField(
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade200),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: Color.fromRGBO(31, 210, 201, 1))),
                              hintStyle: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                              hintText: "Codice utente",
                              fillColor: Colors.grey[200],
                              filled: true,
                            ))),
                    SizedBox(height: 10),

                    // PULSANTE LOGIN

                    GestureDetector(
                      onTap: () => accesso(),
                      child: Container(
                        padding: EdgeInsets.all(18),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(31, 210, 201, 1),
                            borderRadius: BorderRadius.circular(12)),
                        constraints: BoxConstraints(maxWidth: 250),
                        child: const Center(
                          child: Text(
                            "Accedi",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Sei un coach?  ",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => LoginPageCoach(),
                              ),
                            );
                          },
                          child: Container(
                            child: Text(
                              "Accedi",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Color.fromRGBO(31, 210, 201, 1)),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  void accesso() {}
}
