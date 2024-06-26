
import 'package:app_fitness_test_2/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationHelper {
  
  final DatabaseService _dbs = DatabaseService();
  //SIGN UP METHOD


  Future signUp(
      {required String email,
      required String password,
      required String username}) async {
    try {
      await _dbs.getAuth().createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
      _dbs.getAuth().currentUser?.updateDisplayName(username);
      _dbs
          .getInstanceDb()
          .collection(_dbs.getCollezioneUtenti())
          .doc(_dbs.getAuth().currentUser?.uid)
          .set({
        "mail": _dbs.getAuth().currentUser?.email,
        "username": username,
        "isCoach": false
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
