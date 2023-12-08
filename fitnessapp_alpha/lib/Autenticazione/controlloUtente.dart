import 'package:app_fitness_test/Autenticazione/LoginPage.dart';
import 'package:app_fitness_test/SchermateClienti/HomePageClient.dart';
import 'package:app_fitness_test/SchermateCoach/HomePageCoach.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class authCheck extends StatelessWidget {
  const authCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.hasData) {
            print("Utente già autenticato");
            // controllo se coach o cliente
            return FutureBuilder(
              future: checkIfUserIsCoach(snapshot.data?.email),
              builder:
                  (BuildContext context, AsyncSnapshot<bool> coachSnapshot) {
                if (coachSnapshot.data == true) {
                  // L'utente è un coach, naviga alla schermata del coach
                  return const schermataHomeCliente();
                } else {
                  // L'utente non è un coach, naviga alla schermata del cliente
                  return const schermataHomeCoach();
                }
              },
            );
          } else {
            print("Utente alla schermata login");
            return const LoginPage();
          }
        },
      ),
    );
  }
}

Future<bool> checkIfUserIsCoach(String? userEmail) async {
  if (userEmail != null) {
    try {
      // Accedi alla collezione "coach" in Firetore
      final QuerySnapshot query = await FirebaseFirestore.instance
          .collection('coach')
          .where('emailCoach', isEqualTo: userEmail)
          .get();
      return query.docs.isEmpty;
    } catch (e) {
      // Gestisci l'errore qui
    }
  }
  return true;
}

class authService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//LOGIN ACCOUNT
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future<UserCredential> accedi(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

// USCITA DALL'APP
  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }

//CREAZIONE ACCOUNT
  Future<UserCredential> registrati(
      String email, String password, String codiceAtleta) async {
    try {
      // creazione account
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      //query, basata su codice atleta, sul documento relativo al cliente.
      final QuerySnapshot query = await _firestore
          .collection('clienti')
          .where('codiceAtleta', isEqualTo: codiceAtleta)
          .get();

      //aggiungo al documento la mail del cliente, relativa all'account creato
      final DocumentSnapshot docSnapshot = query.docs.single;
      await docSnapshot.reference
          .set({'mailAtleta': email}, SetOptions(merge: true));

      // nome - cognome - altri dati nella registrazione che si possono mettere ora o in seguito...
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // metodi get

  String? getEmailFromDb() {
    return _firebaseAuth.currentUser?.email;
  }
}
