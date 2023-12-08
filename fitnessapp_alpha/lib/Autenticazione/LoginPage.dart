import 'package:app_fitness_test/Autenticazione/LoginPage.dart';
import 'package:app_fitness_test/Autenticazione/controlloUtente.dart';
import 'package:provider/provider.dart';
import 'package:app_fitness_test/Autenticazione/RegisterPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'customFormComponents.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void AccessoUtente() async {
    final as = Provider.of<authService>(context, listen: false);
    try {
      await as.accedi(emailController.text, passwordController.text);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade300,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // logo

                  Text("LOGO", style: TextStyle(fontSize: 45)),
                  const SizedBox(
                    height: 35,
                  ),
                  myEditText(
                      controller: emailController,
                      hintText: "Email",
                      isHidden: false),
                  const SizedBox(
                    height: 10,
                  ),
                  myEditText(
                      controller: passwordController,
                      hintText: "Password",
                      isHidden: true),
                  const SizedBox(
                    height: 10,
                  ),
                  myEnterButton(onTap: AccessoUtente, text: "Accedi"),

                  const SizedBox(
                    height: 25,
                  ),
                  Text("Non sei registrato?"),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterPage()),
                          );
                        },
                        child: Text(
                          " REGISTRATI ",
                          style: TextStyle(
                            color: Colors.lightBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text("con il tuo "),
                      Text(
                        "CODICE ATLETA ",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
