import 'package:app_fitness_test_2/Cliente/HomeCliente.dart';
import 'package:app_fitness_test_2/Coach/HomeCoach.dart';
import 'package:app_fitness_test_2/autenticazione/login.dart';
import 'package:app_fitness_test_2/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
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
      builder: (context, child) {
        return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!);
      },
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: temaLight(),
      darkTheme: temaDark(),
      themeMode: ThemeMode.system,
      home: loadingPageMain(),
    );
  }

  static const Color colorePrimario = Colors.lightBlue;
  static const Color colorePrimarioDark = Colors.lightBlue;

  ThemeData temaLight() {
    return ThemeData(
        expansionTileTheme: ExpansionTileThemeData(
            collapsedShape: Border(),
            tilePadding: EdgeInsets.symmetric(horizontal: 16),
            textColor: colorePrimario,
            iconColor: colorePrimario),
        listTileTheme: ListTileThemeData(minLeadingWidth: 16),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        canvasColor: Colors.grey.shade50,
        cardColor: Colors.white,
        shadowColor: ThemeData().shadowColor.withOpacity(0.1),
        appBarTheme: AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.dark),
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.grey.shade800),
            centerTitle: true,
            titleTextStyle: TextStyle(
                fontSize: 24,
                )),
        brightness: Brightness.light,
        useMaterial3: false,
        primaryColor: colorePrimario,
        textTheme: GoogleFonts.latoTextTheme(TextTheme()));
  }

  ThemeData temaDark() {
   
    return ThemeData(
        expansionTileTheme: ExpansionTileThemeData(
            collapsedShape: Border(),
            tilePadding: EdgeInsets.symmetric(horizontal: 16),
            textColor: colorePrimarioDark,
            iconColor: colorePrimarioDark),
        listTileTheme: ListTileThemeData(minLeadingWidth: 16),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        
        canvasColor: Colors.grey.shade900,
        cardColor: Colors.grey.shade800,
        shadowColor: ThemeData().shadowColor.withOpacity(0.3),
        appBarTheme: AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.light
                ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            toolbarHeight: 64,
            iconTheme: const IconThemeData(color: Colors.white),
            centerTitle: true,
           ),
        brightness: Brightness.dark,
        useMaterial3: false,
        primaryColor: colorePrimarioDark,
        textTheme: GoogleFonts.latoTextTheme(TextTheme()));
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
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
