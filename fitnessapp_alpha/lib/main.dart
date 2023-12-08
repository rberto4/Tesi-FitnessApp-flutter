import 'package:app_fitness_test/Autenticazione/LoginPage.dart';
import 'package:app_fitness_test/Autenticazione/RegisterPage.dart';
import 'package:app_fitness_test/Autenticazione/controlloUtente.dart';
import 'package:app_fitness_test/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ChangeNotifierProvider(
    create: (context) => authService(),
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: authCheck()),
    );
  }
}
