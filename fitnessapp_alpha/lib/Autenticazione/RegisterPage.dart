import 'package:app_fitness_test/Autenticazione/controlloUtente.dart';
import 'package:app_fitness_test/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'customFormComponents.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final cpasswordController = TextEditingController();
  final codAtletaController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// REGISTRAZIONE UTENTE

  void registroUtente() async {
    final QuerySnapshot result = await _firestore
        .collection('clienti')
        .where('codiceAtleta', isEqualTo: codAtletaController.text)
        .get();

    if (result.docs.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Codice atleta non valido")));
      return;
    }
    if (passwordController.text != cpasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Controlla la password di conferma")));
      return;
    }

    final as = Provider.of<authService>(context, listen: false);
    try {
      await as.registrati(emailController.text, passwordController.text,
          codAtletaController.text);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainApp()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey.shade300,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(
                  context); // Torna indietro alla schermata precedente
            },
          ),
        ),
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
                      controller: codAtletaController,
                      hintText: "Codice Atleta",
                      isHidden: false),
                  const SizedBox(
                    height: 10,
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
                  myEditText(
                      controller: cpasswordController,
                      hintText: "Conferma Password",
                      isHidden: true),
                  const SizedBox(
                    height: 10,
                  ),
                  myEnterButton(onTap: registroUtente, text: "Registrati"),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
