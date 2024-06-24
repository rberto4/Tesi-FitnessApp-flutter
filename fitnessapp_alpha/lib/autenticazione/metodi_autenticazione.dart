import 'dart:async';
import 'package:app_fitness_test_2/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final DatabaseService _dbs = DatabaseService();
  //SIGN UP METHOD

  Future signUpCliente({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      await _dbs.getAuth().createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
      await _dbs.getAuth().currentUser?.updateDisplayName(username);
      await _dbs
          .getInstanceDb()
          .collection(_dbs.getCollezioneUtenti())
          .doc(_dbs.uid_user_loggato)
          .set({
        "email": _dbs.getAuth().currentUser?.email,
        "username": username,
        "uid": _dbs.getAuth().currentUser!.uid
      });

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future signUpCoach({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      await _dbs.getAuth().createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
      await _dbs.getAuth().currentUser?.updateDisplayName(username);
      await _dbs
          .getInstanceDb()
          .collection(_dbs.getCollezioneCoaches())
          .doc(_dbs.uid_user_loggato)
          .set({
        "email": _dbs.getAuth().currentUser?.email,
        "username": username,
        "uid": _dbs.getAuth().currentUser!.uid,
        "listaClientiSeguiti": List.empty(growable: true)
      });

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //SIGN IN METHOD
  Future signIn({required String email, required String password}) async {
    try {
      await _dbs
          .getAuth()
          .signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //SIGN OUT METHOD
  Future signOut() async {
    await _dbs.getAuth().signOut();
  }

  // check se è loggato
}
