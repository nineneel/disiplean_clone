// ignore_for_file: use_build_context_synchronously

import 'package:disiplean_clone/constants/style/text_style.dart';
import 'package:disiplean_clone/screens/auth/login_screen.dart';
import 'package:disiplean_clone/screens/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  Future<void> _checkAuthenticatedUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    await Future.delayed(const Duration(seconds: 2));

    // Check current user, if there is a user redirect to home screen
    // If there is no user redirect to Login Screen
    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } else {
  
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    }
  }

  @override
  void initState() {
    // Call checkAuthnticatedUser before login
    Future(() async => await _checkAuthenticatedUser());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Disiplean Clone",
          style: largeTextStyle,
        ),
      ),
    );
  }
}
