import 'package:app_fitness_test_2/Cliente/HomeCliente.dart';
import 'package:app_fitness_test_2/autenticazione/login.dart';
import 'package:app_fitness_test_2/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationHelper {
  final DatabaseService _dbs = DatabaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  get user => _auth.currentUser;
  //SIGN UP METHOD


  Future signUp({required String email, required String password, required String username}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _auth.currentUser?.updateDisplayName(username);
      _dbs
          .getInstanceDb()
          .collection(_dbs.getCollezioneUtenti())
          .doc(_auth.currentUser?.uid)
          .set({
        "mail": _auth.currentUser?.email,
        "username": username,
        "isCoach" : false
      });
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //SIGN IN METHOD
  Future signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //SIGN OUT METHOD
  Future signOut() async {
    await _auth.signOut();
    print('signout');
  }

  // check se è loggato
}
