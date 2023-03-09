import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<String> signInWithEmailAndPassword(String email, String password);
  Future<String> createUserWithEmailAndPassword(String email, String password);
  Future<String> currentUser();
  Future<void> resetPassword(String email);
  Future<void> signOut();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    FirebaseUser user = (await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password)).user;
    return user.uid;
  }

  Future<String> createUserWithEmailAndPassword(
      String email, String password) async {
    try {FirebaseUser user = (await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password)).user;
    return user.uid;}catch (e) {
      return e.toString();
    }
  }

  Future<String> currentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.uid;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}
