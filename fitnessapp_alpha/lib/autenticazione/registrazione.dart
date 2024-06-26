
import 'package:flutter/material.dart';
import 'package:app_fitness_test_2/autenticazione/metodi_autenticazione.dart';
import 'package:app_fitness_test_2/Cliente/HomeCliente.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool passwordVisible = true;

  TextEditingController mailcontroller = TextEditingController();
  TextEditingController usernamecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController confirmpasswordcontroller = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    //  backgroundColor: Colors.grey.shade200,
      // BARRA DI STATO

      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 4,
        title: const Text(
          "Registrazione",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        shadowColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // FORM DI REGISTRAZIONE UTENTE
          
                    // nome e cognome
          
                    const SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsetsDirectional.only(
                            top: 16, bottom: 8),
                        child: Text(
                          "Nome e Cognome",
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
                          controller: usernamecontroller,
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
                                  const BorderRadius.all(Radius.circular(8.0)),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            prefixIcon: const Icon(
                              Icons.account_circle_rounded,
                              color: Colors.black,
                            ),
                          )),
                    ),
          
                    // mail
                    const SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsetsDirectional.only(
                            top: 16, bottom: 8),
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
                          controller: mailcontroller,
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
                                  const BorderRadius.all(Radius.circular(8.0)),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            prefixIcon: const Icon(
                              Icons.mail_rounded,
                              color: Colors.black,
                            ),
                          )),
                    ),
          
                    // password
          
                    const SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsetsDirectional.only(
                            top: 16, bottom: 8),
                        child: Text(
                          "Password e Conferma Password",
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
                        controller: passwordcontroller,
                        obscureText: passwordVisible,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Devi inserire una password ';
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
                                const BorderRadius.all(Radius.circular(8.0)),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          prefixIcon: const Icon(
                            Icons.lock_rounded,
                            color: Colors.black,
                          ),
                          alignLabelWithHint: false,
                        ),
                      ),
                    ),
                    Container(
                      height: 8,
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
                        controller: confirmpasswordcontroller,
                        obscureText: passwordVisible,
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
                                const BorderRadius.all(Radius.circular(8.0)),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          prefixIcon: const Icon(
                            Icons.check_box_rounded,
                            color: Colors.black,
                          ),
                          alignLabelWithHint: false,
                        ),
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
                              if (passwordcontroller.text !=
                                  confirmpasswordcontroller.text) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Password e conferma password, non coincidono")));
                              } else {
                                AuthenticationHelper()
                                    .signUp(
                                        email: mailcontroller.text,
                                        password: passwordcontroller.text,
                                        username: usernamecontroller.text
                                        )
                                    .then((result) {
                                  if (result == null) {
                                   
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const MainPageUtente()));
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBar(content: Text(result)),
                                    );
                                  }
                                });
                              }
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
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              "Registra account",
                              style: TextStyle(
                                  color: Colors.white,
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
        ),
      ),
    );
  }
}
