import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPageCoach extends StatelessWidget {
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
                      "coach",
                      style: TextStyle(
                        fontSize: 45,
                      ),
                    ),
                    SizedBox(height: 45),

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
                              hintText: "Email",
                              fillColor: Colors.grey[200],
                              filled: true,
                            ))),
                    SizedBox(height: 10),
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
                              hintText: "Password",
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
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  void accesso() {}
}
