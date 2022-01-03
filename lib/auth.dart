import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_baby_shop_app/app.dart';

import 'screens/sign_in.dart';

class AuthScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (_auth.currentUser != null) {
      return const TheBabyShopApp();
    } else {
      /// Show sign in screen if user not login
      // return TheBabyShopApp();
      return const SignInScreen();
    }
  }
}