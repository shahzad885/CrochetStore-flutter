import 'dart:async';
import 'package:crochet_store/UI/Auth/LoginScreen.dart';
import 'package:crochet_store/UserSide/CBottomBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class IntroscreenProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void isLogin(BuildContext context) {
    final user = _auth.currentUser;

    Timer(const Duration(seconds: 8), () {
      if (user != null) {
        // Navigate to the home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SalomonBottomBarWidget()),
        );
      } else {
        // Navigate to the login screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Loginscreen()),
        );
      }
    });
  }
}
