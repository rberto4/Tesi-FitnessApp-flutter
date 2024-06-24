// ignore_for_file: must_be_immutable, no_logic_in_create_state

import 'package:app_fitness_test_2/Cliente/HomeCliente.dart';
import 'package:app_fitness_test_2/Coach/HomeCoach.dart';
import 'package:flutter/material.dart';
import 'package:app_fitness_test_2/autenticazione/metodi_autenticazione.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _passwordVisible = true;
  bool _registrazioneCoach = false;

  TextEditingController _mailcontroller = TextEditingController();
  TextEditingController _usernamecontroller = TextEditingController();
  TextEditingController _passwordcontroller = TextEditingController();
  TextEditingController _confirmpasswordcontroller = TextEditingController();
  final AuthenticationService _authenticationService = AuthenticationService();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // BARRA DI STATOAuthenticationHelper
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // FORM DI REGISTRAZIONE UTENTE

                    // nome utente

                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(
                            top: 16, bottom: 8),
                        child: Text(
                          "Nome utente",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).hintColor,
                              fontSize: 16),
                        ),
                      ),
                    ),
                    TextFormField(
                        controller: _usernamecontroller,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Devi inserire il tuo nome e cognome';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2,
                                color: Theme.of(context).primaryColor),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8.0)),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                          errorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(width: 2, color: Colors.red),
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2,
                                color: Theme.of(context).primaryColor),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8.0)),
                          ),
                          filled: true,
                          prefixIcon: Icon(
                            Icons.account_circle_rounded,
                            color: Theme.of(context).hintColor,
                          ),
                        )),

                    // mail
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(
                            top: 16, bottom: 8),
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
                            return 'Devi inserire la tua e-mail';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2,
                                color: Theme.of(context).primaryColor),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8.0)),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                          errorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(width: 2, color: Colors.red),
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2,
                                color: Theme.of(context).primaryColor),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8.0)),
                          ),
                          filled: true,
                          prefixIcon: Icon(
                            Icons.mail_rounded,
                            color: Theme.of(context).hintColor,
                          ),
                        )),

                    // password

                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(
                            top: 16, bottom: 8),
                        child: Text(
                          "Password e Conferma Password",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).hintColor,
                              fontSize: 16),
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: _passwordcontroller,
                      obscureText: _passwordVisible,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Devi inserire una password ';
                        }
                        return null;
                      },
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
                        alignLabelWithHint: false,
                      ),
                    ),
                    Container(
                      height: 16,
                    ),
                    TextFormField(
                      controller: _confirmpasswordcontroller,
                      obscureText: _passwordVisible,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          // controllo conferma password

                          return 'Reinserisci la password scelta, per confermarla';
                        }
                        return null;
                      },
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
                          Icons.check_box_rounded,
                          color: Theme.of(context).hintColor,
                        ),
                        alignLabelWithHint: false,
                      ),
                    ),
                    Container(height: 16),
                    SwitchListTile(
                      contentPadding: EdgeInsets.all(0),
                      title: Text("Mi sto registrando come Coach",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).hintColor,
                              fontSize: 16)),
                      value: _registrazioneCoach,
                      onChanged: (value) => {
                        setState(() {
                          _registrazioneCoach = !_registrazioneCoach;
                        })
                      },
                    ),
                    Container(
                      height: 16,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                          icon: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Icon(Icons.done_rounded),
                          ),
                          onPressed: () {
                            registraUtente();
                          },
                          label: const Text("Salva il tuo nuovo account"),
                          style: ButtonStyle(
                              elevation: const WidgetStatePropertyAll(1),
                              backgroundColor: WidgetStatePropertyAll(
                                  Theme.of(context).primaryColor),
                              shape: WidgetStatePropertyAll<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              )))),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  registraUtente() {
    if (_formKey.currentState!.validate()) {
      if (_passwordcontroller.text != _confirmpasswordcontroller.text) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Password e conferma password, non coincidono")));
      } else if (!_registrazioneCoach) {
        _authenticationService
            .signUpCliente(
          email: _mailcontroller.text,
          password: _passwordcontroller.text,
          username: _usernamecontroller.text,
        )
            .then((result) {
          if (result == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Cliente aggiunto con successo")),
            );
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const MainPageUtente(),
                ));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(result)),
            );
          }
        });
      } else {
        _authenticationService
            .signUpCoach(
          email: _mailcontroller.text,
          password: _passwordcontroller.text,
          username: _usernamecontroller.text,
        )
            .then((result) {
          if (result == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Coach aggiunto con successo")),
            );
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const MainPageCoach(),
                ));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(result)),
            );
          }
        });
      }
    }
  }
}
