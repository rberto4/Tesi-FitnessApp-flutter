// ignore_for_file: unnecessary_const

import 'package:app_fitness_test_2/Coach/HomeCoach.dart';
import 'package:app_fitness_test_2/autenticazione/metodi_autenticazione.dart';
import 'package:app_fitness_test_2/autenticazione/registrazione.dart';
import 'package:app_fitness_test_2/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:app_fitness_test_2/Cliente/HomeCliente.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _passwordVisible = true;
  final TextEditingController _mailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final DatabaseService _dbs = DatabaseService();
  final AuthenticationService _authenticationService = AuthenticationService();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.grey.shade200,
        body: Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'lib/Immagini/Logo.png',
                  height: MediaQuery.of(context).size.height * (3 / 8),
                  alignment: Alignment.topCenter,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding:
                        const EdgeInsetsDirectional.only(top: 16, bottom: 8),
                    child: Text(
                      "E-mail",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).hintColor,
                          fontSize: 16),
                    ),
                  ),
                ),
                TextFormField(
                    controller: _mailcontroller,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Devi inserire una e-mail';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 2, color: Theme.of(context).primaryColor),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8.0)),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.red),
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 2, color: Theme.of(context).primaryColor),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8.0)),
                      ),
                      filled: true,
                      prefixIcon: Icon(
                        Icons.mail_rounded,
                        color: Theme.of(context).hintColor,
                      ),
                    )),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding:
                        const EdgeInsetsDirectional.only(top: 16, bottom: 8),
                    child: Text(
                      "Password",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                  ),
                ),
                TextFormField(
                  controller: _passwordcontroller,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Devi inserire una password';
                    }
                    return null;
                  },
                  obscureText: _passwordVisible,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2, color: Theme.of(context).primaryColor),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(8.0)),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.red),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2, color: Theme.of(context).primaryColor),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(8.0)),
                    ),
                    filled: true,
                    prefixIcon: Icon(
                      Icons.lock_rounded,
                      color: Theme.of(context).hintColor,
                    ),
                    suffixIcon: IconButton(
                      color: Theme.of(context).primaryColor,
                      icon: Icon(!_passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(
                          () {
                            _passwordVisible = !_passwordVisible;
                          },
                        );
                      },
                    ),
                    alignLabelWithHint: false,
                  ),
                ),
                Container(
                  height: 16,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _authenticationService
                              .signIn(
                                  email: _mailcontroller.text,
                                  password: _passwordcontroller.text)
                              .then((result) {
                            if (result == null) {
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) {
                                return FutureBuilder<DocumentSnapshot>(
                                  future: _dbs.controlloSeUtenteCoach(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      if (snapshot.data!.exists) {
                                        return const MainPageCoach();
                                      } else {
                                        return const MainPageUtente();
                                      }
                                    } else {
                                      return const SizedBox(
                                          width: double.infinity,
                                          height: double.infinity,
                                          child: Center(
                                              child:
                                                  CircularProgressIndicator()));
                                    }
                                  },
                                );
                              }));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(result)),
                              );
                            }
                          });
                        }
                      },
                      style: ButtonStyle(
                          shape: const WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)))),
                          backgroundColor: WidgetStatePropertyAll(
                              Theme.of(context).primaryColor)),
                      child: const Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "Accedi",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      )),
                ),
                SizedBox(
                    width: double.infinity,
                    height: 64,
                    child: Center(
                        child:
                            Text(" - Oppure, se non disponi di un account - ",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).hintColor,
                                )))),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterPage(),
                            ));
                      },
                      style: ButtonStyle(
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 1),
                              borderRadius: const BorderRadius.all(
                                  const Radius.circular(8)))),
                          backgroundColor:
                              const WidgetStatePropertyAll(Colors.transparent)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "Registrati",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      )),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * (2 / 8)),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
