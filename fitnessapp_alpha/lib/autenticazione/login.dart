import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:app_fitness_test_2/firebase_options.dart';

import 'registrazione.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool passwordVisible = true;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Login page",
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      height: 48,
                    ),
                    // mail text input
                    const SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsetsDirectional.only(top: 16, bottom: 8),
                        child: Text(
                          "E-mail",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius:
                              8.0, // You can set this blurRadius as per your requirement
                        ),
                      ]),
                      child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Devi inserire una e-mail';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2,
                                  color: Theme.of(context).primaryColor),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                            errorBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 2, color: Colors.red),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2,
                                  color: Theme.of(context).primaryColor),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            prefixIcon: const Icon(
                              Icons.mail_rounded,
                              color: Colors.black,
                            ),
                          )),
                    ),

                    const SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsetsDirectional.only(top: 16, bottom: 8),
                        child: Text(
                          "Password",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius:
                              16.0, // You can set this blurRadius as per your requirement
                        ),
                      ]),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Devi inserire una password';
                          }
                          return null;
                        },
                        obscureText: passwordVisible,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2,
                                color: Theme.of(context).primaryColor),
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
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
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          prefixIcon: Icon(
                            Icons.lock_rounded,
                            color: Colors.black,
                          ),
                          suffixIcon: IconButton(
                            color: Theme.of(context).primaryColor,
                            icon: Icon(!passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(
                                () {
                                  passwordVisible = !passwordVisible;
                                },
                              );
                            },
                          ),
                          alignLabelWithHint: false,
                        ),
                      ),
                    ),

                    Container(
                      height: 16,
                    ),

                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // If the form is valid, display a snackbar. In the real world,
                              // you'd often call a server or save the information in a database.
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Login in corso, attendi')),
                              );
                            }
                          },
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8)))),
                              backgroundColor: MaterialStatePropertyAll(
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
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "Non sei ancora registrato?",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                            fontSize: 12),
                      ),
                    ),

                    Container(
                      width: double.infinity,
                      child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RegisterPage()),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0))),
                              side: BorderSide(
                                  width: 2,
                                  color: Theme.of(context).primaryColor)),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              "Registrati qui",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
