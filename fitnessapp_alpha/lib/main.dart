import 'package:app_fitness_test_2/Cliente/HomeCliente.dart';
import 'package:app_fitness_test_2/Coach/HomeCoach.dart';
import 'package:app_fitness_test_2/autenticazione/login.dart';
import 'package:app_fitness_test_2/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: false,
      ),
      home: loadingPageMain(),
    );
  }
}

class loadingPageMain extends StatelessWidget {
  final DatabaseService _dbs = DatabaseService();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _dbs.getAuth().authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            return LoginPage();
          } else {
            return FutureBuilder(
              future: _dbs.isCoach(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.exists) {
                    return MainPageCoach();
                  } else {
                    return MainPageUtente();
                  }
                } else {
                  return MainPageUtente();
                }
              },
            );
          }
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
