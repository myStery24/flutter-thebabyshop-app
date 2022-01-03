import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_baby_shop_app/screens/sign_in.dart';

/// Firebase name, email, password authentication
Future<User> createAccount(String name, String email, String password) async {
  FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  try {
    UserCredential userCrendetial = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    // print("Account created Successfully");

    userCrendetial.user.updateDisplayName(name);

    await _firestore.collection('users').doc(_auth.currentUser.uid).set({
      "address": "-",
      "number": "-",
      "image": "-",
      "name": name,
      "email": email,
      "uid": _auth.currentUser.uid,
      "createdAt": DateTime.now(),
      "updatedAt": DateTime.now(),
    });

    return userCrendetial.user;
  } catch (e) {
    // print(e);
    return null;
  }
}

Future<User> logIn(String email, String password) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);

    // print("Login Successfully");
    _firestore
        .collection('users')
        .doc(_auth.currentUser.uid)
        .get()
        .then((value) => userCredential.user.updateDisplayName(value['name']));

    return userCredential.user;
  } catch (e) {
    // print(e);
    return null;
  }
}

Future logOut(BuildContext context) async {
  FirebaseAuth _auth = FirebaseAuth.instance;

  try {
    await _auth.signOut().then((value) {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => const SignInScreen()));
    });
  } catch (e) {
    // print("error");
  }
}
